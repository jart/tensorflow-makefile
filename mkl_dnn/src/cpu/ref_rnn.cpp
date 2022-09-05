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

/*
  General architecture

  for diff states, we have n_states + 1 as we have n_states diff
  to propagate to the previous iteration and 1 states to propagate
  to the previous layer
  index 0 is dh for cell(t-1, l) to consume
  index 1 is dc for cell(t-1, l) to consume
  index 2 is dh for cell(t, l-1) to consume
  this indexing enables to have the same indexing for states in elemwise
  function
  only the cell execution function should be impacted

 */
#include "c_types_map.hpp"
#include "math_utils.hpp"
#include "mkldnn_traits.hpp"
#include "type_helpers.hpp"

#include "ref_rnn.hpp"

namespace mkldnn {
namespace impl {
namespace cpu {

using namespace mkldnn::impl::utils;
using namespace mkldnn::impl::math;
using namespace prop_kind;
using namespace alg_kind;

#define AOC array_offset_calculator

template <>
float activation<alg_kind::eltwise_relu, prop_kind::forward>(
        float dd, float s, float alpha, float cliping) {
    return relu_fwd<float>(s, alpha);
}

template <>
float activation<alg_kind::eltwise_relu, prop_kind::backward>(
        float dd, float s, float alpha, float cliping) {
    return relu_bwd<float>(dd, s, alpha);
}

template <>
float activation<alg_kind::eltwise_tanh, prop_kind::forward>(
        float dd, float s, float alpha, float cliping) {
    return tanh_fwd<float>(s);
}

template <>
float activation<alg_kind::eltwise_tanh, prop_kind::backward>(
        float dd, float s, float alpha, float cliping) {
    return tanh_bwd<float>(dd, s);
}

//************************* Cell execution *************************//
/// @todo shall this be templated on activation function to enable svml calls
/// particularly?
template <>
elemwise_sig(_ref_rnn_common_t<prop_kind::forward>::rnn_elemwise) {
    AOC<float, 3> ws_gates(ws_gates_, batch, n_gates, dic);
    AOC<const float, 2> bias(bias_, n_gates, dic);
    AOC<float, 3> states_t_l(states_t_l_, n_states, batch, wic);
#pragma omp parallel for
    for (int i = 0; i < batch; i++) {
        for (int j = 0; j < dic; j++) {
            const float h
                    = activation_func(0, ws_gates(i, 0, j) + bias(0, j), 0, 0);
            ws_gates(i, 0, j) = states_t_l(0, i, j) = h;
        }
    }
}

template <>
elemwise_sig(_ref_rnn_common_t<prop_kind::backward>::rnn_elemwise) {
    AOC<float, 3> ws_gates(ws_gates_, batch, n_gates, dic);
    AOC<float, 3> diff_states_tp1_l(
            diff_states_tp1_l_, n_states + 1, batch, wic);
    AOC<float, 3> diff_states_t_lp1(
            diff_states_t_lp1_, n_states + 1, batch, wic);
#pragma omp parallel for
    for (int i = 0; i < batch; ++i) {
        for (int j = 0; j < dic; ++j) {
            const float dH = diff_states_t_lp1(n_states, i, j)
                    + diff_states_tp1_l(0, i, j);
            auto g = ws_gates(i, 0, j);
            ws_gates(i, 0, j) = activation_func(dH, g, 0, 0);
        }
    }
}

template <>
elemwise_sig(_ref_rnn_common_t<prop_kind::forward>::lstm_elemwise) {
    AOC<float, 3> ws_gates(ws_gates_, batch, n_gates, dic);
    AOC<const float, 2> bias(bias_, n_gates, dic);
    AOC<float, 3> states_t_l(states_t_l_, n_states, batch, wic);
    AOC<float, 3> states_tm1_l(states_tm1_l_, n_states, batch, wic);

#pragma omp parallel for
    for (int i = 0; i < batch; i++) {
#pragma omp simd
        for (int j = 0; j < dic; j++) {
            ws_gates(i, 0, j) = logistic_fwd(ws_gates(i, 0, j) + bias(0, j));
            ws_gates(i, 1, j) = logistic_fwd(ws_gates(i, 1, j) + bias(1, j));
            ws_gates(i, 2, j) = logistic_fwd(ws_gates(i, 2, j) + bias(2, j));
            ws_gates(i, 3, j) = tanh_fwd(ws_gates(i, 3, j) + bias(3, j));

            float tmp = ws_gates(i, 0, j) * states_tm1_l(1, i, j)
                    + ws_gates(i, 1, j) * ws_gates(i, 3, j);
            states_t_l(0, i, j) = ws_gates(i, 2, j) * tanh_fwd(tmp);
            states_t_l(1, i, j) = tmp;
        }
    }
}

#if 0
/// @todo GRU mixes gemms and elemwise with gate 1.
template<>
elemwise_sig(_ref_rnn_common_t<prop_kind::forward>::gru_elemwise){
    AOC<float, 3> ws_gates(ws_gates_, batch, n_gates, dic);
    AOC<const float, 2> bias(bias_, n_gates, dic);
    AOC<float, 3> states_t_l(states_t_l_, n_states, batch, wic);
    AOC<float, 3> states_tm1_l(states_tm1_l_, n_states, batch, wic);

    auto sigmoid = [=](float a) {float tmp=expf(-a); return 1.0f / (1.0f + tmp);};
#pragma omp parallel for
    for(int i=0; i<batch; i++){
        for (int gate = 0; gate < 2; gate++)
            for(int j = 0; j < dic; j++){
                ws_gates(i,gate,j) += bias(gate,j);
                ws_gates(i,gate,j) = sigmoid(ws_gates(i,gate,j));
            }
        for(int j=0; j < dic; j++){
            ws_gates(i,2,j) += bias(3,j);
            ws_gates(i,2,j) = tanh_fwd(ws_gates(i,3,j));

            states_t_l(0,i,j) = (1 - ws_gates(i,0,j)) * states_tm1_l(0,i,j)
                + ws_gates(i,0,j)*ws_gates(i,2,j);
        }
    }

    for(int i=0; i<batch; i++)
        for(int j=0; j<dic; j++){
            float tmp = ws_gates(i,0,j) * states_tm1_l(1,i,j)
                + ws_gates(i,1,j)*ws_gates(i,3,j);
            states_t_l(0,i,j) = ws_gates(i,2,j) * tanh_fwd(tmp);
            states_t_l(1,i,j) = tmp;
        }
}
#endif

template <>
elemwise_sig(_ref_rnn_common_t<prop_kind::backward>::lstm_elemwise) {
    AOC<float, 3> ws_gates(ws_gates_, batch, n_gates, dic);
    AOC<const float, 2> bias(bias_, n_gates, dic);
    AOC<float, 3> states_t_l(states_t_l_, n_states, batch, wic);
    AOC<float, 3> states_tm1_l(states_tm1_l_, n_states, batch, wic);
    AOC<float, 3> diff_states_t_l(diff_states_t_l_, n_states + 1, batch, wic);
    AOC<float, 3> diff_states_tp1_l(
            diff_states_tp1_l_, n_states + 1, batch, wic);
    AOC<float, 3> diff_states_t_lp1(
            diff_states_t_lp1_, n_states + 1, batch, wic);

    auto one_m_square = [](float a) -> float { return 1.0f - a * a; };

#pragma omp parallel for
    for (int i = 0; i < batch; i++) {
#pragma omp simd
        for (int j = 0; j < dic; j++) {
            float Ct = states_t_l(1, i, j);
            /// @todo save it in the workspace in fwd pass or recompute it to
            /// save bw
            float tanhCt = tanh_fwd(Ct);
            // we have 2 incoming diffs on Ht
            float dHt = diff_states_tp1_l(0, i, j)
                    + diff_states_t_lp1(n_states, i, j);
            float dCt = diff_states_tp1_l(1, i, j)
                    + one_m_square(tanhCt) * ws_gates(i, 2, j) * dHt;

            float dG0 = states_tm1_l(1, i, j)
                    * logistic_bwd(dCt, ws_gates(i, 0, j));
            float dG1
                    = ws_gates(i, 3, j) * logistic_bwd(dCt, ws_gates(i, 1, j));
            float dG2 = logistic_bwd(tanhCt * dHt, ws_gates(i, 2, j));
            float dG3 = ws_gates(i, 1, j) * tanh_bwd(dCt, ws_gates(i, 3, j));

            diff_states_t_l(1, i, j) = dCt * ws_gates(i, 0, j);

            ws_gates(i, 0, j) = dG0;
            ws_gates(i, 1, j) = dG1;
            ws_gates(i, 2, j) = dG2;
            ws_gates(i, 3, j) = dG3;
        }
    }
}

template <prop_kind_t aprop>
gemm_sig(_ref_rnn_common_t<aprop>::packed_gemm) {
#if USE_MKL_PACKED_GEMM
    cblas_sgemm_compute(CblasColMajor, CblasPacked,
            is_B_trans ? CblasTrans : CblasNoTrans, m, n, k, a_, strideA_m, b_,
            is_B_trans ? strideB_n : strideB_k, beta, c_, strideC_m);
#else
    UNUSED(m);
    UNUSED(n);
    UNUSED(k);
    UNUSED(a_);
    UNUSED(b_);
    UNUSED(c_);
    UNUSED(is_B_trans);
    UNUSED(beta);
    assert(!"packed gemm is disabled");
#endif
}

template <prop_kind_t aprop>
gemm_sig(_ref_rnn_common_t<aprop>::gemm) {
    cblas_sgemm(CblasColMajor, CblasNoTrans,
            is_B_trans ? CblasTrans : CblasNoTrans, m, n, k, 1.0f, a_,
            strideA_m, b_, is_B_trans ? strideB_n : strideB_k, beta, c_,
            strideC_m);
}

/// @todo template this function on fwd or bwd, if the overhead
///  to pass argument for empty function is too big
template <>
cell_execution_sig(_ref_rnn_common_t<prop_kind::forward>::cell_execution) {
    (this->*gemm_input_func)(n_gates * dic, batch, slc, n_gates * dic, slc,
            batch, wic, n_gates * dic, batch, w_input_, states_t_lm1_,
            ws_gates_, false, 0.0f);
    (this->*gemm_state_func)(n_gates * dic, batch, sic, n_gates * dic, sic,
            batch, wic, n_gates * dic, batch, w_state_, states_tm1_l_,
            ws_gates_, false, 1.0f);
    (this->*elemwise_func)(dic, wic, batch, n_states, n_gates, ws_gates_,
            states_t_l_, states_t_lm1_, states_tm1_l_, diff_states_t_l_,
            diff_states_t_lp1_, diff_states_tp1_l_, bias_);
}

template <>
cell_execution_sig(_ref_rnn_common_t<prop_kind::backward>::cell_execution) {
    (this->*elemwise_func)(dic, wic, batch, n_states, n_gates, ws_gates_,
            states_t_l_, states_t_lm1_, states_tm1_l_, diff_states_t_l_,
            diff_states_t_lp1_, diff_states_tp1_l_, bias_);

    /// bwd by data on the cell
    (this->*gemm_state_func)(sic, batch, n_gates * dic, sic, n_gates * dic,
            batch, n_gates * dic, wic, batch, w_state_, ws_gates_,
            diff_states_t_l_, false, 0.0f);
    (this->*gemm_input_func)(slc, batch, n_gates * dic, slc, n_gates * dic,
            batch, n_gates * dic, wic, batch, w_input_, ws_gates_,
            diff_states_t_l_ + n_states * (batch * wic), false, 0.0f);

    /// bwd by weights on the cell
    gemm(n_gates * dic, slc, batch, n_gates * dic, batch, wic, batch,
            n_gates * dic, slc, ws_gates_, states_t_lm1_, diff_w_input_, true,
            1.0f);
    gemm(n_gates * dic, sic, batch, n_gates * dic, batch, wic, batch,
            n_gates * dic, sic, ws_gates_, states_tm1_l_, diff_w_state_, true,
            1.0f);

/// bwd by bias we just accumulate diffs from the gates
#if (_OPENMP == 201307)
#pragma omp parallel for simd collapse(2)
#else
#pragma omp parallel for collapse(2) ///@todo block k on simd-width
#endif
    for (int i = 0; i < n_gates; i++)
        for (int k = 0; k < dic; k++)
            for (int j = 0; j < batch; j++)
                diff_bias_[i * dic + k]
                        += ws_gates_[(j * n_gates + i) * dic + k];
}

//*************** Grid computations strategy: linear ***************//
template <prop_kind_t aprop>
grid_execution_sig(_ref_rnn_common_t<aprop>::linear_execution) {
    AOC<float, 4> ws_states(ws_states_, n_layer + 1, n_direction, n_iter + 1,
            n_states * batch * wic);
    AOC<float, 4> ws_diff_states(ws_diff_states_, n_layer + 1, n_direction,
            n_iter + 1, (n_states + 1) * batch * wic);
    AOC<float, 4> ws_gates(
            ws_gates_, n_layer, n_direction, n_iter, n_gates * batch * dic);
    AOC<float *, 2> weights_input(weights_input_, n_layer, n_direction);
    AOC<float *, 2> weights_states(weights_states_, n_layer, n_direction);
    AOC<const float, 3> bias(bias_, n_layer, n_direction, n_gates * dic);
    AOC<float, 3> diff_weights_layer(
            diff_weights_layer_, n_layer, n_direction, slc * n_gates * dic);
    AOC<float, 3> diff_weights_iter(
            diff_weights_iter_, n_layer, n_direction, sic * n_gates * dic);
    AOC<float, 3> diff_bias(diff_bias_, n_layer, n_direction, n_gates * dic);

    // We run the grid of computation
    for (int dir = 0; dir < n_direction; dir++) {
        for (int j = 0; j < n_layer; j++) {
            for (int i = 0; i < n_iter; i++) {
                int lay, iter;
                if (aprop == prop_kind::forward) {
                    lay = j;
                    iter = i;
                } else { // backward
                    lay = n_layer - j - 1;
                    iter = n_iter - i - 1;
                }
                cell_execution(dic, slc, sic, wic, batch, n_gates, n_states,
                        &(ws_states(lay + 1, dir, iter + 1, 0)),
                        &(ws_diff_states(lay, dir, iter, 0)),
                        weights_input(lay, dir), weights_states(lay, dir),
                        &(bias(lay, dir, 0)),
                        &(ws_states(lay, dir, iter + 1, 0)),
                        &(ws_states(lay + 1, dir, iter, 0)),
                        &(ws_diff_states(lay + 1, dir, iter, 0)),
                        &(ws_diff_states(lay, dir, iter + 1, 0)),
                        &(diff_weights_layer(lay, dir, 0)),
                        &(diff_weights_iter(lay, dir, 0)),
                        &(diff_bias(lay, dir, 0)),
                        &(ws_gates(lay, dir, iter, 0)));
            }
        }
    }
}

#if 0
//************* Grid computations strategy: wavefront **************//

/*
  // To cover n_iter > n_layer and n_iter < n_layer
  min_dim = min(n_layer, n_iter)
  max_dim = max(n_layer, n_iter)
  and we assume that i refers to the max_dim dimension and j to the min_dim dimension

  We compute the the wavefront using 3 loop nests, each nest having 2 loops:
  - one for the head of the form loop on n_layer, and loop on n_elem in wave
      for (int i = 0; i < min_dim - 1; i++)
          for(int j = 0; j < i+1; j++)
  - one for the body:
      for (int i = 0; i < max_dim - min_dim + 1; i++)
          for(int j = 0; j < min_dim; j++)
  - one for the tail
      for (int i = min_dim; i > 0 ; i--)
          for(int j = 0; j < i; j++)
  Here, we define classes for each of the wavefront direction to compute
  the coordinates of the recurrent cells when running a wavefront execution
 */

typedef enum wavefront_loop_index_ {
    head,
    body,
    tail
} wavefront_loop_index;

struct wavefront_indexer {
    wavefront_indexer(int dim)
        : dim_(dim){};
    virtual int get(wavefront_loop_index idx,int i, int j) const;
protected:
    int dim_;
};

// bottom to top or left to right maxdim
struct wi_b2t_l2r_maxdim : wavefront_indexer {
    int get(wavefront_loop_index idx, int i, int j) const override {
        switch(idx){
        case head: return i - j;
        case body: return i - j;
        case tail: return dim_ - 1 - j;
        default: return -1;
        }
    }
};

// bottom to top or left to right mindim
struct wi_b2t_l2r_mindim : wavefront_indexer {
    int get(wavefront_loop_index idx, int i , int j) const override {
        switch(idx){
        case head: return j;
        case body: return j;
        case tail: return dim_ - i + j;
        default: return -1;
        }
    }
};

template<typename original_indexer>
struct reversed_indexer : wavefront_indexer {
    reversed_indexer(int dim) : wavefront_indexer(dim),
                                wd(original_indexer(dim)){}

