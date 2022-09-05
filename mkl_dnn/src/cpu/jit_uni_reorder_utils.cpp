/*******************************************************************************
* Copyright 2018 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

#include <assert.h>

#include "c_types_map.hpp"
#include "memory_desc_wrapper.hpp"
#include "mkldnn_debug.h"
#include "nstl.hpp"
#include "type_helpers.hpp"
#include "utils.hpp"

#include "cpu_primitive.hpp"
#include "cpu_reorder_pd.hpp"
#include "jit_uni_reorder.hpp"

using namespace mkldnn::impl::types;
using namespace mkldnn::impl::status;

namespace mkldnn {
namespace impl {
namespace cpu {

namespace tr {

/** ad-hoc structure to describe blocked memory layout */
struct layout_desc_t {
    data_type_t dt;
    int ndims;
    dims_t id;
    dims_t dims;
    strides_t strides;
};

status_t cvt_mem_desc_to_layout_desc(const memory_desc_t &md_,
        layout_desc_t &ld) {
    using namespace mkldnn::impl::memory_format;

    auto md = memory_desc_wrapper(md_);
    auto bd = md.blocking_desc();

    ld.ndims = 0;
    ld.dt = md.data_type();

    auto P = [&ld](int id, int dim, ptrdiff_t stride) {
        assert((size_t)ld.ndims < sizeof(ld.dims) / sizeof(ld.dims[0]));
        ld.id[ld.ndims] = id;
        ld.dims[ld.ndims] = dim;
        ld.strides[ld.ndims] = stride;
        ++ld.ndims;
    };

    /* special cases */
    switch (md.format()) {
    case memory_format::undef:
    case memory_format::any:
    case wino_fmt:
        return invalid_arguments;
    case OIhw4i16o4i:
        P(0, md.dims()[0] / 16, bd.strides[0][0]);
        P(0, 16, 4);
        P(1, md.dims()[1] / 16, bd.strides[0][1]);
        P(1, 4, 16*4);
        P(1, 4, 1);
        P(2, md.dims()[2], bd.strides[0][2]);
        P(3, md.dims()[3], bd.strides[0][3]);
        return success;
    case OIhw8i16o2i:
        P(0, md.dims()[0] / 16, bd.strides[0][0]);
        P(0, 16, 2);
        P(1, md.dims()[1] / 16, bd.strides[0][1]);
        P(1, 8, 16*2);
        P(1, 2, 1);
        P(2, md.dims()[2], bd.strides[0][2]);
        P(3, md.dims()[3], bd.strides[0][3]);
        return success;
    case OIhw8o16i2o:
        P(0, md.dims()[0] / 16, bd.strides[0][0]);
        P(0, 8, 16*2);
        P(0, 2, 1);
        P(1, md.dims()[1] / 16, bd.strides[0][1]);
        P(1, 16, 2);
        P(2, md.dims()[2], bd.strides[0][2]);
        P(3, md.dims()[3], bd.strides[0][3]);
        return success;
    case gOIhw4i16o4i:
        P(0, md.dims()[0], bd.strides[0][0]);
        P(1, md.dims()[1] / 16, bd.strides[0][1]);
        P(1, 16, 4);
        P(2, md.dims()[2] / 16, bd.strides[0][2]);
        P(2, 4, 16*4);
        P(2, 4, 1);
        P(3, md.dims()[3], bd.strides[0][3]);
        P(4, md.dims()[4], bd.strides[0][4]);
        return success;
    case gOIhw8i16o2i:
        P(0, md.dims()[0], bd.strides[0][0]);
        P(1, md.dims()[1] / 16, bd.strides[0][1]);
        P(1, 16, 2);
        P(2, md.dims()[2] / 16, bd.strides[0][2]);
        P(2, 8, 16*2);
        P(2, 2, 1);
        P(3, md.dims()[3], bd.strides[0][3]);
        P(4, md.dims()[4], bd.strides[0][4]);
        return success;
    case gOIhw8o16i2o:
        P(0, md.dims()[0], bd.strides[0][0]);
        P(1, md.dims()[1] / 16, bd.strides[0][1]);
        P(1, 8, 16*2);
        P(1, 2, 1);
        P(2, md.dims()[2] / 16, bd.strides[0][2]);
        P(2, 16, 2);
        P(3, md.dims()[3], bd.strides[0][3]);
        P(4, md.dims()[4], bd.strides[0][4]);
        return success;
    default: break;
    }

    /* regular blocked format */
    for (int d = 0; d < md.ndims(); ++d) {
        P(d, md.dims()[d] / bd.block_dims[d], bd.strides[0][d]);
        if (bd.block_dims[d] != 1)
            P(d, bd.block_dims[d], bd.strides[1][d]);
    }

    return success;
}

