/*******************************************************************************
* Copyright 2016-2018 Intel Corporation
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
#include "mkldnn_types.h"

#include "c_types_map.hpp"
#include "memory_desc_wrapper.hpp"
#include "memory_pd.hpp"
#include "type_helpers.hpp"
#include "utils.hpp"

namespace mkldnn {
namespace impl {

memory_desc_wrapper::memory_desc_wrapper(const memory_pd_t *m_pd)
    : _md(m_pd == nullptr ? nullptr : m_pd->desc()) {}

namespace {
using namespace mkldnn::impl::utils;
using namespace mkldnn::impl::status;
using namespace mkldnn::impl::memory_format;

status_t fill_x(memory_desc_t &md) {
    const int ndims = md.ndims;
    if (ndims != 1) return invalid_arguments;
    blocking_desc_t &blk = md.layout_desc.blocking;
    array_set(blk.block_dims, 1, ndims);
    array_set(blk.strides[1], 1, ndims);
    blk.strides[0][0] = 1;
    array_copy(blk.padding_dims, md.dims, ndims);
    array_set(blk.offset_padding_to_data, 0, ndims);
    blk.offset_padding = 0;
    return success;
}

/* TODO: improve me maybe... and put this to utils */
inline void set_default_strides(strides_t strides, const dims_t dims,
        int ndims, const int *perm = NULL) {
    int id_perm[TENSOR_MAX_DIMS] = {0};
    for (int i = 0; i < ndims; ++i)
        id_perm[i] = i;
    if (perm == NULL)
        perm = id_perm;

    strides[perm[ndims - 1]] = 1;
    for (int d = 1; d < ndims; ++d) {
        const int prev_idx = perm[ndims - d];
        const int curr_idx = perm[ndims - 1 - d];

        strides[curr_idx] = dims[curr_idx] == 0
            ? 1
            : strides[prev_idx] * nstl::max(1, dims[prev_idx]);
    }
}

status_t fill_nonblocked(memory_desc_t &md, const int perm[]) {
    const int ndims = md.ndims;
    blocking_desc_t &blk = md.layout_desc.blocking;
    array_set(blk.block_dims, 1, ndims);
    array_set(blk.strides[1], 1, ndims);
    set_default_strides(blk.strides[0], md.dims, ndims, perm);
    array_copy(blk.padding_dims, md.dims, ndims);
    array_set(blk.offset_padding_to_data, 0, ndims);
    blk.offset_padding = 0;
    return success;
}

status_t fill_contiguous_blocked(memory_desc_t &md, const dims_t block_dims,
        const int perm[]) {
    const int ndims = md.ndims;

    for (int d = 0; d < ndims; ++d)
        if (md.dims[d] % block_dims[d] != 0)
            return unimplemented;

    blocking_desc_t &blk = md.layout_desc.blocking;
    array_copy(blk.block_dims, block_dims, ndims);

    dim_t unrolled_dims[2*TENSOR_MAX_DIMS];
    stride_t unrolled_strides[2*TENSOR_MAX_DIMS];
    for (int d = 0; d < ndims; ++d) {
        unrolled_dims[d] = md.dims[d] / block_dims[d];
        unrolled_dims[ndims + d] = block_dims[d];
    }

    set_default_strides(unrolled_strides, unrolled_dims, 2*ndims, perm);
    array_copy(blk.strides[0], &unrolled_strides[0], ndims);
    array_copy(blk.strides[1], &unrolled_strides[ndims], ndims);
    array_copy(blk.padding_dims, md.dims, ndims);
    array_set(blk.offset_padding_to_data, 0, ndims);
    blk.offset_padding = 0;
    return success;
}

status_t fill_nc(memory_desc_t &md) {
    if (md.ndims != 2) return invalid_arguments;

    const int perm[2] = {0, 1};
    return fill_nonblocked(md, perm);
}

status_t fill_nchw(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const int perm[4] = {0, 1, 2, 3};
    return fill_nonblocked(md, perm);
}

status_t fill_ncdhw(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const int perm[5] = {0, 1, 2, 3, 4};
    return fill_nonblocked(md, perm);
}

