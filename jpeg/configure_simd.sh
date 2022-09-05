#!/bin/bash
set -euo pipefail
cat <<'EOF' >jpeg/simd/jsimdcfg.inc
%define DCTSIZE 8
%define DCTSIZE2 64
%define RGB_RED 0
%define RGB_GREEN 1
%define RGB_BLUE 2
%define RGB_PIXELSIZE 3
%define EXT_RGB_RED 0
%define EXT_RGB_GREEN 1
%define EXT_RGB_BLUE 2
%define EXT_RGB_PIXELSIZE 3
%define EXT_RGBX_RED 0
%define EXT_RGBX_GREEN 1
%define EXT_RGBX_BLUE 2
%define EXT_RGBX_PIXELSIZE 4
%define EXT_BGR_RED 2
%define EXT_BGR_GREEN 1
%define EXT_BGR_BLUE 0
%define EXT_BGR_PIXELSIZE 3
%define EXT_BGRX_RED 2
%define EXT_BGRX_GREEN 1
%define EXT_BGRX_BLUE 0
%define EXT_BGRX_PIXELSIZE 4
%define EXT_XBGR_RED 3
%define EXT_XBGR_GREEN 2
%define EXT_XBGR_BLUE 1
%define EXT_XBGR_PIXELSIZE 4
%define EXT_XRGB_RED 1
%define EXT_XRGB_GREEN 2
%define EXT_XRGB_BLUE 3
%define EXT_XRGB_PIXELSIZE 4
%define RGBX_FILLER_0XFF 1
%define JSAMPLE byte ; unsigned char
%define SIZEOF_JSAMPLE SIZEOF_BYTE ; sizeof(JSAMPLE)
%define CENTERJSAMPLE 128
%define JCOEF word ; short
%define SIZEOF_JCOEF SIZEOF_WORD ; sizeof(JCOEF)
%define JDIMENSION dword ; unsigned int
%define SIZEOF_JDIMENSION SIZEOF_DWORD ; sizeof(JDIMENSION)
%define JSAMPROW POINTER ; JSAMPLE * (jpeglib.h)
%define JSAMPARRAY POINTER ; JSAMPROW * (jpeglib.h)
%define JSAMPIMAGE POINTER ; JSAMPARRAY * (jpeglib.h)
%define JCOEFPTR POINTER ; JCOEF * (jpeglib.h)
%define SIZEOF_JSAMPROW SIZEOF_POINTER ; sizeof(JSAMPROW)
%define SIZEOF_JSAMPARRAY SIZEOF_POINTER ; sizeof(JSAMPARRAY)
%define SIZEOF_JSAMPIMAGE SIZEOF_POINTER ; sizeof(JSAMPIMAGE)
%define SIZEOF_JCOEFPTR SIZEOF_POINTER ; sizeof(JCOEFPTR)
%define DCTELEM word ; short
%define SIZEOF_DCTELEM SIZEOF_WORD ; sizeof(DCTELEM)
%define float FP32 ; float
%define SIZEOF_FAST_FLOAT SIZEOF_FP32 ; sizeof(float)
%define ISLOW_MULT_TYPE word ; must be short
%define SIZEOF_ISLOW_MULT_TYPE SIZEOF_WORD ; sizeof(ISLOW_MULT_TYPE)
%define IFAST_MULT_TYPE word ; must be short
%define SIZEOF_IFAST_MULT_TYPE SIZEOF_WORD ; sizeof(IFAST_MULT_TYPE)
%define IFAST_SCALE_BITS 2 ; fractional bits in scale factors
%define FLOAT_MULT_TYPE FP32 ; must be float
%define SIZEOF_FLOAT_MULT_TYPE SIZEOF_FP32 ; sizeof(FLOAT_MULT_TYPE)
%define JSIMD_NONE 0x00
%define JSIMD_MMX 0x01
%define JSIMD_3DNOW 0x02
%define JSIMD_SSE 0x04
%define JSIMD_SSE2 0x08
EOF