status_t prb_init(prb_t &p, const memory_desc_t &imd, const memory_desc_t &omd,
        const primitive_attr_t *attr) {
    layout_desc_t ild, old;
    status_t status = cvt_mem_desc_to_layout_desc(imd, ild);
    if (status != success) return status;
    status = cvt_mem_desc_to_layout_desc(omd, old);
    if (status != success) return status;

    p.itype = ild.dt;
    p.otype = old.dt;

    int ndims = 0;

    int i_pos = 0; /* state for input  -- current dimension */
    int o_pos = 0; /* state for output -- current dimension */

    while (i_pos < ild.ndims && o_pos < old.ndims) {
        assert(ild.id[i_pos] == old.id[o_pos]);
        if (ild.id[i_pos] != old.id[o_pos])
            return runtime_error;

        assert(ndims < max_ndims);
        if (ndims == max_ndims)
            return runtime_error;

        if (ild.dims[i_pos] == old.dims[o_pos]) {
            p.nodes[ndims].n = ild.dims[i_pos];
            p.nodes[ndims].is = ild.strides[i_pos];
            p.nodes[ndims].os = old.strides[o_pos];
            ++ndims;
            ++i_pos;
            ++o_pos;
        } else if (ild.dims[i_pos] < old.dims[o_pos]) {
            assert(old.dims[o_pos] % ild.dims[i_pos] == 0);
            int factor = old.dims[o_pos] / ild.dims[i_pos];
            p.nodes[ndims].n = ild.dims[i_pos];
            p.nodes[ndims].is = ild.strides[i_pos];
            p.nodes[ndims].os = old.strides[o_pos] * factor;
            ++ndims;
            ++i_pos;
            old.dims[o_pos] = factor;
        } else if (ild.dims[i_pos] > old.dims[o_pos]) {
            assert(ild.dims[i_pos] % old.dims[o_pos] == 0);
            int factor = ild.dims[i_pos] / old.dims[o_pos];
            p.nodes[ndims].n = old.dims[o_pos];
            p.nodes[ndims].is = ild.strides[i_pos] * factor;
            p.nodes[ndims].os = old.strides[o_pos];
            ++ndims;
            ++o_pos;
            ild.dims[i_pos] = factor;
        }
    }
    p.ndims = ndims;

    dims_t zero_pos = {0};
    p.ioff = memory_desc_wrapper(imd).off_v(zero_pos);
    p.ooff = memory_desc_wrapper(omd).off_v(zero_pos);

    p.is_alpha = attr->output_scales_.scales_[0] != 1.f;
    if (attr->output_scales_.mask_ != 0) return unimplemented;

    const int sum_idx = attr->post_ops_.find(primitive_kind::sum);
    p.beta = sum_idx == -1 ? 0.f : attr->post_ops_.entry_[sum_idx].sum.scale;

    return success;
}

void prb_normalize(prb_t &p) {
    for (int d = 0; d < p.ndims; ++d) {
        int min_pos = d;
        for (int j = d + 1; j < p.ndims; ++j) {
            bool new_min = false
                || p.nodes[j].os < p.nodes[min_pos].os
                || (true
                        && p.nodes[j].os == p.nodes[min_pos].os
                        && p.nodes[j].n < p.nodes[min_pos].n);
            if (new_min) min_pos = j;
        }
        if (min_pos != d) {
            nstl::swap(p.nodes[d].n, p.nodes[min_pos].n);
            nstl::swap(p.nodes[d].is, p.nodes[min_pos].is);
            nstl::swap(p.nodes[d].os, p.nodes[min_pos].os);
        }
    }
}

void prb_simplify(prb_t &p) {
    for (int d = 0; d < p.ndims - 1; ++d) {
        auto &this_node = p.nodes[d + 0];
        auto &next_node = p.nodes[d + 1];
        bool fold = true
            && next_node.is == (ptrdiff_t)this_node.n * this_node.is
            && next_node.os == (ptrdiff_t)this_node.n * this_node.os;
        if (fold) {
            this_node.n *= next_node.n;
            for (int j = d + 2; j < p.ndims; ++j)
                p.nodes[j - 1] = p.nodes[j];
            --p.ndims;
        }
    }
}

void prb_node_split(prb_t &p, int dim, size_t n1) {
    assert(dim < p.ndims);
    assert(p.ndims < max_ndims);
    assert(p.nodes[dim].n % n1 == 0);

    p.ndims += 1;

    for (int d = p.ndims; d > dim + 1; --d)
        p.nodes[d] = p.nodes[d - 1];

    p.nodes[dim + 1].n = p.nodes[dim].n / n1;
    p.nodes[dim + 1].is = p.nodes[dim].is * n1;
    p.nodes[dim + 1].os = p.nodes[dim].os * n1;

    p.nodes[dim].n = n1;
}

void prb_node_swap(prb_t &p, int d0, int d1) {
    assert(d0 < p.ndims);
    assert(d1 < p.ndims);
    assert(p.ndims < max_ndims);

    if (d0 == d1) return;

    nstl::swap(p.nodes[d0], p.nodes[d1]);
}

void prb_node_move(prb_t &p, int d0, int d1) {
    assert(d0 < p.ndims);
    assert(d1 < p.ndims);
    assert(p.ndims < max_ndims);

    if (d0 == d1) return;

    node_t node = p.nodes[d0];

    if (d0 < d1)
        for (int d = d0; d < d1; ++d)
            p.nodes[d] = p.nodes[d + 1];
    else
        for (int d = d0; d > d1; --d)
            p.nodes[d] = p.nodes[d - 1];

    p.nodes[d1] = node;
}

void prb_dump(const prb_t &p) {
    printf("@@@ type:%s:%s ndims:%d ", mkldnn_dt2str(p.itype),
            mkldnn_dt2str(p.otype), p.ndims);
    for (int d = 0; d < p.ndims; ++d)
        printf("[%zu:%td:%td]", p.nodes[d].n, p.nodes[d].is, p.nodes[d].os);
    printf(" off:%zu:%zu\n", p.ioff, p.ooff);
}

}

}
}
}