status_t fill_oidhw(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const int perm[5] = {0, 1, 2, 3, 4};
    return fill_nonblocked(md, perm);
}

status_t fill_goidhw(memory_desc_t &md) {
    if (md.ndims != 6) return invalid_arguments;

    const int perm[6] = {0, 1, 2, 3, 4, 5};
    return fill_nonblocked(md, perm);
}

status_t fill_nhwc(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const int perm[4] = {0, 2, 3, 1};
    return fill_nonblocked(md, perm);
}

status_t fill_ndhwc(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const int perm[5] = {0, 2, 3, 4, 1};
    return fill_nonblocked(md, perm);
}

status_t fill_chwn(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const int perm[4] = {1, 2, 3, 0};
    return fill_nonblocked(md, perm);
}

status_t fill_nChw8c(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {1, 8, 1, 1};
    const int perm[] = {
        0, 1, 2, 3,
        4, 5, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_nChw16c(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {1, 16, 1, 1};
    const int perm[] = {
        0, 1, 2, 3,
        4, 5, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_nCdhw16c(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 16, 1, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_oi(memory_desc_t &md) {
    if (md.ndims != 2) return invalid_arguments;

    const int perm[2] = {0, 1};
    return fill_nonblocked(md, perm);
}

status_t fill_io(memory_desc_t &md) {
    if (md.ndims != 2) return invalid_arguments;

    const int perm[2] = {1, 0};
    return fill_nonblocked(md, perm);
}

status_t fill_oihw(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const int perm[4] = {0, 1, 2, 3};
    return fill_nonblocked(md, perm);
}

status_t fill_ihwo(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const int perm[4] = {1, 2, 3, 0};
    return fill_nonblocked(md, perm);
}

status_t fill_hwio(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const int perm[4] = {2, 3, 1, 0};
    return fill_nonblocked(md, perm);
}

status_t fill_OIhw8i8o(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {8, 8, 1, 1};
    const int perm[] = {
        0, 1, 2, 3,
        5, 4, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_OIhw16i16o(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {16, 16, 1, 1};
    const int perm[] = {
        0, 1, 2, 3,
        5, 4, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_OIdhw16i16o(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {16, 16, 1, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        6, 5, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_OIhw4i16o4i(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {16, 16, 1, 1};
    const int perm[] = {
        0, 1, 2, 3,
        5, 4, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_OIhw8i16o2i(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {16, 16, 1, 1};
    const int perm[] = {
        0, 1, 2, 3,
        5, 4, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_OIhw8o8i(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {8, 8, 1, 1};
    const int perm[] = {
        0, 1, 2, 3,
        4, 5, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_OIhw16o16i(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {16, 16, 1, 1};
    const int perm[] = {
        0, 1, 2, 3,
        4, 5, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_OIdhw16o16i(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {16, 16, 1, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_IOhw16o16i(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {16, 16, 1, 1};
    const int perm[] = {
        1, 0, 2, 3,
        4, 5, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_OIhw8o16i2o(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {16, 16, 1, 1};
    const int perm[] = {
        0, 1, 2, 3,
        4, 5, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_Oihw8o(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {8, 1, 1, 1};
    const int perm[] = {
        0, 1, 2, 3,
        4, 5, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_Oihw16o(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {16, 1, 1, 1};
    const int perm[] = {
        0, 1, 2, 3,
        4, 5, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_Oidhw16o(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {16, 1, 1, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_Ohwi8o(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {8, 1, 1, 1};
    const int perm[] = {
        0, 2, 3, 1,
        4, 5, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_Ohwi16o(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {16, 1, 1, 1};
    const int perm[] = {
        0, 2, 3, 1,
        4, 5, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_Odhwi16o(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {16, 1, 1, 1, 1};
    const int perm[] = {
        0, 2, 3, 4, 1,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_OhIw16o4i(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const dims_t block_dims = {16, 4, 1, 1};
    const int perm[] = {
        0, 2, 1, 3,
        4, 5, 6, 7};
    return fill_contiguous_blocked(md, block_dims, perm);
}
status_t fill_goihw(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const int perm[5] = {0, 1, 2, 3, 4};
    return fill_nonblocked(md, perm);
}

status_t fill_hwigo(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const int perm[5] = {3, 4, 2, 0, 1};
    return fill_nonblocked(md, perm);
}

status_t fill_gOIhw8i8o(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 8, 8, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 7, 6, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOIhw16i16o(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 16, 16, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 7, 6, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOIdhw16i16o(memory_desc_t &md) {
    if (md.ndims != 6) return invalid_arguments;

    const dims_t block_dims = {1, 16, 16, 1, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4, 5,
        6, 8, 7, 9, 10, 11};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOihw8o(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 8, 1, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOihw16o(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 16, 1, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOidhw16o(memory_desc_t &md) {
    if (md.ndims != 6) return invalid_arguments;

    const dims_t block_dims = {1, 16, 1, 1, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4, 5,
        6, 7, 8, 9, 10, 11};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOhwi8o(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 8, 1, 1, 1};
    const int perm[] = {
        0, 1, 3, 4, 2,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOhwi16o(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 16, 1, 1, 1};
    const int perm[] = {
        0, 1, 3, 4, 2,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOdhwi16o(memory_desc_t &md) {
    if (md.ndims != 6) return invalid_arguments;

    const dims_t block_dims = {1, 16, 1, 1, 1, 1};
    const int perm[] = {
        0, 1, 3, 4, 5, 2,
        6, 7, 8, 9, 10, 11};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOIhw4i16o4i(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 16, 16, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 7, 6, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_Goihw8g(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {8, 1, 1, 1, 1};
    const int perm[] = {
         0, 1, 2, 3, 4,
         5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_Goihw16g(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {16, 1, 1, 1, 1};
    const int perm[] = {
         0, 1, 2, 3, 4,
         5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOIhw8i16o2i(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 16, 16, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 7, 6, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOIhw8o8i(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 8, 8, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOIhw16o16i(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 16, 16, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOIdhw16o16i(memory_desc_t &md) {
    if (md.ndims != 6) return invalid_arguments;

    const dims_t block_dims = {1, 16, 16, 1, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4, 5,
        6, 7, 8, 9, 10, 11};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gIOhw16o16i(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 16, 16, 1, 1};
    const int perm[] = {
        0, 2, 1, 3, 4,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOIhw8o16i2o(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 16, 16, 1, 1};
    const int perm[] = {
        0, 1, 2, 3, 4,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_gOhIw16o4i(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const dims_t block_dims = {1, 16, 4, 1, 1};
    const int perm[] = {
        0, 1, 3, 2, 4,
        5, 6, 7, 8, 9};
    return fill_contiguous_blocked(md, block_dims, perm);
}

status_t fill_ntc(memory_desc_t &md) {
    if (md.ndims != 3) return invalid_arguments;

    const int perm[3] = { 1, 0, 2 };
    return fill_nonblocked(md, perm);
}

status_t fill_tnc(memory_desc_t &md) {
    if (md.ndims != 3) return invalid_arguments;
    const int perm[3] = { 0, 1, 2 };
    return fill_nonblocked(md, perm);
}

status_t fill_ldsnc(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;
    const int perm[5] = { 0, 1, 2, 3, 4 };
    return fill_nonblocked(md, perm);
}

status_t fill_ldigo(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const int perm[5] = { 0, 1, 2, 3, 4 };
    return fill_nonblocked(md, perm);
}

status_t fill_ldgoi(memory_desc_t &md) {
    if (md.ndims != 5) return invalid_arguments;

    const int perm[5] = { 0, 1, 3, 4, 2 };
    return fill_nonblocked(md, perm);
}

status_t fill_ldgo(memory_desc_t &md) {
    if (md.ndims != 4) return invalid_arguments;

    const int perm[4] = { 0, 1, 2, 3 };
    return fill_nonblocked(md, perm);
}

}

status_t memory_desc_wrapper::compute_blocking(memory_desc_t &memory_desc)
{
    if (memory_desc.ndims == 0) return invalid_arguments;

    switch (memory_desc.format) {
    case x: return fill_x(memory_desc);
    case nc: return fill_nc(memory_desc);
    case nchw: return fill_nchw(memory_desc);
    case nhwc: return fill_nhwc(memory_desc);
    case chwn: return fill_chwn(memory_desc);
    case nChw8c: return fill_nChw8c(memory_desc);
    case nChw16c: return fill_nChw16c(memory_desc);
    case oi: return fill_oi(memory_desc);
    case io: return fill_io(memory_desc);
    case oihw: return fill_oihw(memory_desc);
    case ihwo: return fill_ihwo(memory_desc);
    case hwio: return fill_hwio(memory_desc);
    case OIhw8i8o: return fill_OIhw8i8o(memory_desc);
    case OIhw16i16o: return fill_OIhw16i16o(memory_desc);
    case OIhw4i16o4i: return fill_OIhw4i16o4i(memory_desc);
    case OIhw8i16o2i: return fill_OIhw8i16o2i(memory_desc);
    case OIhw8o16i2o: return fill_OIhw8o16i2o(memory_desc);
    case OIhw8o8i: return fill_OIhw8o8i(memory_desc);
    case OIhw16o16i: return fill_OIhw16o16i(memory_desc);
    case IOhw16o16i: return fill_IOhw16o16i(memory_desc);
    case Oihw8o: return fill_Oihw8o(memory_desc);
    case Oihw16o: return fill_Oihw16o(memory_desc);
    case Ohwi8o: return fill_Ohwi8o(memory_desc);
    case Ohwi16o: return fill_Ohwi16o(memory_desc);
    case OhIw16o4i: return fill_OhIw16o4i(memory_desc);
    case goihw: return fill_goihw(memory_desc);
    case hwigo: return fill_hwigo(memory_desc);
    case gOIhw8i8o: return fill_gOIhw8i8o(memory_desc);
    case gOIhw16i16o: return fill_gOIhw16i16o(memory_desc);
    case gOIhw4i16o4i: return fill_gOIhw4i16o4i(memory_desc);
    case gOIhw8i16o2i: return fill_gOIhw8i16o2i(memory_desc);
    case gOIhw8o16i2o: return fill_gOIhw8o16i2o(memory_desc);
    case gOIhw8o8i: return fill_gOIhw8o8i(memory_desc);
    case gOIhw16o16i: return fill_gOIhw16o16i(memory_desc);
    case gIOhw16o16i: return fill_gIOhw16o16i(memory_desc);
    case gOihw8o: return fill_gOihw8o(memory_desc);
    case gOihw16o: return fill_gOihw16o(memory_desc);
    case gOhwi8o: return fill_gOhwi8o(memory_desc);
    case gOhwi16o: return fill_gOhwi16o(memory_desc);
    case Goihw8g: return fill_Goihw8g(memory_desc);
    case Goihw16g: return fill_Goihw16g(memory_desc);
    case gOhIw16o4i: return fill_gOhIw16o4i(memory_desc);
    case ncdhw: return fill_ncdhw(memory_desc);
    case ndhwc: return fill_ndhwc(memory_desc);
    case oidhw: return fill_oidhw(memory_desc);
    case goidhw: return fill_goidhw(memory_desc);
    case nCdhw16c: return fill_nCdhw16c(memory_desc);
    case OIdhw16i16o: return fill_OIdhw16i16o(memory_desc);
    case gOIdhw16i16o: return fill_gOIdhw16i16o(memory_desc);
    case OIdhw16o16i: return fill_OIdhw16o16i(memory_desc);
    case gOIdhw16o16i: return fill_gOIdhw16o16i(memory_desc);
    case Oidhw16o: return fill_Oidhw16o(memory_desc);
    case Odhwi16o: return fill_Odhwi16o(memory_desc);
    case gOidhw16o: return fill_gOidhw16o(memory_desc);
    case gOdhwi16o: return fill_gOdhwi16o(memory_desc);
    case ntc: return fill_ntc(memory_desc);
    case tnc: return fill_tnc(memory_desc);
    case ldsnc: return fill_ldsnc(memory_desc);
    case ldigo: return fill_ldigo(memory_desc);
    case ldgoi: return fill_ldgoi(memory_desc);
    case ldgo: return fill_ldgo(memory_desc);
    case wino_fmt: return success;
    default: break;
    }

    return invalid_arguments;
}

}
}

// vim: et ts=4 sw=4 cindent cino^=l0,\:0,N-s
