#!/bin/bash
set -euo pipefail
for out in jpeg/simd/jccolor-sse2-64.o jpeg/simd/jcgray-sse2-64.o jpeg/simd/jchuff-sse2-64.o jpeg/simd/jcsample-sse2-64.o jpeg/simd/jdcolor-sse2-64.o jpeg/simd/jdmerge-sse2-64.o jpeg/simd/jdsample-sse2-64.o jpeg/simd/jfdctflt-sse-64.o jpeg/simd/jfdctfst-sse2-64.o jpeg/simd/jfdctint-sse2-64.o jpeg/simd/jidctflt-sse2-64.o jpeg/simd/jidctfst-sse2-64.o jpeg/simd/jidctint-sse2-64.o jpeg/simd/jidctred-sse2-64.o jpeg/simd/jquantf-sse2-64.o jpeg/simd/jquanti-sse2-64.o; do
  blake-bin/nasm/nasm -f elf64    -DELF -DPIC -DRGBX_FILLER_0XFF -D__x86_64__ -DARCH_X86_64    -I $(dirname jpeg/simd/jdct.inc)/    -I $(dirname jpeg/simd/jsimdcfg.inc)/    -o $out    $(dirname jpeg/simd/jdct.inc)/$(basename ${out%.o}.asm)
done