    int get(wavefront_loop_index idx, int i, int j) const override {
        switch(idx){
        case head: return dim_ - 1 - wd.head(i,j);
        case body: return dim_ - 1 - wd.body(i,j);
        case tail: return dim_ - 1 - wd.tail(i,j);
        default: return -1;
        }
    }
    
private:
    original_indexer wd;
};

// top to bottom or right left maxdim and mindim
using wi_t2b_r2l_maxdim = reversed_indexer<wi_b2t_l2r_maxdim>;
using wi_t2b_r2l_mindim = reversed_indexer<wi_b2t_l2r_mindim>;

template<prop_kind_t aprop>
grid_execution_sig(_ref_rnn_common_t<aprop>::wavefront_execution){// (int dic, int slc,
                         // int sic, int batch,
                         // int n_layer, int n_direction, int n_iter,
                         // int n_gates, int n_states,
                         // const float **weights_input_, //[n_gates*dic][slc],
                         // const float **weights_states_, //[n_gates*dic][dic],
                         // const float *bias_, //[n_gates][dic],
                         // float *ws_, //[n_layer+1][n_direction][n_iter+1][n_states][batch][dic],
                         // float *gates_){ //[n_layer][n_direction][n_iter][batch][n_gates][dic]) {

    AOC<float, 4> ws(ws_, n_layer + 1, n_direction, n_iter + 1, n_states * batch * wic);
    AOC<float, 4> gates(gates_, n_layer, n_direction, n_iter, n_gates * batch * dic);
    AOC<float*, 2> weights_input(weights_input_, n_layer, n_direction);
    AOC<float*, 2> weights_states(weights_states_, n_layer, n_direction);
    AOC<const float, 2> bias(bias_, n_layer, n_gates * dic);
    // Setup the indexers: we have to check directions and if max_dim or min_dim
    bool is_niter_maxdim = n_iter >= n_layer;
    wavefront_indexer wi_maxdim = (is_niter_maxdim)
        ? (((exec_dir == b2t_l2r) || (exec_dir == t2b_l2r)) //niter is maxdim, we look for l2r
           ? (wavefront_indexer) wi_b2t_l2r_maxdim(n_iter)
           : (wavefront_indexer) wi_t2b_r2l_maxdim(n_iter))
        : (((exec_dir == b2t_l2r) || (exec_dir == b2t_r2l)) //nlayer is maxdim, we look for b2t
           ? (wavefront_indexer) wi_b2t_l2r_maxdim(n_layer)
           : (wavefront_indexer) wi_t2b_r2l_maxdim(n_layer));
    
    wavefront_indexer wi_mindim = (!is_niter_maxdim)
        ? (((exec_dir == b2t_l2r) || (exec_dir == t2b_l2r)) //niter is mindim, we look for l2r
           ? (wavefront_indexer) wi_b2t_l2r_mindim(n_iter)
           : (wavefront_indexer) wi_t2b_r2l_mindim(n_iter))
        : (((exec_dir == b2t_l2r) || (exec_dir == b2t_r2l)) //nlayer is mindim, we look for b2t
           ? (wavefront_indexer) wi_b2t_l2r_mindim(n_layer)
           : (wavefront_indexer) wi_t2b_r2l_mindim(n_layer));
    
    // auto get_offset = [=](wavefront_loop_index idx, int i, int j){
    //     int dim_min = wi_mindim.get(idx, i,j);
    //     int dim_max = wi_maxdim.get(idx, i,j);
    //     int offset = (is_niter_maxdim)
    //     ? dim_min*n_iter + dim_max
    //     : dim_max*n_iter + dim_min;
    // };

#define get_lay_n_iter(idx, i, j)               \
    do {                                        \
        int dim_min = wi_mindim.get(idx, i, j); \
        int dim_max = wi_maxdim.get(idx, i, j); \
        if (is_niter_maxdim) {                  \
            lay = dim_min;                      \
            iter = dim_max;                     \
        } else {                                \
            lay = dim_max;                      \
            iter = dim_min;                     \
        }                                       \
    } while (0)

    int min_dim = is_niter_maxdim ? n_layer : n_iter;
    int max_dim = is_niter_maxdim ? n_iter :n_layer;
    int lay, iter;
    for (int i = 0; i < min_dim - 1; i++)
        for(int j = 0; j < i+1; j++){
            get_lay_n_iter(head,i,j);
            cell_execution(dic, slc, sic, batch,
                 n_gates, n_states,
                 &(ws(lay, iter, 0)), weights_input(lay - 1, 0),
                 weights_states(lay - 1, 0), &(bias(lay-1, 0)),
                 &(ws(lay - 1, iter, 0)), &(ws(lay, iter - 1, 0)), &(gates(lay-1, iter-1, 0)));
        }
    for (int i = min_dim - 1; i < max_dim; i++)
        for(int j = 0; j < min_dim; j++){
            get_lay_n_iter(body,i,j);
        }
    for (int i = min_dim - 1; i > 0 ; i--)
        for(int j = 0; j < i; j++){
            get_lay_n_iter(tail,i,j);
        }

#undef get_lay_n_iter
}
#endif
//********* GRID computations strategy: utility functions **********//

template <>
void _ref_rnn_common_t<prop_kind::forward>::copy_init_layer(bool lr, bool rl,
        int n_layer, int n_direction, int n_iter, int batch, int slc, int dlc,
        int wic, int n_states, float *ws_states_, float *ws_diff_states_,
        const float *xt_, const float *diff_dst_layer_) {
    AOC<float, 5> ws_states(
            ws_states_, n_direction, n_iter + 1, n_states, batch, wic);
    auto xt_d = memory_desc_wrapper(conf_.src_pd(0));

#pragma omp parallel for
    for (int it = 0; it < n_iter; it++) {
        auto xxt = xt_ + xt_d.blk_off(it);
        if (lr)
            for (int b = 0; b < batch; b++)
                for (int c = 0; c < slc; c++)
                    ws_states(0, it + 1, 0, b, c) = *(xxt + b * slc + c);
        if (rl)
            for (int b = 0; b < batch; b++)
                for (int c = 0; c < slc; c++)
                    ws_states(n_direction - 1, n_iter - it, 0, b, c)
                            = *(xxt + b * slc + c);
    }
}

template <>
void _ref_rnn_common_t<prop_kind::backward>::copy_init_layer(bool lr, bool rl,
        int n_layer, int n_direction, int n_iter, int batch, int slc, int dlc,
        int wic, int n_states, float *ws_states_, float *ws_diff_states_,
        const float *xt_, const float *diff_dst_layer_) {
    AOC<float, 6> ws_diff_states(ws_diff_states_, n_layer + 1, n_direction,
            n_iter + 1, (n_states + 1), batch, wic);
    auto diff_dst_layer_d = memory_desc_wrapper(conf_.diff_dst_pd(0));

    switch (conf_.direction()) {
    case mkldnn_bidirectional_concat:
#pragma omp parallel for collapse(2)
        for (int it = 0; it < n_iter; it++) {
            for (int b = 0; b < batch; b++) {
                auto diff_dst_layer_x
                        = diff_dst_layer_ + diff_dst_layer_d.blk_off(it, b);
                for (int s = 0; s < dlc; s++) {
                    ws_diff_states(n_layer, 0, it, n_states, b, s)
                            = diff_dst_layer_x[s];
                    ws_diff_states(n_layer, 1, it, n_states, b, s)
                            = diff_dst_layer_x[slc + s];
                }
            }
        }
        break;
    case mkldnn_bidirectional_sum:
#pragma omp parallel for collapse(2)
        for (int it = 0; it < n_iter; it++) {
            for (int b = 0; b < batch; b++) {
                auto diff_dst_layer_x
                        = diff_dst_layer_ + diff_dst_layer_d.blk_off(it, b);
                for (int s = 0; s < slc; s++) {
                    ws_diff_states(n_layer, 0, it, n_states, b, s)
                            = diff_dst_layer_x[s];
                    ws_diff_states(n_layer, 1, it, n_states, b, s)
                            = diff_dst_layer_x[s];
                }
            }
        }
        break;
    default: // assumes default is always unidirectional
#pragma omp parallel for collapse(2)
        for (int it = 0; it < n_iter; it++) {
            for (int b = 0; b < batch; b++) {
                auto diff_dst_layer_x
                        = diff_dst_layer_ + diff_dst_layer_d.blk_off(it, b);
                for (int s = 0; s < slc; s++) {
                    ws_diff_states(n_layer, 0, it, n_states, b, s)
                            = diff_dst_layer_x[s];
                }
            }
        }
        break;
    }
}

template <>
void _ref_rnn_common_t<prop_kind::forward>::copy_init_iter(int n_layer,
        int n_direction, int n_states, int batch, int sic, int dic, int wic,
        int n_iter, float *ws_states_, float *ws_diff_states_,
        const float *firstit_states_, const float *diff_dst_iter_) {
    AOC<float, 6> ws_states(ws_states_, n_layer + 1, n_direction, n_iter + 1,
            n_states, batch, wic);
    auto firstit_states_d = memory_desc_wrapper(conf_.src_pd(1));
    if (firstit_states_) {
#pragma omp parallel for collapse(2)
        for (int lay = 0; lay < n_layer; lay++)
            for (int dir = 0; dir < n_direction; dir++)
                for (int state = 0; state < n_states; state++)
                    for (int b = 0; b < batch; ++b) {
                        array_copy(&(ws_states(lay + 1, dir, 0, state, b, 0)),
                                firstit_states_
                                        + firstit_states_d.blk_off(
                                                  lay, dir, state, b),
                                sic);
                    }
    } else {
#pragma omp parallel for collapse(2)
        for (int lay = 0; lay < n_layer; lay++)
            for (int dir = 0; dir < n_direction; dir++)
                for (int state = 0; state < n_states; state++)
                    for (int i = 0; i < batch; i++)
                        for (int j = 0; j < sic; j++)
                            ws_states(lay + 1, dir, 0, state, i, j) = 0.0f;
    }
}

template <>
void _ref_rnn_common_t<prop_kind::backward>::copy_init_iter(int n_layer,
        int n_direction, int n_states, int batch, int sic, int dic, int wic,
        int n_iter, float *ws_states_, float *ws_diff_states_,
        const float *firstit_states_, const float *diff_dst_iter_) {
    AOC<float, 6> ws_diff_states(ws_diff_states_, n_layer + 1, n_direction,
            n_iter + 1, n_states + 1, batch, wic);
    auto diff_dst_iter_d = memory_desc_wrapper(conf_.diff_dst_pd(1));
    if (diff_dst_iter_) {
#pragma omp parallel for collapse(4)
        for (int lay = 0; lay < n_layer; lay++)
            for (int dir = 0; dir < n_direction; dir++)
                for (int state = 0; state < n_states; state++)
                    for (int b = 0; b < batch; ++b) {
                        array_copy(&(ws_diff_states(
                                           lay, dir, n_iter, state, b, 0)),
                                diff_dst_iter_
                                        + diff_dst_iter_d.blk_off(
                                                  lay, dir, state, b),
                                dic);
                    }
    } else {
#pragma omp parallel for collapse(4)
        for (int lay = 0; lay < n_layer; lay++)
            for (int dir = 0; dir < n_direction; dir++)
                for (int state = 0; state < n_states; state++)
                    for (int i = 0; i < batch; i++)
                        for (int j = 0; j < sic; j++)
                            ws_diff_states(lay, dir, n_iter, state, i, j)
                                    = 0.0f;
    }
}

template <>
void _ref_rnn_common_t<prop_kind::forward>::copy_res_layer(bool lr, bool rl,
        int n_layer, int n_direction, int n_iter, int batch,
        int n_output_features, int slc, int dic, int wic, int n_states,
        mkldnn_rnn_direction_t direction, float *dst_layer_,
        float *diff_src_layer, const float *ws_states_,
        const float *ws_diff_states_) {
    auto dst_layer_d = memory_desc_wrapper(conf_.dst_pd(0));
    AOC<const float, 6> ws_states(ws_states_, n_layer + 1, n_direction,
            n_iter + 1, n_states, batch, wic);
#pragma omp parallel for collapse(2)
    for (int it = 0; it < n_iter; it++) {
        for (int b = 0; b < batch; b++) {
            int dir = 0;
            if (lr) {
                for (int s = 0; s < dic; s++)
                    dst_layer_[dst_layer_d.blk_off(it, b, dir * dic + s)]
                            = ws_states(n_layer, dir, it + 1, 0, b, s);
                dir = 1;
            }
            if (rl) {
                for (int s = 0; s < dic; s++)
                    switch (direction) {
                    case mkldnn_bidirectional_sum:
                        dst_layer_[dst_layer_d.blk_off(it, b, s)] += ws_states(
                                n_layer, dir, n_iter - it, 0, b, s);
                        break;
                    default:
                        dst_layer_[dst_layer_d.blk_off(it, b, dir * dic + s)]
                                = ws_states(n_layer, dir, n_iter - it, 0, b, s);
                    }
            }
        }
    }
}

template <>
void _ref_rnn_common_t<prop_kind::backward>::copy_res_layer(bool lr, bool rl,
        int n_layer, int n_direction, int n_iter, int batch,
        int n_output_features, int slc, int dic, int wic, int n_states,
        mkldnn_rnn_direction_t direction, float *dst_layer_,
        float *diff_src_layer_, const float *ws_states_,
        const float *ws_diff_states_) {
    auto diff_src_layer_d = memory_desc_wrapper(conf_.diff_src_pd(0));
    AOC<const float, 6> ws_diff_states(ws_diff_states_, n_layer + 1,
            n_direction, n_iter + 1, n_states + 1, batch, wic);
#pragma omp parallel for collapse(2)
    for (int it = 0; it < n_iter; it++) {
        for (int b = 0; b < batch; b++) {
            int dir = 0;
            for (int s = 0; s < slc; s++) {
                float *dst_addr = diff_src_layer_
                        + diff_src_layer_d.blk_off(
                                  (direction
                                          == mkldnn_unidirectional_right2left) ?
                                          n_iter - 1 - it :
                                          it,
                                  b, dir * slc + s);
                float res = ws_diff_states(0, 0, it, n_states, b, s);
                if (n_direction - 1)
                    res += ws_diff_states(
                            0, 1, n_iter - 1 - it, n_states, b, s);
                dst_addr[0] = res;
            }
        }
    }
}

template <>
void _ref_rnn_common_t<prop_kind::forward>::copy_res_iter(int n_layer,
        int n_direction, int n_states, int batch, int sic, int dic, int wic,
        int n_iter, float *dst_iter_, float *diff_src_iter_,
        const float *ws_states_, const float *ws_diff_states_) {
    auto dst_iter_d = memory_desc_wrapper(conf_.dst_pd(1));
    AOC<const float, 6> ws_states(ws_states_, n_layer + 1, n_direction,
            n_iter + 1, n_states, batch, wic);
    if (dst_iter_) {
#pragma omp parallel for collapse(4)
        for (int lay = 0; lay < n_layer; lay++) {
            for (int dir = 0; dir < n_direction; dir++)
                for (int state = 0; state < n_states; state++)
                    for (int b = 0; b < batch; b++)
                        for (int s = 0; s < dic; s++) {
                            dst_iter_[dst_iter_d.blk_off(lay, dir, state, b, s)]
                                    = ws_states(
                                            lay + 1, dir, n_iter, state, b, s);
                        }
        }
    }
}

template <>
void _ref_rnn_common_t<prop_kind::backward>::copy_res_iter(int n_layer,
        int n_direction, int n_states, int batch, int sic, int dic, int wic,
        int n_iter, float *dst_iter_, float *diff_src_iter_,
        const float *ws_states_, const float *ws_diff_states_) {
    auto diff_src_iter_d = memory_desc_wrapper(conf_.diff_src_pd(1));
    AOC<const float, 6> ws_diff_states(ws_diff_states_, n_layer + 1,
            n_direction, n_iter + 1, n_states + 1, batch, wic);
    if (diff_src_iter_) {
#pragma omp parallel for collapse(4)
        for (int lay = 0; lay < n_layer; lay++) {
            for (int dir = 0; dir < n_direction; dir++)
                for (int state = 0; state < n_states; state++)
                    for (int b = 0; b < batch; b++)
                        for (int s = 0; s < sic; s++) {
                            diff_src_iter_[diff_src_iter_d.blk_off(
                                    lay, dir, state, b, s)]
                                    = ws_diff_states(lay, dir, 0, state, b, s);
                        }
        }
    }
}

template <prop_kind_t aprop>
packing_sig(_ref_rnn_common_t<aprop>::pack_weights) {
#if USE_MKL_PACKED_GEMM
    AOC<const float, 3> w(
            w_, n_layer, n_direction, n_gates * OC_size * IC_size);
    AOC<float *, 2> weights(weights_, n_layer, n_direction);
    int m = 0, n = 0, k = 0, ldA = 0;
    auto transA = CblasNoTrans;
    if (aprop == prop_kind::forward) {
        m = n_gates * OC_size;
        n = batch;
        k = IC_size;
        transA = CblasNoTrans;
        ldA = m;
    }
    if (aprop == prop_kind::backward) {
        m = IC_size;
        n = batch;
        k = n_gates * OC_size;
        transA = CblasTrans;
        ldA = k;
    }
    for (int i = 0; i < n_layer; i++) {
        for (int d = 0; d < n_direction; d++) {
            weights(i, d) = cblas_sgemm_alloc(CblasAMatrix, m, n, k);
            cblas_sgemm_pack(CblasColMajor, CblasAMatrix, transA, m, n, k, 1.0f,
                    &(w(i, d, 0)), ldA, weights(i, d));
        }
    }
#else
    UNUSED(n_layer);
    UNUSED(n_direction);
    UNUSED(n_weights);
    UNUSED(n_gates);
    UNUSED(batch);
    UNUSED(OC_size);
    UNUSED(IC_size);
    UNUSED(weights_);
    UNUSED(w_);
    assert(!"packed gemm is disabled");
#endif
}

template <prop_kind_t aprop>
packing_sig(_ref_rnn_common_t<aprop>::no_pack_weights) {
    AOC<const float, 3> w(
            w_, n_layer, n_direction, n_gates * OC_size * IC_size);
    AOC<float *, 2> weights(weights_, n_layer, n_direction);
    for (int i = 0; i < n_layer; i++) {
        for (int d = 0; d < n_direction; d++) {
            weights(i, d) = (float *)&(w(i, d, 0));
        }
    }
}

template <prop_kind_t aprop>
free_packed_sig(_ref_rnn_common_t<aprop>::free_packed_weights) {
#if USE_MKL_PACKED_GEMM
    for (int i = 0; i < n_layer; i++) {
        cblas_sgemm_free(weights_[i]);
    }
#else
    UNUSED(n_layer);
    UNUSED(weights_);
    assert(!"packed gemm is disabled");
#endif
}

template <prop_kind_t aprop>
free_packed_sig(_ref_rnn_common_t<aprop>::free_no_packed_weights) {
    UNUSED(n_layer);
    UNUSED(weights_);
}

//********************* Execution function *********************//
template <prop_kind_t aprop>
void _ref_rnn_common_t<aprop>::execute_() {
    int n_layer = conf_.L();
    int n_direction = conf_.D();
    int n_iter = conf_.T();
    int n_gates = conf_.G();
    int n_states = conf_.S();
    int n_weights_input = conf_.SLC();
    int n_weights_state = conf_.SIC();
    int batch = conf_.MB();
    int slc = conf_.SLC();
    int sic = conf_.SIC();
    int dic = conf_.DIC();
    int dlc = conf_.DLC();
    int wic = nstl::max(slc, nstl::max(sic, dic));

    bool is_fwd = aprop == prop_kind::forward;

    int input_idx = 0;
    int output_idx = 0;
    auto input
            = reinterpret_cast<const float *>(this->input_memory(input_idx++));
    auto states = conf_.with_src_iter() ?
            reinterpret_cast<const float *>(this->input_memory(input_idx++)) :
            nullptr;
    auto w_input
            = reinterpret_cast<const float *>(this->input_memory(input_idx++));
    auto w_state
            = reinterpret_cast<const float *>(this->input_memory(input_idx++));
    auto bias = conf_.with_bias() ?
            reinterpret_cast<const float *>(this->input_memory(input_idx++)) :
            nullptr;

    auto dst_last_layer = is_fwd ?
            reinterpret_cast<float *>(this->memory(output_idx++)) :
            const_cast<float *>(reinterpret_cast<const float *>(
                    this->input_memory(input_idx++)));
    auto dst_last_iter = conf_.with_dst_iter() ?
            (is_fwd ? reinterpret_cast<float *>(this->memory(output_idx++)) :
                      const_cast<float *>(reinterpret_cast<const float *>(
                              this->input_memory(input_idx++)))) :
            nullptr;

    auto diff_dst_layer = is_fwd ?
            nullptr :
            reinterpret_cast<const float *>(this->input_memory(input_idx++));
    auto diff_dst_iter = is_fwd || !conf_.with_src_iter() ?
            nullptr :
            reinterpret_cast<const float *>(this->input_memory(input_idx++));

    // if no workspace was provided we use the scratchpad
    if (use_scratchpad_) {
        ws_gates_ = ((float *)scratchpad_->get());
        ws_states_ = ((float *)scratchpad_->get()) + ws_states_offset_;
        ws_diff_states_
                = ((float *)scratchpad_->get()) + ws_diff_states_offset_;
    } else {
        float *ws_ptr = is_fwd ?
                reinterpret_cast<float *>(this->memory(output_idx++)) :
                const_cast<float *>(reinterpret_cast<const float *>(
                        this->input_memory(input_idx++)));
        ws_gates_ = ws_ptr + ws_gates_offset_;
        ws_states_ = ws_ptr + ws_states_offset_;
        ws_diff_states_ = ws_ptr + ws_diff_states_offset_;
    }

    auto diff_src_layer = is_fwd ?
            nullptr :
            reinterpret_cast<float *>(this->memory(output_idx++));
    auto diff_src_iter = is_fwd || !conf_.with_src_iter() ?
            nullptr :
            reinterpret_cast<float *>(this->memory(output_idx++));
    auto diff_weights_layer = is_fwd ?
            nullptr :
            reinterpret_cast<float *>(this->memory(output_idx++));
    auto diff_weights_iter = is_fwd ?
            nullptr :
            reinterpret_cast<float *>(this->memory(output_idx++));
    auto diff_bias = is_fwd || !conf_.with_bias() ?
            nullptr :
            reinterpret_cast<float *>(this->memory(output_idx++));

    // initialize diff_states to 0
    if (aprop == prop_kind::backward)
        array_set(ws_diff_states_, 0.0f, conf_.ws_diff_states_size());

    // TODO: implement without copies
    bool is_lr = !one_of(exec_dir, b2t_r2l, t2b_r2l);
    bool is_rl = !one_of(exec_dir, b2t_l2r, t2b_l2r);

    // we pack the weights if we are using the packed API
    (this->*weights_state_pack_func)(n_layer, n_direction, n_weights_state,
            n_gates, batch, dic, sic, ptr_wei_state_, w_state);
    (this->*weights_input_pack_func)(n_layer, n_direction, n_weights_input,
            n_gates, batch, dic, slc, ptr_wei_input_, w_input);

    // we first need to copy the initial states and input into ws
    copy_init_layer(is_lr, is_rl, n_layer, n_direction, n_iter, batch, slc, dlc,
            wic, n_states, ws_states_, ws_diff_states_, input, diff_dst_layer);
    copy_init_iter(n_layer, n_direction, n_states, batch, sic, dic, wic, n_iter,
            ws_states_, ws_diff_states_, states, diff_dst_iter);

    // run the execution on the grid
    (this->*grid_computation)(dic, slc, sic, wic, batch, n_layer, n_direction,
            n_iter, n_gates, n_states, ptr_wei_input_, ptr_wei_state_,
            (float *)bias, ws_states_, ws_diff_states_, ws_gates_,
            diff_weights_layer, diff_weights_iter, diff_bias);

    // Finally we copy the results to the result buffers
    copy_res_layer(is_lr, is_rl, n_layer, n_direction, n_iter, batch,
            n_output_features, slc, dic, wic, n_states, conf_.direction(),
            dst_last_layer, diff_src_layer, ws_states_, ws_diff_states_);
    copy_res_iter(n_layer, n_direction, n_states, batch, sic, dic, wic, n_iter,
            dst_last_iter, diff_src_iter, ws_states_, ws_diff_states_);

    // We free the packed weights if they were packed internally
    (this->*weights_state_free_packed_func)(n_layer, ptr_wei_state_);
    (this->*weights_input_free_packed_func)(n_layer, ptr_wei_input_);
};

template struct _ref_rnn_common_t<prop_kind::forward>;
template struct _ref_rnn_common_t<prop_kind::backward>;
}
}
}
