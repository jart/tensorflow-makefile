#               .--.                              .--.
#             .'(`                               /  ..\
#          __.>\ '.  _.---,._,'             ____.'  _o/
#        /.--.  : |/' _.--.<                '--.     |.__
#     _..-'    `\     /'     `'             _.-'     /--'
#      >_.-``-. `Y  /' _.---._____     _.--'        /
#     '` .-''. \|:  \.'   ___, .-'`   ~'--....___.-'
#      .'--._ `-:  \/   /'    \
#          /.'`\ :;    /'       `-.      blakefile
#         -`    |     |                 version o.1
#               :.; : |
#               |:    |             The sun does arise,
#               |     :          And make happy the skies.
#               :. :  |            The merry bells ring
#               |   ; :           To welcome the Spring.
#               :;   .|          The sky-lark and thrush,
#               |     |           The birds of the bush,
#               :. :  |             Sing louder around,
#               |  .  |        To the bells' cheerful sound
#               :.   .|        While our sports shall be seen
#               |   ; |            On the Echoing Green.
#             .jgs    ;
#             /:::.    `\
# blakefiler -c opt //tensorflow/core:lib //tensorflow/core:protos_all_cc //tensorflow/core:framework_lite //tensorflow/core:ops //tensorflow/core:framework

.UNSANDBOXED = 1

COMPILATION_MODE = ape
TARGET_CPU = k8
ANDROID_CPU = armeabi

AR = ar
ARFLAGS = rcsD
AS = as
CC = cc
CPP = $(CC) -E
CXX = c++
DWP = dwp
FPIC = -fPIC
FPIE = -fno-pie
GCC = gcc
GCOV = gcov
GCOVTOOL = gcov-tool
JAVA = java
JAVAC = javac
LD = ld
LLVM_PROFDATA = llvm-profdata
NM = nm
NOWA = -Wl,--no-whole-archive
OBJCOPY = objcopy
OBJDUMP = objdump
PIE = -pie
STRIP = strip
WA = -Wl,--whole-archive

STACK_FRAME = -Wframe-larger-than=32768
STACK_FRAME_UNLIMITED = -Wframe-larger-than=100000000 -Wno-vla

CFLAGS.security = -fstack-protector $(STACK_FRAME)
CPPFLAGS.security = -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1
CXXFLAGS.security = $(CFLAGS.security)
LDFLAGS.security = -Wl,-z,relro,-z,now

CPPFLAGS.determinism = -Wno-builtin-macro-redefined '-D__DATE__="redacted"' '-D__TIMESTAMP__="redacted"' '-D__TIME__="redacted"'

CFLAGS.fastbuild = -g0 -O0
CPPFLAGS.fastbuild =
CXXFLAGS.fastbuild = $(CFLAGS.fastbuild)
LDFLAGS.fastbuild = -Wl,-S
LDLIBS.fastbuild =

CFLAGS.dbg = -g
CPPFLAGS.dbg =
CXXFLAGS.dbg = $(CFLAGS.dbg)
LDFLAGS.dbg =
LDLIBS.dbg =

CFLAGS.opt = -g0 -O2 -ffunction-sections -fdata-sections
CPPFLAGS.opt = -DNDEBUG
CXXFLAGS.opt = $(CFLAGS.opt)
LDFLAGS.opt = -Wl,--gc-sections
LDLIBS.opt =

CFLAGS.ape = \
	-g0 \
	-O2 \
	-fno-omit-frame-pointer \
	-fdata-sections \
	-ffunction-sections \
	-pg -mnop-mcount \
	-mno-tls-direct-seg-refs
CPPFLAGS.ape = \
	-DNDEBUG \
	-nostdinc \
	-iquote ../cosmo \
	-isystem ../cosmo/libc/isystem \
	-include libc/integral/normalize.inc
CXXFLAGS.ape = \
	$(CFLAGS.ape)
LDFLAGS.ape = \
	-static \
	-no-pie \
	-nostdlib \
	-fuse-ld=bfd \
	-Wl,--gc-sections \
	-Wl,--oformat=binary \
	-Wl,-T,../cosmo/o/ape/ape.lds \
	../cosmo/o/ape/ape-no-modify-self.o \
	../cosmo/o/libc/crt/crt.o
LDLIBS.ape = \
	../cosmo/o/third_party/libcxx/libcxx.a \
	../cosmo/o/cosmopolitan.a

CFLAGS.global =
CPPFLAGS.global = $(CPPFLAGS.determinism)
CXXFLAGS.global = -std=c++11
LDFLAGS.global =
LDLIBS.global =

ifeq ($(COMPILATION_MODE),fastbuild)
  CFLAGS.default = $(CFLAGS.global) $(CFLAGS.fastbuild)
  CPPFLAGS.default = $(CPPFLAGS.global) $(CPPFLAGS.fastbuild)
  CXXFLAGS.default = $(CXXFLAGS.global) $(CXXFLAGS.fastbuild)
  LDFLAGS.default = $(LDFLAGS.global) $(LDFLAGS.fastbuild)
  LDLIBS.default = $(LDLIBS.global) $(LDLIBS.fastbuild)
endif

ifeq ($(COMPILATION_MODE),dbg)
  CFLAGS.default = $(CFLAGS.global) $(CFLAGS.dbg)
  CPPFLAGS.default = $(CPPFLAGS.global) $(CPPFLAGS.dbg)
  CXXFLAGS.default = $(CXXFLAGS.global) $(CXXFLAGS.dbg)
  LDFLAGS.default = $(LDFLAGS.global) $(LDFLAGS.dbg)
  LDLIBS.default = $(LDLIBS.global) $(LDLIBS.dbg)
endif

ifeq ($(COMPILATION_MODE),opt)
  CFLAGS.default = $(CFLAGS.global) $(CFLAGS.opt)
  CPPFLAGS.default = $(CPPFLAGS.global) $(CPPFLAGS.opt)
  CXXFLAGS.default = $(CXXFLAGS.global) $(CXXFLAGS.opt)
  LDFLAGS.default = $(LDFLAGS.global) $(LDFLAGS.opt)
  LDLIBS.default = $(LDLIBS.global) $(LDLIBS.opt)
endif

ifeq ($(COMPILATION_MODE),ape)
  CFLAGS.default = $(CFLAGS.global) $(CFLAGS.ape)
  CPPFLAGS.default = $(CPPFLAGS.global) $(CPPFLAGS.ape)
  CXXFLAGS.default = $(CXXFLAGS.global) $(CXXFLAGS.ape)
  LDFLAGS.default = $(LDFLAGS.global) $(LDFLAGS.ape)
  LDLIBS.default = $(LDLIBS.global) $(LDLIBS.ape)
endif

CFLAGS = $(CFLAGS.default)
CPPFLAGS = $(CPPFLAGS.default)
CXXFLAGS = $(CXXFLAGS.default)
LDFLAGS = $(LDFLAGS.default)
LDLIBS = $(LDLIBS.default)

################################################################################
# @bazel_tools//tools/cpp:stl

################################################################################
# @bazel_tools//third_party/def_parser:def_parser_lib

bazel_tools_third_party_def_parser_def_parser_lib_HEADERS = \
	bazel_tools/third_party/def_parser/def_parser.h

bazel_tools_third_party_def_parser_def_parser_lib_LINK = \
	blake-bin/bazel_tools/third_party/def_parser/libdef_parser_lib.so

blake-bin/bazel_tools/third_party/def_parser/_objs/def_parser_lib/%.pic.o: \
		bazel_tools/third_party/def_parser/%.cc \
		$(bazel_tools_third_party_def_parser_def_parser_lib_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/third_party/def_parser/_objs/def_parser_lib/%.o: \
		bazel_tools/third_party/def_parser/%.cc \
		$(bazel_tools_third_party_def_parser_def_parser_lib_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/third_party/def_parser/libdef_parser_lib.a: \
		blake-bin/bazel_tools/third_party/def_parser/_objs/def_parser_lib/def_parser.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_third_party_def_parser_def_parser_lib_SBLINK = \
	blake-bin/bazel_tools/third_party/def_parser/libdef_parser_lib.a

blake-bin/bazel_tools/third_party/def_parser/libdef_parser_lib.pic.a: \
		blake-bin/bazel_tools/third_party/def_parser/_objs/def_parser_lib/def_parser.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_third_party_def_parser_def_parser_lib_SPLINK = \
	blake-bin/bazel_tools/third_party/def_parser/libdef_parser_lib.pic.a

blake-bin/bazel_tools/third_party/def_parser/libdef_parser_lib.so: \
		$(bazel_tools_third_party_def_parser_def_parser_lib_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_third_party_def_parser_def_parser_lib_SPLINK) $(NOWA) 

################################################################################
# @bazel_tools//tools/cpp:malloc

################################################################################
# @bazel_tools//third_party/def_parser:def_parser

blake-bin/bazel_tools/third_party/def_parser/_objs/def_parser/%.o: \
		bazel_tools/third_party/def_parser/%.cc \
		$(bazel_tools_third_party_def_parser_def_parser_lib_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/third_party/def_parser/libdef_parser.a: \
		blake-bin/bazel_tools/third_party/def_parser/_objs/def_parser/def_parser_main.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_third_party_def_parser_def_parser_SBLINKT = \
	blake-bin/bazel_tools/third_party/def_parser/libdef_parser.a

bazel_tools_third_party_def_parser_def_parser_SBLINKF = \
	$(WA) $(bazel_tools_third_party_def_parser_def_parser_SBLINKT) $(NOWA)

blake-bin/bazel_tools/third_party/def_parser/def_parser: \
		$(bazel_tools_third_party_def_parser_def_parser_SBLINKT) \
		$(bazel_tools_third_party_def_parser_def_parser_lib_SBLINK)
	$(CXX) $(CFLAGS.security)  $(CXXFLAGS) $(LDFLAGS.security)  $(PIE) $(LDFLAGS) $(TARGET_ARCH) $(bazel_tools_third_party_def_parser_def_parser_SBLINKF) $(bazel_tools_third_party_def_parser_def_parser_lib_SBLINK) $(LOADLIBES)  $(LDLIBS) -o $@

################################################################################
# @local_config_cuda//cuda:cudart

local_config_cuda_cuda_cudart_CPPFLAGS = \
	-isystem local_config_cuda/cuda \
	-isystem local_config_cuda/cuda/cuda/include

local_config_cuda_cuda_cudart_LINKT = $(local_config_cuda_cuda_cudart_SPLINK)
local_config_cuda_cuda_cudart_LINKF = $(local_config_cuda_cuda_cudart_SPLINK)

blake-bin/local_config_cuda/cuda/libcudart.a: \
		local_config_cuda/cuda/cuda/lib/libcudart.so
	$(AR) $(ARFLAGS) $@ $^

local_config_cuda_cuda_cudart_SBLINK = \
	blake-bin/local_config_cuda/cuda/libcudart.a

blake-bin/local_config_cuda/cuda/libcudart.pic.a: \
		local_config_cuda/cuda/cuda/lib/libcudart.so
	$(AR) $(ARFLAGS) $@ $^

local_config_cuda_cuda_cudart_SPLINK = \
	blake-bin/local_config_cuda/cuda/libcudart.pic.a

################################################################################
# //tensorflow/core/platform/default/build_config:cuda

tensorflow_core_platform_default_build_config_cuda_LDFLAGS = \
	-Wl,-rpath,../local_config_cuda/cuda/lib64 \
	-Wl,-rpath,../local_config_cuda/cuda/extras/CUPTI/lib64

################################################################################
# //tensorflow/core:cuda

################################################################################
# //tensorflow/core:abi

tensorflow_core_abi_HEADERS = tensorflow/core/platform/abi.h
tensorflow_core_abi_LINK = blake-bin/tensorflow/core/libabi.so

blake-bin/tensorflow/core/_objs/abi/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_abi_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote . $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/abi/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_abi_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote . $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libabi.a: \
		blake-bin/tensorflow/core/_objs/abi/platform/abi.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_abi_SBLINK = blake-bin/tensorflow/core/libabi.a

blake-bin/tensorflow/core/libabi.pic.a: \
		blake-bin/tensorflow/core/_objs/abi/platform/abi.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_abi_SPLINK = blake-bin/tensorflow/core/libabi.pic.a

blake-bin/tensorflow/core/libabi.so: $(tensorflow_core_abi_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_abi_SPLINK) $(NOWA) 

################################################################################
# //tensorflow/core:lib_platform

tensorflow_core_lib_platform_HEADERS = tensorflow/core/platform/platform.h

################################################################################
# //tensorflow/core/platform/default/build_config:base

tensorflow_core_platform_default_build_config_base_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

################################################################################
# //tensorflow/core:platform_base

tensorflow_core_platform_base_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_platform_base_HEADERS = \
	tensorflow/core/platform/byte_order.h \
	tensorflow/core/platform/env_time.h \
	tensorflow/core/platform/logging.h \
	tensorflow/core/platform/macros.h \
	tensorflow/core/platform/types.h

tensorflow_core_platform_base_LINK = \
	blake-bin/tensorflow/core/libplatform_base.so

tensorflow_core_platform_base_COMPILE_HEADERS = \
	tensorflow/core/platform/default/integral_types.h \
	tensorflow/core/platform/default/logging.h \
	tensorflow/core/platform/windows/integral_types.h \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS)

blake-bin/tensorflow/core/_objs/platform_base/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_platform_base_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_platform_base_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote . $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/platform_base/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_platform_base_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_platform_base_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote . $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libplatform_base.a: \
		blake-bin/tensorflow/core/_objs/platform_base/platform/default/logging.o \
		blake-bin/tensorflow/core/_objs/platform_base/platform/posix/env_time.o \
		blake-bin/tensorflow/core/_objs/platform_base/platform/env_time.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_platform_base_SBLINK = \
	blake-bin/tensorflow/core/libplatform_base.a

blake-bin/tensorflow/core/libplatform_base.pic.a: \
		blake-bin/tensorflow/core/_objs/platform_base/platform/default/logging.pic.o \
		blake-bin/tensorflow/core/_objs/platform_base/platform/posix/env_time.pic.o \
		blake-bin/tensorflow/core/_objs/platform_base/platform/env_time.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_platform_base_SPLINK = \
	blake-bin/tensorflow/core/libplatform_base.pic.a

blake-bin/tensorflow/core/libplatform_base.so: \
		$(tensorflow_core_platform_base_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_platform_base_SPLINK) $(NOWA) 

################################################################################
# //tensorflow/core:core_stringpiece

tensorflow_core_core_stringpiece_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_core_stringpiece_HEADERS = \
	tensorflow/core/lib/core/stringpiece.h

tensorflow_core_core_stringpiece_LINK = \
	blake-bin/tensorflow/core/libcore_stringpiece.so

tensorflow_core_core_stringpiece_COMPILE_HEADERS = \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS)

blake-bin/tensorflow/core/_objs/core_stringpiece/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_core_stringpiece_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_core_stringpiece_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote . $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/core_stringpiece/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_core_stringpiece_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_core_stringpiece_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote . $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libcore_stringpiece.a: \
		blake-bin/tensorflow/core/_objs/core_stringpiece/lib/core/stringpiece.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_core_stringpiece_SBLINK = \
	blake-bin/tensorflow/core/libcore_stringpiece.a

blake-bin/tensorflow/core/libcore_stringpiece.pic.a: \
		blake-bin/tensorflow/core/_objs/core_stringpiece/lib/core/stringpiece.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_core_stringpiece_SPLINK = \
	blake-bin/tensorflow/core/libcore_stringpiece.pic.a

blake-bin/tensorflow/core/libcore_stringpiece.so: \
		$(tensorflow_core_core_stringpiece_SPLINK) \
		$(tensorflow_core_platform_base_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_core_stringpiece_SPLINK) $(NOWA) $(tensorflow_core_platform_base_LINK) 

################################################################################
# //tensorflow/core:lib_hash_crc32c_accelerate_internal

tensorflow_core_lib_hash_crc32c_accelerate_internal_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread \
	-msse4.2

tensorflow_core_lib_hash_crc32c_accelerate_internal_LINK = \
	blake-bin/tensorflow/core/liblib_hash_crc32c_accelerate_internal.so

blake-bin/tensorflow/core/_objs/lib_hash_crc32c_accelerate_internal/%.pic.o: \
		tensorflow/core/%.cc
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_lib_hash_crc32c_accelerate_internal_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote . $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/lib_hash_crc32c_accelerate_internal/%.o: \
		tensorflow/core/%.cc
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_lib_hash_crc32c_accelerate_internal_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote . $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/liblib_hash_crc32c_accelerate_internal.a: \
		blake-bin/tensorflow/core/_objs/lib_hash_crc32c_accelerate_internal/lib/hash/crc32c_accelerate.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_lib_hash_crc32c_accelerate_internal_SBLINK = \
	blake-bin/tensorflow/core/liblib_hash_crc32c_accelerate_internal.a

blake-bin/tensorflow/core/liblib_hash_crc32c_accelerate_internal.pic.a: \
		blake-bin/tensorflow/core/_objs/lib_hash_crc32c_accelerate_internal/lib/hash/crc32c_accelerate.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_lib_hash_crc32c_accelerate_internal_SPLINK = \
	blake-bin/tensorflow/core/liblib_hash_crc32c_accelerate_internal.pic.a

blake-bin/tensorflow/core/liblib_hash_crc32c_accelerate_internal.so: \
		$(tensorflow_core_lib_hash_crc32c_accelerate_internal_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_lib_hash_crc32c_accelerate_internal_SPLINK) $(NOWA) 

################################################################################
# @protobuf_archive//:protobuf_lite

protobuf_archive_protobuf_lite_CFLAGS = \
	-DHAVE_PTHREAD \
	-Wall \
	-Wwrite-strings \
	-Woverloaded-virtual \
	-Wno-sign-compare \
	-Wno-unused-function \
	-Wno-writable-strings

protobuf_archive_protobuf_lite_CPPFLAGS = -isystem protobuf_archive/src
protobuf_archive_protobuf_lite_LDLIBS = -lpthread -lm

protobuf_archive_protobuf_lite_HEADERS = \
	protobuf_archive/src/google/protobuf/any.h \
	protobuf_archive/src/google/protobuf/any.pb.h \
	protobuf_archive/src/google/protobuf/api.pb.h \
	protobuf_archive/src/google/protobuf/arena.h \
	protobuf_archive/src/google/protobuf/arena_impl.h \
	protobuf_archive/src/google/protobuf/arena_test_util.h \
	protobuf_archive/src/google/protobuf/arenastring.h \
	protobuf_archive/src/google/protobuf/compiler/annotation_test_util.h \
	protobuf_archive/src/google/protobuf/compiler/code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/command_line_interface.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_enum.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_extension.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_file.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_generator.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message_layout_helper.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_options.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_padding_optimizer.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_service.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_string_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_unittest.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_doc_comment.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_enum.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_field_base.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_generator.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_message.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_names.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_options.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_reflection_class.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_source_generator_base.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_wrapper_field.h \
	protobuf_archive/src/google/protobuf/compiler/importer.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_context.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_doc_comment.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_extension.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_extension_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_file.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_generator.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_generator_factory.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_lazy_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_lazy_message_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_map_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_builder.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_builder_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_name_resolver.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_names.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_options.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_primitive_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_service.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_shared_code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_string_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_string_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/js/js_generator.h \
	protobuf_archive/src/google/protobuf/compiler/js/well_known_types_embed.h \
	protobuf_archive/src/google/protobuf/compiler/mock_code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_enum.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_extension.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_file.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_generator.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_message.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_oneof.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/package_info.h \
	protobuf_archive/src/google/protobuf/compiler/parser.h \
	protobuf_archive/src/google/protobuf/compiler/php/php_generator.h \
	protobuf_archive/src/google/protobuf/compiler/plugin.h \
	protobuf_archive/src/google/protobuf/compiler/plugin.pb.h \
	protobuf_archive/src/google/protobuf/compiler/python/python_generator.h \
	protobuf_archive/src/google/protobuf/compiler/ruby/ruby_generator.h \
	protobuf_archive/src/google/protobuf/compiler/subprocess.h \
	protobuf_archive/src/google/protobuf/compiler/zip_writer.h \
	protobuf_archive/src/google/protobuf/descriptor.h \
	protobuf_archive/src/google/protobuf/descriptor.pb.h \
	protobuf_archive/src/google/protobuf/descriptor_database.h \
	protobuf_archive/src/google/protobuf/duration.pb.h \
	protobuf_archive/src/google/protobuf/dynamic_message.h \
	protobuf_archive/src/google/protobuf/empty.pb.h \
	protobuf_archive/src/google/protobuf/extension_set.h \
	protobuf_archive/src/google/protobuf/field_mask.pb.h \
	protobuf_archive/src/google/protobuf/generated_enum_reflection.h \
	protobuf_archive/src/google/protobuf/generated_enum_util.h \
	protobuf_archive/src/google/protobuf/generated_message_reflection.h \
	protobuf_archive/src/google/protobuf/generated_message_table_driven.h \
	protobuf_archive/src/google/protobuf/generated_message_table_driven_lite.h \
	protobuf_archive/src/google/protobuf/generated_message_util.h \
	protobuf_archive/src/google/protobuf/has_bits.h \
	protobuf_archive/src/google/protobuf/implicit_weak_message.h \
	protobuf_archive/src/google/protobuf/inlined_string_field.h \
	protobuf_archive/src/google/protobuf/io/coded_stream.h \
	protobuf_archive/src/google/protobuf/io/coded_stream_inl.h \
	protobuf_archive/src/google/protobuf/io/gzip_stream.h \
	protobuf_archive/src/google/protobuf/io/package_info.h \
	protobuf_archive/src/google/protobuf/io/printer.h \
	protobuf_archive/src/google/protobuf/io/strtod.h \
	protobuf_archive/src/google/protobuf/io/tokenizer.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream_impl.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream_impl_lite.h \
	protobuf_archive/src/google/protobuf/map.h \
	protobuf_archive/src/google/protobuf/map_entry.h \
	protobuf_archive/src/google/protobuf/map_entry_lite.h \
	protobuf_archive/src/google/protobuf/map_field.h \
	protobuf_archive/src/google/protobuf/map_field_inl.h \
	protobuf_archive/src/google/protobuf/map_field_lite.h \
	protobuf_archive/src/google/protobuf/map_lite_test_util.h \
	protobuf_archive/src/google/protobuf/map_test_util.h \
	protobuf_archive/src/google/protobuf/map_test_util_impl.h \
	protobuf_archive/src/google/protobuf/map_type_handler.h \
	protobuf_archive/src/google/protobuf/message.h \
	protobuf_archive/src/google/protobuf/message_lite.h \
	protobuf_archive/src/google/protobuf/metadata.h \
	protobuf_archive/src/google/protobuf/metadata_lite.h \
	protobuf_archive/src/google/protobuf/package_info.h \
	protobuf_archive/src/google/protobuf/reflection.h \
	protobuf_archive/src/google/protobuf/reflection_internal.h \
	protobuf_archive/src/google/protobuf/reflection_ops.h \
	protobuf_archive/src/google/protobuf/repeated_field.h \
	protobuf_archive/src/google/protobuf/service.h \
	protobuf_archive/src/google/protobuf/source_context.pb.h \
	protobuf_archive/src/google/protobuf/struct.pb.h \
	protobuf_archive/src/google/protobuf/stubs/bytestream.h \
	protobuf_archive/src/google/protobuf/stubs/callback.h \
	protobuf_archive/src/google/protobuf/stubs/casts.h \
	protobuf_archive/src/google/protobuf/stubs/common.h \
	protobuf_archive/src/google/protobuf/stubs/fastmem.h \
	protobuf_archive/src/google/protobuf/stubs/hash.h \
	protobuf_archive/src/google/protobuf/stubs/int128.h \
	protobuf_archive/src/google/protobuf/stubs/io_win32.h \
	protobuf_archive/src/google/protobuf/stubs/logging.h \
	protobuf_archive/src/google/protobuf/stubs/macros.h \
	protobuf_archive/src/google/protobuf/stubs/map_util.h \
	protobuf_archive/src/google/protobuf/stubs/mathlimits.h \
	protobuf_archive/src/google/protobuf/stubs/mathutil.h \
	protobuf_archive/src/google/protobuf/stubs/mutex.h \
	protobuf_archive/src/google/protobuf/stubs/once.h \
	protobuf_archive/src/google/protobuf/stubs/platform_macros.h \
	protobuf_archive/src/google/protobuf/stubs/port.h \
	protobuf_archive/src/google/protobuf/stubs/singleton.h \
	protobuf_archive/src/google/protobuf/stubs/status.h \
	protobuf_archive/src/google/protobuf/stubs/status_macros.h \
	protobuf_archive/src/google/protobuf/stubs/statusor.h \
	protobuf_archive/src/google/protobuf/stubs/stl_util.h \
	protobuf_archive/src/google/protobuf/stubs/stringpiece.h \
	protobuf_archive/src/google/protobuf/stubs/stringprintf.h \
	protobuf_archive/src/google/protobuf/stubs/strutil.h \
	protobuf_archive/src/google/protobuf/stubs/substitute.h \
	protobuf_archive/src/google/protobuf/stubs/template_util.h \
	protobuf_archive/src/google/protobuf/stubs/time.h \
	protobuf_archive/src/google/protobuf/test_util.h \
	protobuf_archive/src/google/protobuf/test_util_lite.h \
	protobuf_archive/src/google/protobuf/testing/file.h \
	protobuf_archive/src/google/protobuf/testing/googletest.h \
	protobuf_archive/src/google/protobuf/text_format.h \
	protobuf_archive/src/google/protobuf/timestamp.pb.h \
	protobuf_archive/src/google/protobuf/type.pb.h \
	protobuf_archive/src/google/protobuf/unknown_field_set.h \
	protobuf_archive/src/google/protobuf/util/delimited_message_util.h \
	protobuf_archive/src/google/protobuf/util/field_comparator.h \
	protobuf_archive/src/google/protobuf/util/field_mask_util.h \
	protobuf_archive/src/google/protobuf/util/internal/constants.h \
	protobuf_archive/src/google/protobuf/util/internal/datapiece.h \
	protobuf_archive/src/google/protobuf/util/internal/default_value_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/error_listener.h \
	protobuf_archive/src/google/protobuf/util/internal/expecting_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/field_mask_utility.h \
	protobuf_archive/src/google/protobuf/util/internal/json_escaping.h \
	protobuf_archive/src/google/protobuf/util/internal/json_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/json_stream_parser.h \
	protobuf_archive/src/google/protobuf/util/internal/location_tracker.h \
	protobuf_archive/src/google/protobuf/util/internal/mock_error_listener.h \
	protobuf_archive/src/google/protobuf/util/internal/object_location_tracker.h \
	protobuf_archive/src/google/protobuf/util/internal/object_source.h \
	protobuf_archive/src/google/protobuf/util/internal/object_writer.h \
	protobuf_archive/src/google/protobuf/util/internal/proto_writer.h \
	protobuf_archive/src/google/protobuf/util/internal/protostream_objectsource.h \
	protobuf_archive/src/google/protobuf/util/internal/protostream_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/structured_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/type_info.h \
	protobuf_archive/src/google/protobuf/util/internal/type_info_test_helper.h \
	protobuf_archive/src/google/protobuf/util/internal/utility.h \
	protobuf_archive/src/google/protobuf/util/json_util.h \
	protobuf_archive/src/google/protobuf/util/message_differencer.h \
	protobuf_archive/src/google/protobuf/util/package_info.h \
	protobuf_archive/src/google/protobuf/util/time_util.h \
	protobuf_archive/src/google/protobuf/util/type_resolver.h \
	protobuf_archive/src/google/protobuf/util/type_resolver_util.h \
	protobuf_archive/src/google/protobuf/wire_format.h \
	protobuf_archive/src/google/protobuf/wire_format_lite.h \
	protobuf_archive/src/google/protobuf/wire_format_lite_inl.h \
	protobuf_archive/src/google/protobuf/wrappers.pb.h

protobuf_archive_protobuf_lite_LINK = \
	blake-bin/protobuf_archive/libprotobuf_lite.so

blake-bin/protobuf_archive/_objs/protobuf_lite/%.pic.o: \
		protobuf_archive/%.cc \
		$(protobuf_archive_protobuf_lite_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(protobuf_archive_protobuf_lite_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(protobuf_archive_protobuf_lite_CPPFLAGS) $(CPPFLAGS) -iquote protobuf_archive $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/protobuf_archive/_objs/protobuf_lite/%.o: \
		protobuf_archive/%.cc \
		$(protobuf_archive_protobuf_lite_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(protobuf_archive_protobuf_lite_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(protobuf_archive_protobuf_lite_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote protobuf_archive $(TARGET_ARCH) -c -o $@ $<

blake-bin/protobuf_archive/libprotobuf_lite.a: \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/arena.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/arenastring.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/extension_set.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/generated_message_table_driven_lite.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/generated_message_util.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/implicit_weak_message.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/io/coded_stream.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/io/zero_copy_stream.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/io/zero_copy_stream_impl_lite.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/message_lite.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/repeated_field.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/bytestream.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/common.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/int128.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/io_win32.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/status.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/statusor.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/stringpiece.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/stringprintf.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/structurally_valid.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/strutil.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/time.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/wire_format_lite.o
	$(AR) $(ARFLAGS) $@ $^

protobuf_archive_protobuf_lite_SBLINK = \
	blake-bin/protobuf_archive/libprotobuf_lite.a

blake-bin/protobuf_archive/libprotobuf_lite.pic.a: \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/arena.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/arenastring.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/extension_set.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/generated_message_table_driven_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/generated_message_util.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/implicit_weak_message.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/io/coded_stream.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/io/zero_copy_stream.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/io/zero_copy_stream_impl_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/message_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/repeated_field.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/bytestream.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/common.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/int128.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/io_win32.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/status.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/statusor.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/stringpiece.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/stringprintf.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/structurally_valid.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/strutil.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/stubs/time.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf_lite/src/google/protobuf/wire_format_lite.pic.o
	$(AR) $(ARFLAGS) $@ $^

protobuf_archive_protobuf_lite_SPLINK = \
	blake-bin/protobuf_archive/libprotobuf_lite.pic.a

blake-bin/protobuf_archive/libprotobuf_lite.so: \
		$(protobuf_archive_protobuf_lite_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(protobuf_archive_protobuf_lite_SPLINK) $(NOWA) $(protobuf_archive_protobuf_lite_LDLIBS)

################################################################################
# @protobuf_archive//:protobuf

protobuf_archive_protobuf_CFLAGS = \
	-DHAVE_PTHREAD \
	-Wall \
	-Wwrite-strings \
	-Woverloaded-virtual \
	-Wno-sign-compare \
	-Wno-unused-function \
	-Wno-writable-strings

protobuf_archive_protobuf_CPPFLAGS = -isystem protobuf_archive/src
protobuf_archive_protobuf_LDLIBS = -lpthread -lm

protobuf_archive_protobuf_HEADERS = \
	protobuf_archive/src/google/protobuf/any.h \
	protobuf_archive/src/google/protobuf/any.pb.h \
	protobuf_archive/src/google/protobuf/api.pb.h \
	protobuf_archive/src/google/protobuf/arena.h \
	protobuf_archive/src/google/protobuf/arena_impl.h \
	protobuf_archive/src/google/protobuf/arena_test_util.h \
	protobuf_archive/src/google/protobuf/arenastring.h \
	protobuf_archive/src/google/protobuf/compiler/annotation_test_util.h \
	protobuf_archive/src/google/protobuf/compiler/code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/command_line_interface.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_enum.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_extension.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_file.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_generator.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message_layout_helper.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_options.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_padding_optimizer.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_service.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_string_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_unittest.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_doc_comment.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_enum.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_field_base.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_generator.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_message.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_names.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_options.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_reflection_class.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_source_generator_base.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_wrapper_field.h \
	protobuf_archive/src/google/protobuf/compiler/importer.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_context.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_doc_comment.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_extension.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_extension_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_file.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_generator.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_generator_factory.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_lazy_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_lazy_message_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_map_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_builder.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_builder_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_name_resolver.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_names.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_options.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_primitive_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_service.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_shared_code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_string_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_string_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/js/js_generator.h \
	protobuf_archive/src/google/protobuf/compiler/js/well_known_types_embed.h \
	protobuf_archive/src/google/protobuf/compiler/mock_code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_enum.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_extension.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_file.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_generator.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_message.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_oneof.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/package_info.h \
	protobuf_archive/src/google/protobuf/compiler/parser.h \
	protobuf_archive/src/google/protobuf/compiler/php/php_generator.h \
	protobuf_archive/src/google/protobuf/compiler/plugin.h \
	protobuf_archive/src/google/protobuf/compiler/plugin.pb.h \
	protobuf_archive/src/google/protobuf/compiler/python/python_generator.h \
	protobuf_archive/src/google/protobuf/compiler/ruby/ruby_generator.h \
	protobuf_archive/src/google/protobuf/compiler/subprocess.h \
	protobuf_archive/src/google/protobuf/compiler/zip_writer.h \
	protobuf_archive/src/google/protobuf/descriptor.h \
	protobuf_archive/src/google/protobuf/descriptor.pb.h \
	protobuf_archive/src/google/protobuf/descriptor_database.h \
	protobuf_archive/src/google/protobuf/duration.pb.h \
	protobuf_archive/src/google/protobuf/dynamic_message.h \
	protobuf_archive/src/google/protobuf/empty.pb.h \
	protobuf_archive/src/google/protobuf/extension_set.h \
	protobuf_archive/src/google/protobuf/field_mask.pb.h \
	protobuf_archive/src/google/protobuf/generated_enum_reflection.h \
	protobuf_archive/src/google/protobuf/generated_enum_util.h \
	protobuf_archive/src/google/protobuf/generated_message_reflection.h \
	protobuf_archive/src/google/protobuf/generated_message_table_driven.h \
	protobuf_archive/src/google/protobuf/generated_message_table_driven_lite.h \
	protobuf_archive/src/google/protobuf/generated_message_util.h \
	protobuf_archive/src/google/protobuf/has_bits.h \
	protobuf_archive/src/google/protobuf/implicit_weak_message.h \
	protobuf_archive/src/google/protobuf/inlined_string_field.h \
	protobuf_archive/src/google/protobuf/io/coded_stream.h \
	protobuf_archive/src/google/protobuf/io/coded_stream_inl.h \
	protobuf_archive/src/google/protobuf/io/gzip_stream.h \
	protobuf_archive/src/google/protobuf/io/package_info.h \
	protobuf_archive/src/google/protobuf/io/printer.h \
	protobuf_archive/src/google/protobuf/io/strtod.h \
	protobuf_archive/src/google/protobuf/io/tokenizer.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream_impl.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream_impl_lite.h \
	protobuf_archive/src/google/protobuf/map.h \
	protobuf_archive/src/google/protobuf/map_entry.h \
	protobuf_archive/src/google/protobuf/map_entry_lite.h \
	protobuf_archive/src/google/protobuf/map_field.h \
	protobuf_archive/src/google/protobuf/map_field_inl.h \
	protobuf_archive/src/google/protobuf/map_field_lite.h \
	protobuf_archive/src/google/protobuf/map_lite_test_util.h \
	protobuf_archive/src/google/protobuf/map_test_util.h \
	protobuf_archive/src/google/protobuf/map_test_util_impl.h \
	protobuf_archive/src/google/protobuf/map_type_handler.h \
	protobuf_archive/src/google/protobuf/message.h \
	protobuf_archive/src/google/protobuf/message_lite.h \
	protobuf_archive/src/google/protobuf/metadata.h \
	protobuf_archive/src/google/protobuf/metadata_lite.h \
	protobuf_archive/src/google/protobuf/package_info.h \
	protobuf_archive/src/google/protobuf/reflection.h \
	protobuf_archive/src/google/protobuf/reflection_internal.h \
	protobuf_archive/src/google/protobuf/reflection_ops.h \
	protobuf_archive/src/google/protobuf/repeated_field.h \
	protobuf_archive/src/google/protobuf/service.h \
	protobuf_archive/src/google/protobuf/source_context.pb.h \
	protobuf_archive/src/google/protobuf/struct.pb.h \
	protobuf_archive/src/google/protobuf/stubs/bytestream.h \
	protobuf_archive/src/google/protobuf/stubs/callback.h \
	protobuf_archive/src/google/protobuf/stubs/casts.h \
	protobuf_archive/src/google/protobuf/stubs/common.h \
	protobuf_archive/src/google/protobuf/stubs/fastmem.h \
	protobuf_archive/src/google/protobuf/stubs/hash.h \
	protobuf_archive/src/google/protobuf/stubs/int128.h \
	protobuf_archive/src/google/protobuf/stubs/io_win32.h \
	protobuf_archive/src/google/protobuf/stubs/logging.h \
	protobuf_archive/src/google/protobuf/stubs/macros.h \
	protobuf_archive/src/google/protobuf/stubs/map_util.h \
	protobuf_archive/src/google/protobuf/stubs/mathlimits.h \
	protobuf_archive/src/google/protobuf/stubs/mathutil.h \
	protobuf_archive/src/google/protobuf/stubs/mutex.h \
	protobuf_archive/src/google/protobuf/stubs/once.h \
	protobuf_archive/src/google/protobuf/stubs/platform_macros.h \
	protobuf_archive/src/google/protobuf/stubs/port.h \
	protobuf_archive/src/google/protobuf/stubs/singleton.h \
	protobuf_archive/src/google/protobuf/stubs/status.h \
	protobuf_archive/src/google/protobuf/stubs/status_macros.h \
	protobuf_archive/src/google/protobuf/stubs/statusor.h \
	protobuf_archive/src/google/protobuf/stubs/stl_util.h \
	protobuf_archive/src/google/protobuf/stubs/stringpiece.h \
	protobuf_archive/src/google/protobuf/stubs/stringprintf.h \
	protobuf_archive/src/google/protobuf/stubs/strutil.h \
	protobuf_archive/src/google/protobuf/stubs/substitute.h \
	protobuf_archive/src/google/protobuf/stubs/template_util.h \
	protobuf_archive/src/google/protobuf/stubs/time.h \
	protobuf_archive/src/google/protobuf/test_util.h \
	protobuf_archive/src/google/protobuf/test_util_lite.h \
	protobuf_archive/src/google/protobuf/testing/file.h \
	protobuf_archive/src/google/protobuf/testing/googletest.h \
	protobuf_archive/src/google/protobuf/text_format.h \
	protobuf_archive/src/google/protobuf/timestamp.pb.h \
	protobuf_archive/src/google/protobuf/type.pb.h \
	protobuf_archive/src/google/protobuf/unknown_field_set.h \
	protobuf_archive/src/google/protobuf/util/delimited_message_util.h \
	protobuf_archive/src/google/protobuf/util/field_comparator.h \
	protobuf_archive/src/google/protobuf/util/field_mask_util.h \
	protobuf_archive/src/google/protobuf/util/internal/constants.h \
	protobuf_archive/src/google/protobuf/util/internal/datapiece.h \
	protobuf_archive/src/google/protobuf/util/internal/default_value_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/error_listener.h \
	protobuf_archive/src/google/protobuf/util/internal/expecting_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/field_mask_utility.h \
	protobuf_archive/src/google/protobuf/util/internal/json_escaping.h \
	protobuf_archive/src/google/protobuf/util/internal/json_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/json_stream_parser.h \
	protobuf_archive/src/google/protobuf/util/internal/location_tracker.h \
	protobuf_archive/src/google/protobuf/util/internal/mock_error_listener.h \
	protobuf_archive/src/google/protobuf/util/internal/object_location_tracker.h \
	protobuf_archive/src/google/protobuf/util/internal/object_source.h \
	protobuf_archive/src/google/protobuf/util/internal/object_writer.h \
	protobuf_archive/src/google/protobuf/util/internal/proto_writer.h \
	protobuf_archive/src/google/protobuf/util/internal/protostream_objectsource.h \
	protobuf_archive/src/google/protobuf/util/internal/protostream_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/structured_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/type_info.h \
	protobuf_archive/src/google/protobuf/util/internal/type_info_test_helper.h \
	protobuf_archive/src/google/protobuf/util/internal/utility.h \
	protobuf_archive/src/google/protobuf/util/json_util.h \
	protobuf_archive/src/google/protobuf/util/message_differencer.h \
	protobuf_archive/src/google/protobuf/util/package_info.h \
	protobuf_archive/src/google/protobuf/util/time_util.h \
	protobuf_archive/src/google/protobuf/util/type_resolver.h \
	protobuf_archive/src/google/protobuf/util/type_resolver_util.h \
	protobuf_archive/src/google/protobuf/wire_format.h \
	protobuf_archive/src/google/protobuf/wire_format_lite.h \
	protobuf_archive/src/google/protobuf/wire_format_lite_inl.h \
	protobuf_archive/src/google/protobuf/wrappers.pb.h

protobuf_archive_protobuf_LINK = blake-bin/protobuf_archive/libprotobuf.so

protobuf_archive_protobuf_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS)

protobuf_archive_protobuf_COMPILE_HEADERS = \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS)

blake-bin/protobuf_archive/_objs/protobuf/%.pic.o: \
		protobuf_archive/%.cc \
		$(protobuf_archive_protobuf_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(protobuf_archive_protobuf_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(protobuf_archive_protobuf_COMPILE_CPPFLAGS) $(CPPFLAGS) -iquote protobuf_archive $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/protobuf_archive/_objs/protobuf/%.o: \
		protobuf_archive/%.cc \
		$(protobuf_archive_protobuf_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(protobuf_archive_protobuf_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(protobuf_archive_protobuf_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote protobuf_archive $(TARGET_ARCH) -c -o $@ $<

blake-bin/protobuf_archive/libprotobuf.a: \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/any.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/any.pb.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/api.pb.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/compiler/importer.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/compiler/parser.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/descriptor.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/descriptor.pb.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/descriptor_database.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/duration.pb.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/dynamic_message.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/empty.pb.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/extension_set_heavy.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/field_mask.pb.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/generated_message_reflection.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/generated_message_table_driven.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/io/gzip_stream.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/io/printer.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/io/strtod.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/io/tokenizer.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/io/zero_copy_stream_impl.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/map_field.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/message.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/reflection_ops.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/service.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/source_context.pb.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/struct.pb.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/stubs/mathlimits.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/stubs/substitute.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/text_format.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/timestamp.pb.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/type.pb.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/unknown_field_set.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/delimited_message_util.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/field_comparator.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/field_mask_util.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/datapiece.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/default_value_objectwriter.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/error_listener.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/field_mask_utility.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/json_escaping.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/json_objectwriter.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/json_stream_parser.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/object_writer.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/proto_writer.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/protostream_objectsource.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/protostream_objectwriter.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/type_info.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/type_info_test_helper.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/utility.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/json_util.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/message_differencer.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/time_util.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/type_resolver_util.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/wire_format.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/wrappers.pb.o
	$(AR) $(ARFLAGS) $@ $^

protobuf_archive_protobuf_SBLINK = blake-bin/protobuf_archive/libprotobuf.a

blake-bin/protobuf_archive/libprotobuf.pic.a: \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/any.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/any.pb.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/api.pb.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/compiler/importer.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/compiler/parser.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/descriptor.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/descriptor.pb.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/descriptor_database.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/duration.pb.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/dynamic_message.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/empty.pb.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/extension_set_heavy.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/field_mask.pb.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/generated_message_reflection.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/generated_message_table_driven.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/io/gzip_stream.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/io/printer.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/io/strtod.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/io/tokenizer.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/io/zero_copy_stream_impl.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/map_field.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/message.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/reflection_ops.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/service.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/source_context.pb.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/struct.pb.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/stubs/mathlimits.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/stubs/substitute.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/text_format.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/timestamp.pb.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/type.pb.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/unknown_field_set.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/delimited_message_util.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/field_comparator.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/field_mask_util.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/datapiece.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/default_value_objectwriter.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/error_listener.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/field_mask_utility.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/json_escaping.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/json_objectwriter.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/json_stream_parser.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/object_writer.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/proto_writer.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/protostream_objectsource.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/protostream_objectwriter.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/type_info.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/type_info_test_helper.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/internal/utility.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/json_util.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/message_differencer.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/time_util.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/util/type_resolver_util.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/wire_format.pic.o \
		blake-bin/protobuf_archive/_objs/protobuf/src/google/protobuf/wrappers.pb.pic.o
	$(AR) $(ARFLAGS) $@ $^

protobuf_archive_protobuf_SPLINK = blake-bin/protobuf_archive/libprotobuf.pic.a

blake-bin/protobuf_archive/libprotobuf.so: \
		$(protobuf_archive_protobuf_SPLINK) \
		$(protobuf_archive_protobuf_lite_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(protobuf_archive_protobuf_SPLINK) $(NOWA) $(protobuf_archive_protobuf_lite_LINK) $(protobuf_archive_protobuf_LDLIBS)

################################################################################
# @protobuf_archive//:js_embed

blake-bin/protobuf_archive/_objs/js_embed/%.o: protobuf_archive/%.cc 
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote protobuf_archive $(TARGET_ARCH) -c -o $@ $<

blake-bin/protobuf_archive/libjs_embed.a: \
		blake-bin/protobuf_archive/_objs/js_embed/src/google/protobuf/compiler/js/embed.o
	$(AR) $(ARFLAGS) $@ $^

protobuf_archive_js_embed_SBLINKT = blake-bin/protobuf_archive/libjs_embed.a

protobuf_archive_js_embed_SBLINKF = \
	$(WA) $(protobuf_archive_js_embed_SBLINKT) $(NOWA)

blake-bin/protobuf_archive/js_embed: $(protobuf_archive_js_embed_SBLINKT)
	$(CXX) $(CFLAGS.security)  $(CXXFLAGS) $(LDFLAGS.security)  $(PIE) $(LDFLAGS) $(TARGET_ARCH) $(protobuf_archive_js_embed_SBLINKF) $(LOADLIBES)  $(LDLIBS) -o $@

################################################################################
# @protobuf_archive//:generate_js_well_known_types_embed

protobuf_archive/src/google/protobuf/compiler/js/well_known_types_embed.cc: \
		protobuf_archive/src/google/protobuf/compiler/js/well_known_types/any.js \
		protobuf_archive/src/google/protobuf/compiler/js/well_known_types/struct.js \
		protobuf_archive/src/google/protobuf/compiler/js/well_known_types/timestamp.js \
		blake-bin/protobuf_archive/js_embed
	@mkdir -p protobuf_archive/src/google/protobuf/compiler/js
	blake-bin/protobuf_archive/js_embed protobuf_archive/src/google/protobuf/compiler/js/well_known_types/any.js protobuf_archive/src/google/protobuf/compiler/js/well_known_types/struct.js protobuf_archive/src/google/protobuf/compiler/js/well_known_types/timestamp.js > protobuf_archive/src/google/protobuf/compiler/js/well_known_types_embed.cc

################################################################################
# @protobuf_archive//:protoc_lib

protobuf_archive_protoc_lib_CFLAGS = \
	-DHAVE_PTHREAD \
	-Wall \
	-Wwrite-strings \
	-Woverloaded-virtual \
	-Wno-sign-compare \
	-Wno-unused-function \
	-Wno-writable-strings

protobuf_archive_protoc_lib_CPPFLAGS = -isystem protobuf_archive/src
protobuf_archive_protoc_lib_LDLIBS = -lpthread -lm
protobuf_archive_protoc_lib_LINK = blake-bin/protobuf_archive/libprotoc_lib.so

protobuf_archive_protoc_lib_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protoc_lib_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS)

protobuf_archive_protoc_lib_COMPILE_HEADERS = \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS)

blake-bin/protobuf_archive/_objs/protoc_lib/%.pic.o: \
		protobuf_archive/%.cc \
		$(protobuf_archive_protoc_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(protobuf_archive_protoc_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(protobuf_archive_protoc_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) -iquote protobuf_archive $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/protobuf_archive/_objs/protoc_lib/%.o: \
		protobuf_archive/%.cc \
		$(protobuf_archive_protoc_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(protobuf_archive_protoc_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(protobuf_archive_protoc_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote protobuf_archive $(TARGET_ARCH) -c -o $@ $<

blake-bin/protobuf_archive/libprotoc_lib.a: \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/code_generator.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/command_line_interface.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_enum.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_enum_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_extension.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_file.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_generator.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_helpers.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_map_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_message.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_message_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_padding_optimizer.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_primitive_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_service.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_string_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_doc_comment.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_enum.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_enum_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_field_base.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_generator.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_helpers.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_map_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_message.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_message_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_primitive_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_reflection_class.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_repeated_enum_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_repeated_message_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_repeated_primitive_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_source_generator_base.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_wrapper_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_context.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_doc_comment.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_enum.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_enum_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_enum_field_lite.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_enum_lite.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_extension.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_extension_lite.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_file.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_generator.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_generator_factory.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_helpers.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_lazy_message_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_lazy_message_field_lite.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_map_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_map_field_lite.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message_builder.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message_builder_lite.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message_field_lite.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message_lite.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_name_resolver.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_primitive_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_primitive_field_lite.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_service.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_shared_code_generator.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_string_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_string_field_lite.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/js/js_generator.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/js/well_known_types_embed.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_enum.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_enum_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_extension.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_file.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_generator.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_helpers.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_map_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_message.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_message_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_oneof.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_primitive_field.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/php/php_generator.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/plugin.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/plugin.pb.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/python/python_generator.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/ruby/ruby_generator.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/subprocess.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/zip_writer.o
	$(AR) $(ARFLAGS) $@ $^

protobuf_archive_protoc_lib_SBLINK = blake-bin/protobuf_archive/libprotoc_lib.a

blake-bin/protobuf_archive/libprotoc_lib.pic.a: \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/code_generator.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/command_line_interface.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_enum.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_enum_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_extension.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_file.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_generator.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_helpers.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_map_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_message.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_message_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_padding_optimizer.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_primitive_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_service.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/cpp/cpp_string_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_doc_comment.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_enum.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_enum_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_field_base.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_generator.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_helpers.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_map_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_message.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_message_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_primitive_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_reflection_class.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_repeated_enum_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_repeated_message_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_repeated_primitive_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_source_generator_base.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/csharp/csharp_wrapper_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_context.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_doc_comment.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_enum.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_enum_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_enum_field_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_enum_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_extension.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_extension_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_file.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_generator.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_generator_factory.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_helpers.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_lazy_message_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_lazy_message_field_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_map_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_map_field_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message_builder.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message_builder_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message_field_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_message_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_name_resolver.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_primitive_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_primitive_field_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_service.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_shared_code_generator.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_string_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/java/java_string_field_lite.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/js/js_generator.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/js/well_known_types_embed.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_enum.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_enum_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_extension.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_file.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_generator.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_helpers.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_map_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_message.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_message_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_oneof.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/objectivec/objectivec_primitive_field.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/php/php_generator.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/plugin.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/plugin.pb.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/python/python_generator.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/ruby/ruby_generator.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/subprocess.pic.o \
		blake-bin/protobuf_archive/_objs/protoc_lib/src/google/protobuf/compiler/zip_writer.pic.o
	$(AR) $(ARFLAGS) $@ $^

protobuf_archive_protoc_lib_SPLINK = \
	blake-bin/protobuf_archive/libprotoc_lib.pic.a

blake-bin/protobuf_archive/libprotoc_lib.so: \
		$(protobuf_archive_protoc_lib_SPLINK) \
		$(protobuf_archive_protobuf_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(protobuf_archive_protoc_lib_SPLINK) $(NOWA) $(protobuf_archive_protobuf_LINK) $(protobuf_archive_protoc_lib_LDLIBS)

################################################################################
# @protobuf_archive//:protoc

protobuf_archive_protoc_LDLIBS = -lpthread -lm

protobuf_archive_protoc_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protoc_lib_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS)

protobuf_archive_protoc_COMPILE_HEADERS = \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS)

blake-bin/protobuf_archive/_objs/protoc/%.o: \
		protobuf_archive/%.cc \
		$(protobuf_archive_protoc_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(protobuf_archive_protoc_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote protobuf_archive $(TARGET_ARCH) -c -o $@ $<

blake-bin/protobuf_archive/libprotoc.a: \
		blake-bin/protobuf_archive/_objs/protoc/src/google/protobuf/compiler/main.o
	$(AR) $(ARFLAGS) $@ $^

protobuf_archive_protoc_SBLINKT = blake-bin/protobuf_archive/libprotoc.a

protobuf_archive_protoc_SBLINKF = \
	$(WA) $(protobuf_archive_protoc_SBLINKT) $(NOWA)

blake-bin/protobuf_archive/protoc: \
		$(protobuf_archive_protoc_SBLINKT) \
		$(protobuf_archive_protoc_lib_SBLINK) \
		$(protobuf_archive_protobuf_SBLINK) \
		$(protobuf_archive_protobuf_lite_SBLINK)
	$(CXX) $(CFLAGS.security)  $(CXXFLAGS) $(LDFLAGS.security)  $(PIE) $(LDFLAGS) $(TARGET_ARCH) $(protobuf_archive_protoc_SBLINKF) $(protobuf_archive_protoc_lib_SBLINK) $(protobuf_archive_protobuf_SBLINK) $(protobuf_archive_protobuf_lite_SBLINK) $(LOADLIBES) $(protobuf_archive_protoc_LDLIBS) $(LDLIBS) -o $@

################################################################################
# @protobuf_archive//:cc_wkt_protos_genproto

protobuf_archive_cc_wkt_protos_genproto_PREREQUISITES = \
	protobuf_archive/src/google/protobuf/any.proto \
	protobuf_archive/src/google/protobuf/api.proto \
	protobuf_archive/src/google/protobuf/compiler/plugin.proto \
	protobuf_archive/src/google/protobuf/descriptor.proto \
	protobuf_archive/src/google/protobuf/duration.proto \
	protobuf_archive/src/google/protobuf/empty.proto \
	protobuf_archive/src/google/protobuf/field_mask.proto \
	protobuf_archive/src/google/protobuf/source_context.proto \
	protobuf_archive/src/google/protobuf/struct.proto \
	protobuf_archive/src/google/protobuf/timestamp.proto \
	protobuf_archive/src/google/protobuf/type.proto \
	protobuf_archive/src/google/protobuf/wrappers.proto \
	blake-bin/protobuf_archive/protoc

blake-bin/protobuf_archive/cc_wkt_protos_genproto.stamp: \
		$(protobuf_archive_cc_wkt_protos_genproto_PREREQUISITES)
	@mkdir -p blake-bin/protobuf_archive
	@touch blake-bin/protobuf_archive/cc_wkt_protos_genproto.stamp


################################################################################
# //tensorflow/core:error_codes_proto_cc_genproto

tensorflow_core_error_codes_proto_cc_genproto_PREREQUISITES = \
	tensorflow/core/lib/core/error_codes.proto \
	blake-bin/protobuf_archive/protoc

blake-bin/tensorflow/core/error_codes_proto_cc_genproto.stamp: \
		$(tensorflow_core_error_codes_proto_cc_genproto_PREREQUISITES)
	@mkdir -p tensorflow/core/lib/core
	blake-bin/protobuf_archive/protoc -I. -Iprotobuf_archive/src --cpp_out=. tensorflow/core/lib/core/error_codes.proto
	@mkdir -p blake-bin/tensorflow/core
	@touch blake-bin/tensorflow/core/error_codes_proto_cc_genproto.stamp

tensorflow/core/lib/core/error_codes.pb.cc: blake-bin/tensorflow/core/error_codes_proto_cc_genproto.stamp;
tensorflow/core/lib/core/error_codes.pb.h: blake-bin/tensorflow/core/error_codes_proto_cc_genproto.stamp;

################################################################################
# @protobuf_archive//:cc_wkt_protos

################################################################################
# @protobuf_archive//:protobuf_headers

protobuf_archive_protobuf_headers_CPPFLAGS = -isystem protobuf_archive/src

protobuf_archive_protobuf_headers_HEADERS = \
	protobuf_archive/src/google/protobuf/any.h \
	protobuf_archive/src/google/protobuf/any.pb.h \
	protobuf_archive/src/google/protobuf/api.pb.h \
	protobuf_archive/src/google/protobuf/arena.h \
	protobuf_archive/src/google/protobuf/arena_impl.h \
	protobuf_archive/src/google/protobuf/arena_test_util.h \
	protobuf_archive/src/google/protobuf/arenastring.h \
	protobuf_archive/src/google/protobuf/compiler/annotation_test_util.h \
	protobuf_archive/src/google/protobuf/compiler/code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/command_line_interface.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_enum.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_extension.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_file.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_generator.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message_layout_helper.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_options.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_padding_optimizer.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_service.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_string_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_unittest.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_doc_comment.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_enum.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_field_base.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_generator.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_message.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_names.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_options.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_reflection_class.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_source_generator_base.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_wrapper_field.h \
	protobuf_archive/src/google/protobuf/compiler/importer.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_context.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_doc_comment.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_extension.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_extension_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_file.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_generator.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_generator_factory.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_lazy_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_lazy_message_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_map_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_builder.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_builder_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_name_resolver.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_names.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_options.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_primitive_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_service.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_shared_code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_string_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_string_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/js/js_generator.h \
	protobuf_archive/src/google/protobuf/compiler/js/well_known_types_embed.h \
	protobuf_archive/src/google/protobuf/compiler/mock_code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_enum.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_extension.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_file.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_generator.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_message.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_oneof.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/package_info.h \
	protobuf_archive/src/google/protobuf/compiler/parser.h \
	protobuf_archive/src/google/protobuf/compiler/php/php_generator.h \
	protobuf_archive/src/google/protobuf/compiler/plugin.h \
	protobuf_archive/src/google/protobuf/compiler/plugin.pb.h \
	protobuf_archive/src/google/protobuf/compiler/python/python_generator.h \
	protobuf_archive/src/google/protobuf/compiler/ruby/ruby_generator.h \
	protobuf_archive/src/google/protobuf/compiler/subprocess.h \
	protobuf_archive/src/google/protobuf/compiler/zip_writer.h \
	protobuf_archive/src/google/protobuf/descriptor.h \
	protobuf_archive/src/google/protobuf/descriptor.pb.h \
	protobuf_archive/src/google/protobuf/descriptor_database.h \
	protobuf_archive/src/google/protobuf/duration.pb.h \
	protobuf_archive/src/google/protobuf/dynamic_message.h \
	protobuf_archive/src/google/protobuf/empty.pb.h \
	protobuf_archive/src/google/protobuf/extension_set.h \
	protobuf_archive/src/google/protobuf/field_mask.pb.h \
	protobuf_archive/src/google/protobuf/generated_enum_reflection.h \
	protobuf_archive/src/google/protobuf/generated_enum_util.h \
	protobuf_archive/src/google/protobuf/generated_message_reflection.h \
	protobuf_archive/src/google/protobuf/generated_message_table_driven.h \
	protobuf_archive/src/google/protobuf/generated_message_table_driven_lite.h \
	protobuf_archive/src/google/protobuf/generated_message_util.h \
	protobuf_archive/src/google/protobuf/has_bits.h \
	protobuf_archive/src/google/protobuf/implicit_weak_message.h \
	protobuf_archive/src/google/protobuf/inlined_string_field.h \
	protobuf_archive/src/google/protobuf/io/coded_stream.h \
	protobuf_archive/src/google/protobuf/io/coded_stream_inl.h \
	protobuf_archive/src/google/protobuf/io/gzip_stream.h \
	protobuf_archive/src/google/protobuf/io/package_info.h \
	protobuf_archive/src/google/protobuf/io/printer.h \
	protobuf_archive/src/google/protobuf/io/strtod.h \
	protobuf_archive/src/google/protobuf/io/tokenizer.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream_impl.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream_impl_lite.h \
	protobuf_archive/src/google/protobuf/map.h \
	protobuf_archive/src/google/protobuf/map_entry.h \
	protobuf_archive/src/google/protobuf/map_entry_lite.h \
	protobuf_archive/src/google/protobuf/map_field.h \
	protobuf_archive/src/google/protobuf/map_field_inl.h \
	protobuf_archive/src/google/protobuf/map_field_lite.h \
	protobuf_archive/src/google/protobuf/map_lite_test_util.h \
	protobuf_archive/src/google/protobuf/map_test_util.h \
	protobuf_archive/src/google/protobuf/map_test_util_impl.h \
	protobuf_archive/src/google/protobuf/map_type_handler.h \
	protobuf_archive/src/google/protobuf/message.h \
	protobuf_archive/src/google/protobuf/message_lite.h \
	protobuf_archive/src/google/protobuf/metadata.h \
	protobuf_archive/src/google/protobuf/metadata_lite.h \
	protobuf_archive/src/google/protobuf/package_info.h \
	protobuf_archive/src/google/protobuf/reflection.h \
	protobuf_archive/src/google/protobuf/reflection_internal.h \
	protobuf_archive/src/google/protobuf/reflection_ops.h \
	protobuf_archive/src/google/protobuf/repeated_field.h \
	protobuf_archive/src/google/protobuf/service.h \
	protobuf_archive/src/google/protobuf/source_context.pb.h \
	protobuf_archive/src/google/protobuf/struct.pb.h \
	protobuf_archive/src/google/protobuf/stubs/bytestream.h \
	protobuf_archive/src/google/protobuf/stubs/callback.h \
	protobuf_archive/src/google/protobuf/stubs/casts.h \
	protobuf_archive/src/google/protobuf/stubs/common.h \
	protobuf_archive/src/google/protobuf/stubs/fastmem.h \
	protobuf_archive/src/google/protobuf/stubs/hash.h \
	protobuf_archive/src/google/protobuf/stubs/int128.h \
	protobuf_archive/src/google/protobuf/stubs/io_win32.h \
	protobuf_archive/src/google/protobuf/stubs/logging.h \
	protobuf_archive/src/google/protobuf/stubs/macros.h \
	protobuf_archive/src/google/protobuf/stubs/map_util.h \
	protobuf_archive/src/google/protobuf/stubs/mathlimits.h \
	protobuf_archive/src/google/protobuf/stubs/mathutil.h \
	protobuf_archive/src/google/protobuf/stubs/mutex.h \
	protobuf_archive/src/google/protobuf/stubs/once.h \
	protobuf_archive/src/google/protobuf/stubs/platform_macros.h \
	protobuf_archive/src/google/protobuf/stubs/port.h \
	protobuf_archive/src/google/protobuf/stubs/singleton.h \
	protobuf_archive/src/google/protobuf/stubs/status.h \
	protobuf_archive/src/google/protobuf/stubs/status_macros.h \
	protobuf_archive/src/google/protobuf/stubs/statusor.h \
	protobuf_archive/src/google/protobuf/stubs/stl_util.h \
	protobuf_archive/src/google/protobuf/stubs/stringpiece.h \
	protobuf_archive/src/google/protobuf/stubs/stringprintf.h \
	protobuf_archive/src/google/protobuf/stubs/strutil.h \
	protobuf_archive/src/google/protobuf/stubs/substitute.h \
	protobuf_archive/src/google/protobuf/stubs/template_util.h \
	protobuf_archive/src/google/protobuf/stubs/time.h \
	protobuf_archive/src/google/protobuf/test_util.h \
	protobuf_archive/src/google/protobuf/test_util_lite.h \
	protobuf_archive/src/google/protobuf/testing/file.h \
	protobuf_archive/src/google/protobuf/testing/googletest.h \
	protobuf_archive/src/google/protobuf/text_format.h \
	protobuf_archive/src/google/protobuf/timestamp.pb.h \
	protobuf_archive/src/google/protobuf/type.pb.h \
	protobuf_archive/src/google/protobuf/unknown_field_set.h \
	protobuf_archive/src/google/protobuf/util/delimited_message_util.h \
	protobuf_archive/src/google/protobuf/util/field_comparator.h \
	protobuf_archive/src/google/protobuf/util/field_mask_util.h \
	protobuf_archive/src/google/protobuf/util/internal/constants.h \
	protobuf_archive/src/google/protobuf/util/internal/datapiece.h \
	protobuf_archive/src/google/protobuf/util/internal/default_value_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/error_listener.h \
	protobuf_archive/src/google/protobuf/util/internal/expecting_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/field_mask_utility.h \
	protobuf_archive/src/google/protobuf/util/internal/json_escaping.h \
	protobuf_archive/src/google/protobuf/util/internal/json_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/json_stream_parser.h \
	protobuf_archive/src/google/protobuf/util/internal/location_tracker.h \
	protobuf_archive/src/google/protobuf/util/internal/mock_error_listener.h \
	protobuf_archive/src/google/protobuf/util/internal/object_location_tracker.h \
	protobuf_archive/src/google/protobuf/util/internal/object_source.h \
	protobuf_archive/src/google/protobuf/util/internal/object_writer.h \
	protobuf_archive/src/google/protobuf/util/internal/proto_writer.h \
	protobuf_archive/src/google/protobuf/util/internal/protostream_objectsource.h \
	protobuf_archive/src/google/protobuf/util/internal/protostream_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/structured_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/type_info.h \
	protobuf_archive/src/google/protobuf/util/internal/type_info_test_helper.h \
	protobuf_archive/src/google/protobuf/util/internal/utility.h \
	protobuf_archive/src/google/protobuf/util/json_util.h \
	protobuf_archive/src/google/protobuf/util/message_differencer.h \
	protobuf_archive/src/google/protobuf/util/package_info.h \
	protobuf_archive/src/google/protobuf/util/time_util.h \
	protobuf_archive/src/google/protobuf/util/type_resolver.h \
	protobuf_archive/src/google/protobuf/util/type_resolver_util.h \
	protobuf_archive/src/google/protobuf/wire_format.h \
	protobuf_archive/src/google/protobuf/wire_format_lite.h \
	protobuf_archive/src/google/protobuf/wire_format_lite_inl.h \
	protobuf_archive/src/google/protobuf/wrappers.pb.h

################################################################################
# //tensorflow/core:error_codes_proto_cc_impl

tensorflow_core_error_codes_proto_cc_impl_CFLAGS = \
	-Wno-unknown-warning-option \
	-Wno-unused-but-set-variable \
	-Wno-sign-compare

tensorflow_core_error_codes_proto_cc_impl_HEADERS = \
	tensorflow/core/lib/core/error_codes.pb.h

tensorflow_core_error_codes_proto_cc_impl_LINK = \
	blake-bin/tensorflow/core/liberror_codes_proto_cc_impl.so

tensorflow_core_error_codes_proto_cc_impl_COMPILE_IQUOTES = \
	-iquote . \
	-iquote protobuf_archive

tensorflow_core_error_codes_proto_cc_impl_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS)

tensorflow_core_error_codes_proto_cc_impl_COMPILE_HEADERS = \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS)

blake-bin/tensorflow/core/_objs/error_codes_proto_cc_impl/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_error_codes_proto_cc_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_error_codes_proto_cc_impl_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_error_codes_proto_cc_impl_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_error_codes_proto_cc_impl_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/error_codes_proto_cc_impl/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_error_codes_proto_cc_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_error_codes_proto_cc_impl_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_error_codes_proto_cc_impl_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_error_codes_proto_cc_impl_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/liberror_codes_proto_cc_impl.a: \
		blake-bin/tensorflow/core/_objs/error_codes_proto_cc_impl/lib/core/error_codes.pb.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_error_codes_proto_cc_impl_SBLINK = \
	blake-bin/tensorflow/core/liberror_codes_proto_cc_impl.a

blake-bin/tensorflow/core/liberror_codes_proto_cc_impl.pic.a: \
		blake-bin/tensorflow/core/_objs/error_codes_proto_cc_impl/lib/core/error_codes.pb.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_error_codes_proto_cc_impl_SPLINK = \
	blake-bin/tensorflow/core/liberror_codes_proto_cc_impl.pic.a

blake-bin/tensorflow/core/liberror_codes_proto_cc_impl.so: \
		$(tensorflow_core_error_codes_proto_cc_impl_SPLINK) \
		$(protobuf_archive_protobuf_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_error_codes_proto_cc_impl_SPLINK) $(NOWA) $(protobuf_archive_protobuf_LINK) 

################################################################################
# //tensorflow/core:error_codes_proto_cc

tensorflow_core_error_codes_proto_cc_CFLAGS = \
	-Wno-unknown-warning-option \
	-Wno-unused-but-set-variable \
	-Wno-sign-compare

tensorflow_core_error_codes_proto_cc_HEADERS = \
	tensorflow/core/lib/core/error_codes.pb.h

################################################################################
# //tensorflow/core:protos_all_proto_cc_genproto

tensorflow_core_protos_all_proto_cc_genproto_PREREQUISITES = \
	tensorflow/core/example/example.proto \
	tensorflow/core/example/feature.proto \
	tensorflow/core/framework/allocation_description.proto \
	tensorflow/core/framework/attr_value.proto \
	tensorflow/core/framework/cost_graph.proto \
	tensorflow/core/framework/device_attributes.proto \
	tensorflow/core/framework/function.proto \
	tensorflow/core/framework/graph.proto \
	tensorflow/core/framework/graph_transfer_info.proto \
	tensorflow/core/framework/iterator.proto \
	tensorflow/core/framework/kernel_def.proto \
	tensorflow/core/framework/log_memory.proto \
	tensorflow/core/framework/node_def.proto \
	tensorflow/core/framework/op_def.proto \
	tensorflow/core/framework/api_def.proto \
	tensorflow/core/framework/reader_base.proto \
	tensorflow/core/framework/remote_fused_graph_execute_info.proto \
	tensorflow/core/framework/resource_handle.proto \
	tensorflow/core/framework/step_stats.proto \
	tensorflow/core/framework/summary.proto \
	tensorflow/core/framework/tensor.proto \
	tensorflow/core/framework/tensor_description.proto \
	tensorflow/core/framework/tensor_shape.proto \
	tensorflow/core/framework/tensor_slice.proto \
	tensorflow/core/framework/types.proto \
	tensorflow/core/framework/variable.proto \
	tensorflow/core/framework/versions.proto \
	tensorflow/core/protobuf/config.proto \
	tensorflow/core/protobuf/cluster.proto \
	tensorflow/core/protobuf/debug.proto \
	tensorflow/core/protobuf/device_properties.proto \
	tensorflow/core/protobuf/queue_runner.proto \
	tensorflow/core/protobuf/rewriter_config.proto \
	tensorflow/core/protobuf/tensor_bundle.proto \
	tensorflow/core/protobuf/saver.proto \
	tensorflow/core/util/event.proto \
	tensorflow/core/util/memmapped_file_system.proto \
	tensorflow/core/util/saved_tensor_slice.proto \
	tensorflow/core/example/example_parser_configuration.proto \
	tensorflow/core/protobuf/checkpointable_object_graph.proto \
	tensorflow/core/protobuf/control_flow.proto \
	tensorflow/core/protobuf/meta_graph.proto \
	tensorflow/core/protobuf/named_tensor.proto \
	tensorflow/core/protobuf/saved_model.proto \
	tensorflow/core/protobuf/tensorflow_server.proto \
	tensorflow/core/protobuf/transport_options.proto \
	tensorflow/core/util/test_log.proto \
	blake-bin/protobuf_archive/protoc

blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp: \
		$(tensorflow_core_protos_all_proto_cc_genproto_PREREQUISITES)
	@mkdir -p tensorflow/core/example
	@mkdir -p tensorflow/core/framework
	@mkdir -p tensorflow/core/protobuf
	@mkdir -p tensorflow/core/util
	blake-bin/protobuf_archive/protoc -I. -Iprotobuf_archive/src --cpp_out=. tensorflow/core/example/example.proto tensorflow/core/example/feature.proto tensorflow/core/framework/allocation_description.proto tensorflow/core/framework/attr_value.proto tensorflow/core/framework/cost_graph.proto tensorflow/core/framework/device_attributes.proto tensorflow/core/framework/function.proto tensorflow/core/framework/graph.proto tensorflow/core/framework/graph_transfer_info.proto tensorflow/core/framework/iterator.proto tensorflow/core/framework/kernel_def.proto tensorflow/core/framework/log_memory.proto tensorflow/core/framework/node_def.proto tensorflow/core/framework/op_def.proto tensorflow/core/framework/api_def.proto tensorflow/core/framework/reader_base.proto tensorflow/core/framework/remote_fused_graph_execute_info.proto tensorflow/core/framework/resource_handle.proto tensorflow/core/framework/step_stats.proto tensorflow/core/framework/summary.proto tensorflow/core/framework/tensor.proto tensorflow/core/framework/tensor_description.proto tensorflow/core/framework/tensor_shape.proto tensorflow/core/framework/tensor_slice.proto tensorflow/core/framework/types.proto tensorflow/core/framework/variable.proto tensorflow/core/framework/versions.proto tensorflow/core/protobuf/config.proto tensorflow/core/protobuf/cluster.proto tensorflow/core/protobuf/debug.proto tensorflow/core/protobuf/device_properties.proto tensorflow/core/protobuf/queue_runner.proto tensorflow/core/protobuf/rewriter_config.proto tensorflow/core/protobuf/tensor_bundle.proto tensorflow/core/protobuf/saver.proto tensorflow/core/util/event.proto tensorflow/core/util/memmapped_file_system.proto tensorflow/core/util/saved_tensor_slice.proto tensorflow/core/example/example_parser_configuration.proto tensorflow/core/protobuf/checkpointable_object_graph.proto tensorflow/core/protobuf/control_flow.proto tensorflow/core/protobuf/meta_graph.proto tensorflow/core/protobuf/named_tensor.proto tensorflow/core/protobuf/saved_model.proto tensorflow/core/protobuf/tensorflow_server.proto tensorflow/core/protobuf/transport_options.proto tensorflow/core/util/test_log.proto
	@mkdir -p blake-bin/tensorflow/core
	@touch blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp

tensorflow/core/example/example.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/example/feature.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/allocation_description.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/attr_value.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/cost_graph.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/device_attributes.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/function.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/graph.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/graph_transfer_info.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/iterator.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/kernel_def.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/log_memory.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/node_def.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/op_def.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/api_def.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/reader_base.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/remote_fused_graph_execute_info.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/resource_handle.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/step_stats.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/summary.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/tensor.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/tensor_description.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/tensor_shape.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/tensor_slice.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/types.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/variable.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/versions.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/config.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/cluster.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/debug.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/device_properties.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/queue_runner.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/rewriter_config.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/tensor_bundle.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/saver.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/util/event.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/util/memmapped_file_system.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/util/saved_tensor_slice.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/example/example_parser_configuration.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/checkpointable_object_graph.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/control_flow.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/meta_graph.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/named_tensor.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/saved_model.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/tensorflow_server.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/transport_options.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/util/test_log.pb.cc: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/example/example.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/example/feature.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/allocation_description.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/attr_value.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/cost_graph.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/device_attributes.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/function.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/graph.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/graph_transfer_info.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/iterator.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/kernel_def.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/log_memory.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/node_def.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/op_def.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/api_def.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/reader_base.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/remote_fused_graph_execute_info.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/resource_handle.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/step_stats.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/summary.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/tensor.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/tensor_description.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/tensor_shape.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/tensor_slice.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/types.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/variable.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/framework/versions.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/config.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/cluster.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/debug.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/device_properties.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/queue_runner.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/rewriter_config.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/tensor_bundle.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/saver.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/util/event.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/util/memmapped_file_system.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/util/saved_tensor_slice.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/example/example_parser_configuration.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/checkpointable_object_graph.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/control_flow.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/meta_graph.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/named_tensor.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/saved_model.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/tensorflow_server.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/protobuf/transport_options.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;
tensorflow/core/util/test_log.pb.h: blake-bin/tensorflow/core/protos_all_proto_cc_genproto.stamp;

################################################################################
# //tensorflow/core:protos_all_proto_cc_impl

tensorflow_core_protos_all_proto_cc_impl_CFLAGS = \
	-Wno-unknown-warning-option \
	-Wno-unused-but-set-variable \
	-Wno-sign-compare

tensorflow_core_protos_all_proto_cc_impl_HEADERS = \
	tensorflow/core/example/example.pb.h \
	tensorflow/core/example/example_parser_configuration.pb.h \
	tensorflow/core/example/feature.pb.h \
	tensorflow/core/framework/allocation_description.pb.h \
	tensorflow/core/framework/api_def.pb.h \
	tensorflow/core/framework/attr_value.pb.h \
	tensorflow/core/framework/cost_graph.pb.h \
	tensorflow/core/framework/device_attributes.pb.h \
	tensorflow/core/framework/function.pb.h \
	tensorflow/core/framework/graph.pb.h \
	tensorflow/core/framework/graph_transfer_info.pb.h \
	tensorflow/core/framework/iterator.pb.h \
	tensorflow/core/framework/kernel_def.pb.h \
	tensorflow/core/framework/log_memory.pb.h \
	tensorflow/core/framework/node_def.pb.h \
	tensorflow/core/framework/op_def.pb.h \
	tensorflow/core/framework/reader_base.pb.h \
	tensorflow/core/framework/remote_fused_graph_execute_info.pb.h \
	tensorflow/core/framework/resource_handle.pb.h \
	tensorflow/core/framework/step_stats.pb.h \
	tensorflow/core/framework/summary.pb.h \
	tensorflow/core/framework/tensor.pb.h \
	tensorflow/core/framework/tensor_description.pb.h \
	tensorflow/core/framework/tensor_shape.pb.h \
	tensorflow/core/framework/tensor_slice.pb.h \
	tensorflow/core/framework/types.pb.h \
	tensorflow/core/framework/variable.pb.h \
	tensorflow/core/framework/versions.pb.h \
	tensorflow/core/protobuf/checkpointable_object_graph.pb.h \
	tensorflow/core/protobuf/cluster.pb.h \
	tensorflow/core/protobuf/config.pb.h \
	tensorflow/core/protobuf/control_flow.pb.h \
	tensorflow/core/protobuf/debug.pb.h \
	tensorflow/core/protobuf/device_properties.pb.h \
	tensorflow/core/protobuf/meta_graph.pb.h \
	tensorflow/core/protobuf/named_tensor.pb.h \
	tensorflow/core/protobuf/queue_runner.pb.h \
	tensorflow/core/protobuf/rewriter_config.pb.h \
	tensorflow/core/protobuf/saved_model.pb.h \
	tensorflow/core/protobuf/saver.pb.h \
	tensorflow/core/protobuf/tensor_bundle.pb.h \
	tensorflow/core/protobuf/tensorflow_server.pb.h \
	tensorflow/core/protobuf/transport_options.pb.h \
	tensorflow/core/util/event.pb.h \
	tensorflow/core/util/memmapped_file_system.pb.h \
	tensorflow/core/util/saved_tensor_slice.pb.h \
	tensorflow/core/util/test_log.pb.h

tensorflow_core_protos_all_proto_cc_impl_LINK = \
	blake-bin/tensorflow/core/libprotos_all_proto_cc_impl.so

tensorflow_core_protos_all_proto_cc_impl_COMPILE_IQUOTES = \
	-iquote . \
	-iquote protobuf_archive

tensorflow_core_protos_all_proto_cc_impl_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS)

tensorflow_core_protos_all_proto_cc_impl_COMPILE_HEADERS = \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS)

blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_protos_all_proto_cc_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_protos_all_proto_cc_impl_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_protos_all_proto_cc_impl_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_protos_all_proto_cc_impl_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_protos_all_proto_cc_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_protos_all_proto_cc_impl_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_protos_all_proto_cc_impl_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_protos_all_proto_cc_impl_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libprotos_all_proto_cc_impl.a: \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/example/example.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/example/feature.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/allocation_description.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/attr_value.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/cost_graph.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/device_attributes.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/function.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/graph.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/graph_transfer_info.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/iterator.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/kernel_def.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/log_memory.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/node_def.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/op_def.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/api_def.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/reader_base.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/remote_fused_graph_execute_info.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/resource_handle.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/step_stats.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/summary.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/tensor.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/tensor_description.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/tensor_shape.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/tensor_slice.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/types.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/variable.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/versions.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/config.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/cluster.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/debug.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/device_properties.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/queue_runner.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/rewriter_config.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/tensor_bundle.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/saver.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/util/event.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/util/memmapped_file_system.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/util/saved_tensor_slice.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/example/example_parser_configuration.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/checkpointable_object_graph.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/control_flow.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/meta_graph.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/named_tensor.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/saved_model.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/tensorflow_server.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/transport_options.pb.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/util/test_log.pb.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_protos_all_proto_cc_impl_SBLINK = \
	blake-bin/tensorflow/core/libprotos_all_proto_cc_impl.a

blake-bin/tensorflow/core/libprotos_all_proto_cc_impl.pic.a: \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/example/example.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/example/feature.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/allocation_description.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/attr_value.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/cost_graph.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/device_attributes.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/function.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/graph.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/graph_transfer_info.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/iterator.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/kernel_def.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/log_memory.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/node_def.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/op_def.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/api_def.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/reader_base.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/remote_fused_graph_execute_info.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/resource_handle.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/step_stats.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/summary.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/tensor.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/tensor_description.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/tensor_shape.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/tensor_slice.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/types.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/variable.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/framework/versions.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/config.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/cluster.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/debug.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/device_properties.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/queue_runner.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/rewriter_config.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/tensor_bundle.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/saver.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/util/event.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/util/memmapped_file_system.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/util/saved_tensor_slice.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/example/example_parser_configuration.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/checkpointable_object_graph.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/control_flow.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/meta_graph.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/named_tensor.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/saved_model.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/tensorflow_server.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/protobuf/transport_options.pb.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_cc_impl/util/test_log.pb.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_protos_all_proto_cc_impl_SPLINK = \
	blake-bin/tensorflow/core/libprotos_all_proto_cc_impl.pic.a

blake-bin/tensorflow/core/libprotos_all_proto_cc_impl.so: \
		$(tensorflow_core_protos_all_proto_cc_impl_SPLINK) \
		$(tensorflow_core_error_codes_proto_cc_impl_LINK) \
		$(protobuf_archive_protobuf_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_protos_all_proto_cc_impl_SPLINK) $(NOWA) $(tensorflow_core_error_codes_proto_cc_impl_LINK) $(protobuf_archive_protobuf_LINK) 

################################################################################
# //tensorflow/core:protos_all_cc_impl

################################################################################
# //tensorflow/core:protos_all_proto_cc

tensorflow_core_protos_all_proto_cc_CFLAGS = \
	-Wno-unknown-warning-option \
	-Wno-unused-but-set-variable \
	-Wno-sign-compare

tensorflow_core_protos_all_proto_cc_HEADERS = \
	tensorflow/core/example/example.pb.h \
	tensorflow/core/example/example_parser_configuration.pb.h \
	tensorflow/core/example/feature.pb.h \
	tensorflow/core/framework/allocation_description.pb.h \
	tensorflow/core/framework/api_def.pb.h \
	tensorflow/core/framework/attr_value.pb.h \
	tensorflow/core/framework/cost_graph.pb.h \
	tensorflow/core/framework/device_attributes.pb.h \
	tensorflow/core/framework/function.pb.h \
	tensorflow/core/framework/graph.pb.h \
	tensorflow/core/framework/graph_transfer_info.pb.h \
	tensorflow/core/framework/iterator.pb.h \
	tensorflow/core/framework/kernel_def.pb.h \
	tensorflow/core/framework/log_memory.pb.h \
	tensorflow/core/framework/node_def.pb.h \
	tensorflow/core/framework/op_def.pb.h \
	tensorflow/core/framework/reader_base.pb.h \
	tensorflow/core/framework/remote_fused_graph_execute_info.pb.h \
	tensorflow/core/framework/resource_handle.pb.h \
	tensorflow/core/framework/step_stats.pb.h \
	tensorflow/core/framework/summary.pb.h \
	tensorflow/core/framework/tensor.pb.h \
	tensorflow/core/framework/tensor_description.pb.h \
	tensorflow/core/framework/tensor_shape.pb.h \
	tensorflow/core/framework/tensor_slice.pb.h \
	tensorflow/core/framework/types.pb.h \
	tensorflow/core/framework/variable.pb.h \
	tensorflow/core/framework/versions.pb.h \
	tensorflow/core/protobuf/checkpointable_object_graph.pb.h \
	tensorflow/core/protobuf/cluster.pb.h \
	tensorflow/core/protobuf/config.pb.h \
	tensorflow/core/protobuf/control_flow.pb.h \
	tensorflow/core/protobuf/debug.pb.h \
	tensorflow/core/protobuf/device_properties.pb.h \
	tensorflow/core/protobuf/meta_graph.pb.h \
	tensorflow/core/protobuf/named_tensor.pb.h \
	tensorflow/core/protobuf/queue_runner.pb.h \
	tensorflow/core/protobuf/rewriter_config.pb.h \
	tensorflow/core/protobuf/saved_model.pb.h \
	tensorflow/core/protobuf/saver.pb.h \
	tensorflow/core/protobuf/tensor_bundle.pb.h \
	tensorflow/core/protobuf/tensorflow_server.pb.h \
	tensorflow/core/protobuf/transport_options.pb.h \
	tensorflow/core/util/event.pb.h \
	tensorflow/core/util/memmapped_file_system.pb.h \
	tensorflow/core/util/saved_tensor_slice.pb.h \
	tensorflow/core/util/test_log.pb.h

################################################################################
# //tensorflow/core:protos_all_cc

################################################################################
# //tensorflow/core/platform/default/build_config:protos_cc

tensorflow_core_platform_default_build_config_protos_cc_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

################################################################################
# //tensorflow/core:protos_cc

################################################################################
# //tensorflow/core/platform/default/build_config:proto_parsing

tensorflow_core_platform_default_build_config_proto_parsing_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

################################################################################
# @eigen_archive//:eigen

eigen_archive_eigen_CPPFLAGS = \
	-DEIGEN_MPL2_ONLY \
	-DEIGEN_MAX_ALIGN_BYTES=64 \
	-isystem eigen_archive

eigen_archive_eigen_HEADERS = \
	eigen_archive/Eigen/Cholesky \
	eigen_archive/Eigen/CholmodSupport \
	eigen_archive/Eigen/Core \
	eigen_archive/Eigen/Dense \
	eigen_archive/Eigen/Eigenvalues \
	eigen_archive/Eigen/Geometry \
	eigen_archive/Eigen/Householder \
	eigen_archive/Eigen/Jacobi \
	eigen_archive/Eigen/KLUSupport \
	eigen_archive/Eigen/LU \
	eigen_archive/Eigen/OrderingMethods \
	eigen_archive/Eigen/PaStiXSupport \
	eigen_archive/Eigen/PardisoSupport \
	eigen_archive/Eigen/QR \
	eigen_archive/Eigen/QtAlignedMalloc \
	eigen_archive/Eigen/SPQRSupport \
	eigen_archive/Eigen/SVD \
	eigen_archive/Eigen/SparseCore \
	eigen_archive/Eigen/SparseQR \
	eigen_archive/Eigen/StdDeque \
	eigen_archive/Eigen/StdList \
	eigen_archive/Eigen/StdVector \
	eigen_archive/Eigen/SuperLUSupport \
	eigen_archive/Eigen/UmfPackSupport \
	eigen_archive/Eigen/src/Cholesky/LDLT.h \
	eigen_archive/Eigen/src/Cholesky/LLT.h \
	eigen_archive/Eigen/src/Cholesky/LLT_LAPACKE.h \
	eigen_archive/Eigen/src/CholmodSupport/CholmodSupport.h \
	eigen_archive/Eigen/src/Core/ArithmeticSequence.h \
	eigen_archive/Eigen/src/Core/Array.h \
	eigen_archive/Eigen/src/Core/ArrayBase.h \
	eigen_archive/Eigen/src/Core/ArrayWrapper.h \
	eigen_archive/Eigen/src/Core/Assign.h \
	eigen_archive/Eigen/src/Core/AssignEvaluator.h \
	eigen_archive/Eigen/src/Core/Assign_MKL.h \
	eigen_archive/Eigen/src/Core/BandMatrix.h \
	eigen_archive/Eigen/src/Core/Block.h \
	eigen_archive/Eigen/src/Core/BooleanRedux.h \
	eigen_archive/Eigen/src/Core/CommaInitializer.h \
	eigen_archive/Eigen/src/Core/ConditionEstimator.h \
	eigen_archive/Eigen/src/Core/CoreEvaluators.h \
	eigen_archive/Eigen/src/Core/CoreIterators.h \
	eigen_archive/Eigen/src/Core/CwiseBinaryOp.h \
	eigen_archive/Eigen/src/Core/CwiseNullaryOp.h \
	eigen_archive/Eigen/src/Core/CwiseTernaryOp.h \
	eigen_archive/Eigen/src/Core/CwiseUnaryOp.h \
	eigen_archive/Eigen/src/Core/CwiseUnaryView.h \
	eigen_archive/Eigen/src/Core/DenseBase.h \
	eigen_archive/Eigen/src/Core/DenseCoeffsBase.h \
	eigen_archive/Eigen/src/Core/DenseStorage.h \
	eigen_archive/Eigen/src/Core/Diagonal.h \
	eigen_archive/Eigen/src/Core/DiagonalMatrix.h \
	eigen_archive/Eigen/src/Core/DiagonalProduct.h \
	eigen_archive/Eigen/src/Core/Dot.h \
	eigen_archive/Eigen/src/Core/EigenBase.h \
	eigen_archive/Eigen/src/Core/ForceAlignedAccess.h \
	eigen_archive/Eigen/src/Core/Fuzzy.h \
	eigen_archive/Eigen/src/Core/GeneralProduct.h \
	eigen_archive/Eigen/src/Core/GenericPacketMath.h \
	eigen_archive/Eigen/src/Core/GlobalFunctions.h \
	eigen_archive/Eigen/src/Core/IO.h \
	eigen_archive/Eigen/src/Core/IndexedView.h \
	eigen_archive/Eigen/src/Core/Inverse.h \
	eigen_archive/Eigen/src/Core/Map.h \
	eigen_archive/Eigen/src/Core/MapBase.h \
	eigen_archive/Eigen/src/Core/MathFunctions.h \
	eigen_archive/Eigen/src/Core/MathFunctionsImpl.h \
	eigen_archive/Eigen/src/Core/Matrix.h \
	eigen_archive/Eigen/src/Core/MatrixBase.h \
	eigen_archive/Eigen/src/Core/NestByValue.h \
	eigen_archive/Eigen/src/Core/NoAlias.h \
	eigen_archive/Eigen/src/Core/NumTraits.h \
	eigen_archive/Eigen/src/Core/PermutationMatrix.h \
	eigen_archive/Eigen/src/Core/PlainObjectBase.h \
	eigen_archive/Eigen/src/Core/Product.h \
	eigen_archive/Eigen/src/Core/ProductEvaluators.h \
	eigen_archive/Eigen/src/Core/Random.h \
	eigen_archive/Eigen/src/Core/Redux.h \
	eigen_archive/Eigen/src/Core/Ref.h \
	eigen_archive/Eigen/src/Core/Replicate.h \
	eigen_archive/Eigen/src/Core/ReturnByValue.h \
	eigen_archive/Eigen/src/Core/Reverse.h \
	eigen_archive/Eigen/src/Core/Select.h \
	eigen_archive/Eigen/src/Core/SelfAdjointView.h \
	eigen_archive/Eigen/src/Core/SelfCwiseBinaryOp.h \
	eigen_archive/Eigen/src/Core/Solve.h \
	eigen_archive/Eigen/src/Core/SolveTriangular.h \
	eigen_archive/Eigen/src/Core/SolverBase.h \
	eigen_archive/Eigen/src/Core/StableNorm.h \
	eigen_archive/Eigen/src/Core/Stride.h \
	eigen_archive/Eigen/src/Core/Swap.h \
	eigen_archive/Eigen/src/Core/Transpose.h \
	eigen_archive/Eigen/src/Core/Transpositions.h \
	eigen_archive/Eigen/src/Core/TriangularMatrix.h \
	eigen_archive/Eigen/src/Core/VectorBlock.h \
	eigen_archive/Eigen/src/Core/VectorwiseOp.h \
	eigen_archive/Eigen/src/Core/Visitor.h \
	eigen_archive/Eigen/src/Core/arch/AVX/Complex.h \
	eigen_archive/Eigen/src/Core/arch/AVX/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/AVX/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/AVX/TypeCasting.h \
	eigen_archive/Eigen/src/Core/arch/AVX512/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/AVX512/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/AltiVec/Complex.h \
	eigen_archive/Eigen/src/Core/arch/AltiVec/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/AltiVec/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/Complex.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/Half.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/PacketMathHalf.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/TypeCasting.h \
	eigen_archive/Eigen/src/Core/arch/Default/ConjHelper.h \
	eigen_archive/Eigen/src/Core/arch/Default/Settings.h \
	eigen_archive/Eigen/src/Core/arch/NEON/Complex.h \
	eigen_archive/Eigen/src/Core/arch/NEON/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/NEON/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/SSE/Complex.h \
	eigen_archive/Eigen/src/Core/arch/SSE/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/SSE/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/SSE/TypeCasting.h \
	eigen_archive/Eigen/src/Core/arch/ZVector/Complex.h \
	eigen_archive/Eigen/src/Core/arch/ZVector/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/ZVector/PacketMath.h \
	eigen_archive/Eigen/src/Core/functors/AssignmentFunctors.h \
	eigen_archive/Eigen/src/Core/functors/BinaryFunctors.h \
	eigen_archive/Eigen/src/Core/functors/NullaryFunctors.h \
	eigen_archive/Eigen/src/Core/functors/StlFunctors.h \
	eigen_archive/Eigen/src/Core/functors/TernaryFunctors.h \
	eigen_archive/Eigen/src/Core/functors/UnaryFunctors.h \
	eigen_archive/Eigen/src/Core/products/GeneralBlockPanelKernel.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixMatrix.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixMatrixTriangular.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixMatrixTriangular_BLAS.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixMatrix_BLAS.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixVector.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixVector_BLAS.h \
	eigen_archive/Eigen/src/Core/products/Parallelizer.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointMatrixMatrix.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointMatrixMatrix_BLAS.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointMatrixVector.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointMatrixVector_BLAS.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointProduct.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointRank2Update.h \
	eigen_archive/Eigen/src/Core/products/TriangularMatrixMatrix.h \
	eigen_archive/Eigen/src/Core/products/TriangularMatrixMatrix_BLAS.h \
	eigen_archive/Eigen/src/Core/products/TriangularMatrixVector.h \
	eigen_archive/Eigen/src/Core/products/TriangularMatrixVector_BLAS.h \
	eigen_archive/Eigen/src/Core/products/TriangularSolverMatrix.h \
	eigen_archive/Eigen/src/Core/products/TriangularSolverMatrix_BLAS.h \
	eigen_archive/Eigen/src/Core/products/TriangularSolverVector.h \
	eigen_archive/Eigen/src/Core/util/BlasUtil.h \
	eigen_archive/Eigen/src/Core/util/Constants.h \
	eigen_archive/Eigen/src/Core/util/DisableStupidWarnings.h \
	eigen_archive/Eigen/src/Core/util/ForwardDeclarations.h \
	eigen_archive/Eigen/src/Core/util/IndexedViewHelper.h \
	eigen_archive/Eigen/src/Core/util/IntegralConstant.h \
	eigen_archive/Eigen/src/Core/util/MKL_support.h \
	eigen_archive/Eigen/src/Core/util/Macros.h \
	eigen_archive/Eigen/src/Core/util/Memory.h \
	eigen_archive/Eigen/src/Core/util/Meta.h \
	eigen_archive/Eigen/src/Core/util/ReenableStupidWarnings.h \
	eigen_archive/Eigen/src/Core/util/StaticAssert.h \
	eigen_archive/Eigen/src/Core/util/SymbolicIndex.h \
	eigen_archive/Eigen/src/Core/util/XprHelper.h \
	eigen_archive/Eigen/src/Eigenvalues/ComplexEigenSolver.h \
	eigen_archive/Eigen/src/Eigenvalues/ComplexSchur.h \
	eigen_archive/Eigen/src/Eigenvalues/ComplexSchur_LAPACKE.h \
	eigen_archive/Eigen/src/Eigenvalues/EigenSolver.h \
	eigen_archive/Eigen/src/Eigenvalues/GeneralizedEigenSolver.h \
	eigen_archive/Eigen/src/Eigenvalues/GeneralizedSelfAdjointEigenSolver.h \
	eigen_archive/Eigen/src/Eigenvalues/HessenbergDecomposition.h \
	eigen_archive/Eigen/src/Eigenvalues/MatrixBaseEigenvalues.h \
	eigen_archive/Eigen/src/Eigenvalues/RealQZ.h \
	eigen_archive/Eigen/src/Eigenvalues/RealSchur.h \
	eigen_archive/Eigen/src/Eigenvalues/RealSchur_LAPACKE.h \
	eigen_archive/Eigen/src/Eigenvalues/SelfAdjointEigenSolver.h \
	eigen_archive/Eigen/src/Eigenvalues/SelfAdjointEigenSolver_LAPACKE.h \
	eigen_archive/Eigen/src/Eigenvalues/Tridiagonalization.h \
	eigen_archive/Eigen/src/Geometry/AlignedBox.h \
	eigen_archive/Eigen/src/Geometry/AngleAxis.h \
	eigen_archive/Eigen/src/Geometry/EulerAngles.h \
	eigen_archive/Eigen/src/Geometry/Homogeneous.h \
	eigen_archive/Eigen/src/Geometry/Hyperplane.h \
	eigen_archive/Eigen/src/Geometry/OrthoMethods.h \
	eigen_archive/Eigen/src/Geometry/ParametrizedLine.h \
	eigen_archive/Eigen/src/Geometry/Quaternion.h \
	eigen_archive/Eigen/src/Geometry/Rotation2D.h \
	eigen_archive/Eigen/src/Geometry/RotationBase.h \
	eigen_archive/Eigen/src/Geometry/Scaling.h \
	eigen_archive/Eigen/src/Geometry/Transform.h \
	eigen_archive/Eigen/src/Geometry/Translation.h \
	eigen_archive/Eigen/src/Geometry/Umeyama.h \
	eigen_archive/Eigen/src/Geometry/arch/Geometry_SSE.h \
	eigen_archive/Eigen/src/Householder/BlockHouseholder.h \
	eigen_archive/Eigen/src/Householder/Householder.h \
	eigen_archive/Eigen/src/Householder/HouseholderSequence.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/BasicPreconditioners.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/BiCGSTAB.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/ConjugateGradient.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/IncompleteCholesky.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/IncompleteLUT.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/IterativeSolverBase.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/LeastSquareConjugateGradient.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/SolveWithGuess.h \
	eigen_archive/Eigen/src/Jacobi/Jacobi.h \
	eigen_archive/Eigen/src/KLUSupport/KLUSupport.h \
	eigen_archive/Eigen/src/LU/Determinant.h \
	eigen_archive/Eigen/src/LU/FullPivLU.h \
	eigen_archive/Eigen/src/LU/InverseImpl.h \
	eigen_archive/Eigen/src/LU/PartialPivLU.h \
	eigen_archive/Eigen/src/LU/PartialPivLU_LAPACKE.h \
	eigen_archive/Eigen/src/LU/arch/Inverse_SSE.h \
	eigen_archive/Eigen/src/MetisSupport/MetisSupport.h \
	eigen_archive/Eigen/src/OrderingMethods/Eigen_Colamd.h \
	eigen_archive/Eigen/src/OrderingMethods/Ordering.h \
	eigen_archive/Eigen/src/PaStiXSupport/PaStiXSupport.h \
	eigen_archive/Eigen/src/PardisoSupport/PardisoSupport.h \
	eigen_archive/Eigen/src/QR/ColPivHouseholderQR.h \
	eigen_archive/Eigen/src/QR/ColPivHouseholderQR_LAPACKE.h \
	eigen_archive/Eigen/src/QR/CompleteOrthogonalDecomposition.h \
	eigen_archive/Eigen/src/QR/FullPivHouseholderQR.h \
	eigen_archive/Eigen/src/QR/HouseholderQR.h \
	eigen_archive/Eigen/src/QR/HouseholderQR_LAPACKE.h \
	eigen_archive/Eigen/src/SPQRSupport/SuiteSparseQRSupport.h \
	eigen_archive/Eigen/src/SVD/BDCSVD.h \
	eigen_archive/Eigen/src/SVD/JacobiSVD.h \
	eigen_archive/Eigen/src/SVD/JacobiSVD_LAPACKE.h \
	eigen_archive/Eigen/src/SVD/SVDBase.h \
	eigen_archive/Eigen/src/SVD/UpperBidiagonalization.h \
	eigen_archive/Eigen/src/SparseCore/AmbiVector.h \
	eigen_archive/Eigen/src/SparseCore/CompressedStorage.h \
	eigen_archive/Eigen/src/SparseCore/ConservativeSparseSparseProduct.h \
	eigen_archive/Eigen/src/SparseCore/MappedSparseMatrix.h \
	eigen_archive/Eigen/src/SparseCore/SparseAssign.h \
	eigen_archive/Eigen/src/SparseCore/SparseBlock.h \
	eigen_archive/Eigen/src/SparseCore/SparseColEtree.h \
	eigen_archive/Eigen/src/SparseCore/SparseCompressedBase.h \
	eigen_archive/Eigen/src/SparseCore/SparseCwiseBinaryOp.h \
	eigen_archive/Eigen/src/SparseCore/SparseCwiseUnaryOp.h \
	eigen_archive/Eigen/src/SparseCore/SparseDenseProduct.h \
	eigen_archive/Eigen/src/SparseCore/SparseDiagonalProduct.h \
	eigen_archive/Eigen/src/SparseCore/SparseDot.h \
	eigen_archive/Eigen/src/SparseCore/SparseFuzzy.h \
	eigen_archive/Eigen/src/SparseCore/SparseMap.h \
	eigen_archive/Eigen/src/SparseCore/SparseMatrix.h \
	eigen_archive/Eigen/src/SparseCore/SparseMatrixBase.h \
	eigen_archive/Eigen/src/SparseCore/SparsePermutation.h \
	eigen_archive/Eigen/src/SparseCore/SparseProduct.h \
	eigen_archive/Eigen/src/SparseCore/SparseRedux.h \
	eigen_archive/Eigen/src/SparseCore/SparseRef.h \
	eigen_archive/Eigen/src/SparseCore/SparseSelfAdjointView.h \
	eigen_archive/Eigen/src/SparseCore/SparseSolverBase.h \
	eigen_archive/Eigen/src/SparseCore/SparseSparseProductWithPruning.h \
	eigen_archive/Eigen/src/SparseCore/SparseTranspose.h \
	eigen_archive/Eigen/src/SparseCore/SparseTriangularView.h \
	eigen_archive/Eigen/src/SparseCore/SparseUtil.h \
	eigen_archive/Eigen/src/SparseCore/SparseVector.h \
	eigen_archive/Eigen/src/SparseCore/SparseView.h \
	eigen_archive/Eigen/src/SparseCore/TriangularSolver.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU.h \
	eigen_archive/Eigen/src/SparseLU/SparseLUImpl.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_Memory.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_Structs.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_SupernodalMatrix.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_Utils.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_column_bmod.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_column_dfs.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_copy_to_ucol.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_gemm_kernel.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_heap_relax_snode.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_kernel_bmod.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_panel_bmod.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_panel_dfs.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_pivotL.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_pruneL.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_relax_snode.h \
	eigen_archive/Eigen/src/SparseQR/SparseQR.h \
	eigen_archive/Eigen/src/StlSupport/StdDeque.h \
	eigen_archive/Eigen/src/StlSupport/StdList.h \
	eigen_archive/Eigen/src/StlSupport/StdVector.h \
	eigen_archive/Eigen/src/StlSupport/details.h \
	eigen_archive/Eigen/src/SuperLUSupport/SuperLUSupport.h \
	eigen_archive/Eigen/src/UmfPackSupport/UmfPackSupport.h \
	eigen_archive/Eigen/src/misc/Image.h \
	eigen_archive/Eigen/src/misc/Kernel.h \
	eigen_archive/Eigen/src/misc/RealSvd2x2.h \
	eigen_archive/Eigen/src/misc/blas.h \
	eigen_archive/Eigen/src/misc/lapack.h \
	eigen_archive/Eigen/src/misc/lapacke.h \
	eigen_archive/Eigen/src/misc/lapacke_mangling.h \
	eigen_archive/Eigen/src/plugins/ArrayCwiseBinaryOps.h \
	eigen_archive/Eigen/src/plugins/ArrayCwiseUnaryOps.h \
	eigen_archive/Eigen/src/plugins/BlockMethods.h \
	eigen_archive/Eigen/src/plugins/CommonCwiseBinaryOps.h \
	eigen_archive/Eigen/src/plugins/CommonCwiseUnaryOps.h \
	eigen_archive/Eigen/src/plugins/IndexedViewMethods.h \
	eigen_archive/Eigen/src/plugins/MatrixCwiseBinaryOps.h \
	eigen_archive/Eigen/src/plugins/MatrixCwiseUnaryOps.h \
	eigen_archive/unsupported/Eigen/CXX11/CMakeLists.txt \
	eigen_archive/unsupported/Eigen/CXX11/Tensor \
	eigen_archive/unsupported/Eigen/CXX11/TensorSymmetry \
	eigen_archive/unsupported/Eigen/CXX11/ThreadPool \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/README.md \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/Tensor.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorArgMax.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorArgMaxSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorAssign.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorBase.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorBroadcasting.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorChipping.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorConcatenation.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContraction.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContractionBlocking.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContractionCuda.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContractionMapper.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContractionSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContractionThreadPool.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorConversion.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorConvolution.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorConvolutionSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorCostModel.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorCustomOp.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDevice.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDeviceCuda.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDeviceDefault.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDeviceSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDeviceThreadPool.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDimensionList.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDimensions.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorEvalTo.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorEvaluator.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorExecutor.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorExpr.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorFFT.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorFixedSize.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorForcedEval.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorForwardDeclarations.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorFunctors.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorGenerator.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorGlobalFunctions.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorIO.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorImagePatch.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorIndexList.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorInflation.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorInitializer.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorIntDiv.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorLayoutSwap.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorMacros.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorMap.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorMeta.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorMorphing.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorPadding.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorPatch.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorRandom.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorReduction.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorReductionCuda.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorReductionSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorRef.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorReverse.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorScan.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorShuffling.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorStorage.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorStriding.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclConvertToDeviceExpression.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclExprConstructor.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclExtractAccessor.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclExtractFunctors.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclFunctors.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclLeafCount.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclPlaceHolderExpr.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclRun.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclTuple.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorTrace.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorTraits.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorUInt128.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorVolumePatch.h \
	eigen_archive/unsupported/Eigen/CXX11/src/TensorSymmetry/DynamicSymmetry.h \
	eigen_archive/unsupported/Eigen/CXX11/src/TensorSymmetry/StaticSymmetry.h \
	eigen_archive/unsupported/Eigen/CXX11/src/TensorSymmetry/Symmetry.h \
	eigen_archive/unsupported/Eigen/CXX11/src/TensorSymmetry/util/TemplateGroupTheory.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/EventCount.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/NonBlockingThreadPool.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/RunQueue.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/SimpleThreadPool.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/ThreadCancel.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/ThreadEnvironment.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/ThreadLocal.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/ThreadPoolInterface.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/ThreadYield.h \
	eigen_archive/unsupported/Eigen/CXX11/src/util/CXX11Meta.h \
	eigen_archive/unsupported/Eigen/CXX11/src/util/CXX11Workarounds.h \
	eigen_archive/unsupported/Eigen/CXX11/src/util/EmulateArray.h \
	eigen_archive/unsupported/Eigen/CXX11/src/util/EmulateCXX11Meta.h \
	eigen_archive/unsupported/Eigen/CXX11/src/util/MaxSizeVector.h \
	eigen_archive/unsupported/Eigen/FFT \
	eigen_archive/unsupported/Eigen/KroneckerProduct \
	eigen_archive/unsupported/Eigen/MatrixFunctions \
	eigen_archive/unsupported/Eigen/SpecialFunctions \
	eigen_archive/unsupported/Eigen/src/FFT/ei_fftw_impl.h \
	eigen_archive/unsupported/Eigen/src/FFT/ei_kissfft_impl.h \
	eigen_archive/unsupported/Eigen/src/KroneckerProduct/KroneckerTensorProduct.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/MatrixExponential.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/MatrixFunction.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/MatrixLogarithm.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/MatrixPower.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/MatrixSquareRoot.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/StemFunction.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/SpecialFunctionsArrayAPI.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/SpecialFunctionsFunctors.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/SpecialFunctionsHalf.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/SpecialFunctionsImpl.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/SpecialFunctionsPacketMath.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/arch/CUDA/CudaSpecialFunctions.h

################################################################################
# @local_config_sycl//sycl:sycl_headers

local_config_sycl_sycl_sycl_headers_CPPFLAGS = \
	-isystem local_config_sycl/sycl \
	-isystem local_config_sycl/sycl/include

local_config_sycl_sycl_sycl_headers_HEADERS = \
	local_config_sycl/sycl/include/sycl.hpp

################################################################################
# @local_config_sycl//sycl:syclrt

local_config_sycl_sycl_syclrt_CPPFLAGS = -isystem local_config_sycl/sycl/include

local_config_sycl_sycl_syclrt_LINK = \
	blake-bin/local_config_sycl/sycl/libsyclrt.so

blake-bin/local_config_sycl/sycl/libsyclrt.a: \
		local_config_sycl/sycl/lib/libComputeCpp.so
	$(AR) $(ARFLAGS) $@ $^

local_config_sycl_sycl_syclrt_SBLINK = \
	blake-bin/local_config_sycl/sycl/libsyclrt.a

blake-bin/local_config_sycl/sycl/libsyclrt.pic.a: \
		local_config_sycl/sycl/lib/libComputeCpp.so
	$(AR) $(ARFLAGS) $@ $^

local_config_sycl_sycl_syclrt_SPLINK = \
	blake-bin/local_config_sycl/sycl/libsyclrt.pic.a

blake-bin/local_config_sycl/sycl/libsyclrt.so: \
		$(local_config_sycl_sycl_syclrt_SPLINK)
	$(CC) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(local_config_sycl_sycl_syclrt_SPLINK) $(NOWA) 

################################################################################
# @local_config_sycl//sycl:sycl

################################################################################
# //third_party/eigen3:eigen3

third_party_eigen3_eigen3_HEADERS = \
	third_party/eigen3/Eigen/Cholesky \
	third_party/eigen3/Eigen/Core \
	third_party/eigen3/Eigen/Eigenvalues \
	third_party/eigen3/Eigen/LU \
	third_party/eigen3/Eigen/QR \
	third_party/eigen3/Eigen/SVD \
	third_party/eigen3/unsupported/Eigen/CXX11/FixedPoint \
	third_party/eigen3/unsupported/Eigen/CXX11/Tensor \
	third_party/eigen3/unsupported/Eigen/CXX11/ThreadPool \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/FixedPointTypes.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/MatMatProduct.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/MatMatProductAVX2.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/MatMatProductNEON.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/MatVecProduct.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/PacketMathAVX2.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/PacketMathAVX512.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/TypeCastingAVX2.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/TypeCastingAVX512.h \
	third_party/eigen3/unsupported/Eigen/MatrixFunctions \
	third_party/eigen3/unsupported/Eigen/SpecialFunctions

################################################################################
# @double_conversion//:double-conversion

double_conversion_double-conversion_CPPFLAGS = -isystem double_conversion
double_conversion_double-conversion_LDLIBS = -lm

double_conversion_double-conversion_HEADERS = \
	double_conversion/double-conversion/bignum-dtoa.h \
	double_conversion/double-conversion/bignum.h \
	double_conversion/double-conversion/cached-powers.h \
	double_conversion/double-conversion/diy-fp.h \
	double_conversion/double-conversion/double-conversion.h \
	double_conversion/double-conversion/fast-dtoa.h \
	double_conversion/double-conversion/fixed-dtoa.h \
	double_conversion/double-conversion/ieee.h \
	double_conversion/double-conversion/strtod.h

double_conversion_double-conversion_LINK = \
	blake-bin/double_conversion/libdouble-conversion.so

double_conversion_double-conversion_COMPILE_HEADERS = \
	double_conversion/double-conversion/utils.h \
	$(double_conversion_double-conversion_HEADERS)

blake-bin/double_conversion/_objs/double-conversion/%.pic.o: \
		double_conversion/%.cc \
		$(double_conversion_double-conversion_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(double_conversion_double-conversion_CPPFLAGS) $(CPPFLAGS) -iquote double_conversion $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/double_conversion/_objs/double-conversion/%.o: \
		double_conversion/%.cc \
		$(double_conversion_double-conversion_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(double_conversion_double-conversion_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote double_conversion $(TARGET_ARCH) -c -o $@ $<

blake-bin/double_conversion/libdouble-conversion.a: \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/bignum.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/bignum-dtoa.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/cached-powers.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/diy-fp.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/double-conversion.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/fast-dtoa.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/fixed-dtoa.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/strtod.o
	$(AR) $(ARFLAGS) $@ $^

double_conversion_double-conversion_SBLINK = \
	blake-bin/double_conversion/libdouble-conversion.a

blake-bin/double_conversion/libdouble-conversion.pic.a: \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/bignum.pic.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/bignum-dtoa.pic.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/cached-powers.pic.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/diy-fp.pic.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/double-conversion.pic.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/fast-dtoa.pic.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/fixed-dtoa.pic.o \
		blake-bin/double_conversion/_objs/double-conversion/double-conversion/strtod.pic.o
	$(AR) $(ARFLAGS) $@ $^

double_conversion_double-conversion_SPLINK = \
	blake-bin/double_conversion/libdouble-conversion.pic.a

blake-bin/double_conversion/libdouble-conversion.so: \
		$(double_conversion_double-conversion_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(double_conversion_double-conversion_SPLINK) $(NOWA) $(double_conversion_double-conversion_LDLIBS)

################################################################################
# //tensorflow/core:lib_proto_parsing

tensorflow_core_lib_proto_parsing_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_lib_proto_parsing_HEADERS = \
	tensorflow/core/lib/core/errors.h \
	tensorflow/core/lib/core/status.h \
	tensorflow/core/lib/core/stringpiece.h \
	tensorflow/core/lib/strings/numbers.h \
	tensorflow/core/lib/strings/strcat.h \
	tensorflow/core/platform/init_main.h \
	tensorflow/core/platform/logging.h \
	tensorflow/core/platform/macros.h \
	tensorflow/core/platform/platform.h \
	tensorflow/core/platform/protobuf.h \
	tensorflow/core/platform/types.h \
	tensorflow/core/platform/windows/cpu_info.h \
	tensorflow/core/lib/bfloat16/bfloat16.h \
	tensorflow/core/platform/default/integral_types.h \
	tensorflow/core/platform/default/logging.h \
	tensorflow/core/platform/default/protobuf.h

tensorflow_core_lib_proto_parsing_LINK = \
	blake-bin/tensorflow/core/liblib_proto_parsing.so

tensorflow_core_lib_proto_parsing_COMPILE_IQUOTES = \
	-iquote . \
	-iquote protobuf_archive \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote double_conversion

tensorflow_core_lib_proto_parsing_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_lib_proto_parsing_COMPILE_HEADERS = \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS)

blake-bin/tensorflow/core/_objs/lib_proto_parsing/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_lib_proto_parsing_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_lib_proto_parsing_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_lib_proto_parsing_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_lib_proto_parsing_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/lib_proto_parsing/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_lib_proto_parsing_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_lib_proto_parsing_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_lib_proto_parsing_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_lib_proto_parsing_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/liblib_proto_parsing.a: \
		blake-bin/tensorflow/core/_objs/lib_proto_parsing/platform/default/protobuf.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_lib_proto_parsing_SBLINK = \
	blake-bin/tensorflow/core/liblib_proto_parsing.a

blake-bin/tensorflow/core/liblib_proto_parsing.pic.a: \
		blake-bin/tensorflow/core/_objs/lib_proto_parsing/platform/default/protobuf.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_lib_proto_parsing_SPLINK = \
	blake-bin/tensorflow/core/liblib_proto_parsing.pic.a

blake-bin/tensorflow/core/liblib_proto_parsing.so: \
		$(tensorflow_core_lib_proto_parsing_SPLINK) \
		$(double_conversion_double-conversion_LINK) \
		$(tensorflow_core_platform_base_LINK) \
		$(tensorflow_core_error_codes_proto_cc_impl_LINK) \
		$(tensorflow_core_protos_all_proto_cc_impl_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_lib_proto_parsing_SPLINK) $(NOWA) $(double_conversion_double-conversion_LINK) $(tensorflow_core_platform_base_LINK) $(tensorflow_core_error_codes_proto_cc_impl_LINK) $(tensorflow_core_protos_all_proto_cc_impl_LINK) 

################################################################################
# //tensorflow/core:protos_all_cc_genproto

tensorflow_core_protos_all_cc_genproto_PREREQUISITES = \
	blake-bin/protobuf_archive/protoc

blake-bin/tensorflow/core/protos_all_cc_genproto.stamp: \
		$(tensorflow_core_protos_all_cc_genproto_PREREQUISITES)
	@mkdir -p blake-bin/tensorflow/core
	@touch blake-bin/tensorflow/core/protos_all_cc_genproto.stamp


################################################################################
# //tensorflow/core/grappler/costs:op_performance_data_cc_genproto

tensorflow_core_grappler_costs_op_performance_data_cc_genproto_PREREQUISITES = \
	tensorflow/core/grappler/costs/op_performance_data.proto \
	blake-bin/protobuf_archive/protoc

blake-bin/tensorflow/core/grappler/costs/op_performance_data_cc_genproto.stamp: \
		$(tensorflow_core_grappler_costs_op_performance_data_cc_genproto_PREREQUISITES)
	@mkdir -p tensorflow/core/grappler/costs
	blake-bin/protobuf_archive/protoc -I. -Iprotobuf_archive/src --cpp_out=. tensorflow/core/grappler/costs/op_performance_data.proto
	@mkdir -p blake-bin/tensorflow/core/grappler/costs
	@touch blake-bin/tensorflow/core/grappler/costs/op_performance_data_cc_genproto.stamp

tensorflow/core/grappler/costs/op_performance_data.pb.cc: blake-bin/tensorflow/core/grappler/costs/op_performance_data_cc_genproto.stamp;
tensorflow/core/grappler/costs/op_performance_data.pb.h: blake-bin/tensorflow/core/grappler/costs/op_performance_data_cc_genproto.stamp;

################################################################################
# //tensorflow/core/grappler/costs:op_performance_data_cc_impl

tensorflow_core_grappler_costs_op_performance_data_cc_impl_CFLAGS = \
	-Wno-unknown-warning-option \
	-Wno-unused-but-set-variable \
	-Wno-sign-compare

tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS = \
	tensorflow/core/grappler/costs/op_performance_data.pb.h

tensorflow_core_grappler_costs_op_performance_data_cc_impl_LINK = \
	blake-bin/tensorflow/core/grappler/costs/libop_performance_data_cc_impl.so

tensorflow_core_grappler_costs_op_performance_data_cc_impl_COMPILE_IQUOTES = \
	-iquote . \
	-iquote protobuf_archive

tensorflow_core_grappler_costs_op_performance_data_cc_impl_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS)

tensorflow_core_grappler_costs_op_performance_data_cc_impl_COMPILE_HEADERS = \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS)

blake-bin/tensorflow/core/grappler/costs/_objs/op_performance_data_cc_impl/%.pic.o: \
		tensorflow/core/grappler/costs/%.cc \
		$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_grappler_costs_op_performance_data_cc_impl_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_grappler_costs_op_performance_data_cc_impl_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_grappler_costs_op_performance_data_cc_impl_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/grappler/costs/_objs/op_performance_data_cc_impl/%.o: \
		tensorflow/core/grappler/costs/%.cc \
		$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_grappler_costs_op_performance_data_cc_impl_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_grappler_costs_op_performance_data_cc_impl_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_grappler_costs_op_performance_data_cc_impl_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/grappler/costs/libop_performance_data_cc_impl.a: \
		blake-bin/tensorflow/core/grappler/costs/_objs/op_performance_data_cc_impl/op_performance_data.pb.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_grappler_costs_op_performance_data_cc_impl_SBLINK = \
	blake-bin/tensorflow/core/grappler/costs/libop_performance_data_cc_impl.a

blake-bin/tensorflow/core/grappler/costs/libop_performance_data_cc_impl.pic.a: \
		blake-bin/tensorflow/core/grappler/costs/_objs/op_performance_data_cc_impl/op_performance_data.pb.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_grappler_costs_op_performance_data_cc_impl_SPLINK = \
	blake-bin/tensorflow/core/grappler/costs/libop_performance_data_cc_impl.pic.a

blake-bin/tensorflow/core/grappler/costs/libop_performance_data_cc_impl.so: \
		$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_SPLINK) \
		$(protobuf_archive_protobuf_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_grappler_costs_op_performance_data_cc_impl_SPLINK) $(NOWA) $(protobuf_archive_protobuf_LINK) 

################################################################################
# @gif_archive//:windows_unistd_h

gif_archive/windows/unistd.h: 
	@mkdir -p gif_archive/windows
	touch gif_archive/windows/unistd.h

################################################################################
# @gif_archive//:windows_polyfill

gif_archive_windows_polyfill_CPPFLAGS = -isystem gif_archive/windows
gif_archive_windows_polyfill_HEADERS = gif_archive/windows/unistd.h

################################################################################
# @gif_archive//:gif

gif_archive_gif_CPPFLAGS = -isystem gif_archive/lib
gif_archive_gif_HEADERS = gif_archive/lib/gif_lib.h
gif_archive_gif_LINK = blake-bin/gif_archive/libgif.so

gif_archive_gif_COMPILE_HEADERS = \
	gif_archive/lib/gif_hash.h \
	gif_archive/lib/gif_lib_private.h \
	$(gif_archive_gif_HEADERS)

blake-bin/gif_archive/_objs/gif/%.pic.o: \
		gif_archive/%.c \
		$(gif_archive_gif_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security)  $(CFLAGS) $(CPPFLAGS.security) $(gif_archive_gif_CPPFLAGS) $(CPPFLAGS) -iquote gif_archive $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/gif_archive/_objs/gif/%.o: \
		gif_archive/%.c \
		$(gif_archive_gif_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security)  $(CFLAGS) $(CPPFLAGS.security) $(gif_archive_gif_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote gif_archive $(TARGET_ARCH) -c -o $@ $<

blake-bin/gif_archive/libgif.a: \
		blake-bin/gif_archive/_objs/gif/lib/dgif_lib.o \
		blake-bin/gif_archive/_objs/gif/lib/egif_lib.o \
		blake-bin/gif_archive/_objs/gif/lib/gif_err.o \
		blake-bin/gif_archive/_objs/gif/lib/gif_font.o \
		blake-bin/gif_archive/_objs/gif/lib/gif_hash.o \
		blake-bin/gif_archive/_objs/gif/lib/gifalloc.o \
		blake-bin/gif_archive/_objs/gif/lib/openbsd-reallocarray.o \
		blake-bin/gif_archive/_objs/gif/lib/quantize.o
	$(AR) $(ARFLAGS) $@ $^

gif_archive_gif_SBLINK = blake-bin/gif_archive/libgif.a

blake-bin/gif_archive/libgif.pic.a: \
		blake-bin/gif_archive/_objs/gif/lib/dgif_lib.pic.o \
		blake-bin/gif_archive/_objs/gif/lib/egif_lib.pic.o \
		blake-bin/gif_archive/_objs/gif/lib/gif_err.pic.o \
		blake-bin/gif_archive/_objs/gif/lib/gif_font.pic.o \
		blake-bin/gif_archive/_objs/gif/lib/gif_hash.pic.o \
		blake-bin/gif_archive/_objs/gif/lib/gifalloc.pic.o \
		blake-bin/gif_archive/_objs/gif/lib/openbsd-reallocarray.pic.o \
		blake-bin/gif_archive/_objs/gif/lib/quantize.pic.o
	$(AR) $(ARFLAGS) $@ $^

gif_archive_gif_SPLINK = blake-bin/gif_archive/libgif.pic.a

blake-bin/gif_archive/libgif.so: $(gif_archive_gif_SPLINK)
	$(CC) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(gif_archive_gif_SPLINK) $(NOWA) 

################################################################################
# //tensorflow/core/platform/default/build_config:gif

tensorflow_core_platform_default_build_config_gif_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

################################################################################
# @jpeg//:configure

jpeg/jconfig.h: \
		jpeg/jconfig_win.h \
		jpeg/jconfig_nowin_nosimd.h \
		jpeg/jconfig_nowin_simd.h
	@mkdir -p jpeg
	cp jpeg/jconfig_nowin_simd.h jpeg/jconfig.h

################################################################################
# @jpeg//:configure_internal

jpeg/jconfigint.h: jpeg/jconfigint_win.h jpeg/jconfigint_nowin.h
	@mkdir -p jpeg
	cp jpeg/jconfigint_nowin.h jpeg/jconfigint.h

################################################################################
# @jpeg//:simd_altivec

jpeg_simd_altivec_CFLAGS = -O3 -w

jpeg_simd_altivec_HEADERS = \
	jpeg/simd/jccolext-altivec.c \
	jpeg/simd/jcgryext-altivec.c \
	jpeg/simd/jdcolext-altivec.c \
	jpeg/simd/jdmrgext-altivec.c

jpeg_simd_altivec_LINK = blake-bin/jpeg/libsimd_altivec.so

jpeg_simd_altivec_COMPILE_HEADERS = \
	jpeg/jchuff.h \
	jpeg/jconfig.h \
	jpeg/jdct.h \
	jpeg/jerror.h \
	jpeg/jinclude.h \
	jpeg/jmorecfg.h \
	jpeg/jpegint.h \
	jpeg/jpeglib.h \
	jpeg/jsimd.h \
	jpeg/jsimddct.h \
	jpeg/simd/jcsample.h \
	jpeg/simd/jsimd.h \
	jpeg/simd/jsimd_altivec.h \
	$(jpeg_simd_altivec_HEADERS)

blake-bin/jpeg/_objs/simd_altivec/%.pic.o: \
		jpeg/%.c \
		$(jpeg_simd_altivec_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_simd_altivec_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote jpeg $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/_objs/simd_altivec/%.o: \
		jpeg/%.c \
		$(jpeg_simd_altivec_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_simd_altivec_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote jpeg $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/libsimd_altivec.a: \
		blake-bin/jpeg/_objs/simd_altivec/simd/jccolor-altivec.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jcgray-altivec.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jcsample-altivec.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jdcolor-altivec.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jdmerge-altivec.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jdsample-altivec.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jfdctfst-altivec.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jfdctint-altivec.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jidctfst-altivec.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jidctint-altivec.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jquanti-altivec.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jsimd_powerpc.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_simd_altivec_SBLINK = blake-bin/jpeg/libsimd_altivec.a

blake-bin/jpeg/libsimd_altivec.pic.a: \
		blake-bin/jpeg/_objs/simd_altivec/simd/jccolor-altivec.pic.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jcgray-altivec.pic.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jcsample-altivec.pic.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jdcolor-altivec.pic.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jdmerge-altivec.pic.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jdsample-altivec.pic.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jfdctfst-altivec.pic.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jfdctint-altivec.pic.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jidctfst-altivec.pic.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jidctint-altivec.pic.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jquanti-altivec.pic.o \
		blake-bin/jpeg/_objs/simd_altivec/simd/jsimd_powerpc.pic.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_simd_altivec_SPLINK = blake-bin/jpeg/libsimd_altivec.pic.a

blake-bin/jpeg/libsimd_altivec.so: $(jpeg_simd_altivec_SPLINK)
	$(CC) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(jpeg_simd_altivec_SPLINK) $(NOWA) 

################################################################################
# @jpeg//:simd_armv7a

jpeg_simd_armv7a_CFLAGS = -O3 -w
jpeg_simd_armv7a_LINK = blake-bin/jpeg/libsimd_armv7a.so

jpeg_simd_armv7a_COMPILE_HEADERS = \
	jpeg/jchuff.h \
	jpeg/jconfig.h \
	jpeg/jdct.h \
	jpeg/jinclude.h \
	jpeg/jmorecfg.h \
	jpeg/jpeglib.h \
	jpeg/jsimd.h \
	jpeg/jsimddct.h \
	jpeg/simd/jsimd.h

blake-bin/jpeg/_objs/simd_armv7a/%.pic.o: \
		jpeg/%.c \
		$(jpeg_simd_armv7a_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_simd_armv7a_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote jpeg $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/_objs/simd_armv7a/%.o: \
		jpeg/%.c \
		$(jpeg_simd_armv7a_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_simd_armv7a_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote jpeg $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/_objs/simd_armv7a/%.s: \
		jpeg/%.S \
		$(jpeg_simd_armv7a_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CPP) $(CPPFLAGS.security) $(CPPFLAGS) -o $@ $<

blake-bin/jpeg/_objs/simd_armv7a/%.o: \
		blake-bin/jpeg/_objs/simd_armv7a/%.s \
		$(jpeg_simd_armv7a_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) $(TARGET_MACH) -o $@ $<

blake-bin/jpeg/libsimd_armv7a.a: \
		blake-bin/jpeg/_objs/simd_armv7a/simd/jsimd_arm.o \
		blake-bin/jpeg/_objs/simd_armv7a/simd/jsimd_arm_neon.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_simd_armv7a_SBLINK = blake-bin/jpeg/libsimd_armv7a.a

blake-bin/jpeg/libsimd_armv7a.pic.a: \
		blake-bin/jpeg/_objs/simd_armv7a/simd/jsimd_arm.pic.o \
		blake-bin/jpeg/_objs/simd_armv7a/simd/jsimd_arm_neon.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_simd_armv7a_SPLINK = blake-bin/jpeg/libsimd_armv7a.pic.a

blake-bin/jpeg/libsimd_armv7a.so: $(jpeg_simd_armv7a_SPLINK)
	$(CC) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(jpeg_simd_armv7a_SPLINK) $(NOWA) 

################################################################################
# @jpeg//:simd_armv8a

jpeg_simd_armv8a_CFLAGS = -O3 -w
jpeg_simd_armv8a_LINK = blake-bin/jpeg/libsimd_armv8a.so

jpeg_simd_armv8a_COMPILE_HEADERS = \
	jpeg/jchuff.h \
	jpeg/jconfig.h \
	jpeg/jdct.h \
	jpeg/jerror.h \
	jpeg/jinclude.h \
	jpeg/jmorecfg.h \
	jpeg/jpegint.h \
	jpeg/jpeglib.h \
	jpeg/jsimd.h \
	jpeg/jsimddct.h \
	jpeg/simd/jsimd.h

blake-bin/jpeg/_objs/simd_armv8a/%.pic.o: \
		jpeg/%.c \
		$(jpeg_simd_armv8a_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_simd_armv8a_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote jpeg $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/_objs/simd_armv8a/%.o: \
		jpeg/%.c \
		$(jpeg_simd_armv8a_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_simd_armv8a_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote jpeg $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/_objs/simd_armv8a/%.s: \
		jpeg/%.S \
		$(jpeg_simd_armv8a_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CPP) $(CPPFLAGS.security) $(CPPFLAGS) -o $@ $<

blake-bin/jpeg/_objs/simd_armv8a/%.o: \
		blake-bin/jpeg/_objs/simd_armv8a/%.s \
		$(jpeg_simd_armv8a_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) $(TARGET_MACH) -o $@ $<

blake-bin/jpeg/libsimd_armv8a.a: \
		blake-bin/jpeg/_objs/simd_armv8a/simd/jsimd_arm64.o \
		blake-bin/jpeg/_objs/simd_armv8a/simd/jsimd_arm64_neon.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_simd_armv8a_SBLINK = blake-bin/jpeg/libsimd_armv8a.a

blake-bin/jpeg/libsimd_armv8a.pic.a: \
		blake-bin/jpeg/_objs/simd_armv8a/simd/jsimd_arm64.pic.o \
		blake-bin/jpeg/_objs/simd_armv8a/simd/jsimd_arm64_neon.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_simd_armv8a_SPLINK = blake-bin/jpeg/libsimd_armv8a.pic.a

blake-bin/jpeg/libsimd_armv8a.so: $(jpeg_simd_armv8a_SPLINK)
	$(CC) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(jpeg_simd_armv8a_SPLINK) $(NOWA) 

################################################################################
# @jpeg//:simd_none

jpeg_simd_none_CFLAGS = -O3 -w
jpeg_simd_none_LINK = blake-bin/jpeg/libsimd_none.so

jpeg_simd_none_COMPILE_HEADERS = \
	jpeg/jchuff.h \
	jpeg/jconfig.h \
	jpeg/jdct.h \
	jpeg/jerror.h \
	jpeg/jinclude.h \
	jpeg/jmorecfg.h \
	jpeg/jpegint.h \
	jpeg/jpeglib.h \
	jpeg/jsimd.h \
	jpeg/jsimddct.h

blake-bin/jpeg/_objs/simd_none/%.pic.o: \
		jpeg/%.c \
		$(jpeg_simd_none_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_simd_none_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote jpeg $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/_objs/simd_none/%.o: jpeg/%.c $(jpeg_simd_none_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_simd_none_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote jpeg $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/libsimd_none.a: blake-bin/jpeg/_objs/simd_none/jsimd_none.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_simd_none_SBLINK = blake-bin/jpeg/libsimd_none.a

blake-bin/jpeg/libsimd_none.pic.a: \
		blake-bin/jpeg/_objs/simd_none/jsimd_none.pic.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_simd_none_SPLINK = blake-bin/jpeg/libsimd_none.pic.a

blake-bin/jpeg/libsimd_none.so: $(jpeg_simd_none_SPLINK)
	$(CC) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(jpeg_simd_none_SPLINK) $(NOWA) 

################################################################################
# @jpeg//:configure_simd

jpeg/simd/jsimdcfg.inc: 
	@mkdir -p jpeg/simd
	jpeg/configure_simd.sh

################################################################################
# @nasm//:nasm

nasm_nasm_CFLAGS = -w

nasm_nasm_CPPFLAGS = \
	-DHAVE_SNPRINTF \
	-DHAVE_VSNPRINTF \
	-DHAVE_SYS_TYPES_H \
	-isystem nasm/asm \
	-isystem nasm/include \
	-isystem nasm/output \
	-isystem nasm/x86

nasm_nasm_COMPILE_HEADERS = \
	nasm/asm/assemble.h \
	nasm/asm/directiv.h \
	nasm/asm/eval.h \
	nasm/asm/float.h \
	nasm/asm/listing.h \
	nasm/asm/parser.h \
	nasm/asm/pptok.h \
	nasm/asm/preproc.h \
	nasm/asm/quote.h \
	nasm/asm/stdscan.h \
	nasm/asm/tokens.h \
	nasm/config/unknown.h \
	nasm/disasm/disasm.h \
	nasm/disasm/sync.h \
	nasm/include/compiler.h \
	nasm/include/disp8.h \
	nasm/include/error.h \
	nasm/include/hashtbl.h \
	nasm/include/iflag.h \
	nasm/include/insns.h \
	nasm/include/labels.h \
	nasm/include/md5.h \
	nasm/include/nasm.h \
	nasm/include/nasmint.h \
	nasm/include/nasmlib.h \
	nasm/include/opflags.h \
	nasm/include/perfhash.h \
	nasm/include/raa.h \
	nasm/include/rbtree.h \
	nasm/include/rdoff.h \
	nasm/include/saa.h \
	nasm/include/strlist.h \
	nasm/include/tables.h \
	nasm/include/ver.h \
	nasm/nasmlib/file.h \
	nasm/output/dwarf.h \
	nasm/output/elf.h \
	nasm/output/outelf.h \
	nasm/output/outform.h \
	nasm/output/outlib.h \
	nasm/output/pecoff.h \
	nasm/output/stabs.h \
	nasm/version.h \
	nasm/x86/iflaggen.h \
	nasm/x86/insnsi.h \
	nasm/x86/regdis.h \
	nasm/x86/regs.h

blake-bin/nasm/_objs/nasm/%.o: nasm/%.c $(nasm_nasm_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(nasm_nasm_CFLAGS) $(CFLAGS) $(CPPFLAGS.security) $(nasm_nasm_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote nasm $(TARGET_ARCH) -c -o $@ $<

blake-bin/nasm/libnasm.a: \
		blake-bin/nasm/_objs/nasm/asm/assemble.o \
		blake-bin/nasm/_objs/nasm/asm/directbl.o \
		blake-bin/nasm/_objs/nasm/asm/directiv.o \
		blake-bin/nasm/_objs/nasm/asm/error.o \
		blake-bin/nasm/_objs/nasm/asm/eval.o \
		blake-bin/nasm/_objs/nasm/asm/exprdump.o \
		blake-bin/nasm/_objs/nasm/asm/exprlib.o \
		blake-bin/nasm/_objs/nasm/asm/float.o \
		blake-bin/nasm/_objs/nasm/asm/labels.o \
		blake-bin/nasm/_objs/nasm/asm/listing.o \
		blake-bin/nasm/_objs/nasm/asm/nasm.o \
		blake-bin/nasm/_objs/nasm/asm/parser.o \
		blake-bin/nasm/_objs/nasm/asm/pptok.o \
		blake-bin/nasm/_objs/nasm/asm/pragma.o \
		blake-bin/nasm/_objs/nasm/asm/preproc.o \
		blake-bin/nasm/_objs/nasm/asm/preproc-nop.o \
		blake-bin/nasm/_objs/nasm/asm/quote.o \
		blake-bin/nasm/_objs/nasm/asm/rdstrnum.o \
		blake-bin/nasm/_objs/nasm/asm/segalloc.o \
		blake-bin/nasm/_objs/nasm/asm/stdscan.o \
		blake-bin/nasm/_objs/nasm/asm/strfunc.o \
		blake-bin/nasm/_objs/nasm/asm/tokhash.o \
		blake-bin/nasm/_objs/nasm/common/common.o \
		blake-bin/nasm/_objs/nasm/disasm/disasm.o \
		blake-bin/nasm/_objs/nasm/disasm/sync.o \
		blake-bin/nasm/_objs/nasm/macros/macros.o \
		blake-bin/nasm/_objs/nasm/nasmlib/badenum.o \
		blake-bin/nasm/_objs/nasm/nasmlib/bsi.o \
		blake-bin/nasm/_objs/nasm/nasmlib/crc64.o \
		blake-bin/nasm/_objs/nasm/nasmlib/file.o \
		blake-bin/nasm/_objs/nasm/nasmlib/filename.o \
		blake-bin/nasm/_objs/nasm/nasmlib/hashtbl.o \
		blake-bin/nasm/_objs/nasm/nasmlib/ilog2.o \
		blake-bin/nasm/_objs/nasm/nasmlib/malloc.o \
		blake-bin/nasm/_objs/nasm/nasmlib/md5c.o \
		blake-bin/nasm/_objs/nasm/nasmlib/mmap.o \
		blake-bin/nasm/_objs/nasm/nasmlib/path.o \
		blake-bin/nasm/_objs/nasm/nasmlib/perfhash.o \
		blake-bin/nasm/_objs/nasm/nasmlib/raa.o \
		blake-bin/nasm/_objs/nasm/nasmlib/rbtree.o \
		blake-bin/nasm/_objs/nasm/nasmlib/readnum.o \
		blake-bin/nasm/_objs/nasm/nasmlib/realpath.o \
		blake-bin/nasm/_objs/nasm/nasmlib/saa.o \
		blake-bin/nasm/_objs/nasm/nasmlib/srcfile.o \
		blake-bin/nasm/_objs/nasm/nasmlib/string.o \
		blake-bin/nasm/_objs/nasm/nasmlib/strlist.o \
		blake-bin/nasm/_objs/nasm/nasmlib/ver.o \
		blake-bin/nasm/_objs/nasm/nasmlib/zerobuf.o \
		blake-bin/nasm/_objs/nasm/output/codeview.o \
		blake-bin/nasm/_objs/nasm/output/legacy.o \
		blake-bin/nasm/_objs/nasm/output/nulldbg.o \
		blake-bin/nasm/_objs/nasm/output/nullout.o \
		blake-bin/nasm/_objs/nasm/output/outaout.o \
		blake-bin/nasm/_objs/nasm/output/outas86.o \
		blake-bin/nasm/_objs/nasm/output/outbin.o \
		blake-bin/nasm/_objs/nasm/output/outcoff.o \
		blake-bin/nasm/_objs/nasm/output/outdbg.o \
		blake-bin/nasm/_objs/nasm/output/outelf.o \
		blake-bin/nasm/_objs/nasm/output/outform.o \
		blake-bin/nasm/_objs/nasm/output/outieee.o \
		blake-bin/nasm/_objs/nasm/output/outlib.o \
		blake-bin/nasm/_objs/nasm/output/outmacho.o \
		blake-bin/nasm/_objs/nasm/output/outobj.o \
		blake-bin/nasm/_objs/nasm/output/outrdf2.o \
		blake-bin/nasm/_objs/nasm/stdlib/snprintf.o \
		blake-bin/nasm/_objs/nasm/stdlib/strlcpy.o \
		blake-bin/nasm/_objs/nasm/stdlib/strnlen.o \
		blake-bin/nasm/_objs/nasm/stdlib/vsnprintf.o \
		blake-bin/nasm/_objs/nasm/x86/disp8.o \
		blake-bin/nasm/_objs/nasm/x86/iflag.o \
		blake-bin/nasm/_objs/nasm/x86/insnsa.o \
		blake-bin/nasm/_objs/nasm/x86/insnsb.o \
		blake-bin/nasm/_objs/nasm/x86/insnsd.o \
		blake-bin/nasm/_objs/nasm/x86/insnsn.o \
		blake-bin/nasm/_objs/nasm/x86/regdis.o \
		blake-bin/nasm/_objs/nasm/x86/regflags.o \
		blake-bin/nasm/_objs/nasm/x86/regs.o \
		blake-bin/nasm/_objs/nasm/x86/regvals.o
	$(AR) $(ARFLAGS) $@ $^

nasm_nasm_SBLINKT = blake-bin/nasm/libnasm.a
nasm_nasm_SBLINKF = $(WA) $(nasm_nasm_SBLINKT) $(NOWA)

blake-bin/nasm/nasm: $(nasm_nasm_SBLINKT)
	$(CC) $(CFLAGS.security) $(nasm_nasm_CFLAGS) $(CFLAGS) $(LDFLAGS.security)  $(PIE) $(LDFLAGS) $(TARGET_ARCH) $(nasm_nasm_SBLINKF) $(LOADLIBES)  $(LDLIBS) -o $@

################################################################################
# @jpeg//:simd_x86_64_assemblage23

jpeg_simd_x86_64_assemblage23_PREREQUISITES = \
	jpeg/simd/jccolext-sse2-64.asm \
	jpeg/simd/jccolor-sse2-64.asm \
	jpeg/simd/jcgray-sse2-64.asm \
	jpeg/simd/jcgryext-sse2-64.asm \
	jpeg/simd/jchuff-sse2-64.asm \
	jpeg/simd/jcolsamp.inc \
	jpeg/simd/jcsample-sse2-64.asm \
	jpeg/simd/jdcolext-sse2-64.asm \
	jpeg/simd/jdcolor-sse2-64.asm \
	jpeg/simd/jdct.inc \
	jpeg/simd/jdmerge-sse2-64.asm \
	jpeg/simd/jdmrgext-sse2-64.asm \
	jpeg/simd/jdsample-sse2-64.asm \
	jpeg/simd/jfdctflt-sse-64.asm \
	jpeg/simd/jfdctfst-sse2-64.asm \
	jpeg/simd/jfdctint-sse2-64.asm \
	jpeg/simd/jidctflt-sse2-64.asm \
	jpeg/simd/jidctfst-sse2-64.asm \
	jpeg/simd/jidctint-sse2-64.asm \
	jpeg/simd/jidctred-sse2-64.asm \
	jpeg/simd/jpeg_nbits_table.inc \
	jpeg/simd/jquantf-sse2-64.asm \
	jpeg/simd/jquanti-sse2-64.asm \
	jpeg/simd/jsimdcfg.inc \
	jpeg/simd/jsimdext.inc \
	blake-bin/nasm/nasm

blake-bin/jpeg/simd_x86_64_assemblage23.stamp: \
		$(jpeg_simd_x86_64_assemblage23_PREREQUISITES)
	@mkdir -p jpeg/simd
	@printf "%s\n" 'for out in jpeg/simd/jccolor-sse2-64.o jpeg/simd/jcgray-sse2-64.o jpeg/simd/jchuff-sse2-64.o jpeg/simd/jcsample-sse2-64.o jpeg/simd/jdcolor-sse2-64.o jpeg/simd/jdmerge-sse2-64.o jpeg/simd/jdsample-sse2-64.o jpeg/simd/jfdctflt-sse-64.o jpeg/simd/jfdctfst-sse2-64.o jpeg/simd/jfdctint-sse2-64.o jpeg/simd/jidctflt-sse2-64.o jpeg/simd/jidctfst-sse2-64.o jpeg/simd/jidctint-sse2-64.o jpeg/simd/jidctred-sse2-64.o jpeg/simd/jquantf-sse2-64.o jpeg/simd/jquanti-sse2-64.o; do \
	  blake-bin/nasm/nasm -f elf64    -DELF -DPIC -DRGBX_FILLER_0XFF -D__x86_64__ -DARCH_X86_64    -I $$(dirname jpeg/simd/jdct.inc)/    -I $$(dirname jpeg/simd/jsimdcfg.inc)/    -o $$out    $$(dirname jpeg/simd/jdct.inc)/$$(basename $${out%.o}.asm) \
	done'
	@jpeg/simd_x86_64_assemblage23.sh
	@mkdir -p blake-bin/jpeg
	@touch blake-bin/jpeg/simd_x86_64_assemblage23.stamp

jpeg/simd/jccolor-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jcgray-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jchuff-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jcsample-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jdcolor-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jdmerge-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jdsample-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jfdctflt-sse-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jfdctfst-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jfdctint-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jidctflt-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jidctfst-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jidctint-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jidctred-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jquantf-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;
jpeg/simd/jquanti-sse2-64.o: blake-bin/jpeg/simd_x86_64_assemblage23.stamp;

################################################################################
# @jpeg//:simd_x86_64

jpeg_simd_x86_64_CFLAGS = -O3 -w
jpeg_simd_x86_64_LINKT = $(jpeg_simd_x86_64_SPLINK)
jpeg_simd_x86_64_LINKF = $(jpeg_simd_x86_64_SPLINK)

jpeg_simd_x86_64_COMPILE_HEADERS = \
	jpeg/jchuff.h \
	jpeg/jconfig.h \
	jpeg/jdct.h \
	jpeg/jerror.h \
	jpeg/jinclude.h \
	jpeg/jmorecfg.h \
	jpeg/jpegint.h \
	jpeg/jpeglib.h \
	jpeg/jsimd.h \
	jpeg/jsimddct.h \
	jpeg/simd/jsimd.h

blake-bin/jpeg/_objs/simd_x86_64/%.pic.o: \
		jpeg/%.c \
		$(jpeg_simd_x86_64_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_simd_x86_64_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote jpeg $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/_objs/simd_x86_64/%.o: \
		jpeg/%.c \
		$(jpeg_simd_x86_64_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_simd_x86_64_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote jpeg $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/libsimd_x86_64.a: \
		blake-bin/jpeg/_objs/simd_x86_64/simd/jsimd_x86_64.o \
		jpeg/simd/jccolor-sse2-64.o \
		jpeg/simd/jcgray-sse2-64.o \
		jpeg/simd/jchuff-sse2-64.o \
		jpeg/simd/jcsample-sse2-64.o \
		jpeg/simd/jdcolor-sse2-64.o \
		jpeg/simd/jdmerge-sse2-64.o \
		jpeg/simd/jdsample-sse2-64.o \
		jpeg/simd/jfdctflt-sse-64.o \
		jpeg/simd/jfdctfst-sse2-64.o \
		jpeg/simd/jfdctint-sse2-64.o \
		jpeg/simd/jidctflt-sse2-64.o \
		jpeg/simd/jidctfst-sse2-64.o \
		jpeg/simd/jidctint-sse2-64.o \
		jpeg/simd/jidctred-sse2-64.o \
		jpeg/simd/jquantf-sse2-64.o \
		jpeg/simd/jquanti-sse2-64.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_simd_x86_64_SBLINK = blake-bin/jpeg/libsimd_x86_64.a

blake-bin/jpeg/libsimd_x86_64.pic.a: \
		jpeg/simd/jccolor-sse2-64.o \
		jpeg/simd/jcgray-sse2-64.o \
		jpeg/simd/jchuff-sse2-64.o \
		jpeg/simd/jcsample-sse2-64.o \
		jpeg/simd/jdcolor-sse2-64.o \
		jpeg/simd/jdmerge-sse2-64.o \
		jpeg/simd/jdsample-sse2-64.o \
		jpeg/simd/jfdctflt-sse-64.o \
		jpeg/simd/jfdctfst-sse2-64.o \
		jpeg/simd/jfdctint-sse2-64.o \
		jpeg/simd/jidctflt-sse2-64.o \
		jpeg/simd/jidctfst-sse2-64.o \
		jpeg/simd/jidctint-sse2-64.o \
		jpeg/simd/jidctred-sse2-64.o \
		jpeg/simd/jquantf-sse2-64.o \
		jpeg/simd/jquanti-sse2-64.o \
		blake-bin/jpeg/_objs/simd_x86_64/simd/jsimd_x86_64.pic.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_simd_x86_64_SPLINK = blake-bin/jpeg/libsimd_x86_64.pic.a

################################################################################
# @jpeg//:jpeg

jpeg_jpeg_CFLAGS = -O3 -w

jpeg_jpeg_HEADERS = \
	jpeg/jccolext.c \
	jpeg/jdcol565.c \
	jpeg/jdcolext.c \
	jpeg/jdmrg565.c \
	jpeg/jdmrgext.c \
	jpeg/jerror.h \
	jpeg/jmorecfg.h \
	jpeg/jpegint.h \
	jpeg/jpeglib.h \
	jpeg/jstdhuff.c

jpeg_jpeg_LINK = blake-bin/jpeg/libjpeg.so

jpeg_jpeg_COMPILE_HEADERS = \
	jpeg/jchuff.h \
	jpeg/jconfig.h \
	jpeg/jconfigint.h \
	jpeg/jdcoefct.h \
	jpeg/jdct.h \
	jpeg/jdhuff.h \
	jpeg/jdmainct.h \
	jpeg/jdmaster.h \
	jpeg/jdsample.h \
	jpeg/jinclude.h \
	jpeg/jmemsys.h \
	jpeg/jpeg_nbits_table.h \
	jpeg/jpegcomp.h \
	jpeg/jversion.h \
	$(jpeg_jpeg_HEADERS)

blake-bin/jpeg/_objs/jpeg/%.pic.o: jpeg/%.c $(jpeg_jpeg_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_jpeg_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote jpeg $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/_objs/jpeg/%.o: jpeg/%.c $(jpeg_jpeg_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jpeg_jpeg_CFLAGS) $(CFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote jpeg $(TARGET_ARCH) -c -o $@ $<

blake-bin/jpeg/libjpeg.a: \
		blake-bin/jpeg/_objs/jpeg/jaricom.o \
		blake-bin/jpeg/_objs/jpeg/jcapimin.o \
		blake-bin/jpeg/_objs/jpeg/jcapistd.o \
		blake-bin/jpeg/_objs/jpeg/jcarith.o \
		blake-bin/jpeg/_objs/jpeg/jccoefct.o \
		blake-bin/jpeg/_objs/jpeg/jccolor.o \
		blake-bin/jpeg/_objs/jpeg/jcdctmgr.o \
		blake-bin/jpeg/_objs/jpeg/jchuff.o \
		blake-bin/jpeg/_objs/jpeg/jcinit.o \
		blake-bin/jpeg/_objs/jpeg/jcmainct.o \
		blake-bin/jpeg/_objs/jpeg/jcmarker.o \
		blake-bin/jpeg/_objs/jpeg/jcmaster.o \
		blake-bin/jpeg/_objs/jpeg/jcomapi.o \
		blake-bin/jpeg/_objs/jpeg/jcparam.o \
		blake-bin/jpeg/_objs/jpeg/jcphuff.o \
		blake-bin/jpeg/_objs/jpeg/jcprepct.o \
		blake-bin/jpeg/_objs/jpeg/jcsample.o \
		blake-bin/jpeg/_objs/jpeg/jctrans.o \
		blake-bin/jpeg/_objs/jpeg/jdapimin.o \
		blake-bin/jpeg/_objs/jpeg/jdapistd.o \
		blake-bin/jpeg/_objs/jpeg/jdarith.o \
		blake-bin/jpeg/_objs/jpeg/jdatadst.o \
		blake-bin/jpeg/_objs/jpeg/jdatasrc.o \
		blake-bin/jpeg/_objs/jpeg/jdcoefct.o \
		blake-bin/jpeg/_objs/jpeg/jdcolor.o \
		blake-bin/jpeg/_objs/jpeg/jddctmgr.o \
		blake-bin/jpeg/_objs/jpeg/jdhuff.o \
		blake-bin/jpeg/_objs/jpeg/jdinput.o \
		blake-bin/jpeg/_objs/jpeg/jdmainct.o \
		blake-bin/jpeg/_objs/jpeg/jdmarker.o \
		blake-bin/jpeg/_objs/jpeg/jdmaster.o \
		blake-bin/jpeg/_objs/jpeg/jdmerge.o \
		blake-bin/jpeg/_objs/jpeg/jdphuff.o \
		blake-bin/jpeg/_objs/jpeg/jdpostct.o \
		blake-bin/jpeg/_objs/jpeg/jdsample.o \
		blake-bin/jpeg/_objs/jpeg/jdtrans.o \
		blake-bin/jpeg/_objs/jpeg/jerror.o \
		blake-bin/jpeg/_objs/jpeg/jfdctflt.o \
		blake-bin/jpeg/_objs/jpeg/jfdctfst.o \
		blake-bin/jpeg/_objs/jpeg/jfdctint.o \
		blake-bin/jpeg/_objs/jpeg/jidctflt.o \
		blake-bin/jpeg/_objs/jpeg/jidctfst.o \
		blake-bin/jpeg/_objs/jpeg/jidctint.o \
		blake-bin/jpeg/_objs/jpeg/jidctred.o \
		blake-bin/jpeg/_objs/jpeg/jmemmgr.o \
		blake-bin/jpeg/_objs/jpeg/jmemnobs.o \
		blake-bin/jpeg/_objs/jpeg/jquant1.o \
		blake-bin/jpeg/_objs/jpeg/jquant2.o \
		blake-bin/jpeg/_objs/jpeg/jutils.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_jpeg_SBLINK = blake-bin/jpeg/libjpeg.a

blake-bin/jpeg/libjpeg.pic.a: \
		blake-bin/jpeg/_objs/jpeg/jaricom.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcapimin.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcapistd.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcarith.pic.o \
		blake-bin/jpeg/_objs/jpeg/jccoefct.pic.o \
		blake-bin/jpeg/_objs/jpeg/jccolor.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcdctmgr.pic.o \
		blake-bin/jpeg/_objs/jpeg/jchuff.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcinit.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcmainct.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcmarker.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcmaster.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcomapi.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcparam.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcphuff.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcprepct.pic.o \
		blake-bin/jpeg/_objs/jpeg/jcsample.pic.o \
		blake-bin/jpeg/_objs/jpeg/jctrans.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdapimin.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdapistd.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdarith.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdatadst.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdatasrc.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdcoefct.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdcolor.pic.o \
		blake-bin/jpeg/_objs/jpeg/jddctmgr.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdhuff.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdinput.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdmainct.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdmarker.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdmaster.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdmerge.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdphuff.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdpostct.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdsample.pic.o \
		blake-bin/jpeg/_objs/jpeg/jdtrans.pic.o \
		blake-bin/jpeg/_objs/jpeg/jerror.pic.o \
		blake-bin/jpeg/_objs/jpeg/jfdctflt.pic.o \
		blake-bin/jpeg/_objs/jpeg/jfdctfst.pic.o \
		blake-bin/jpeg/_objs/jpeg/jfdctint.pic.o \
		blake-bin/jpeg/_objs/jpeg/jidctflt.pic.o \
		blake-bin/jpeg/_objs/jpeg/jidctfst.pic.o \
		blake-bin/jpeg/_objs/jpeg/jidctint.pic.o \
		blake-bin/jpeg/_objs/jpeg/jidctred.pic.o \
		blake-bin/jpeg/_objs/jpeg/jmemmgr.pic.o \
		blake-bin/jpeg/_objs/jpeg/jmemnobs.pic.o \
		blake-bin/jpeg/_objs/jpeg/jquant1.pic.o \
		blake-bin/jpeg/_objs/jpeg/jquant2.pic.o \
		blake-bin/jpeg/_objs/jpeg/jutils.pic.o
	$(AR) $(ARFLAGS) $@ $^

jpeg_jpeg_SPLINK = blake-bin/jpeg/libjpeg.pic.a

blake-bin/jpeg/libjpeg.so: $(jpeg_jpeg_SPLINK) $(jpeg_simd_x86_64_LINKT)
	$(CC) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(jpeg_jpeg_SPLINK) $(NOWA) $(jpeg_simd_x86_64_LINKF) 

################################################################################
# //tensorflow/core/platform/default/build_config:jpeg

tensorflow_core_platform_default_build_config_jpeg_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

################################################################################
# @com_googlesource_code_re2//:re2

com_googlesource_code_re2_re2_CFLAGS = -pthread
com_googlesource_code_re2_re2_LDFLAGS = -pthread

com_googlesource_code_re2_re2_HEADERS = \
	com_googlesource_code_re2/re2/filtered_re2.h \
	com_googlesource_code_re2/re2/re2.h \
	com_googlesource_code_re2/re2/set.h \
	com_googlesource_code_re2/re2/stringpiece.h

com_googlesource_code_re2_re2_LINK = \
	blake-bin/com_googlesource_code_re2/libre2.so

com_googlesource_code_re2_re2_COMPILE_HEADERS = \
	com_googlesource_code_re2/re2/bitmap256.h \
	com_googlesource_code_re2/re2/prefilter.h \
	com_googlesource_code_re2/re2/prefilter_tree.h \
	com_googlesource_code_re2/re2/prog.h \
	com_googlesource_code_re2/re2/regexp.h \
	com_googlesource_code_re2/re2/unicode_casefold.h \
	com_googlesource_code_re2/re2/unicode_groups.h \
	com_googlesource_code_re2/re2/walker-inl.h \
	com_googlesource_code_re2/util/flags.h \
	com_googlesource_code_re2/util/logging.h \
	com_googlesource_code_re2/util/mix.h \
	com_googlesource_code_re2/util/mutex.h \
	com_googlesource_code_re2/util/sparse_array.h \
	com_googlesource_code_re2/util/sparse_set.h \
	com_googlesource_code_re2/util/strutil.h \
	com_googlesource_code_re2/util/utf.h \
	com_googlesource_code_re2/util/util.h \
	$(com_googlesource_code_re2_re2_HEADERS)

blake-bin/com_googlesource_code_re2/_objs/re2/%.pic.o: \
		com_googlesource_code_re2/%.cc \
		$(com_googlesource_code_re2_re2_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(com_googlesource_code_re2_re2_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote com_googlesource_code_re2 $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/com_googlesource_code_re2/_objs/re2/%.o: \
		com_googlesource_code_re2/%.cc \
		$(com_googlesource_code_re2_re2_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(com_googlesource_code_re2_re2_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote com_googlesource_code_re2 $(TARGET_ARCH) -c -o $@ $<

blake-bin/com_googlesource_code_re2/libre2.a: \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/bitstate.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/compile.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/dfa.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/filtered_re2.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/mimics_pcre.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/nfa.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/onepass.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/parse.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/perl_groups.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/prefilter.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/prefilter_tree.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/prog.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/re2.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/regexp.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/set.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/simplify.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/stringpiece.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/tostring.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/unicode_casefold.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/unicode_groups.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/util/rune.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/util/strutil.o
	$(AR) $(ARFLAGS) $@ $^

com_googlesource_code_re2_re2_SBLINK = \
	blake-bin/com_googlesource_code_re2/libre2.a

blake-bin/com_googlesource_code_re2/libre2.pic.a: \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/bitstate.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/compile.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/dfa.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/filtered_re2.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/mimics_pcre.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/nfa.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/onepass.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/parse.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/perl_groups.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/prefilter.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/prefilter_tree.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/prog.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/re2.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/regexp.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/set.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/simplify.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/stringpiece.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/tostring.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/unicode_casefold.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/re2/unicode_groups.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/util/rune.pic.o \
		blake-bin/com_googlesource_code_re2/_objs/re2/util/strutil.pic.o
	$(AR) $(ARFLAGS) $@ $^

com_googlesource_code_re2_re2_SPLINK = \
	blake-bin/com_googlesource_code_re2/libre2.pic.a

blake-bin/com_googlesource_code_re2/libre2.so: \
		$(com_googlesource_code_re2_re2_SPLINK)
	$(CXX) -shared $(LDFLAGS.security) $(com_googlesource_code_re2_re2_LDFLAGS) $(LDFLAGS) -o $@ $(WA) $(com_googlesource_code_re2_re2_SPLINK) $(NOWA) 

################################################################################
# @farmhash_archive//:farmhash

farmhash_archive_farmhash_CPPFLAGS = -isystem farmhash_archive/src
farmhash_archive_farmhash_HEADERS = farmhash_archive/src/farmhash.h
farmhash_archive_farmhash_LINK = blake-bin/farmhash_archive/libfarmhash.so

blake-bin/farmhash_archive/_objs/farmhash/%.pic.o: \
		farmhash_archive/%.cc \
		$(farmhash_archive_farmhash_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(farmhash_archive_farmhash_CPPFLAGS) $(CPPFLAGS) -iquote farmhash_archive $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/farmhash_archive/_objs/farmhash/%.o: \
		farmhash_archive/%.cc \
		$(farmhash_archive_farmhash_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(farmhash_archive_farmhash_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote farmhash_archive $(TARGET_ARCH) -c -o $@ $<

blake-bin/farmhash_archive/libfarmhash.a: \
		blake-bin/farmhash_archive/_objs/farmhash/src/farmhash.o
	$(AR) $(ARFLAGS) $@ $^

farmhash_archive_farmhash_SBLINK = blake-bin/farmhash_archive/libfarmhash.a

blake-bin/farmhash_archive/libfarmhash.pic.a: \
		blake-bin/farmhash_archive/_objs/farmhash/src/farmhash.pic.o
	$(AR) $(ARFLAGS) $@ $^

farmhash_archive_farmhash_SPLINK = blake-bin/farmhash_archive/libfarmhash.pic.a

blake-bin/farmhash_archive/libfarmhash.so: $(farmhash_archive_farmhash_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(farmhash_archive_farmhash_SPLINK) $(NOWA) 

################################################################################
# @fft2d//:fft2d

fft2d_fft2d_LDLIBS = -lm
fft2d_fft2d_LINK = blake-bin/fft2d/libfft2d.so

blake-bin/fft2d/_objs/fft2d/%.pic.o: fft2d/%.c 
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security)  $(CFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote fft2d $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/fft2d/_objs/fft2d/%.o: fft2d/%.c 
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security)  $(CFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote fft2d $(TARGET_ARCH) -c -o $@ $<

blake-bin/fft2d/libfft2d.a: blake-bin/fft2d/_objs/fft2d/fft/fftsg.o
	$(AR) $(ARFLAGS) $@ $^

fft2d_fft2d_SBLINK = blake-bin/fft2d/libfft2d.a

blake-bin/fft2d/libfft2d.pic.a: blake-bin/fft2d/_objs/fft2d/fft/fftsg.pic.o
	$(AR) $(ARFLAGS) $@ $^

fft2d_fft2d_SPLINK = blake-bin/fft2d/libfft2d.pic.a

blake-bin/fft2d/libfft2d.so: $(fft2d_fft2d_SPLINK)
	$(CC) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(fft2d_fft2d_SPLINK) $(NOWA) $(fft2d_fft2d_LDLIBS)

################################################################################
# @highwayhash//:compiler_specific

highwayhash_compiler_specific_HEADERS = \
	highwayhash/highwayhash/compiler_specific.h

################################################################################
# @highwayhash//:arch_specific

highwayhash_arch_specific_HEADERS = highwayhash/highwayhash/arch_specific.h
highwayhash_arch_specific_LINK = blake-bin/highwayhash/libarch_specific.so

highwayhash_arch_specific_COMPILE_HEADERS = \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS)

blake-bin/highwayhash/_objs/arch_specific/%.pic.o: \
		highwayhash/%.cc \
		$(highwayhash_arch_specific_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote highwayhash $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/highwayhash/_objs/arch_specific/%.o: \
		highwayhash/%.cc \
		$(highwayhash_arch_specific_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote highwayhash $(TARGET_ARCH) -c -o $@ $<

blake-bin/highwayhash/libarch_specific.a: \
		blake-bin/highwayhash/_objs/arch_specific/highwayhash/arch_specific.o
	$(AR) $(ARFLAGS) $@ $^

highwayhash_arch_specific_SBLINK = blake-bin/highwayhash/libarch_specific.a

blake-bin/highwayhash/libarch_specific.pic.a: \
		blake-bin/highwayhash/_objs/arch_specific/highwayhash/arch_specific.pic.o
	$(AR) $(ARFLAGS) $@ $^

highwayhash_arch_specific_SPLINK = blake-bin/highwayhash/libarch_specific.pic.a

blake-bin/highwayhash/libarch_specific.so: $(highwayhash_arch_specific_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(highwayhash_arch_specific_SPLINK) $(NOWA) 

################################################################################
# @highwayhash//:sip_hash

highwayhash_sip_hash_HEADERS = \
	highwayhash/highwayhash/endianess.h \
	highwayhash/highwayhash/sip_hash.h \
	highwayhash/highwayhash/state_helpers.h

highwayhash_sip_hash_LINK = blake-bin/highwayhash/libsip_hash.so

highwayhash_sip_hash_COMPILE_HEADERS = \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS)

blake-bin/highwayhash/_objs/sip_hash/%.pic.o: \
		highwayhash/%.cc \
		$(highwayhash_sip_hash_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote highwayhash $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/highwayhash/_objs/sip_hash/%.o: \
		highwayhash/%.cc \
		$(highwayhash_sip_hash_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote highwayhash $(TARGET_ARCH) -c -o $@ $<

blake-bin/highwayhash/libsip_hash.a: \
		blake-bin/highwayhash/_objs/sip_hash/highwayhash/sip_hash.o
	$(AR) $(ARFLAGS) $@ $^

highwayhash_sip_hash_SBLINK = blake-bin/highwayhash/libsip_hash.a

blake-bin/highwayhash/libsip_hash.pic.a: \
		blake-bin/highwayhash/_objs/sip_hash/highwayhash/sip_hash.pic.o
	$(AR) $(ARFLAGS) $@ $^

highwayhash_sip_hash_SPLINK = blake-bin/highwayhash/libsip_hash.pic.a

blake-bin/highwayhash/libsip_hash.so: \
		$(highwayhash_sip_hash_SPLINK) \
		$(highwayhash_arch_specific_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(highwayhash_sip_hash_SPLINK) $(NOWA) $(highwayhash_arch_specific_LINK) 

################################################################################
# @zlib_archive//:zlib

zlib_archive_zlib_CFLAGS = -Wno-shift-negative-value -DZ_HAVE_UNISTD_H
zlib_archive_zlib_CPPFLAGS = -isystem zlib_archive
zlib_archive_zlib_HEADERS = zlib_archive/zlib.h
zlib_archive_zlib_LINK = blake-bin/zlib_archive/libzlib.so

zlib_archive_zlib_COMPILE_HEADERS = \
	zlib_archive/crc32.h \
	zlib_archive/deflate.h \
	zlib_archive/gzguts.h \
	zlib_archive/inffast.h \
	zlib_archive/inffixed.h \
	zlib_archive/inflate.h \
	zlib_archive/inftrees.h \
	zlib_archive/trees.h \
	zlib_archive/zconf.h \
	zlib_archive/zutil.h \
	$(zlib_archive_zlib_HEADERS)

blake-bin/zlib_archive/_objs/zlib/%.pic.o: \
		zlib_archive/%.c \
		$(zlib_archive_zlib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(zlib_archive_zlib_CFLAGS) $(CFLAGS) $(CPPFLAGS.security) $(zlib_archive_zlib_CPPFLAGS) $(CPPFLAGS) -iquote zlib_archive $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/zlib_archive/_objs/zlib/%.o: \
		zlib_archive/%.c \
		$(zlib_archive_zlib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(zlib_archive_zlib_CFLAGS) $(CFLAGS) $(CPPFLAGS.security) $(zlib_archive_zlib_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote zlib_archive $(TARGET_ARCH) -c -o $@ $<

blake-bin/zlib_archive/libzlib.a: \
		blake-bin/zlib_archive/_objs/zlib/adler32.o \
		blake-bin/zlib_archive/_objs/zlib/compress.o \
		blake-bin/zlib_archive/_objs/zlib/crc32.o \
		blake-bin/zlib_archive/_objs/zlib/deflate.o \
		blake-bin/zlib_archive/_objs/zlib/gzclose.o \
		blake-bin/zlib_archive/_objs/zlib/gzlib.o \
		blake-bin/zlib_archive/_objs/zlib/gzread.o \
		blake-bin/zlib_archive/_objs/zlib/gzwrite.o \
		blake-bin/zlib_archive/_objs/zlib/infback.o \
		blake-bin/zlib_archive/_objs/zlib/inffast.o \
		blake-bin/zlib_archive/_objs/zlib/inflate.o \
		blake-bin/zlib_archive/_objs/zlib/inftrees.o \
		blake-bin/zlib_archive/_objs/zlib/trees.o \
		blake-bin/zlib_archive/_objs/zlib/uncompr.o \
		blake-bin/zlib_archive/_objs/zlib/zutil.o
	$(AR) $(ARFLAGS) $@ $^

zlib_archive_zlib_SBLINK = blake-bin/zlib_archive/libzlib.a

blake-bin/zlib_archive/libzlib.pic.a: \
		blake-bin/zlib_archive/_objs/zlib/adler32.pic.o \
		blake-bin/zlib_archive/_objs/zlib/compress.pic.o \
		blake-bin/zlib_archive/_objs/zlib/crc32.pic.o \
		blake-bin/zlib_archive/_objs/zlib/deflate.pic.o \
		blake-bin/zlib_archive/_objs/zlib/gzclose.pic.o \
		blake-bin/zlib_archive/_objs/zlib/gzlib.pic.o \
		blake-bin/zlib_archive/_objs/zlib/gzread.pic.o \
		blake-bin/zlib_archive/_objs/zlib/gzwrite.pic.o \
		blake-bin/zlib_archive/_objs/zlib/infback.pic.o \
		blake-bin/zlib_archive/_objs/zlib/inffast.pic.o \
		blake-bin/zlib_archive/_objs/zlib/inflate.pic.o \
		blake-bin/zlib_archive/_objs/zlib/inftrees.pic.o \
		blake-bin/zlib_archive/_objs/zlib/trees.pic.o \
		blake-bin/zlib_archive/_objs/zlib/uncompr.pic.o \
		blake-bin/zlib_archive/_objs/zlib/zutil.pic.o
	$(AR) $(ARFLAGS) $@ $^

zlib_archive_zlib_SPLINK = blake-bin/zlib_archive/libzlib.pic.a

blake-bin/zlib_archive/libzlib.so: $(zlib_archive_zlib_SPLINK)
	$(CC) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(zlib_archive_zlib_SPLINK) $(NOWA) 

################################################################################
# //tensorflow/core/platform/default/build_config:platformlib

tensorflow_core_platform_default_build_config_platformlib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

################################################################################
# @com_google_absl//absl/base:base_internal

com_google_absl_absl_base_base_internal_CFLAGS = \
	-Wall \
	-Wextra \
	-Wcast-qual \
	-Wconversion-null \
	-Wmissing-declarations \
	-Woverlength-strings \
	-Wpointer-arith \
	-Wunused-local-typedefs \
	-Wunused-result \
	-Wvarargs \
	-Wvla \
	-Wwrite-strings \
	-Wno-sign-compare

com_google_absl_absl_base_base_internal_HEADERS = \
	com_google_absl/absl/base/internal/identity.h \
	com_google_absl/absl/base/internal/inline_variable.h \
	com_google_absl/absl/base/internal/invoke.h

################################################################################
# @com_google_absl//absl/base:config

com_google_absl_absl_base_config_CFLAGS = \
	-Wall \
	-Wextra \
	-Wcast-qual \
	-Wconversion-null \
	-Wmissing-declarations \
	-Woverlength-strings \
	-Wpointer-arith \
	-Wunused-local-typedefs \
	-Wunused-result \
	-Wvarargs \
	-Wvla \
	-Wwrite-strings \
	-Wno-sign-compare

com_google_absl_absl_base_config_HEADERS = \
	com_google_absl/absl/base/config.h \
	com_google_absl/absl/base/policy_checks.h

################################################################################
# @com_google_absl//absl/base:dynamic_annotations

com_google_absl_absl_base_dynamic_annotations_CFLAGS = \
	-Wall \
	-Wextra \
	-Wcast-qual \
	-Wconversion-null \
	-Wmissing-declarations \
	-Woverlength-strings \
	-Wpointer-arith \
	-Wunused-local-typedefs \
	-Wunused-result \
	-Wvarargs \
	-Wvla \
	-Wwrite-strings \
	-Wno-sign-compare

com_google_absl_absl_base_dynamic_annotations_CPPFLAGS = \
	-D__CLANG_SUPPORT_DYN_ANNOTATION__

com_google_absl_absl_base_dynamic_annotations_HEADERS = \
	com_google_absl/absl/base/dynamic_annotations.h

com_google_absl_absl_base_dynamic_annotations_LINK = \
	blake-bin/com_google_absl/absl/base/libdynamic_annotations.so

blake-bin/com_google_absl/absl/base/_objs/dynamic_annotations/%.pic.o: \
		com_google_absl/absl/base/%.cc \
		$(com_google_absl_absl_base_dynamic_annotations_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(com_google_absl_absl_base_dynamic_annotations_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) $(CPPFLAGS) -iquote com_google_absl $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/com_google_absl/absl/base/_objs/dynamic_annotations/%.o: \
		com_google_absl/absl/base/%.cc \
		$(com_google_absl_absl_base_dynamic_annotations_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(com_google_absl_absl_base_dynamic_annotations_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote com_google_absl $(TARGET_ARCH) -c -o $@ $<

blake-bin/com_google_absl/absl/base/libdynamic_annotations.a: \
		blake-bin/com_google_absl/absl/base/_objs/dynamic_annotations/dynamic_annotations.o
	$(AR) $(ARFLAGS) $@ $^

com_google_absl_absl_base_dynamic_annotations_SBLINK = \
	blake-bin/com_google_absl/absl/base/libdynamic_annotations.a

blake-bin/com_google_absl/absl/base/libdynamic_annotations.pic.a: \
		blake-bin/com_google_absl/absl/base/_objs/dynamic_annotations/dynamic_annotations.pic.o
	$(AR) $(ARFLAGS) $@ $^

com_google_absl_absl_base_dynamic_annotations_SPLINK = \
	blake-bin/com_google_absl/absl/base/libdynamic_annotations.pic.a

blake-bin/com_google_absl/absl/base/libdynamic_annotations.so: \
		$(com_google_absl_absl_base_dynamic_annotations_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(com_google_absl_absl_base_dynamic_annotations_SPLINK) $(NOWA) 

################################################################################
# @com_google_absl//absl/base:core_headers

com_google_absl_absl_base_core_headers_CFLAGS = \
	-Wall \
	-Wextra \
	-Wcast-qual \
	-Wconversion-null \
	-Wmissing-declarations \
	-Woverlength-strings \
	-Wpointer-arith \
	-Wunused-local-typedefs \
	-Wunused-result \
	-Wvarargs \
	-Wvla \
	-Wwrite-strings \
	-Wno-sign-compare

com_google_absl_absl_base_core_headers_HEADERS = \
	com_google_absl/absl/base/attributes.h \
	com_google_absl/absl/base/macros.h \
	com_google_absl/absl/base/optimization.h \
	com_google_absl/absl/base/port.h \
	com_google_absl/absl/base/thread_annotations.h

################################################################################
# @com_google_absl//absl/base:spinlock_wait

com_google_absl_absl_base_spinlock_wait_CFLAGS = \
	-Wall \
	-Wextra \
	-Wcast-qual \
	-Wconversion-null \
	-Wmissing-declarations \
	-Woverlength-strings \
	-Wpointer-arith \
	-Wunused-local-typedefs \
	-Wunused-result \
	-Wvarargs \
	-Wvla \
	-Wwrite-strings \
	-Wno-sign-compare

com_google_absl_absl_base_spinlock_wait_HEADERS = \
	com_google_absl/absl/base/internal/scheduling_mode.h \
	com_google_absl/absl/base/internal/spinlock_wait.h

com_google_absl_absl_base_spinlock_wait_LINK = \
	blake-bin/com_google_absl/absl/base/libspinlock_wait.so

com_google_absl_absl_base_spinlock_wait_COMPILE_HEADERS = \
	com_google_absl/absl/base/internal/spinlock_akaros.inc \
	com_google_absl/absl/base/internal/spinlock_posix.inc \
	com_google_absl/absl/base/internal/spinlock_win32.inc \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS)

blake-bin/com_google_absl/absl/base/_objs/spinlock_wait/%.pic.o: \
		com_google_absl/absl/base/%.cc \
		$(com_google_absl_absl_base_spinlock_wait_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(com_google_absl_absl_base_spinlock_wait_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) $(CPPFLAGS) -iquote com_google_absl $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/com_google_absl/absl/base/_objs/spinlock_wait/%.o: \
		com_google_absl/absl/base/%.cc \
		$(com_google_absl_absl_base_spinlock_wait_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(com_google_absl_absl_base_spinlock_wait_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote com_google_absl $(TARGET_ARCH) -c -o $@ $<

blake-bin/com_google_absl/absl/base/libspinlock_wait.a: \
		blake-bin/com_google_absl/absl/base/_objs/spinlock_wait/internal/spinlock_wait.o
	$(AR) $(ARFLAGS) $@ $^

com_google_absl_absl_base_spinlock_wait_SBLINK = \
	blake-bin/com_google_absl/absl/base/libspinlock_wait.a

blake-bin/com_google_absl/absl/base/libspinlock_wait.pic.a: \
		blake-bin/com_google_absl/absl/base/_objs/spinlock_wait/internal/spinlock_wait.pic.o
	$(AR) $(ARFLAGS) $@ $^

com_google_absl_absl_base_spinlock_wait_SPLINK = \
	blake-bin/com_google_absl/absl/base/libspinlock_wait.pic.a

blake-bin/com_google_absl/absl/base/libspinlock_wait.so: \
		$(com_google_absl_absl_base_spinlock_wait_SPLINK) \
		$(com_google_absl_absl_base_dynamic_annotations_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(com_google_absl_absl_base_spinlock_wait_SPLINK) $(NOWA) $(com_google_absl_absl_base_dynamic_annotations_LINK) 

################################################################################
# @com_google_absl//absl/base:base

com_google_absl_absl_base_base_CFLAGS = \
	-Wall \
	-Wextra \
	-Wcast-qual \
	-Wconversion-null \
	-Wmissing-declarations \
	-Woverlength-strings \
	-Wpointer-arith \
	-Wunused-local-typedefs \
	-Wunused-result \
	-Wvarargs \
	-Wvla \
	-Wwrite-strings \
	-Wno-sign-compare

com_google_absl_absl_base_base_HEADERS = \
	com_google_absl/absl/base/call_once.h \
	com_google_absl/absl/base/casts.h \
	com_google_absl/absl/base/internal/atomic_hook.h \
	com_google_absl/absl/base/internal/cycleclock.h \
	com_google_absl/absl/base/internal/low_level_scheduling.h \
	com_google_absl/absl/base/internal/per_thread_tls.h \
	com_google_absl/absl/base/internal/raw_logging.h \
	com_google_absl/absl/base/internal/spinlock.h \
	com_google_absl/absl/base/internal/sysinfo.h \
	com_google_absl/absl/base/internal/thread_identity.h \
	com_google_absl/absl/base/internal/tsan_mutex_interface.h \
	com_google_absl/absl/base/internal/unscaledcycleclock.h \
	com_google_absl/absl/base/log_severity.h

com_google_absl_absl_base_base_LINK = \
	blake-bin/com_google_absl/absl/base/libbase.so

com_google_absl_absl_base_base_COMPILE_HEADERS = \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS)

blake-bin/com_google_absl/absl/base/_objs/base/%.pic.o: \
		com_google_absl/absl/base/%.cc \
		$(com_google_absl_absl_base_base_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(com_google_absl_absl_base_base_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) $(CPPFLAGS) -iquote com_google_absl $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/com_google_absl/absl/base/_objs/base/%.o: \
		com_google_absl/absl/base/%.cc \
		$(com_google_absl_absl_base_base_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(com_google_absl_absl_base_base_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote com_google_absl $(TARGET_ARCH) -c -o $@ $<

blake-bin/com_google_absl/absl/base/libbase.a: \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/cycleclock.o \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/raw_logging.o \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/spinlock.o \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/sysinfo.o \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/thread_identity.o \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/unscaledcycleclock.o
	$(AR) $(ARFLAGS) $@ $^

com_google_absl_absl_base_base_SBLINK = \
	blake-bin/com_google_absl/absl/base/libbase.a

blake-bin/com_google_absl/absl/base/libbase.pic.a: \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/cycleclock.pic.o \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/raw_logging.pic.o \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/spinlock.pic.o \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/sysinfo.pic.o \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/thread_identity.pic.o \
		blake-bin/com_google_absl/absl/base/_objs/base/internal/unscaledcycleclock.pic.o
	$(AR) $(ARFLAGS) $@ $^

com_google_absl_absl_base_base_SPLINK = \
	blake-bin/com_google_absl/absl/base/libbase.pic.a

blake-bin/com_google_absl/absl/base/libbase.so: \
		$(com_google_absl_absl_base_base_SPLINK) \
		$(com_google_absl_absl_base_spinlock_wait_LINK) \
		$(com_google_absl_absl_base_dynamic_annotations_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(com_google_absl_absl_base_base_SPLINK) $(NOWA) $(com_google_absl_absl_base_spinlock_wait_LINK) $(com_google_absl_absl_base_dynamic_annotations_LINK) 

################################################################################
# @bazel_tools//src/main/cpp/util:blaze_exit_code

bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS = \
	bazel_tools/src/main/cpp/util/exit_code.h

################################################################################
# @bazel_tools//src/main/cpp/util:logging

bazel_tools_src_main_cpp_util_logging_HEADERS = \
	bazel_tools/src/main/cpp/util/logging.h

bazel_tools_src_main_cpp_util_logging_LINK = \
	blake-bin/bazel_tools/src/main/cpp/util/liblogging.so

bazel_tools_src_main_cpp_util_logging_COMPILE_HEADERS = \
	$(bazel_tools_src_main_cpp_util_logging_HEADERS) \
	$(bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS)

blake-bin/bazel_tools/src/main/cpp/util/_objs/logging/%.pic.o: \
		bazel_tools/src/main/cpp/util/%.cc \
		$(bazel_tools_src_main_cpp_util_logging_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/cpp/util/_objs/logging/%.o: \
		bazel_tools/src/main/cpp/util/%.cc \
		$(bazel_tools_src_main_cpp_util_logging_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/cpp/util/liblogging.a: \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/logging/logging.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_cpp_util_logging_SBLINK = \
	blake-bin/bazel_tools/src/main/cpp/util/liblogging.a

blake-bin/bazel_tools/src/main/cpp/util/liblogging.pic.a: \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/logging/logging.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_cpp_util_logging_SPLINK = \
	blake-bin/bazel_tools/src/main/cpp/util/liblogging.pic.a

blake-bin/bazel_tools/src/main/cpp/util/liblogging.so: \
		$(bazel_tools_src_main_cpp_util_logging_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_main_cpp_util_logging_SPLINK) $(NOWA) 

################################################################################
# @bazel_tools//src/main/cpp/util:port

bazel_tools_src_main_cpp_util_port_HEADERS = \
	bazel_tools/src/main/cpp/util/port.h

bazel_tools_src_main_cpp_util_port_LINK = \
	blake-bin/bazel_tools/src/main/cpp/util/libport.so

blake-bin/bazel_tools/src/main/cpp/util/_objs/port/%.pic.o: \
		bazel_tools/src/main/cpp/util/%.cc \
		$(bazel_tools_src_main_cpp_util_port_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/cpp/util/_objs/port/%.o: \
		bazel_tools/src/main/cpp/util/%.cc \
		$(bazel_tools_src_main_cpp_util_port_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/cpp/util/libport.a: \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/port/port.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_cpp_util_port_SBLINK = \
	blake-bin/bazel_tools/src/main/cpp/util/libport.a

blake-bin/bazel_tools/src/main/cpp/util/libport.pic.a: \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/port/port.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_cpp_util_port_SPLINK = \
	blake-bin/bazel_tools/src/main/cpp/util/libport.pic.a

blake-bin/bazel_tools/src/main/cpp/util/libport.so: \
		$(bazel_tools_src_main_cpp_util_port_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_main_cpp_util_port_SPLINK) $(NOWA) 

################################################################################
# @bazel_tools//src/main/cpp/util:strings

bazel_tools_src_main_cpp_util_strings_CPPFLAGS = -DBLAZE_OPENSOURCE

bazel_tools_src_main_cpp_util_strings_HEADERS = \
	bazel_tools/src/main/cpp/util/strings.h

bazel_tools_src_main_cpp_util_strings_LINK = \
	blake-bin/bazel_tools/src/main/cpp/util/libstrings.so

bazel_tools_src_main_cpp_util_strings_COMPILE_HEADERS = \
	$(bazel_tools_src_main_cpp_util_strings_HEADERS) \
	$(bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS)

blake-bin/bazel_tools/src/main/cpp/util/_objs/strings/%.pic.o: \
		bazel_tools/src/main/cpp/util/%.cc \
		$(bazel_tools_src_main_cpp_util_strings_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/cpp/util/_objs/strings/%.o: \
		bazel_tools/src/main/cpp/util/%.cc \
		$(bazel_tools_src_main_cpp_util_strings_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/cpp/util/libstrings.a: \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/strings/strings.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_cpp_util_strings_SBLINK = \
	blake-bin/bazel_tools/src/main/cpp/util/libstrings.a

blake-bin/bazel_tools/src/main/cpp/util/libstrings.pic.a: \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/strings/strings.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_cpp_util_strings_SPLINK = \
	blake-bin/bazel_tools/src/main/cpp/util/libstrings.pic.a

blake-bin/bazel_tools/src/main/cpp/util/libstrings.so: \
		$(bazel_tools_src_main_cpp_util_strings_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_main_cpp_util_strings_SPLINK) $(NOWA) 

################################################################################
# @bazel_tools//src/main/cpp/util:errors

bazel_tools_src_main_cpp_util_errors_HEADERS = \
	bazel_tools/src/main/cpp/util/errors.h

bazel_tools_src_main_cpp_util_errors_LINK = \
	blake-bin/bazel_tools/src/main/cpp/util/liberrors.so

bazel_tools_src_main_cpp_util_errors_COMPILE_HEADERS = \
	$(bazel_tools_src_main_cpp_util_errors_HEADERS) \
	$(bazel_tools_src_main_cpp_util_logging_HEADERS) \
	$(bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS) \
	$(bazel_tools_src_main_cpp_util_port_HEADERS) \
	$(bazel_tools_src_main_cpp_util_strings_HEADERS)

blake-bin/bazel_tools/src/main/cpp/util/_objs/errors/%.pic.o: \
		bazel_tools/src/main/cpp/util/%.cc \
		$(bazel_tools_src_main_cpp_util_errors_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/cpp/util/_objs/errors/%.o: \
		bazel_tools/src/main/cpp/util/%.cc \
		$(bazel_tools_src_main_cpp_util_errors_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/cpp/util/liberrors.a: \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/errors/errors_posix.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_cpp_util_errors_SBLINK = \
	blake-bin/bazel_tools/src/main/cpp/util/liberrors.a

blake-bin/bazel_tools/src/main/cpp/util/liberrors.pic.a: \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/errors/errors_posix.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_cpp_util_errors_SPLINK = \
	blake-bin/bazel_tools/src/main/cpp/util/liberrors.pic.a

blake-bin/bazel_tools/src/main/cpp/util/liberrors.so: \
		$(bazel_tools_src_main_cpp_util_errors_SPLINK) \
		$(bazel_tools_src_main_cpp_util_strings_LINK) \
		$(bazel_tools_src_main_cpp_util_port_LINK) \
		$(bazel_tools_src_main_cpp_util_logging_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_main_cpp_util_errors_SPLINK) $(NOWA) $(bazel_tools_src_main_cpp_util_strings_LINK) $(bazel_tools_src_main_cpp_util_port_LINK) $(bazel_tools_src_main_cpp_util_logging_LINK) 

################################################################################
# @bazel_tools//src/main/native/windows:lib-util

bazel_tools_src_main_native_windows_lib-util_HEADERS = \
	bazel_tools/src/main/native/windows/util.h

bazel_tools_src_main_native_windows_lib-util_LINK = \
	blake-bin/bazel_tools/src/main/native/windows/liblib-util.so

blake-bin/bazel_tools/src/main/native/windows/_objs/lib-util/%.pic.o: \
		bazel_tools/src/main/native/windows/%.cc \
		$(bazel_tools_src_main_native_windows_lib-util_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/native/windows/_objs/lib-util/%.o: \
		bazel_tools/src/main/native/windows/%.cc \
		$(bazel_tools_src_main_native_windows_lib-util_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/native/windows/liblib-util.a: \
		blake-bin/bazel_tools/src/main/native/windows/_objs/lib-util/util.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_native_windows_lib-util_SBLINK = \
	blake-bin/bazel_tools/src/main/native/windows/liblib-util.a

blake-bin/bazel_tools/src/main/native/windows/liblib-util.pic.a: \
		blake-bin/bazel_tools/src/main/native/windows/_objs/lib-util/util.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_native_windows_lib-util_SPLINK = \
	blake-bin/bazel_tools/src/main/native/windows/liblib-util.pic.a

blake-bin/bazel_tools/src/main/native/windows/liblib-util.so: \
		$(bazel_tools_src_main_native_windows_lib-util_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_main_native_windows_lib-util_SPLINK) $(NOWA) 

################################################################################
# @bazel_tools//src/main/native/windows:lib-file

bazel_tools_src_main_native_windows_lib-file_HEADERS = \
	bazel_tools/src/main/native/windows/file.h

bazel_tools_src_main_native_windows_lib-file_LINK = \
	blake-bin/bazel_tools/src/main/native/windows/liblib-file.so

bazel_tools_src_main_native_windows_lib-file_COMPILE_HEADERS = \
	$(bazel_tools_src_main_native_windows_lib-file_HEADERS) \
	$(bazel_tools_src_main_native_windows_lib-util_HEADERS)

blake-bin/bazel_tools/src/main/native/windows/_objs/lib-file/%.pic.o: \
		bazel_tools/src/main/native/windows/%.cc \
		$(bazel_tools_src_main_native_windows_lib-file_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/native/windows/_objs/lib-file/%.o: \
		bazel_tools/src/main/native/windows/%.cc \
		$(bazel_tools_src_main_native_windows_lib-file_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/native/windows/liblib-file.a: \
		blake-bin/bazel_tools/src/main/native/windows/_objs/lib-file/file.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_native_windows_lib-file_SBLINK = \
	blake-bin/bazel_tools/src/main/native/windows/liblib-file.a

blake-bin/bazel_tools/src/main/native/windows/liblib-file.pic.a: \
		blake-bin/bazel_tools/src/main/native/windows/_objs/lib-file/file.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_native_windows_lib-file_SPLINK = \
	blake-bin/bazel_tools/src/main/native/windows/liblib-file.pic.a

blake-bin/bazel_tools/src/main/native/windows/liblib-file.so: \
		$(bazel_tools_src_main_native_windows_lib-file_SPLINK) \
		$(bazel_tools_src_main_native_windows_lib-util_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_main_native_windows_lib-file_SPLINK) $(NOWA) $(bazel_tools_src_main_native_windows_lib-util_LINK) 

################################################################################
# @bazel_tools//src/main/cpp/util:file

bazel_tools_src_main_cpp_util_file_HEADERS = \
	bazel_tools/src/main/cpp/util/file.h \
	bazel_tools/src/main/cpp/util/file_platform.h

bazel_tools_src_main_cpp_util_file_LINK = \
	blake-bin/bazel_tools/src/main/cpp/util/libfile.so

bazel_tools_src_main_cpp_util_file_COMPILE_HEADERS = \
	$(bazel_tools_src_main_cpp_util_file_HEADERS) \
	$(bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS) \
	$(bazel_tools_src_main_cpp_util_errors_HEADERS) \
	$(bazel_tools_src_main_cpp_util_logging_HEADERS) \
	$(bazel_tools_src_main_cpp_util_port_HEADERS) \
	$(bazel_tools_src_main_cpp_util_strings_HEADERS)

blake-bin/bazel_tools/src/main/cpp/util/_objs/file/%.pic.o: \
		bazel_tools/src/main/cpp/util/%.cc \
		$(bazel_tools_src_main_cpp_util_file_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/cpp/util/_objs/file/%.o: \
		bazel_tools/src/main/cpp/util/%.cc \
		$(bazel_tools_src_main_cpp_util_file_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/main/cpp/util/libfile.a: \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/file/file.o \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/file/file_posix.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_cpp_util_file_SBLINK = \
	blake-bin/bazel_tools/src/main/cpp/util/libfile.a

blake-bin/bazel_tools/src/main/cpp/util/libfile.pic.a: \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/file/file.pic.o \
		blake-bin/bazel_tools/src/main/cpp/util/_objs/file/file_posix.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_main_cpp_util_file_SPLINK = \
	blake-bin/bazel_tools/src/main/cpp/util/libfile.pic.a

blake-bin/bazel_tools/src/main/cpp/util/libfile.so: \
		$(bazel_tools_src_main_cpp_util_file_SPLINK) \
		$(bazel_tools_src_main_cpp_util_strings_LINK) \
		$(bazel_tools_src_main_cpp_util_logging_LINK) \
		$(bazel_tools_src_main_cpp_util_errors_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_main_cpp_util_file_SPLINK) $(NOWA) $(bazel_tools_src_main_cpp_util_strings_LINK) $(bazel_tools_src_main_cpp_util_logging_LINK) $(bazel_tools_src_main_cpp_util_errors_LINK) 

################################################################################
# @bazel_tools//src/tools/launcher/util:util

bazel_tools_src_tools_launcher_util_util_LINK = \
	blake-bin/bazel_tools/src/tools/launcher/util/libutil.so

bazel_tools_src_tools_launcher_util_util_COMPILE_HEADERS = \
	$(bazel_tools_src_main_cpp_util_file_HEADERS) \
	$(bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS) \
	$(bazel_tools_src_main_cpp_util_errors_HEADERS) \
	$(bazel_tools_src_main_cpp_util_logging_HEADERS) \
	$(bazel_tools_src_main_cpp_util_port_HEADERS) \
	$(bazel_tools_src_main_cpp_util_strings_HEADERS)

blake-bin/bazel_tools/src/tools/launcher/util/_objs/util/%.pic.o: \
		bazel_tools/src/tools/launcher/util/%.cc \
		$(bazel_tools_src_tools_launcher_util_util_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/util/_objs/util/%.o: \
		bazel_tools/src/tools/launcher/util/%.cc \
		$(bazel_tools_src_tools_launcher_util_util_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/util/libutil.a: \
		blake-bin/bazel_tools/src/tools/launcher/util/_objs/util/dummy.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_util_util_SBLINK = \
	blake-bin/bazel_tools/src/tools/launcher/util/libutil.a

blake-bin/bazel_tools/src/tools/launcher/util/libutil.pic.a: \
		blake-bin/bazel_tools/src/tools/launcher/util/_objs/util/dummy.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_util_util_SPLINK = \
	blake-bin/bazel_tools/src/tools/launcher/util/libutil.pic.a

blake-bin/bazel_tools/src/tools/launcher/util/libutil.so: \
		$(bazel_tools_src_tools_launcher_util_util_SPLINK) \
		$(bazel_tools_src_main_cpp_util_file_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_tools_launcher_util_util_SPLINK) $(NOWA) $(bazel_tools_src_main_cpp_util_file_LINK) 

################################################################################
# @bazel_tools//src/tools/launcher/util:data_parser

bazel_tools_src_tools_launcher_util_data_parser_LINK = \
	blake-bin/bazel_tools/src/tools/launcher/util/libdata_parser.so

bazel_tools_src_tools_launcher_util_data_parser_COMPILE_HEADERS = \
	$(bazel_tools_src_main_cpp_util_file_HEADERS) \
	$(bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS) \
	$(bazel_tools_src_main_cpp_util_errors_HEADERS) \
	$(bazel_tools_src_main_cpp_util_logging_HEADERS) \
	$(bazel_tools_src_main_cpp_util_port_HEADERS) \
	$(bazel_tools_src_main_cpp_util_strings_HEADERS)

blake-bin/bazel_tools/src/tools/launcher/util/_objs/data_parser/%.pic.o: \
		bazel_tools/src/tools/launcher/util/%.cc \
		$(bazel_tools_src_tools_launcher_util_data_parser_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/util/_objs/data_parser/%.o: \
		bazel_tools/src/tools/launcher/util/%.cc \
		$(bazel_tools_src_tools_launcher_util_data_parser_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/util/libdata_parser.a: \
		blake-bin/bazel_tools/src/tools/launcher/util/_objs/data_parser/dummy.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_util_data_parser_SBLINK = \
	blake-bin/bazel_tools/src/tools/launcher/util/libdata_parser.a

blake-bin/bazel_tools/src/tools/launcher/util/libdata_parser.pic.a: \
		blake-bin/bazel_tools/src/tools/launcher/util/_objs/data_parser/dummy.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_util_data_parser_SPLINK = \
	blake-bin/bazel_tools/src/tools/launcher/util/libdata_parser.pic.a

blake-bin/bazel_tools/src/tools/launcher/util/libdata_parser.so: \
		$(bazel_tools_src_tools_launcher_util_data_parser_SPLINK) \
		$(bazel_tools_src_tools_launcher_util_util_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_tools_launcher_util_data_parser_SPLINK) $(NOWA) $(bazel_tools_src_tools_launcher_util_util_LINK) 

################################################################################
# @bazel_tools//src/tools/launcher:launcher_base

bazel_tools_src_tools_launcher_launcher_base_LINK = \
	blake-bin/bazel_tools/src/tools/launcher/liblauncher_base.so

bazel_tools_src_tools_launcher_launcher_base_COMPILE_HEADERS = \
	$(bazel_tools_src_main_cpp_util_file_HEADERS) \
	$(bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS) \
	$(bazel_tools_src_main_cpp_util_errors_HEADERS) \
	$(bazel_tools_src_main_cpp_util_logging_HEADERS) \
	$(bazel_tools_src_main_cpp_util_port_HEADERS) \
	$(bazel_tools_src_main_cpp_util_strings_HEADERS)

blake-bin/bazel_tools/src/tools/launcher/_objs/launcher_base/%.pic.o: \
		bazel_tools/src/tools/launcher/%.cc \
		$(bazel_tools_src_tools_launcher_launcher_base_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/_objs/launcher_base/%.o: \
		bazel_tools/src/tools/launcher/%.cc \
		$(bazel_tools_src_tools_launcher_launcher_base_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/liblauncher_base.a: \
		blake-bin/bazel_tools/src/tools/launcher/_objs/launcher_base/dummy.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_launcher_base_SBLINK = \
	blake-bin/bazel_tools/src/tools/launcher/liblauncher_base.a

blake-bin/bazel_tools/src/tools/launcher/liblauncher_base.pic.a: \
		blake-bin/bazel_tools/src/tools/launcher/_objs/launcher_base/dummy.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_launcher_base_SPLINK = \
	blake-bin/bazel_tools/src/tools/launcher/liblauncher_base.pic.a

blake-bin/bazel_tools/src/tools/launcher/liblauncher_base.so: \
		$(bazel_tools_src_tools_launcher_launcher_base_SPLINK) \
		$(bazel_tools_src_tools_launcher_util_data_parser_LINK) \
		$(bazel_tools_src_tools_launcher_util_util_LINK) \
		$(bazel_tools_src_main_cpp_util_file_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_tools_launcher_launcher_base_SPLINK) $(NOWA) $(bazel_tools_src_tools_launcher_util_data_parser_LINK) $(bazel_tools_src_tools_launcher_util_util_LINK) $(bazel_tools_src_main_cpp_util_file_LINK) 

################################################################################
# @bazel_tools//src/tools/launcher:bash_launcher

bazel_tools_src_tools_launcher_bash_launcher_LINK = \
	blake-bin/bazel_tools/src/tools/launcher/libbash_launcher.so

bazel_tools_src_tools_launcher_bash_launcher_COMPILE_HEADERS = \
	$(bazel_tools_src_main_cpp_util_file_HEADERS) \
	$(bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS) \
	$(bazel_tools_src_main_cpp_util_errors_HEADERS) \
	$(bazel_tools_src_main_cpp_util_logging_HEADERS) \
	$(bazel_tools_src_main_cpp_util_port_HEADERS) \
	$(bazel_tools_src_main_cpp_util_strings_HEADERS)

blake-bin/bazel_tools/src/tools/launcher/_objs/bash_launcher/%.pic.o: \
		bazel_tools/src/tools/launcher/%.cc \
		$(bazel_tools_src_tools_launcher_bash_launcher_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/_objs/bash_launcher/%.o: \
		bazel_tools/src/tools/launcher/%.cc \
		$(bazel_tools_src_tools_launcher_bash_launcher_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/libbash_launcher.a: \
		blake-bin/bazel_tools/src/tools/launcher/_objs/bash_launcher/dummy.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_bash_launcher_SBLINK = \
	blake-bin/bazel_tools/src/tools/launcher/libbash_launcher.a

blake-bin/bazel_tools/src/tools/launcher/libbash_launcher.pic.a: \
		blake-bin/bazel_tools/src/tools/launcher/_objs/bash_launcher/dummy.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_bash_launcher_SPLINK = \
	blake-bin/bazel_tools/src/tools/launcher/libbash_launcher.pic.a

blake-bin/bazel_tools/src/tools/launcher/libbash_launcher.so: \
		$(bazel_tools_src_tools_launcher_bash_launcher_SPLINK) \
		$(bazel_tools_src_tools_launcher_launcher_base_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_tools_launcher_bash_launcher_SPLINK) $(NOWA) $(bazel_tools_src_tools_launcher_launcher_base_LINK) 

################################################################################
# @bazel_tools//src/tools/launcher:java_launcher

bazel_tools_src_tools_launcher_java_launcher_LINK = \
	blake-bin/bazel_tools/src/tools/launcher/libjava_launcher.so

bazel_tools_src_tools_launcher_java_launcher_COMPILE_HEADERS = \
	$(bazel_tools_src_main_cpp_util_file_HEADERS) \
	$(bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS) \
	$(bazel_tools_src_main_cpp_util_errors_HEADERS) \
	$(bazel_tools_src_main_cpp_util_logging_HEADERS) \
	$(bazel_tools_src_main_cpp_util_port_HEADERS) \
	$(bazel_tools_src_main_cpp_util_strings_HEADERS)

blake-bin/bazel_tools/src/tools/launcher/_objs/java_launcher/%.pic.o: \
		bazel_tools/src/tools/launcher/%.cc \
		$(bazel_tools_src_tools_launcher_java_launcher_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/_objs/java_launcher/%.o: \
		bazel_tools/src/tools/launcher/%.cc \
		$(bazel_tools_src_tools_launcher_java_launcher_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/libjava_launcher.a: \
		blake-bin/bazel_tools/src/tools/launcher/_objs/java_launcher/dummy.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_java_launcher_SBLINK = \
	blake-bin/bazel_tools/src/tools/launcher/libjava_launcher.a

blake-bin/bazel_tools/src/tools/launcher/libjava_launcher.pic.a: \
		blake-bin/bazel_tools/src/tools/launcher/_objs/java_launcher/dummy.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_java_launcher_SPLINK = \
	blake-bin/bazel_tools/src/tools/launcher/libjava_launcher.pic.a

blake-bin/bazel_tools/src/tools/launcher/libjava_launcher.so: \
		$(bazel_tools_src_tools_launcher_java_launcher_SPLINK) \
		$(bazel_tools_src_tools_launcher_launcher_base_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_tools_launcher_java_launcher_SPLINK) $(NOWA) $(bazel_tools_src_tools_launcher_launcher_base_LINK) 

################################################################################
# @bazel_tools//src/tools/launcher:python_launcher

bazel_tools_src_tools_launcher_python_launcher_LINK = \
	blake-bin/bazel_tools/src/tools/launcher/libpython_launcher.so

bazel_tools_src_tools_launcher_python_launcher_COMPILE_HEADERS = \
	$(bazel_tools_src_main_cpp_util_file_HEADERS) \
	$(bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS) \
	$(bazel_tools_src_main_cpp_util_errors_HEADERS) \
	$(bazel_tools_src_main_cpp_util_logging_HEADERS) \
	$(bazel_tools_src_main_cpp_util_port_HEADERS) \
	$(bazel_tools_src_main_cpp_util_strings_HEADERS)

blake-bin/bazel_tools/src/tools/launcher/_objs/python_launcher/%.pic.o: \
		bazel_tools/src/tools/launcher/%.cc \
		$(bazel_tools_src_tools_launcher_python_launcher_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(CPPFLAGS) -iquote bazel_tools $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/_objs/python_launcher/%.o: \
		bazel_tools/src/tools/launcher/%.cc \
		$(bazel_tools_src_tools_launcher_python_launcher_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/libpython_launcher.a: \
		blake-bin/bazel_tools/src/tools/launcher/_objs/python_launcher/dummy.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_python_launcher_SBLINK = \
	blake-bin/bazel_tools/src/tools/launcher/libpython_launcher.a

blake-bin/bazel_tools/src/tools/launcher/libpython_launcher.pic.a: \
		blake-bin/bazel_tools/src/tools/launcher/_objs/python_launcher/dummy.pic.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_python_launcher_SPLINK = \
	blake-bin/bazel_tools/src/tools/launcher/libpython_launcher.pic.a

blake-bin/bazel_tools/src/tools/launcher/libpython_launcher.so: \
		$(bazel_tools_src_tools_launcher_python_launcher_SPLINK) \
		$(bazel_tools_src_tools_launcher_launcher_base_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(bazel_tools_src_tools_launcher_python_launcher_SPLINK) $(NOWA) $(bazel_tools_src_tools_launcher_launcher_base_LINK) 

################################################################################
# @bazel_tools//src/tools/launcher:launcher

bazel_tools_src_tools_launcher_launcher_COMPILE_HEADERS = \
	$(bazel_tools_src_main_cpp_util_file_HEADERS) \
	$(bazel_tools_src_main_cpp_util_blaze_exit_code_HEADERS) \
	$(bazel_tools_src_main_cpp_util_errors_HEADERS) \
	$(bazel_tools_src_main_cpp_util_logging_HEADERS) \
	$(bazel_tools_src_main_cpp_util_port_HEADERS) \
	$(bazel_tools_src_main_cpp_util_strings_HEADERS)

blake-bin/bazel_tools/src/tools/launcher/_objs/launcher/%.o: \
		bazel_tools/src/tools/launcher/%.cc \
		$(bazel_tools_src_tools_launcher_launcher_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(bazel_tools_src_main_cpp_util_strings_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote bazel_tools $(TARGET_ARCH) -c -o $@ $<

blake-bin/bazel_tools/src/tools/launcher/liblauncher.a: \
		blake-bin/bazel_tools/src/tools/launcher/_objs/launcher/dummy.o
	$(AR) $(ARFLAGS) $@ $^

bazel_tools_src_tools_launcher_launcher_SBLINKT = \
	blake-bin/bazel_tools/src/tools/launcher/liblauncher.a

bazel_tools_src_tools_launcher_launcher_SBLINKF = \
	$(WA) $(bazel_tools_src_tools_launcher_launcher_SBLINKT) $(NOWA)

blake-bin/bazel_tools/src/tools/launcher/launcher: \
		$(bazel_tools_src_tools_launcher_launcher_SBLINKT) \
		$(bazel_tools_src_tools_launcher_python_launcher_SBLINK) \
		$(bazel_tools_src_tools_launcher_java_launcher_SBLINK) \
		$(bazel_tools_src_tools_launcher_bash_launcher_SBLINK) \
		$(bazel_tools_src_tools_launcher_launcher_base_SBLINK) \
		$(bazel_tools_src_tools_launcher_util_data_parser_SBLINK) \
		$(bazel_tools_src_tools_launcher_util_util_SBLINK) \
		$(bazel_tools_src_main_cpp_util_file_SBLINK) \
		$(bazel_tools_src_main_cpp_util_errors_SBLINK) \
		$(bazel_tools_src_main_cpp_util_strings_SBLINK) \
		$(bazel_tools_src_main_cpp_util_port_SBLINK) \
		$(bazel_tools_src_main_cpp_util_logging_SBLINK)
	$(CXX) $(CFLAGS.security)  $(CXXFLAGS) $(LDFLAGS.security)  $(PIE) $(LDFLAGS) $(TARGET_ARCH) $(bazel_tools_src_tools_launcher_launcher_SBLINKF) $(bazel_tools_src_tools_launcher_python_launcher_SBLINK) $(bazel_tools_src_tools_launcher_java_launcher_SBLINK) $(bazel_tools_src_tools_launcher_bash_launcher_SBLINK) $(bazel_tools_src_tools_launcher_launcher_base_SBLINK) $(bazel_tools_src_tools_launcher_util_data_parser_SBLINK) $(bazel_tools_src_tools_launcher_util_util_SBLINK) $(bazel_tools_src_main_cpp_util_file_SBLINK) $(bazel_tools_src_main_cpp_util_errors_SBLINK) $(bazel_tools_src_main_cpp_util_strings_SBLINK) $(bazel_tools_src_main_cpp_util_port_SBLINK) $(bazel_tools_src_main_cpp_util_logging_SBLINK) $(LOADLIBES)  $(LDLIBS) -o $@

################################################################################
# @jemalloc//:public_symbols_txt

jemalloc/include/jemalloc/internal/public_symbols.txt: 
	@mkdir -p jemalloc/include/jemalloc/internal
	jemalloc/public_symbols_txt.sh

################################################################################
# @jemalloc//:jemalloc_mangle_h

jemalloc/include/jemalloc/jemalloc_mangle.h: \
		jemalloc/include/jemalloc/internal/public_symbols.txt \
		jemalloc/public_symbols_txt.sh \
		jemalloc/include/jemalloc/jemalloc_mangle.sh
	@mkdir -p jemalloc/include/jemalloc
	jemalloc/include/jemalloc/jemalloc_mangle.sh jemalloc/include/jemalloc/internal/public_symbols.txt jemalloc/public_symbols_txt.sh je_ >jemalloc/include/jemalloc/jemalloc_mangle.h

################################################################################
# @jemalloc//:jemalloc_rename_h

jemalloc/include/jemalloc/jemalloc_rename.h: \
		jemalloc/include/jemalloc/internal/public_symbols.txt \
		jemalloc/public_symbols_txt.sh \
		jemalloc/include/jemalloc/jemalloc_rename.sh
	@mkdir -p jemalloc/include/jemalloc
	jemalloc/include/jemalloc/jemalloc_rename.sh jemalloc/include/jemalloc/internal/public_symbols.txt jemalloc/public_symbols_txt.sh >jemalloc/include/jemalloc/jemalloc_rename.h

################################################################################
# @jemalloc//:jemalloc_h

jemalloc/include/jemalloc/jemalloc.h: \
		jemalloc/include/jemalloc/jemalloc_defs.h \
		jemalloc/include/jemalloc/jemalloc_macros.h \
		jemalloc/include/jemalloc/jemalloc_mangle.h \
		jemalloc/include/jemalloc/jemalloc_protos.h \
		jemalloc/include/jemalloc/jemalloc_rename.h \
		jemalloc/include/jemalloc/jemalloc_typedefs.h \
		jemalloc/include/jemalloc/jemalloc.sh
	@mkdir -p jemalloc/include/jemalloc
	jemalloc/include/jemalloc/jemalloc.sh $(dirname jemalloc/include/jemalloc/jemalloc_defs.h)/../../ >jemalloc/include/jemalloc/jemalloc.h

################################################################################
# @jemalloc//:jemalloc_headers

jemalloc_jemalloc_headers_CPPFLAGS = -isystem jemalloc/include
jemalloc_jemalloc_headers_HEADERS = jemalloc/include/jemalloc/jemalloc.h

################################################################################
# @jemalloc//:private_namespace_h

jemalloc/include/jemalloc/internal/private_namespace.h: \
		jemalloc/include/jemalloc/internal/private_symbols.txt \
		jemalloc/include/jemalloc/internal/private_namespace.sh
	@mkdir -p jemalloc/include/jemalloc/internal
	jemalloc/include/jemalloc/internal/private_namespace.sh jemalloc/include/jemalloc/internal/private_symbols.txt >jemalloc/include/jemalloc/internal/private_namespace.h

################################################################################
# @jemalloc//:size_classes_h

jemalloc/include/jemalloc/internal/size_classes.h: \
		jemalloc/include/jemalloc/internal/size_classes.sh
	@mkdir -p jemalloc/include/jemalloc/internal
	jemalloc/include/jemalloc/internal/size_classes.sh "3 4" 3 12 2 >jemalloc/include/jemalloc/internal/size_classes.h

################################################################################
# @jemalloc//:jemalloc_impl

jemalloc_jemalloc_impl_CFLAGS = -O3 -funroll-loops -D_GNU_SOURCE -D_REENTRANT
jemalloc_jemalloc_impl_CPPFLAGS = -isystem jemalloc/include
jemalloc_jemalloc_impl_LDLIBS = -lpthread

jemalloc_jemalloc_impl_HEADERS = \
	jemalloc/include/jemalloc/internal/arena.h \
	jemalloc/include/jemalloc/internal/assert.h \
	jemalloc/include/jemalloc/internal/atomic.h \
	jemalloc/include/jemalloc/internal/base.h \
	jemalloc/include/jemalloc/internal/bitmap.h \
	jemalloc/include/jemalloc/internal/chunk.h \
	jemalloc/include/jemalloc/internal/chunk_dss.h \
	jemalloc/include/jemalloc/internal/chunk_mmap.h \
	jemalloc/include/jemalloc/internal/ckh.h \
	jemalloc/include/jemalloc/internal/ctl.h \
	jemalloc/include/jemalloc/internal/extent.h \
	jemalloc/include/jemalloc/internal/hash.h \
	jemalloc/include/jemalloc/internal/huge.h \
	jemalloc/include/jemalloc/internal/jemalloc_internal.h \
	jemalloc/include/jemalloc/internal/jemalloc_internal_decls.h \
	jemalloc/include/jemalloc/internal/jemalloc_internal_defs.h \
	jemalloc/include/jemalloc/internal/jemalloc_internal_macros.h \
	jemalloc/include/jemalloc/internal/mb.h \
	jemalloc/include/jemalloc/internal/mutex.h \
	jemalloc/include/jemalloc/internal/nstime.h \
	jemalloc/include/jemalloc/internal/pages.h \
	jemalloc/include/jemalloc/internal/ph.h \
	jemalloc/include/jemalloc/internal/private_namespace.h \
	jemalloc/include/jemalloc/internal/prng.h \
	jemalloc/include/jemalloc/internal/prof.h \
	jemalloc/include/jemalloc/internal/ql.h \
	jemalloc/include/jemalloc/internal/qr.h \
	jemalloc/include/jemalloc/internal/quarantine.h \
	jemalloc/include/jemalloc/internal/rb.h \
	jemalloc/include/jemalloc/internal/rtree.h \
	jemalloc/include/jemalloc/internal/size_classes.h \
	jemalloc/include/jemalloc/internal/smoothstep.h \
	jemalloc/include/jemalloc/internal/spin.h \
	jemalloc/include/jemalloc/internal/stats.h \
	jemalloc/include/jemalloc/internal/tcache.h \
	jemalloc/include/jemalloc/internal/ticker.h \
	jemalloc/include/jemalloc/internal/tsd.h \
	jemalloc/include/jemalloc/internal/util.h \
	jemalloc/include/jemalloc/internal/valgrind.h \
	jemalloc/include/jemalloc/internal/witness.h

jemalloc_jemalloc_impl_LINK = blake-bin/jemalloc/libjemalloc_impl.so

jemalloc_jemalloc_impl_COMPILE_CPPFLAGS = \
	$(jemalloc_jemalloc_impl_CPPFLAGS) \
	$(jemalloc_jemalloc_headers_CPPFLAGS)

jemalloc_jemalloc_impl_COMPILE_HEADERS = \
	$(jemalloc_jemalloc_impl_HEADERS) \
	$(jemalloc_jemalloc_headers_HEADERS)

blake-bin/jemalloc/_objs/jemalloc_impl/%.pic.o: \
		jemalloc/%.c \
		$(jemalloc_jemalloc_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jemalloc_jemalloc_impl_CFLAGS) $(CFLAGS) $(CPPFLAGS.security) $(jemalloc_jemalloc_impl_COMPILE_CPPFLAGS) $(CPPFLAGS) -iquote jemalloc $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/jemalloc/_objs/jemalloc_impl/%.o: \
		jemalloc/%.c \
		$(jemalloc_jemalloc_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(jemalloc_jemalloc_impl_CFLAGS) $(CFLAGS) $(CPPFLAGS.security) $(jemalloc_jemalloc_impl_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote jemalloc $(TARGET_ARCH) -c -o $@ $<

blake-bin/jemalloc/libjemalloc_impl.a: \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/arena.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/atomic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/base.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/bitmap.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/chunk.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/chunk_dss.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/chunk_mmap.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/ckh.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/ctl.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/extent.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/hash.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/huge.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/jemalloc.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/mb.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/mutex.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/nstime.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/pages.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/prng.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/prof.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/quarantine.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/rtree.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/spin.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/stats.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/tcache.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/tsd.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/util.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/witness.o
	$(AR) $(ARFLAGS) $@ $^

jemalloc_jemalloc_impl_SBLINK = blake-bin/jemalloc/libjemalloc_impl.a

blake-bin/jemalloc/libjemalloc_impl.pic.a: \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/arena.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/atomic.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/base.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/bitmap.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/chunk.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/chunk_dss.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/chunk_mmap.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/ckh.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/ctl.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/extent.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/hash.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/huge.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/jemalloc.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/mb.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/mutex.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/nstime.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/pages.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/prng.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/prof.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/quarantine.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/rtree.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/spin.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/stats.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/tcache.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/tsd.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/util.pic.o \
		blake-bin/jemalloc/_objs/jemalloc_impl/src/witness.pic.o
	$(AR) $(ARFLAGS) $@ $^

jemalloc_jemalloc_impl_SPLINK = blake-bin/jemalloc/libjemalloc_impl.pic.a

blake-bin/jemalloc/libjemalloc_impl.so: $(jemalloc_jemalloc_impl_SPLINK)
	$(CC) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(jemalloc_jemalloc_impl_SPLINK) $(NOWA) $(jemalloc_jemalloc_impl_LDLIBS)

################################################################################
# @nsync//:nsync_cpp

nsync_nsync_cpp_CFLAGS = \
	-x \
	c++ \
	-std=c++11 \
	-I./external/nsync//platform/c++11.futex \
	-DNSYNC_ATOMIC_CPP11 \
	-DNSYNC_USE_CPP11_TIMEPOINT \
	-I./external/nsync//platform/c++11 \
	-I./external/nsync//platform/gcc \
	-I./external/nsync//platform/x86_64 \
	-I./external/nsync//public \
	-I./external/nsync//internal \
	-I./external/nsync//platform/posix \
	-D_POSIX_C_SOURCE=200809L \
	-pthread

nsync_nsync_cpp_CPPFLAGS = -isystem nsync/public

nsync_nsync_cpp_HEADERS = \
	nsync/public/nsync.h \
	nsync/public/nsync_atomic.h \
	nsync/public/nsync_counter.h \
	nsync/public/nsync_cpp.h \
	nsync/public/nsync_cv.h \
	nsync/public/nsync_debug.h \
	nsync/public/nsync_mu.h \
	nsync/public/nsync_mu_wait.h \
	nsync/public/nsync_note.h \
	nsync/public/nsync_once.h \
	nsync/public/nsync_time.h \
	nsync/public/nsync_time_internal.h \
	nsync/public/nsync_waiter.h

nsync_nsync_cpp_LINK = blake-bin/nsync/libnsync_cpp.so

nsync_nsync_cpp_COMPILE_HEADERS = \
	nsync/internal/common.h \
	nsync/internal/dll.h \
	nsync/internal/headers.h \
	nsync/internal/sem.h \
	nsync/internal/wait_internal.h \
	nsync/platform/aarch64/cputype.h \
	nsync/platform/alpha/cputype.h \
	nsync/platform/arm/cputype.h \
	nsync/platform/atomic_ind/atomic.h \
	nsync/platform/c++11.futex/platform.h \
	nsync/platform/c++11/atomic.h \
	nsync/platform/c++11/platform.h \
	nsync/platform/c11/atomic.h \
	nsync/platform/clang/atomic.h \
	nsync/platform/clang/compiler.h \
	nsync/platform/cygwin/platform.h \
	nsync/platform/decc/compiler.h \
	nsync/platform/freebsd/platform.h \
	nsync/platform/gcc/atomic.h \
	nsync/platform/gcc/compiler.h \
	nsync/platform/gcc_new/atomic.h \
	nsync/platform/gcc_new_debug/atomic.h \
	nsync/platform/gcc_no_tls/compiler.h \
	nsync/platform/gcc_old/atomic.h \
	nsync/platform/lcc/compiler.h \
	nsync/platform/lcc/nsync_time_init.h \
	nsync/platform/linux/platform.h \
	nsync/platform/macos/atomic.h \
	nsync/platform/macos/platform.h \
	nsync/platform/macos/platform_c++11_os.h \
	nsync/platform/msvc/compiler.h \
	nsync/platform/netbsd/atomic.h \
	nsync/platform/netbsd/platform.h \
	nsync/platform/openbsd/platform.h \
	nsync/platform/osf1/platform.h \
	nsync/platform/pmax/cputype.h \
	nsync/platform/posix/cputype.h \
	nsync/platform/posix/nsync_time_init.h \
	nsync/platform/posix/platform_c++11_os.h \
	nsync/platform/ppc32/cputype.h \
	nsync/platform/ppc64/cputype.h \
	nsync/platform/s390x/cputype.h \
	nsync/platform/shark/cputype.h \
	nsync/platform/tcc/compiler.h \
	nsync/platform/win32/atomic.h \
	nsync/platform/win32/platform.h \
	nsync/platform/win32/platform_c++11_os.h \
	nsync/platform/x86_32/cputype.h \
	nsync/platform/x86_64/cputype.h \
	$(nsync_nsync_cpp_HEADERS)

blake-bin/nsync/_objs/nsync_cpp/%.pic.o: \
		nsync/%.c \
		$(nsync_nsync_cpp_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(nsync_nsync_cpp_CFLAGS) $(CFLAGS) $(CPPFLAGS.security) $(nsync_nsync_cpp_CPPFLAGS) $(CPPFLAGS) -iquote nsync $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/nsync/_objs/nsync_cpp/%.o: \
		nsync/%.c \
		$(nsync_nsync_cpp_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS.security) $(nsync_nsync_cpp_CFLAGS) $(CFLAGS) $(CPPFLAGS.security) $(nsync_nsync_cpp_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote nsync $(TARGET_ARCH) -c -o $@ $<

blake-bin/nsync/_objs/nsync_cpp/%.pic.o: \
		nsync/%.cc \
		$(nsync_nsync_cpp_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(nsync_nsync_cpp_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(nsync_nsync_cpp_CPPFLAGS) $(CPPFLAGS) -iquote nsync $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/nsync/_objs/nsync_cpp/%.o: \
		nsync/%.cc \
		$(nsync_nsync_cpp_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(nsync_nsync_cpp_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(nsync_nsync_cpp_CPPFLAGS) $(FPIE) $(CPPFLAGS) -iquote nsync $(TARGET_ARCH) -c -o $@ $<

blake-bin/nsync/libnsync_cpp.a: \
		blake-bin/nsync/_objs/nsync_cpp/internal/common.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/counter.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/cv.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/debug.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/dll.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/mu.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/mu_wait.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/note.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/once.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/sem_wait.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/time_internal.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/wait.o \
		blake-bin/nsync/_objs/nsync_cpp/platform/c++11/src/time_rep_timespec.o \
		blake-bin/nsync/_objs/nsync_cpp/platform/c++11/src/nsync_panic.o \
		blake-bin/nsync/_objs/nsync_cpp/platform/c++11/src/yield.o \
		blake-bin/nsync/_objs/nsync_cpp/platform/linux/src/nsync_semaphore_futex.o \
		blake-bin/nsync/_objs/nsync_cpp/platform/c++11/src/per_thread_waiter.o
	$(AR) $(ARFLAGS) $@ $^

nsync_nsync_cpp_SBLINK = blake-bin/nsync/libnsync_cpp.a

blake-bin/nsync/libnsync_cpp.pic.a: \
		blake-bin/nsync/_objs/nsync_cpp/internal/common.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/counter.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/cv.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/debug.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/dll.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/mu.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/mu_wait.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/note.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/once.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/sem_wait.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/time_internal.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/internal/wait.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/platform/c++11/src/time_rep_timespec.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/platform/c++11/src/nsync_panic.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/platform/c++11/src/yield.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/platform/linux/src/nsync_semaphore_futex.pic.o \
		blake-bin/nsync/_objs/nsync_cpp/platform/c++11/src/per_thread_waiter.pic.o
	$(AR) $(ARFLAGS) $@ $^

nsync_nsync_cpp_SPLINK = blake-bin/nsync/libnsync_cpp.pic.a

blake-bin/nsync/libnsync_cpp.so: $(nsync_nsync_cpp_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(nsync_nsync_cpp_SPLINK) $(NOWA) 

################################################################################
# @nsync//:nsync_headers

nsync_nsync_headers_CPPFLAGS = -isystem nsync/public

nsync_nsync_headers_HEADERS = \
	nsync/public/nsync.h \
	nsync/public/nsync_atomic.h \
	nsync/public/nsync_counter.h \
	nsync/public/nsync_cpp.h \
	nsync/public/nsync_cv.h \
	nsync/public/nsync_debug.h \
	nsync/public/nsync_mu.h \
	nsync/public/nsync_mu_wait.h \
	nsync/public/nsync_note.h \
	nsync/public/nsync_once.h \
	nsync/public/nsync_time.h \
	nsync/public/nsync_time_internal.h \
	nsync/public/nsync_waiter.h

################################################################################
# @snappy//:config_h

snappy/config.h: 
	@mkdir -p snappy
	snappy/config_h.sh

################################################################################
# @snappy//:snappy_stubs_public_h

snappy/snappy-stubs-public.h: snappy/snappy-stubs-public.h.in
	@mkdir -p snappy
	sed -e 's/${\(.*\)_01}/\1/g' -e 's/${SNAPPY_MAJOR}/1/g' -e 's/${SNAPPY_MINOR}/1/g' -e 's/${SNAPPY_PATCHLEVEL}/4/g' snappy/snappy-stubs-public.h.in >snappy/snappy-stubs-public.h

################################################################################
# @snappy//:snappy

snappy_snappy_CFLAGS = \
	-DHAVE_CONFIG_H \
	-fno-exceptions \
	-Wno-sign-compare \
	-Wno-shift-negative-value \
	-Wno-implicit-function-declaration

snappy_snappy_HEADERS = snappy/snappy.h
snappy_snappy_LINK = blake-bin/snappy/libsnappy.so

snappy_snappy_COMPILE_HEADERS = \
	snappy/config.h \
	snappy/snappy.h \
	snappy/snappy-internal.h \
	snappy/snappy-sinksource.h \
	snappy/snappy-stubs-internal.h \
	snappy/snappy-stubs-public.h \
	$(snappy_snappy_HEADERS)

blake-bin/snappy/_objs/snappy/%.pic.o: \
		snappy/%.cc \
		$(snappy_snappy_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(snappy_snappy_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote snappy $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/snappy/_objs/snappy/%.o: snappy/%.cc $(snappy_snappy_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(snappy_snappy_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote snappy $(TARGET_ARCH) -c -o $@ $<

blake-bin/snappy/libsnappy.a: \
		blake-bin/snappy/_objs/snappy/snappy.o \
		blake-bin/snappy/_objs/snappy/snappy-sinksource.o \
		blake-bin/snappy/_objs/snappy/snappy-stubs-internal.o
	$(AR) $(ARFLAGS) $@ $^

snappy_snappy_SBLINK = blake-bin/snappy/libsnappy.a

blake-bin/snappy/libsnappy.pic.a: \
		blake-bin/snappy/_objs/snappy/snappy.pic.o \
		blake-bin/snappy/_objs/snappy/snappy-sinksource.pic.o \
		blake-bin/snappy/_objs/snappy/snappy-stubs-internal.pic.o
	$(AR) $(ARFLAGS) $@ $^

snappy_snappy_SPLINK = blake-bin/snappy/libsnappy.pic.a

blake-bin/snappy/libsnappy.so: $(snappy_snappy_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(snappy_snappy_SPLINK) $(NOWA) 

################################################################################
# //tensorflow/core:lib_internal_impl

tensorflow_core_lib_internal_impl_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_lib_internal_impl_CPPFLAGS = \
	-DTENSORFLOW_USE_ABSL \
	-DTF_USE_SNAPPY

tensorflow_core_lib_internal_impl_HEADERS = \
	tensorflow/core/platform/default/context.h \
	tensorflow/core/platform/default/dynamic_annotations.h \
	tensorflow/core/platform/default/fingerprint.h \
	tensorflow/core/platform/default/integral_types.h \
	tensorflow/core/platform/default/logging.h \
	tensorflow/core/platform/default/mutex.h \
	tensorflow/core/platform/default/notification.h \
	tensorflow/core/platform/default/protobuf.h \
	tensorflow/core/platform/default/stacktrace.h \
	tensorflow/core/platform/default/string_coding.h \
	tensorflow/core/platform/default/strong_hash.h \
	tensorflow/core/platform/default/thread_annotations.h \
	tensorflow/core/platform/default/tracing_impl.h \
	tensorflow/core/platform/posix/error.h \
	tensorflow/core/platform/posix/posix_file_system.h \
	tensorflow/core/platform/posix/subprocess.h \
	tensorflow/core/lib/core/blocking_counter.h \
	tensorflow/core/lib/core/refcount.h \
	tensorflow/core/lib/gtl/edit_distance.h \
	tensorflow/core/lib/gtl/int_type.h \
	tensorflow/core/lib/gtl/iterator_range.h \
	tensorflow/core/lib/gtl/manual_constructor.h \
	tensorflow/core/lib/gtl/map_util.h \
	tensorflow/core/lib/gtl/stl_util.h \
	tensorflow/core/lib/gtl/top_n.h \
	tensorflow/core/lib/hash/hash.h \
	tensorflow/core/lib/io/inputbuffer.h \
	tensorflow/core/lib/io/iterator.h \
	tensorflow/core/lib/io/snappy/snappy_inputbuffer.h \
	tensorflow/core/lib/io/snappy/snappy_outputbuffer.h \
	tensorflow/core/lib/io/zlib_compression_options.h \
	tensorflow/core/lib/io/zlib_inputstream.h \
	tensorflow/core/lib/io/zlib_outputbuffer.h \
	tensorflow/core/lib/monitoring/collected_metrics.h \
	tensorflow/core/lib/monitoring/collection_registry.h \
	tensorflow/core/lib/monitoring/metric_def.h \
	tensorflow/core/lib/monitoring/mobile_counter.h \
	tensorflow/core/lib/monitoring/mobile_gauge.h \
	tensorflow/core/lib/monitoring/mobile_sampler.h \
	tensorflow/core/lib/png/png_io.h \
	tensorflow/core/lib/random/random.h \
	tensorflow/core/lib/random/random_distributions.h \
	tensorflow/core/lib/random/weighted_picker.h \
	tensorflow/core/lib/strings/base64.h \
	tensorflow/core/lib/strings/ordered_code.h \
	tensorflow/core/lib/strings/proto_text_util.h \
	tensorflow/core/lib/strings/proto_serialization.h \
	tensorflow/core/lib/strings/scanner.h \
	tensorflow/core/lib/wav/wav_io.h \
	tensorflow/core/platform/demangle.h \
	tensorflow/core/platform/denormal.h \
	tensorflow/core/platform/host_info.h \
	tensorflow/core/platform/platform.h \
	tensorflow/core/platform/protobuf_internal.h \
	tensorflow/core/platform/setround.h \
	tensorflow/core/platform/snappy.h \
	tensorflow/core/platform/tensor_coding.h \
	tensorflow/core/platform/tracing.h

tensorflow_core_lib_internal_impl_LINK = \
	blake-bin/tensorflow/core/liblib_internal_impl.so

tensorflow_core_lib_internal_impl_COMPILE_IQUOTES = \
	-iquote . \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote protobuf_archive \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote double_conversion \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote snappy

tensorflow_core_lib_internal_impl_COMPILE_CPPFLAGS = \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS)

tensorflow_core_lib_internal_impl_COMPILE_HEADERS = \
	tensorflow/core/framework/resource_handle.h \
	tensorflow/core/lib/bfloat16/bfloat16.h \
	tensorflow/core/lib/core/arena.h \
	tensorflow/core/lib/core/bitmap.h \
	tensorflow/core/lib/core/bits.h \
	tensorflow/core/lib/core/blocking_counter.h \
	tensorflow/core/lib/core/casts.h \
	tensorflow/core/lib/core/coding.h \
	tensorflow/core/lib/core/errors.h \
	tensorflow/core/lib/core/notification.h \
	tensorflow/core/lib/core/raw_coding.h \
	tensorflow/core/lib/core/refcount.h \
	tensorflow/core/lib/core/status.h \
	tensorflow/core/lib/core/stringpiece.h \
	tensorflow/core/lib/core/threadpool.h \
	tensorflow/core/lib/gtl/array_slice.h \
	tensorflow/core/lib/gtl/array_slice_internal.h \
	tensorflow/core/lib/gtl/cleanup.h \
	tensorflow/core/lib/gtl/compactptrset.h \
	tensorflow/core/lib/gtl/edit_distance.h \
	tensorflow/core/lib/gtl/flatmap.h \
	tensorflow/core/lib/gtl/flatrep.h \
	tensorflow/core/lib/gtl/flatset.h \
	tensorflow/core/lib/gtl/inlined_vector.h \
	tensorflow/core/lib/gtl/int_type.h \
	tensorflow/core/lib/gtl/iterator_range.h \
	tensorflow/core/lib/gtl/manual_constructor.h \
	tensorflow/core/lib/gtl/map_util.h \
	tensorflow/core/lib/gtl/optional.h \
	tensorflow/core/lib/gtl/priority_queue_util.h \
	tensorflow/core/lib/gtl/stl_util.h \
	tensorflow/core/lib/gtl/top_n.h \
	tensorflow/core/lib/hash/crc32c.h \
	tensorflow/core/lib/hash/hash.h \
	tensorflow/core/lib/histogram/histogram.h \
	tensorflow/core/lib/io/block.h \
	tensorflow/core/lib/io/block_builder.h \
	tensorflow/core/lib/io/buffered_inputstream.h \
	tensorflow/core/lib/io/compression.h \
	tensorflow/core/lib/io/format.h \
	tensorflow/core/lib/io/inputbuffer.h \
	tensorflow/core/lib/io/inputstream_interface.h \
	tensorflow/core/lib/io/iterator.h \
	tensorflow/core/lib/io/path.h \
	tensorflow/core/lib/io/proto_encode_helper.h \
	tensorflow/core/lib/io/random_inputstream.h \
	tensorflow/core/lib/io/record_reader.h \
	tensorflow/core/lib/io/record_writer.h \
	tensorflow/core/lib/io/snappy/snappy_inputbuffer.h \
	tensorflow/core/lib/io/snappy/snappy_outputbuffer.h \
	tensorflow/core/lib/io/table.h \
	tensorflow/core/lib/io/table_builder.h \
	tensorflow/core/lib/io/table_options.h \
	tensorflow/core/lib/io/two_level_iterator.h \
	tensorflow/core/lib/io/zlib_compression_options.h \
	tensorflow/core/lib/io/zlib_inputstream.h \
	tensorflow/core/lib/io/zlib_outputbuffer.h \
	tensorflow/core/lib/math/math_util.h \
	tensorflow/core/lib/monitoring/collected_metrics.h \
	tensorflow/core/lib/monitoring/collection_registry.h \
	tensorflow/core/lib/monitoring/counter.h \
	tensorflow/core/lib/monitoring/gauge.h \
	tensorflow/core/lib/monitoring/metric_def.h \
	tensorflow/core/lib/monitoring/mobile_counter.h \
	tensorflow/core/lib/monitoring/mobile_gauge.h \
	tensorflow/core/lib/monitoring/mobile_sampler.h \
	tensorflow/core/lib/monitoring/sampler.h \
	tensorflow/core/lib/random/distribution_sampler.h \
	tensorflow/core/lib/random/exact_uniform_int.h \
	tensorflow/core/lib/random/philox_random.h \
	tensorflow/core/lib/random/random.h \
	tensorflow/core/lib/random/random_distributions.h \
	tensorflow/core/lib/random/simple_philox.h \
	tensorflow/core/lib/random/weighted_picker.h \
	tensorflow/core/lib/strings/base64.h \
	tensorflow/core/lib/strings/numbers.h \
	tensorflow/core/lib/strings/ordered_code.h \
	tensorflow/core/lib/strings/proto_serialization.h \
	tensorflow/core/lib/strings/proto_text_util.h \
	tensorflow/core/lib/strings/scanner.h \
	tensorflow/core/lib/strings/str_util.h \
	tensorflow/core/lib/strings/strcat.h \
	tensorflow/core/lib/strings/stringprintf.h \
	tensorflow/core/lib/wav/wav_io.h \
	tensorflow/core/platform/abi.h \
	tensorflow/core/platform/byte_order.h \
	tensorflow/core/platform/context.h \
	tensorflow/core/platform/cpu_feature_guard.h \
	tensorflow/core/platform/cpu_info.h \
	tensorflow/core/platform/cuda_libdevice_path.h \
	tensorflow/core/platform/cupti_wrapper.h \
	tensorflow/core/platform/demangle.h \
	tensorflow/core/platform/denormal.h \
	tensorflow/core/platform/device_tracer.h \
	tensorflow/core/platform/dynamic_annotations.h \
	tensorflow/core/platform/env.h \
	tensorflow/core/platform/env_time.h \
	tensorflow/core/platform/error.h \
	tensorflow/core/platform/file_statistics.h \
	tensorflow/core/platform/file_system.h \
	tensorflow/core/platform/file_system_helper.h \
	tensorflow/core/platform/fingerprint.h \
	tensorflow/core/platform/host_info.h \
	tensorflow/core/platform/human_readable_json.h \
	tensorflow/core/platform/init_main.h \
	tensorflow/core/platform/load_library.h \
	tensorflow/core/platform/logging.h \
	tensorflow/core/platform/macros.h \
	tensorflow/core/platform/mem.h \
	tensorflow/core/platform/mutex.h \
	tensorflow/core/platform/net.h \
	tensorflow/core/platform/notification.h \
	tensorflow/core/platform/null_file_system.h \
	tensorflow/core/platform/numa.h \
	tensorflow/core/platform/platform.h \
	tensorflow/core/platform/prefetch.h \
	tensorflow/core/platform/profile_utils/android_armv7a_cpu_utils_helper.h \
	tensorflow/core/platform/profile_utils/clock_cycle_profiler.h \
	tensorflow/core/platform/profile_utils/cpu_utils.h \
	tensorflow/core/platform/profile_utils/i_cpu_utils_helper.h \
	tensorflow/core/platform/protobuf.h \
	tensorflow/core/platform/protobuf_internal.h \
	tensorflow/core/platform/regexp.h \
	tensorflow/core/platform/setround.h \
	tensorflow/core/platform/snappy.h \
	tensorflow/core/platform/stacktrace.h \
	tensorflow/core/platform/stacktrace_handler.h \
	tensorflow/core/platform/stream_executor_no_cuda.h \
	tensorflow/core/platform/strong_hash.h \
	tensorflow/core/platform/subprocess.h \
	tensorflow/core/platform/tensor_coding.h \
	tensorflow/core/platform/thread_annotations.h \
	tensorflow/core/platform/tracing.h \
	tensorflow/core/platform/types.h \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS)

blake-bin/tensorflow/core/_objs/lib_internal_impl/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_lib_internal_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_lib_internal_impl_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_lib_internal_impl_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_lib_internal_impl_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/lib_internal_impl/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_lib_internal_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_lib_internal_impl_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_lib_internal_impl_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_lib_internal_impl_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/liblib_internal_impl.a: \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/framework/resource_handle.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/bfloat16/bfloat16.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/core/arena.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/core/bitmap.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/core/coding.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/core/status.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/core/threadpool.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/gtl/optional.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/hash/crc32c.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/hash/hash.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/histogram/histogram.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/block.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/block_builder.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/buffered_inputstream.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/compression.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/format.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/inputbuffer.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/inputstream_interface.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/iterator.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/path.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/random_inputstream.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/record_reader.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/record_writer.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/snappy/snappy_inputbuffer.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/snappy/snappy_outputbuffer.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/table.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/table_builder.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/two_level_iterator.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/zlib_inputstream.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/zlib_outputbuffer.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/monitoring/collection_registry.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/monitoring/sampler.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/random/distribution_sampler.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/random/random.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/random/random_distributions.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/random/simple_philox.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/random/weighted_picker.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/base64.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/numbers.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/ordered_code.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/proto_serialization.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/proto_text_util.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/scanner.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/str_util.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/strcat.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/stringprintf.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/wav/wav_io.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/cpu_feature_guard.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/cpu_info.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/denormal.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/env.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/file_system.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/file_system_helper.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/profile_utils/android_armv7a_cpu_utils_helper.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/profile_utils/clock_cycle_profiler.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/profile_utils/cpu_utils.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/protobuf_util.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/setround.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/stacktrace_handler.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/tensor_coding.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/tracing.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/default/mutex.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/default/string_coding.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/default/tracing.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/env.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/error.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/load_library.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/net.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/port.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/posix_file_system.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/subprocess.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_lib_internal_impl_SBLINK = \
	blake-bin/tensorflow/core/liblib_internal_impl.a

blake-bin/tensorflow/core/liblib_internal_impl.pic.a: \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/framework/resource_handle.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/bfloat16/bfloat16.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/core/arena.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/core/bitmap.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/core/coding.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/core/status.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/core/threadpool.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/gtl/optional.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/hash/crc32c.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/hash/hash.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/histogram/histogram.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/block.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/block_builder.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/buffered_inputstream.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/compression.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/format.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/inputbuffer.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/inputstream_interface.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/iterator.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/path.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/random_inputstream.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/record_reader.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/record_writer.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/snappy/snappy_inputbuffer.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/snappy/snappy_outputbuffer.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/table.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/table_builder.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/two_level_iterator.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/zlib_inputstream.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/io/zlib_outputbuffer.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/monitoring/collection_registry.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/monitoring/sampler.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/random/distribution_sampler.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/random/random.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/random/random_distributions.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/random/simple_philox.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/random/weighted_picker.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/base64.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/numbers.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/ordered_code.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/proto_serialization.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/proto_text_util.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/scanner.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/str_util.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/strcat.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/strings/stringprintf.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/lib/wav/wav_io.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/cpu_feature_guard.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/cpu_info.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/denormal.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/env.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/file_system.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/file_system_helper.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/profile_utils/android_armv7a_cpu_utils_helper.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/profile_utils/clock_cycle_profiler.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/profile_utils/cpu_utils.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/protobuf_util.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/setround.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/stacktrace_handler.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/tensor_coding.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/tracing.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/default/mutex.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/default/string_coding.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/default/tracing.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/env.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/error.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/load_library.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/net.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/port.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/posix_file_system.pic.o \
		blake-bin/tensorflow/core/_objs/lib_internal_impl/platform/posix/subprocess.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_lib_internal_impl_SPLINK = \
	blake-bin/tensorflow/core/liblib_internal_impl.pic.a

blake-bin/tensorflow/core/liblib_internal_impl.so: \
		$(tensorflow_core_lib_internal_impl_SPLINK) \
		$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_LINK) \
		$(protobuf_archive_protobuf_LINK) \
		$(double_conversion_double-conversion_LINK) \
		$(snappy_snappy_LINK) \
		$(zlib_archive_zlib_LINK) \
		$(highwayhash_sip_hash_LINK) \
		$(fft2d_fft2d_LINK) \
		$(farmhash_archive_farmhash_LINK) \
		$(com_googlesource_code_re2_re2_LINK) \
		$(jpeg_jpeg_LINK) \
		$(gif_archive_gif_LINK) \
		$(tensorflow_core_core_stringpiece_LINK) \
		$(tensorflow_core_abi_LINK) \
		$(tensorflow_core_lib_proto_parsing_LINK) \
		$(tensorflow_core_lib_hash_crc32c_accelerate_internal_LINK) \
		$(nsync_nsync_cpp_LINK) \
		$(com_google_absl_absl_base_base_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_lib_internal_impl_SPLINK) $(NOWA) $(tensorflow_core_grappler_costs_op_performance_data_cc_impl_LINK) $(protobuf_archive_protobuf_LINK) $(double_conversion_double-conversion_LINK) $(snappy_snappy_LINK) $(zlib_archive_zlib_LINK) $(highwayhash_sip_hash_LINK) $(fft2d_fft2d_LINK) $(farmhash_archive_farmhash_LINK) $(com_googlesource_code_re2_re2_LINK) $(jpeg_jpeg_LINK) $(gif_archive_gif_LINK) $(tensorflow_core_core_stringpiece_LINK) $(tensorflow_core_abi_LINK) $(tensorflow_core_lib_proto_parsing_LINK) $(tensorflow_core_lib_hash_crc32c_accelerate_internal_LINK) $(nsync_nsync_cpp_LINK) $(com_google_absl_absl_base_base_LINK) 

################################################################################
# //tensorflow/core:lib_internal

tensorflow_core_lib_internal_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_lib_internal_CPPFLAGS = -DTENSORFLOW_USE_ABSL -DTF_USE_SNAPPY
tensorflow_core_lib_internal_LDLIBS = -ldl -lpthread

tensorflow_core_lib_internal_HEADERS = \
	tensorflow/core/platform/default/context.h \
	tensorflow/core/platform/default/dynamic_annotations.h \
	tensorflow/core/platform/default/fingerprint.h \
	tensorflow/core/platform/default/integral_types.h \
	tensorflow/core/platform/default/logging.h \
	tensorflow/core/platform/default/mutex.h \
	tensorflow/core/platform/default/notification.h \
	tensorflow/core/platform/default/protobuf.h \
	tensorflow/core/platform/default/stacktrace.h \
	tensorflow/core/platform/default/string_coding.h \
	tensorflow/core/platform/default/strong_hash.h \
	tensorflow/core/platform/default/thread_annotations.h \
	tensorflow/core/platform/default/tracing_impl.h \
	tensorflow/core/platform/posix/error.h \
	tensorflow/core/platform/posix/posix_file_system.h \
	tensorflow/core/platform/posix/subprocess.h \
	tensorflow/core/lib/core/blocking_counter.h \
	tensorflow/core/lib/core/refcount.h \
	tensorflow/core/lib/gtl/edit_distance.h \
	tensorflow/core/lib/gtl/int_type.h \
	tensorflow/core/lib/gtl/iterator_range.h \
	tensorflow/core/lib/gtl/manual_constructor.h \
	tensorflow/core/lib/gtl/map_util.h \
	tensorflow/core/lib/gtl/stl_util.h \
	tensorflow/core/lib/gtl/top_n.h \
	tensorflow/core/lib/hash/hash.h \
	tensorflow/core/lib/io/inputbuffer.h \
	tensorflow/core/lib/io/iterator.h \
	tensorflow/core/lib/io/snappy/snappy_inputbuffer.h \
	tensorflow/core/lib/io/snappy/snappy_outputbuffer.h \
	tensorflow/core/lib/io/zlib_compression_options.h \
	tensorflow/core/lib/io/zlib_inputstream.h \
	tensorflow/core/lib/io/zlib_outputbuffer.h \
	tensorflow/core/lib/monitoring/collected_metrics.h \
	tensorflow/core/lib/monitoring/collection_registry.h \
	tensorflow/core/lib/monitoring/metric_def.h \
	tensorflow/core/lib/monitoring/mobile_counter.h \
	tensorflow/core/lib/monitoring/mobile_gauge.h \
	tensorflow/core/lib/monitoring/mobile_sampler.h \
	tensorflow/core/lib/png/png_io.h \
	tensorflow/core/lib/random/random.h \
	tensorflow/core/lib/random/random_distributions.h \
	tensorflow/core/lib/random/weighted_picker.h \
	tensorflow/core/lib/strings/base64.h \
	tensorflow/core/lib/strings/ordered_code.h \
	tensorflow/core/lib/strings/proto_text_util.h \
	tensorflow/core/lib/strings/proto_serialization.h \
	tensorflow/core/lib/strings/scanner.h \
	tensorflow/core/lib/wav/wav_io.h \
	tensorflow/core/platform/demangle.h \
	tensorflow/core/platform/denormal.h \
	tensorflow/core/platform/host_info.h \
	tensorflow/core/platform/platform.h \
	tensorflow/core/platform/protobuf_internal.h \
	tensorflow/core/platform/setround.h \
	tensorflow/core/platform/snappy.h \
	tensorflow/core/platform/tensor_coding.h \
	tensorflow/core/platform/tracing.h

################################################################################
# //tensorflow/core:lib

tensorflow_core_lib_HEADERS = \
	tensorflow/core/lib/bfloat16/bfloat16.h \
	tensorflow/core/lib/core/arena.h \
	tensorflow/core/lib/core/bitmap.h \
	tensorflow/core/lib/core/bits.h \
	tensorflow/core/lib/core/casts.h \
	tensorflow/core/lib/core/coding.h \
	tensorflow/core/lib/core/errors.h \
	tensorflow/core/lib/core/notification.h \
	tensorflow/core/lib/core/raw_coding.h \
	tensorflow/core/lib/core/status.h \
	tensorflow/core/lib/core/stringpiece.h \
	tensorflow/core/lib/core/threadpool.h \
	tensorflow/core/lib/gtl/array_slice.h \
	tensorflow/core/lib/gtl/cleanup.h \
	tensorflow/core/lib/gtl/compactptrset.h \
	tensorflow/core/lib/gtl/flatmap.h \
	tensorflow/core/lib/gtl/flatset.h \
	tensorflow/core/lib/gtl/inlined_vector.h \
	tensorflow/core/lib/gtl/optional.h \
	tensorflow/core/lib/gtl/priority_queue_util.h \
	tensorflow/core/lib/hash/crc32c.h \
	tensorflow/core/lib/hash/hash.h \
	tensorflow/core/lib/histogram/histogram.h \
	tensorflow/core/lib/io/buffered_inputstream.h \
	tensorflow/core/lib/io/compression.h \
	tensorflow/core/lib/io/inputstream_interface.h \
	tensorflow/core/lib/io/path.h \
	tensorflow/core/lib/io/proto_encode_helper.h \
	tensorflow/core/lib/io/random_inputstream.h \
	tensorflow/core/lib/io/record_reader.h \
	tensorflow/core/lib/io/record_writer.h \
	tensorflow/core/lib/io/table.h \
	tensorflow/core/lib/io/table_builder.h \
	tensorflow/core/lib/io/table_options.h \
	tensorflow/core/lib/math/math_util.h \
	tensorflow/core/lib/monitoring/counter.h \
	tensorflow/core/lib/monitoring/gauge.h \
	tensorflow/core/lib/monitoring/sampler.h \
	tensorflow/core/lib/random/distribution_sampler.h \
	tensorflow/core/lib/random/philox_random.h \
	tensorflow/core/lib/random/random_distributions.h \
	tensorflow/core/lib/random/simple_philox.h \
	tensorflow/core/lib/strings/numbers.h \
	tensorflow/core/lib/strings/proto_serialization.h \
	tensorflow/core/lib/strings/str_util.h \
	tensorflow/core/lib/strings/strcat.h \
	tensorflow/core/lib/strings/stringprintf.h \
	tensorflow/core/platform/byte_order.h \
	tensorflow/core/platform/env_time.h \
	tensorflow/core/platform/logging.h \
	tensorflow/core/platform/macros.h \
	tensorflow/core/platform/types.h \
	tensorflow/core/platform/env.h \
	tensorflow/core/platform/file_statistics.h \
	tensorflow/core/platform/file_system.h \
	tensorflow/core/platform/file_system_helper.h \
	tensorflow/core/platform/null_file_system.h \
	tensorflow/core/platform/abi.h \
	tensorflow/core/platform/context.h \
	tensorflow/core/platform/cpu_feature_guard.h \
	tensorflow/core/platform/error.h \
	tensorflow/core/platform/fingerprint.h \
	tensorflow/core/platform/net.h \
	tensorflow/core/platform/notification.h \
	tensorflow/core/platform/prefetch.h \
	tensorflow/core/platform/profile_utils/android_armv7a_cpu_utils_helper.h \
	tensorflow/core/platform/profile_utils/clock_cycle_profiler.h \
	tensorflow/core/platform/profile_utils/cpu_utils.h \
	tensorflow/core/platform/profile_utils/i_cpu_utils_helper.h \
	tensorflow/core/platform/stacktrace.h \
	tensorflow/core/platform/stacktrace_handler.h \
	tensorflow/core/platform/strong_hash.h \
	tensorflow/core/platform/subprocess.h \
	tensorflow/core/platform/cpu_info.h \
	tensorflow/core/platform/dynamic_annotations.h \
	tensorflow/core/platform/init_main.h \
	tensorflow/core/platform/mem.h \
	tensorflow/core/platform/mutex.h \
	tensorflow/core/platform/numa.h \
	tensorflow/core/platform/thread_annotations.h \
	tensorflow/core/platform/protobuf.h

################################################################################
# //tensorflow/core:version_info_gen

tensorflow/core/util/version_info.cc: \
		local_config_git/gen/spec.json \
		local_config_git/gen/head \
		local_config_git/gen/branch_ref \
		tensorflow/tools/git/gen_git_source.py
	@mkdir -p tensorflow/core/util
	tensorflow/tools/git/gen_git_source.py --generate local_config_git/gen/spec.json local_config_git/gen/head local_config_git/gen/branch_ref "tensorflow/core/util/version_info.cc" --git_tag_override=${GIT_TAG_OVERRIDE:-}

################################################################################
# //tensorflow/core:version_lib

tensorflow_core_version_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_version_lib_HEADERS = tensorflow/core/public/version.h
tensorflow_core_version_lib_LINK = blake-bin/tensorflow/core/libversion_lib.so

blake-bin/tensorflow/core/_objs/version_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_version_lib_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_version_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote . $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/version_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_version_lib_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_version_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote . $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libversion_lib.a: \
		blake-bin/tensorflow/core/_objs/version_lib/util/version_info.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_version_lib_SBLINK = blake-bin/tensorflow/core/libversion_lib.a

blake-bin/tensorflow/core/libversion_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/version_lib/util/version_info.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_version_lib_SPLINK = \
	blake-bin/tensorflow/core/libversion_lib.pic.a

blake-bin/tensorflow/core/libversion_lib.so: \
		$(tensorflow_core_version_lib_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_version_lib_SPLINK) $(NOWA) 

################################################################################
# //tensorflow/core/platform/default/build_config:minimal

tensorflow_core_platform_default_build_config_minimal_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

################################################################################
# //tensorflow/core:framework_lite

tensorflow_core_framework_lite_HEADERS = \
	tensorflow/core/framework/numeric_types.h \
	tensorflow/core/framework/tensor_types.h \
	tensorflow/core/framework/type_traits.h \
	tensorflow/core/lib/bfloat16/bfloat16.h \
	tensorflow/core/platform/byte_order.h \
	tensorflow/core/platform/default/dynamic_annotations.h \
	tensorflow/core/platform/default/integral_types.h \
	tensorflow/core/platform/default/logging.h \
	tensorflow/core/platform/default/mutex.h \
	tensorflow/core/platform/default/protobuf.h \
	tensorflow/core/platform/default/thread_annotations.h \
	tensorflow/core/platform/dynamic_annotations.h \
	tensorflow/core/platform/macros.h \
	tensorflow/core/platform/mutex.h \
	tensorflow/core/platform/platform.h \
	tensorflow/core/platform/prefetch.h \
	tensorflow/core/platform/thread_annotations.h \
	tensorflow/core/platform/types.h \
	tensorflow/core/platform/cpu_info.h

################################################################################
# //tensorflow/core/kernels:bounds_check

tensorflow_core_kernels_bounds_check_HEADERS = \
	tensorflow/core/kernels/bounds_check.h

################################################################################
# //tensorflow/core:framework_internal_headers_lib

tensorflow_core_framework_internal_headers_lib_HEADERS = \
	tensorflow/core/lib/bfloat16/bfloat16.h \
	tensorflow/core/lib/core/arena.h \
	tensorflow/core/lib/core/bitmap.h \
	tensorflow/core/lib/core/bits.h \
	tensorflow/core/lib/core/casts.h \
	tensorflow/core/lib/core/coding.h \
	tensorflow/core/lib/core/errors.h \
	tensorflow/core/lib/core/notification.h \
	tensorflow/core/lib/core/raw_coding.h \
	tensorflow/core/lib/core/status.h \
	tensorflow/core/lib/core/stringpiece.h \
	tensorflow/core/lib/core/threadpool.h \
	tensorflow/core/lib/gtl/array_slice.h \
	tensorflow/core/lib/gtl/cleanup.h \
	tensorflow/core/lib/gtl/compactptrset.h \
	tensorflow/core/lib/gtl/flatmap.h \
	tensorflow/core/lib/gtl/flatset.h \
	tensorflow/core/lib/gtl/inlined_vector.h \
	tensorflow/core/lib/gtl/optional.h \
	tensorflow/core/lib/gtl/priority_queue_util.h \
	tensorflow/core/lib/hash/crc32c.h \
	tensorflow/core/lib/hash/hash.h \
	tensorflow/core/lib/histogram/histogram.h \
	tensorflow/core/lib/io/buffered_inputstream.h \
	tensorflow/core/lib/io/compression.h \
	tensorflow/core/lib/io/inputstream_interface.h \
	tensorflow/core/lib/io/path.h \
	tensorflow/core/lib/io/proto_encode_helper.h \
	tensorflow/core/lib/io/random_inputstream.h \
	tensorflow/core/lib/io/record_reader.h \
	tensorflow/core/lib/io/record_writer.h \
	tensorflow/core/lib/io/table.h \
	tensorflow/core/lib/io/table_builder.h \
	tensorflow/core/lib/io/table_options.h \
	tensorflow/core/lib/math/math_util.h \
	tensorflow/core/lib/monitoring/counter.h \
	tensorflow/core/lib/monitoring/gauge.h \
	tensorflow/core/lib/monitoring/sampler.h \
	tensorflow/core/lib/random/distribution_sampler.h \
	tensorflow/core/lib/random/philox_random.h \
	tensorflow/core/lib/random/random_distributions.h \
	tensorflow/core/lib/random/simple_philox.h \
	tensorflow/core/lib/strings/numbers.h \
	tensorflow/core/lib/strings/proto_serialization.h \
	tensorflow/core/lib/strings/str_util.h \
	tensorflow/core/lib/strings/strcat.h \
	tensorflow/core/lib/strings/stringprintf.h \
	tensorflow/core/platform/byte_order.h \
	tensorflow/core/platform/env_time.h \
	tensorflow/core/platform/logging.h \
	tensorflow/core/platform/macros.h \
	tensorflow/core/platform/types.h \
	tensorflow/core/platform/env.h \
	tensorflow/core/platform/file_statistics.h \
	tensorflow/core/platform/file_system.h \
	tensorflow/core/platform/file_system_helper.h \
	tensorflow/core/platform/null_file_system.h \
	tensorflow/core/platform/abi.h \
	tensorflow/core/platform/context.h \
	tensorflow/core/platform/cpu_feature_guard.h \
	tensorflow/core/platform/error.h \
	tensorflow/core/platform/fingerprint.h \
	tensorflow/core/platform/net.h \
	tensorflow/core/platform/notification.h \
	tensorflow/core/platform/prefetch.h \
	tensorflow/core/platform/profile_utils/android_armv7a_cpu_utils_helper.h \
	tensorflow/core/platform/profile_utils/clock_cycle_profiler.h \
	tensorflow/core/platform/profile_utils/cpu_utils.h \
	tensorflow/core/platform/profile_utils/i_cpu_utils_helper.h \
	tensorflow/core/platform/stacktrace.h \
	tensorflow/core/platform/stacktrace_handler.h \
	tensorflow/core/platform/strong_hash.h \
	tensorflow/core/platform/subprocess.h \
	tensorflow/core/platform/cpu_info.h \
	tensorflow/core/platform/dynamic_annotations.h \
	tensorflow/core/platform/init_main.h \
	tensorflow/core/platform/mem.h \
	tensorflow/core/platform/mutex.h \
	tensorflow/core/platform/numa.h \
	tensorflow/core/platform/thread_annotations.h \
	tensorflow/core/platform/protobuf.h \
	tensorflow/core/platform/default/context.h \
	tensorflow/core/platform/default/dynamic_annotations.h \
	tensorflow/core/platform/default/fingerprint.h \
	tensorflow/core/platform/default/integral_types.h \
	tensorflow/core/platform/default/logging.h \
	tensorflow/core/platform/default/mutex.h \
	tensorflow/core/platform/default/notification.h \
	tensorflow/core/platform/default/protobuf.h \
	tensorflow/core/platform/default/stacktrace.h \
	tensorflow/core/platform/default/string_coding.h \
	tensorflow/core/platform/default/strong_hash.h \
	tensorflow/core/platform/default/thread_annotations.h \
	tensorflow/core/platform/default/tracing_impl.h \
	tensorflow/core/platform/posix/error.h \
	tensorflow/core/platform/posix/posix_file_system.h \
	tensorflow/core/platform/posix/subprocess.h \
	tensorflow/core/lib/core/blocking_counter.h \
	tensorflow/core/lib/core/refcount.h \
	tensorflow/core/lib/gtl/edit_distance.h \
	tensorflow/core/lib/gtl/int_type.h \
	tensorflow/core/lib/gtl/iterator_range.h \
	tensorflow/core/lib/gtl/manual_constructor.h \
	tensorflow/core/lib/gtl/map_util.h \
	tensorflow/core/lib/gtl/stl_util.h \
	tensorflow/core/lib/gtl/top_n.h \
	tensorflow/core/lib/io/inputbuffer.h \
	tensorflow/core/lib/io/iterator.h \
	tensorflow/core/lib/io/snappy/snappy_inputbuffer.h \
	tensorflow/core/lib/io/snappy/snappy_outputbuffer.h \
	tensorflow/core/lib/io/zlib_compression_options.h \
	tensorflow/core/lib/io/zlib_inputstream.h \
	tensorflow/core/lib/io/zlib_outputbuffer.h \
	tensorflow/core/lib/monitoring/collected_metrics.h \
	tensorflow/core/lib/monitoring/collection_registry.h \
	tensorflow/core/lib/monitoring/metric_def.h \
	tensorflow/core/lib/monitoring/mobile_counter.h \
	tensorflow/core/lib/monitoring/mobile_gauge.h \
	tensorflow/core/lib/monitoring/mobile_sampler.h \
	tensorflow/core/lib/png/png_io.h \
	tensorflow/core/lib/random/random.h \
	tensorflow/core/lib/random/weighted_picker.h \
	tensorflow/core/lib/strings/base64.h \
	tensorflow/core/lib/strings/ordered_code.h \
	tensorflow/core/lib/strings/proto_text_util.h \
	tensorflow/core/lib/strings/scanner.h \
	tensorflow/core/lib/wav/wav_io.h \
	tensorflow/core/platform/demangle.h \
	tensorflow/core/platform/denormal.h \
	tensorflow/core/platform/host_info.h \
	tensorflow/core/platform/platform.h \
	tensorflow/core/platform/protobuf_internal.h \
	tensorflow/core/platform/setround.h \
	tensorflow/core/platform/snappy.h \
	tensorflow/core/platform/tensor_coding.h \
	tensorflow/core/platform/tracing.h \
	com_google_absl/absl/base/call_once.h \
	com_google_absl/absl/base/casts.h \
	com_google_absl/absl/base/internal/atomic_hook.h \
	com_google_absl/absl/base/internal/cycleclock.h \
	com_google_absl/absl/base/internal/low_level_scheduling.h \
	com_google_absl/absl/base/internal/per_thread_tls.h \
	com_google_absl/absl/base/internal/raw_logging.h \
	com_google_absl/absl/base/internal/spinlock.h \
	com_google_absl/absl/base/internal/sysinfo.h \
	com_google_absl/absl/base/internal/thread_identity.h \
	com_google_absl/absl/base/internal/tsan_mutex_interface.h \
	com_google_absl/absl/base/internal/unscaledcycleclock.h \
	com_google_absl/absl/base/log_severity.h \
	com_google_absl/absl/base/internal/identity.h \
	com_google_absl/absl/base/internal/inline_variable.h \
	com_google_absl/absl/base/internal/invoke.h \
	com_google_absl/absl/base/config.h \
	com_google_absl/absl/base/policy_checks.h \
	com_google_absl/absl/base/attributes.h \
	com_google_absl/absl/base/macros.h \
	com_google_absl/absl/base/optimization.h \
	com_google_absl/absl/base/port.h \
	com_google_absl/absl/base/thread_annotations.h \
	com_google_absl/absl/base/dynamic_annotations.h \
	com_google_absl/absl/base/internal/scheduling_mode.h \
	com_google_absl/absl/base/internal/spinlock_wait.h \
	nsync/public/nsync.h \
	nsync/public/nsync_atomic.h \
	nsync/public/nsync_counter.h \
	nsync/public/nsync_cpp.h \
	nsync/public/nsync_cv.h \
	nsync/public/nsync_debug.h \
	nsync/public/nsync_mu.h \
	nsync/public/nsync_mu_wait.h \
	nsync/public/nsync_note.h \
	nsync/public/nsync_once.h \
	nsync/public/nsync_time.h \
	nsync/public/nsync_time_internal.h \
	nsync/public/nsync_waiter.h \
	third_party/eigen3/Eigen/Cholesky \
	third_party/eigen3/Eigen/Core \
	third_party/eigen3/Eigen/Eigenvalues \
	third_party/eigen3/Eigen/LU \
	third_party/eigen3/Eigen/QR \
	third_party/eigen3/Eigen/SVD \
	third_party/eigen3/unsupported/Eigen/CXX11/FixedPoint \
	third_party/eigen3/unsupported/Eigen/CXX11/Tensor \
	third_party/eigen3/unsupported/Eigen/CXX11/ThreadPool \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/FixedPointTypes.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/MatMatProduct.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/MatMatProductAVX2.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/MatMatProductNEON.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/MatVecProduct.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/PacketMathAVX2.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/PacketMathAVX512.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/TypeCastingAVX2.h \
	third_party/eigen3/unsupported/Eigen/CXX11/src/FixedPoint/TypeCastingAVX512.h \
	third_party/eigen3/unsupported/Eigen/MatrixFunctions \
	third_party/eigen3/unsupported/Eigen/SpecialFunctions \
	eigen_archive/Eigen/Cholesky \
	eigen_archive/Eigen/CholmodSupport \
	eigen_archive/Eigen/Core \
	eigen_archive/Eigen/Dense \
	eigen_archive/Eigen/Eigenvalues \
	eigen_archive/Eigen/Geometry \
	eigen_archive/Eigen/Householder \
	eigen_archive/Eigen/Jacobi \
	eigen_archive/Eigen/KLUSupport \
	eigen_archive/Eigen/LU \
	eigen_archive/Eigen/OrderingMethods \
	eigen_archive/Eigen/PaStiXSupport \
	eigen_archive/Eigen/PardisoSupport \
	eigen_archive/Eigen/QR \
	eigen_archive/Eigen/QtAlignedMalloc \
	eigen_archive/Eigen/SPQRSupport \
	eigen_archive/Eigen/SVD \
	eigen_archive/Eigen/SparseCore \
	eigen_archive/Eigen/SparseQR \
	eigen_archive/Eigen/StdDeque \
	eigen_archive/Eigen/StdList \
	eigen_archive/Eigen/StdVector \
	eigen_archive/Eigen/SuperLUSupport \
	eigen_archive/Eigen/UmfPackSupport \
	eigen_archive/Eigen/src/Cholesky/LDLT.h \
	eigen_archive/Eigen/src/Cholesky/LLT.h \
	eigen_archive/Eigen/src/Cholesky/LLT_LAPACKE.h \
	eigen_archive/Eigen/src/CholmodSupport/CholmodSupport.h \
	eigen_archive/Eigen/src/Core/ArithmeticSequence.h \
	eigen_archive/Eigen/src/Core/Array.h \
	eigen_archive/Eigen/src/Core/ArrayBase.h \
	eigen_archive/Eigen/src/Core/ArrayWrapper.h \
	eigen_archive/Eigen/src/Core/Assign.h \
	eigen_archive/Eigen/src/Core/AssignEvaluator.h \
	eigen_archive/Eigen/src/Core/Assign_MKL.h \
	eigen_archive/Eigen/src/Core/BandMatrix.h \
	eigen_archive/Eigen/src/Core/Block.h \
	eigen_archive/Eigen/src/Core/BooleanRedux.h \
	eigen_archive/Eigen/src/Core/CommaInitializer.h \
	eigen_archive/Eigen/src/Core/ConditionEstimator.h \
	eigen_archive/Eigen/src/Core/CoreEvaluators.h \
	eigen_archive/Eigen/src/Core/CoreIterators.h \
	eigen_archive/Eigen/src/Core/CwiseBinaryOp.h \
	eigen_archive/Eigen/src/Core/CwiseNullaryOp.h \
	eigen_archive/Eigen/src/Core/CwiseTernaryOp.h \
	eigen_archive/Eigen/src/Core/CwiseUnaryOp.h \
	eigen_archive/Eigen/src/Core/CwiseUnaryView.h \
	eigen_archive/Eigen/src/Core/DenseBase.h \
	eigen_archive/Eigen/src/Core/DenseCoeffsBase.h \
	eigen_archive/Eigen/src/Core/DenseStorage.h \
	eigen_archive/Eigen/src/Core/Diagonal.h \
	eigen_archive/Eigen/src/Core/DiagonalMatrix.h \
	eigen_archive/Eigen/src/Core/DiagonalProduct.h \
	eigen_archive/Eigen/src/Core/Dot.h \
	eigen_archive/Eigen/src/Core/EigenBase.h \
	eigen_archive/Eigen/src/Core/ForceAlignedAccess.h \
	eigen_archive/Eigen/src/Core/Fuzzy.h \
	eigen_archive/Eigen/src/Core/GeneralProduct.h \
	eigen_archive/Eigen/src/Core/GenericPacketMath.h \
	eigen_archive/Eigen/src/Core/GlobalFunctions.h \
	eigen_archive/Eigen/src/Core/IO.h \
	eigen_archive/Eigen/src/Core/IndexedView.h \
	eigen_archive/Eigen/src/Core/Inverse.h \
	eigen_archive/Eigen/src/Core/Map.h \
	eigen_archive/Eigen/src/Core/MapBase.h \
	eigen_archive/Eigen/src/Core/MathFunctions.h \
	eigen_archive/Eigen/src/Core/MathFunctionsImpl.h \
	eigen_archive/Eigen/src/Core/Matrix.h \
	eigen_archive/Eigen/src/Core/MatrixBase.h \
	eigen_archive/Eigen/src/Core/NestByValue.h \
	eigen_archive/Eigen/src/Core/NoAlias.h \
	eigen_archive/Eigen/src/Core/NumTraits.h \
	eigen_archive/Eigen/src/Core/PermutationMatrix.h \
	eigen_archive/Eigen/src/Core/PlainObjectBase.h \
	eigen_archive/Eigen/src/Core/Product.h \
	eigen_archive/Eigen/src/Core/ProductEvaluators.h \
	eigen_archive/Eigen/src/Core/Random.h \
	eigen_archive/Eigen/src/Core/Redux.h \
	eigen_archive/Eigen/src/Core/Ref.h \
	eigen_archive/Eigen/src/Core/Replicate.h \
	eigen_archive/Eigen/src/Core/ReturnByValue.h \
	eigen_archive/Eigen/src/Core/Reverse.h \
	eigen_archive/Eigen/src/Core/Select.h \
	eigen_archive/Eigen/src/Core/SelfAdjointView.h \
	eigen_archive/Eigen/src/Core/SelfCwiseBinaryOp.h \
	eigen_archive/Eigen/src/Core/Solve.h \
	eigen_archive/Eigen/src/Core/SolveTriangular.h \
	eigen_archive/Eigen/src/Core/SolverBase.h \
	eigen_archive/Eigen/src/Core/StableNorm.h \
	eigen_archive/Eigen/src/Core/Stride.h \
	eigen_archive/Eigen/src/Core/Swap.h \
	eigen_archive/Eigen/src/Core/Transpose.h \
	eigen_archive/Eigen/src/Core/Transpositions.h \
	eigen_archive/Eigen/src/Core/TriangularMatrix.h \
	eigen_archive/Eigen/src/Core/VectorBlock.h \
	eigen_archive/Eigen/src/Core/VectorwiseOp.h \
	eigen_archive/Eigen/src/Core/Visitor.h \
	eigen_archive/Eigen/src/Core/arch/AVX/Complex.h \
	eigen_archive/Eigen/src/Core/arch/AVX/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/AVX/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/AVX/TypeCasting.h \
	eigen_archive/Eigen/src/Core/arch/AVX512/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/AVX512/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/AltiVec/Complex.h \
	eigen_archive/Eigen/src/Core/arch/AltiVec/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/AltiVec/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/Complex.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/Half.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/PacketMathHalf.h \
	eigen_archive/Eigen/src/Core/arch/CUDA/TypeCasting.h \
	eigen_archive/Eigen/src/Core/arch/Default/ConjHelper.h \
	eigen_archive/Eigen/src/Core/arch/Default/Settings.h \
	eigen_archive/Eigen/src/Core/arch/NEON/Complex.h \
	eigen_archive/Eigen/src/Core/arch/NEON/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/NEON/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/SSE/Complex.h \
	eigen_archive/Eigen/src/Core/arch/SSE/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/SSE/PacketMath.h \
	eigen_archive/Eigen/src/Core/arch/SSE/TypeCasting.h \
	eigen_archive/Eigen/src/Core/arch/ZVector/Complex.h \
	eigen_archive/Eigen/src/Core/arch/ZVector/MathFunctions.h \
	eigen_archive/Eigen/src/Core/arch/ZVector/PacketMath.h \
	eigen_archive/Eigen/src/Core/functors/AssignmentFunctors.h \
	eigen_archive/Eigen/src/Core/functors/BinaryFunctors.h \
	eigen_archive/Eigen/src/Core/functors/NullaryFunctors.h \
	eigen_archive/Eigen/src/Core/functors/StlFunctors.h \
	eigen_archive/Eigen/src/Core/functors/TernaryFunctors.h \
	eigen_archive/Eigen/src/Core/functors/UnaryFunctors.h \
	eigen_archive/Eigen/src/Core/products/GeneralBlockPanelKernel.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixMatrix.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixMatrixTriangular.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixMatrixTriangular_BLAS.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixMatrix_BLAS.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixVector.h \
	eigen_archive/Eigen/src/Core/products/GeneralMatrixVector_BLAS.h \
	eigen_archive/Eigen/src/Core/products/Parallelizer.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointMatrixMatrix.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointMatrixMatrix_BLAS.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointMatrixVector.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointMatrixVector_BLAS.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointProduct.h \
	eigen_archive/Eigen/src/Core/products/SelfadjointRank2Update.h \
	eigen_archive/Eigen/src/Core/products/TriangularMatrixMatrix.h \
	eigen_archive/Eigen/src/Core/products/TriangularMatrixMatrix_BLAS.h \
	eigen_archive/Eigen/src/Core/products/TriangularMatrixVector.h \
	eigen_archive/Eigen/src/Core/products/TriangularMatrixVector_BLAS.h \
	eigen_archive/Eigen/src/Core/products/TriangularSolverMatrix.h \
	eigen_archive/Eigen/src/Core/products/TriangularSolverMatrix_BLAS.h \
	eigen_archive/Eigen/src/Core/products/TriangularSolverVector.h \
	eigen_archive/Eigen/src/Core/util/BlasUtil.h \
	eigen_archive/Eigen/src/Core/util/Constants.h \
	eigen_archive/Eigen/src/Core/util/DisableStupidWarnings.h \
	eigen_archive/Eigen/src/Core/util/ForwardDeclarations.h \
	eigen_archive/Eigen/src/Core/util/IndexedViewHelper.h \
	eigen_archive/Eigen/src/Core/util/IntegralConstant.h \
	eigen_archive/Eigen/src/Core/util/MKL_support.h \
	eigen_archive/Eigen/src/Core/util/Macros.h \
	eigen_archive/Eigen/src/Core/util/Memory.h \
	eigen_archive/Eigen/src/Core/util/Meta.h \
	eigen_archive/Eigen/src/Core/util/ReenableStupidWarnings.h \
	eigen_archive/Eigen/src/Core/util/StaticAssert.h \
	eigen_archive/Eigen/src/Core/util/SymbolicIndex.h \
	eigen_archive/Eigen/src/Core/util/XprHelper.h \
	eigen_archive/Eigen/src/Eigenvalues/ComplexEigenSolver.h \
	eigen_archive/Eigen/src/Eigenvalues/ComplexSchur.h \
	eigen_archive/Eigen/src/Eigenvalues/ComplexSchur_LAPACKE.h \
	eigen_archive/Eigen/src/Eigenvalues/EigenSolver.h \
	eigen_archive/Eigen/src/Eigenvalues/GeneralizedEigenSolver.h \
	eigen_archive/Eigen/src/Eigenvalues/GeneralizedSelfAdjointEigenSolver.h \
	eigen_archive/Eigen/src/Eigenvalues/HessenbergDecomposition.h \
	eigen_archive/Eigen/src/Eigenvalues/MatrixBaseEigenvalues.h \
	eigen_archive/Eigen/src/Eigenvalues/RealQZ.h \
	eigen_archive/Eigen/src/Eigenvalues/RealSchur.h \
	eigen_archive/Eigen/src/Eigenvalues/RealSchur_LAPACKE.h \
	eigen_archive/Eigen/src/Eigenvalues/SelfAdjointEigenSolver.h \
	eigen_archive/Eigen/src/Eigenvalues/SelfAdjointEigenSolver_LAPACKE.h \
	eigen_archive/Eigen/src/Eigenvalues/Tridiagonalization.h \
	eigen_archive/Eigen/src/Geometry/AlignedBox.h \
	eigen_archive/Eigen/src/Geometry/AngleAxis.h \
	eigen_archive/Eigen/src/Geometry/EulerAngles.h \
	eigen_archive/Eigen/src/Geometry/Homogeneous.h \
	eigen_archive/Eigen/src/Geometry/Hyperplane.h \
	eigen_archive/Eigen/src/Geometry/OrthoMethods.h \
	eigen_archive/Eigen/src/Geometry/ParametrizedLine.h \
	eigen_archive/Eigen/src/Geometry/Quaternion.h \
	eigen_archive/Eigen/src/Geometry/Rotation2D.h \
	eigen_archive/Eigen/src/Geometry/RotationBase.h \
	eigen_archive/Eigen/src/Geometry/Scaling.h \
	eigen_archive/Eigen/src/Geometry/Transform.h \
	eigen_archive/Eigen/src/Geometry/Translation.h \
	eigen_archive/Eigen/src/Geometry/Umeyama.h \
	eigen_archive/Eigen/src/Geometry/arch/Geometry_SSE.h \
	eigen_archive/Eigen/src/Householder/BlockHouseholder.h \
	eigen_archive/Eigen/src/Householder/Householder.h \
	eigen_archive/Eigen/src/Householder/HouseholderSequence.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/BasicPreconditioners.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/BiCGSTAB.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/ConjugateGradient.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/IncompleteCholesky.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/IncompleteLUT.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/IterativeSolverBase.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/LeastSquareConjugateGradient.h \
	eigen_archive/Eigen/src/IterativeLinearSolvers/SolveWithGuess.h \
	eigen_archive/Eigen/src/Jacobi/Jacobi.h \
	eigen_archive/Eigen/src/KLUSupport/KLUSupport.h \
	eigen_archive/Eigen/src/LU/Determinant.h \
	eigen_archive/Eigen/src/LU/FullPivLU.h \
	eigen_archive/Eigen/src/LU/InverseImpl.h \
	eigen_archive/Eigen/src/LU/PartialPivLU.h \
	eigen_archive/Eigen/src/LU/PartialPivLU_LAPACKE.h \
	eigen_archive/Eigen/src/LU/arch/Inverse_SSE.h \
	eigen_archive/Eigen/src/MetisSupport/MetisSupport.h \
	eigen_archive/Eigen/src/OrderingMethods/Eigen_Colamd.h \
	eigen_archive/Eigen/src/OrderingMethods/Ordering.h \
	eigen_archive/Eigen/src/PaStiXSupport/PaStiXSupport.h \
	eigen_archive/Eigen/src/PardisoSupport/PardisoSupport.h \
	eigen_archive/Eigen/src/QR/ColPivHouseholderQR.h \
	eigen_archive/Eigen/src/QR/ColPivHouseholderQR_LAPACKE.h \
	eigen_archive/Eigen/src/QR/CompleteOrthogonalDecomposition.h \
	eigen_archive/Eigen/src/QR/FullPivHouseholderQR.h \
	eigen_archive/Eigen/src/QR/HouseholderQR.h \
	eigen_archive/Eigen/src/QR/HouseholderQR_LAPACKE.h \
	eigen_archive/Eigen/src/SPQRSupport/SuiteSparseQRSupport.h \
	eigen_archive/Eigen/src/SVD/BDCSVD.h \
	eigen_archive/Eigen/src/SVD/JacobiSVD.h \
	eigen_archive/Eigen/src/SVD/JacobiSVD_LAPACKE.h \
	eigen_archive/Eigen/src/SVD/SVDBase.h \
	eigen_archive/Eigen/src/SVD/UpperBidiagonalization.h \
	eigen_archive/Eigen/src/SparseCore/AmbiVector.h \
	eigen_archive/Eigen/src/SparseCore/CompressedStorage.h \
	eigen_archive/Eigen/src/SparseCore/ConservativeSparseSparseProduct.h \
	eigen_archive/Eigen/src/SparseCore/MappedSparseMatrix.h \
	eigen_archive/Eigen/src/SparseCore/SparseAssign.h \
	eigen_archive/Eigen/src/SparseCore/SparseBlock.h \
	eigen_archive/Eigen/src/SparseCore/SparseColEtree.h \
	eigen_archive/Eigen/src/SparseCore/SparseCompressedBase.h \
	eigen_archive/Eigen/src/SparseCore/SparseCwiseBinaryOp.h \
	eigen_archive/Eigen/src/SparseCore/SparseCwiseUnaryOp.h \
	eigen_archive/Eigen/src/SparseCore/SparseDenseProduct.h \
	eigen_archive/Eigen/src/SparseCore/SparseDiagonalProduct.h \
	eigen_archive/Eigen/src/SparseCore/SparseDot.h \
	eigen_archive/Eigen/src/SparseCore/SparseFuzzy.h \
	eigen_archive/Eigen/src/SparseCore/SparseMap.h \
	eigen_archive/Eigen/src/SparseCore/SparseMatrix.h \
	eigen_archive/Eigen/src/SparseCore/SparseMatrixBase.h \
	eigen_archive/Eigen/src/SparseCore/SparsePermutation.h \
	eigen_archive/Eigen/src/SparseCore/SparseProduct.h \
	eigen_archive/Eigen/src/SparseCore/SparseRedux.h \
	eigen_archive/Eigen/src/SparseCore/SparseRef.h \
	eigen_archive/Eigen/src/SparseCore/SparseSelfAdjointView.h \
	eigen_archive/Eigen/src/SparseCore/SparseSolverBase.h \
	eigen_archive/Eigen/src/SparseCore/SparseSparseProductWithPruning.h \
	eigen_archive/Eigen/src/SparseCore/SparseTranspose.h \
	eigen_archive/Eigen/src/SparseCore/SparseTriangularView.h \
	eigen_archive/Eigen/src/SparseCore/SparseUtil.h \
	eigen_archive/Eigen/src/SparseCore/SparseVector.h \
	eigen_archive/Eigen/src/SparseCore/SparseView.h \
	eigen_archive/Eigen/src/SparseCore/TriangularSolver.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU.h \
	eigen_archive/Eigen/src/SparseLU/SparseLUImpl.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_Memory.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_Structs.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_SupernodalMatrix.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_Utils.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_column_bmod.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_column_dfs.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_copy_to_ucol.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_gemm_kernel.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_heap_relax_snode.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_kernel_bmod.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_panel_bmod.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_panel_dfs.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_pivotL.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_pruneL.h \
	eigen_archive/Eigen/src/SparseLU/SparseLU_relax_snode.h \
	eigen_archive/Eigen/src/SparseQR/SparseQR.h \
	eigen_archive/Eigen/src/StlSupport/StdDeque.h \
	eigen_archive/Eigen/src/StlSupport/StdList.h \
	eigen_archive/Eigen/src/StlSupport/StdVector.h \
	eigen_archive/Eigen/src/StlSupport/details.h \
	eigen_archive/Eigen/src/SuperLUSupport/SuperLUSupport.h \
	eigen_archive/Eigen/src/UmfPackSupport/UmfPackSupport.h \
	eigen_archive/Eigen/src/misc/Image.h \
	eigen_archive/Eigen/src/misc/Kernel.h \
	eigen_archive/Eigen/src/misc/RealSvd2x2.h \
	eigen_archive/Eigen/src/misc/blas.h \
	eigen_archive/Eigen/src/misc/lapack.h \
	eigen_archive/Eigen/src/misc/lapacke.h \
	eigen_archive/Eigen/src/misc/lapacke_mangling.h \
	eigen_archive/Eigen/src/plugins/ArrayCwiseBinaryOps.h \
	eigen_archive/Eigen/src/plugins/ArrayCwiseUnaryOps.h \
	eigen_archive/Eigen/src/plugins/BlockMethods.h \
	eigen_archive/Eigen/src/plugins/CommonCwiseBinaryOps.h \
	eigen_archive/Eigen/src/plugins/CommonCwiseUnaryOps.h \
	eigen_archive/Eigen/src/plugins/IndexedViewMethods.h \
	eigen_archive/Eigen/src/plugins/MatrixCwiseBinaryOps.h \
	eigen_archive/Eigen/src/plugins/MatrixCwiseUnaryOps.h \
	eigen_archive/unsupported/Eigen/CXX11/CMakeLists.txt \
	eigen_archive/unsupported/Eigen/CXX11/Tensor \
	eigen_archive/unsupported/Eigen/CXX11/TensorSymmetry \
	eigen_archive/unsupported/Eigen/CXX11/ThreadPool \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/README.md \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/Tensor.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorArgMax.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorArgMaxSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorAssign.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorBase.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorBroadcasting.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorChipping.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorConcatenation.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContraction.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContractionBlocking.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContractionCuda.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContractionMapper.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContractionSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorContractionThreadPool.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorConversion.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorConvolution.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorConvolutionSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorCostModel.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorCustomOp.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDevice.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDeviceCuda.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDeviceDefault.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDeviceSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDeviceThreadPool.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDimensionList.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorDimensions.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorEvalTo.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorEvaluator.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorExecutor.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorExpr.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorFFT.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorFixedSize.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorForcedEval.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorForwardDeclarations.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorFunctors.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorGenerator.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorGlobalFunctions.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorIO.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorImagePatch.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorIndexList.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorInflation.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorInitializer.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorIntDiv.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorLayoutSwap.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorMacros.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorMap.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorMeta.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorMorphing.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorPadding.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorPatch.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorRandom.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorReduction.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorReductionCuda.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorReductionSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorRef.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorReverse.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorScan.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorShuffling.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorStorage.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorStriding.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSycl.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclConvertToDeviceExpression.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclExprConstructor.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclExtractAccessor.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclExtractFunctors.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclFunctors.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclLeafCount.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclPlaceHolderExpr.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclRun.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorSyclTuple.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorTrace.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorTraits.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorUInt128.h \
	eigen_archive/unsupported/Eigen/CXX11/src/Tensor/TensorVolumePatch.h \
	eigen_archive/unsupported/Eigen/CXX11/src/TensorSymmetry/DynamicSymmetry.h \
	eigen_archive/unsupported/Eigen/CXX11/src/TensorSymmetry/StaticSymmetry.h \
	eigen_archive/unsupported/Eigen/CXX11/src/TensorSymmetry/Symmetry.h \
	eigen_archive/unsupported/Eigen/CXX11/src/TensorSymmetry/util/TemplateGroupTheory.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/EventCount.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/NonBlockingThreadPool.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/RunQueue.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/SimpleThreadPool.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/ThreadCancel.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/ThreadEnvironment.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/ThreadLocal.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/ThreadPoolInterface.h \
	eigen_archive/unsupported/Eigen/CXX11/src/ThreadPool/ThreadYield.h \
	eigen_archive/unsupported/Eigen/CXX11/src/util/CXX11Meta.h \
	eigen_archive/unsupported/Eigen/CXX11/src/util/CXX11Workarounds.h \
	eigen_archive/unsupported/Eigen/CXX11/src/util/EmulateArray.h \
	eigen_archive/unsupported/Eigen/CXX11/src/util/EmulateCXX11Meta.h \
	eigen_archive/unsupported/Eigen/CXX11/src/util/MaxSizeVector.h \
	eigen_archive/unsupported/Eigen/FFT \
	eigen_archive/unsupported/Eigen/KroneckerProduct \
	eigen_archive/unsupported/Eigen/MatrixFunctions \
	eigen_archive/unsupported/Eigen/SpecialFunctions \
	eigen_archive/unsupported/Eigen/src/FFT/ei_fftw_impl.h \
	eigen_archive/unsupported/Eigen/src/FFT/ei_kissfft_impl.h \
	eigen_archive/unsupported/Eigen/src/KroneckerProduct/KroneckerTensorProduct.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/MatrixExponential.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/MatrixFunction.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/MatrixLogarithm.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/MatrixPower.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/MatrixSquareRoot.h \
	eigen_archive/unsupported/Eigen/src/MatrixFunctions/StemFunction.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/SpecialFunctionsArrayAPI.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/SpecialFunctionsFunctors.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/SpecialFunctionsHalf.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/SpecialFunctionsImpl.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/SpecialFunctionsPacketMath.h \
	eigen_archive/unsupported/Eigen/src/SpecialFunctions/arch/CUDA/CudaSpecialFunctions.h \
	gif_archive/lib/gif_lib.h \
	jpeg/jccolext.c \
	jpeg/jdcol565.c \
	jpeg/jdcolext.c \
	jpeg/jdmrg565.c \
	jpeg/jdmrgext.c \
	jpeg/jerror.h \
	jpeg/jmorecfg.h \
	jpeg/jpegint.h \
	jpeg/jpeglib.h \
	jpeg/jstdhuff.c \
	tensorflow/core/example/example.pb.h \
	tensorflow/core/example/example_parser_configuration.pb.h \
	tensorflow/core/example/feature.pb.h \
	tensorflow/core/framework/allocation_description.pb.h \
	tensorflow/core/framework/api_def.pb.h \
	tensorflow/core/framework/attr_value.pb.h \
	tensorflow/core/framework/cost_graph.pb.h \
	tensorflow/core/framework/device_attributes.pb.h \
	tensorflow/core/framework/function.pb.h \
	tensorflow/core/framework/graph.pb.h \
	tensorflow/core/framework/graph_transfer_info.pb.h \
	tensorflow/core/framework/iterator.pb.h \
	tensorflow/core/framework/kernel_def.pb.h \
	tensorflow/core/framework/log_memory.pb.h \
	tensorflow/core/framework/node_def.pb.h \
	tensorflow/core/framework/op_def.pb.h \
	tensorflow/core/framework/reader_base.pb.h \
	tensorflow/core/framework/remote_fused_graph_execute_info.pb.h \
	tensorflow/core/framework/resource_handle.pb.h \
	tensorflow/core/framework/step_stats.pb.h \
	tensorflow/core/framework/summary.pb.h \
	tensorflow/core/framework/tensor.pb.h \
	tensorflow/core/framework/tensor_description.pb.h \
	tensorflow/core/framework/tensor_shape.pb.h \
	tensorflow/core/framework/tensor_slice.pb.h \
	tensorflow/core/framework/types.pb.h \
	tensorflow/core/framework/variable.pb.h \
	tensorflow/core/framework/versions.pb.h \
	tensorflow/core/protobuf/checkpointable_object_graph.pb.h \
	tensorflow/core/protobuf/cluster.pb.h \
	tensorflow/core/protobuf/config.pb.h \
	tensorflow/core/protobuf/control_flow.pb.h \
	tensorflow/core/protobuf/debug.pb.h \
	tensorflow/core/protobuf/device_properties.pb.h \
	tensorflow/core/protobuf/meta_graph.pb.h \
	tensorflow/core/protobuf/named_tensor.pb.h \
	tensorflow/core/protobuf/queue_runner.pb.h \
	tensorflow/core/protobuf/rewriter_config.pb.h \
	tensorflow/core/protobuf/saved_model.pb.h \
	tensorflow/core/protobuf/saver.pb.h \
	tensorflow/core/protobuf/tensor_bundle.pb.h \
	tensorflow/core/protobuf/tensorflow_server.pb.h \
	tensorflow/core/protobuf/transport_options.pb.h \
	tensorflow/core/util/event.pb.h \
	tensorflow/core/util/memmapped_file_system.pb.h \
	tensorflow/core/util/saved_tensor_slice.pb.h \
	tensorflow/core/util/test_log.pb.h \
	protobuf_archive/src/google/protobuf/any.h \
	protobuf_archive/src/google/protobuf/any.pb.h \
	protobuf_archive/src/google/protobuf/api.pb.h \
	protobuf_archive/src/google/protobuf/arena.h \
	protobuf_archive/src/google/protobuf/arena_impl.h \
	protobuf_archive/src/google/protobuf/arena_test_util.h \
	protobuf_archive/src/google/protobuf/arenastring.h \
	protobuf_archive/src/google/protobuf/compiler/annotation_test_util.h \
	protobuf_archive/src/google/protobuf/compiler/code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/command_line_interface.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_enum.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_extension.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_file.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_generator.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_message_layout_helper.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_options.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_padding_optimizer.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_service.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_string_field.h \
	protobuf_archive/src/google/protobuf/compiler/cpp/cpp_unittest.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_doc_comment.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_enum.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_field_base.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_generator.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_message.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_names.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_options.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_reflection_class.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_repeated_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_source_generator_base.h \
	protobuf_archive/src/google/protobuf/compiler/csharp/csharp_wrapper_field.h \
	protobuf_archive/src/google/protobuf/compiler/importer.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_context.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_doc_comment.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_enum_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_extension.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_extension_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_file.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_generator.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_generator_factory.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_lazy_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_lazy_message_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_map_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_builder.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_builder_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_message_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_name_resolver.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_names.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_options.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_primitive_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_service.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_shared_code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_string_field.h \
	protobuf_archive/src/google/protobuf/compiler/java/java_string_field_lite.h \
	protobuf_archive/src/google/protobuf/compiler/js/js_generator.h \
	protobuf_archive/src/google/protobuf/compiler/js/well_known_types_embed.h \
	protobuf_archive/src/google/protobuf/compiler/mock_code_generator.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_enum.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_enum_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_extension.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_file.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_generator.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_helpers.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_map_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_message.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_message_field.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_oneof.h \
	protobuf_archive/src/google/protobuf/compiler/objectivec/objectivec_primitive_field.h \
	protobuf_archive/src/google/protobuf/compiler/package_info.h \
	protobuf_archive/src/google/protobuf/compiler/parser.h \
	protobuf_archive/src/google/protobuf/compiler/php/php_generator.h \
	protobuf_archive/src/google/protobuf/compiler/plugin.h \
	protobuf_archive/src/google/protobuf/compiler/plugin.pb.h \
	protobuf_archive/src/google/protobuf/compiler/python/python_generator.h \
	protobuf_archive/src/google/protobuf/compiler/ruby/ruby_generator.h \
	protobuf_archive/src/google/protobuf/compiler/subprocess.h \
	protobuf_archive/src/google/protobuf/compiler/zip_writer.h \
	protobuf_archive/src/google/protobuf/descriptor.h \
	protobuf_archive/src/google/protobuf/descriptor.pb.h \
	protobuf_archive/src/google/protobuf/descriptor_database.h \
	protobuf_archive/src/google/protobuf/duration.pb.h \
	protobuf_archive/src/google/protobuf/dynamic_message.h \
	protobuf_archive/src/google/protobuf/empty.pb.h \
	protobuf_archive/src/google/protobuf/extension_set.h \
	protobuf_archive/src/google/protobuf/field_mask.pb.h \
	protobuf_archive/src/google/protobuf/generated_enum_reflection.h \
	protobuf_archive/src/google/protobuf/generated_enum_util.h \
	protobuf_archive/src/google/protobuf/generated_message_reflection.h \
	protobuf_archive/src/google/protobuf/generated_message_table_driven.h \
	protobuf_archive/src/google/protobuf/generated_message_table_driven_lite.h \
	protobuf_archive/src/google/protobuf/generated_message_util.h \
	protobuf_archive/src/google/protobuf/has_bits.h \
	protobuf_archive/src/google/protobuf/implicit_weak_message.h \
	protobuf_archive/src/google/protobuf/inlined_string_field.h \
	protobuf_archive/src/google/protobuf/io/coded_stream.h \
	protobuf_archive/src/google/protobuf/io/coded_stream_inl.h \
	protobuf_archive/src/google/protobuf/io/gzip_stream.h \
	protobuf_archive/src/google/protobuf/io/package_info.h \
	protobuf_archive/src/google/protobuf/io/printer.h \
	protobuf_archive/src/google/protobuf/io/strtod.h \
	protobuf_archive/src/google/protobuf/io/tokenizer.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream_impl.h \
	protobuf_archive/src/google/protobuf/io/zero_copy_stream_impl_lite.h \
	protobuf_archive/src/google/protobuf/map.h \
	protobuf_archive/src/google/protobuf/map_entry.h \
	protobuf_archive/src/google/protobuf/map_entry_lite.h \
	protobuf_archive/src/google/protobuf/map_field.h \
	protobuf_archive/src/google/protobuf/map_field_inl.h \
	protobuf_archive/src/google/protobuf/map_field_lite.h \
	protobuf_archive/src/google/protobuf/map_lite_test_util.h \
	protobuf_archive/src/google/protobuf/map_test_util.h \
	protobuf_archive/src/google/protobuf/map_test_util_impl.h \
	protobuf_archive/src/google/protobuf/map_type_handler.h \
	protobuf_archive/src/google/protobuf/message.h \
	protobuf_archive/src/google/protobuf/message_lite.h \
	protobuf_archive/src/google/protobuf/metadata.h \
	protobuf_archive/src/google/protobuf/metadata_lite.h \
	protobuf_archive/src/google/protobuf/package_info.h \
	protobuf_archive/src/google/protobuf/reflection.h \
	protobuf_archive/src/google/protobuf/reflection_internal.h \
	protobuf_archive/src/google/protobuf/reflection_ops.h \
	protobuf_archive/src/google/protobuf/repeated_field.h \
	protobuf_archive/src/google/protobuf/service.h \
	protobuf_archive/src/google/protobuf/source_context.pb.h \
	protobuf_archive/src/google/protobuf/struct.pb.h \
	protobuf_archive/src/google/protobuf/stubs/bytestream.h \
	protobuf_archive/src/google/protobuf/stubs/callback.h \
	protobuf_archive/src/google/protobuf/stubs/casts.h \
	protobuf_archive/src/google/protobuf/stubs/common.h \
	protobuf_archive/src/google/protobuf/stubs/fastmem.h \
	protobuf_archive/src/google/protobuf/stubs/hash.h \
	protobuf_archive/src/google/protobuf/stubs/int128.h \
	protobuf_archive/src/google/protobuf/stubs/io_win32.h \
	protobuf_archive/src/google/protobuf/stubs/logging.h \
	protobuf_archive/src/google/protobuf/stubs/macros.h \
	protobuf_archive/src/google/protobuf/stubs/map_util.h \
	protobuf_archive/src/google/protobuf/stubs/mathlimits.h \
	protobuf_archive/src/google/protobuf/stubs/mathutil.h \
	protobuf_archive/src/google/protobuf/stubs/mutex.h \
	protobuf_archive/src/google/protobuf/stubs/once.h \
	protobuf_archive/src/google/protobuf/stubs/platform_macros.h \
	protobuf_archive/src/google/protobuf/stubs/port.h \
	protobuf_archive/src/google/protobuf/stubs/singleton.h \
	protobuf_archive/src/google/protobuf/stubs/status.h \
	protobuf_archive/src/google/protobuf/stubs/status_macros.h \
	protobuf_archive/src/google/protobuf/stubs/statusor.h \
	protobuf_archive/src/google/protobuf/stubs/stl_util.h \
	protobuf_archive/src/google/protobuf/stubs/stringpiece.h \
	protobuf_archive/src/google/protobuf/stubs/stringprintf.h \
	protobuf_archive/src/google/protobuf/stubs/strutil.h \
	protobuf_archive/src/google/protobuf/stubs/substitute.h \
	protobuf_archive/src/google/protobuf/stubs/template_util.h \
	protobuf_archive/src/google/protobuf/stubs/time.h \
	protobuf_archive/src/google/protobuf/test_util.h \
	protobuf_archive/src/google/protobuf/test_util_lite.h \
	protobuf_archive/src/google/protobuf/testing/file.h \
	protobuf_archive/src/google/protobuf/testing/googletest.h \
	protobuf_archive/src/google/protobuf/text_format.h \
	protobuf_archive/src/google/protobuf/timestamp.pb.h \
	protobuf_archive/src/google/protobuf/type.pb.h \
	protobuf_archive/src/google/protobuf/unknown_field_set.h \
	protobuf_archive/src/google/protobuf/util/delimited_message_util.h \
	protobuf_archive/src/google/protobuf/util/field_comparator.h \
	protobuf_archive/src/google/protobuf/util/field_mask_util.h \
	protobuf_archive/src/google/protobuf/util/internal/constants.h \
	protobuf_archive/src/google/protobuf/util/internal/datapiece.h \
	protobuf_archive/src/google/protobuf/util/internal/default_value_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/error_listener.h \
	protobuf_archive/src/google/protobuf/util/internal/expecting_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/field_mask_utility.h \
	protobuf_archive/src/google/protobuf/util/internal/json_escaping.h \
	protobuf_archive/src/google/protobuf/util/internal/json_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/json_stream_parser.h \
	protobuf_archive/src/google/protobuf/util/internal/location_tracker.h \
	protobuf_archive/src/google/protobuf/util/internal/mock_error_listener.h \
	protobuf_archive/src/google/protobuf/util/internal/object_location_tracker.h \
	protobuf_archive/src/google/protobuf/util/internal/object_source.h \
	protobuf_archive/src/google/protobuf/util/internal/object_writer.h \
	protobuf_archive/src/google/protobuf/util/internal/proto_writer.h \
	protobuf_archive/src/google/protobuf/util/internal/protostream_objectsource.h \
	protobuf_archive/src/google/protobuf/util/internal/protostream_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/structured_objectwriter.h \
	protobuf_archive/src/google/protobuf/util/internal/type_info.h \
	protobuf_archive/src/google/protobuf/util/internal/type_info_test_helper.h \
	protobuf_archive/src/google/protobuf/util/internal/utility.h \
	protobuf_archive/src/google/protobuf/util/json_util.h \
	protobuf_archive/src/google/protobuf/util/message_differencer.h \
	protobuf_archive/src/google/protobuf/util/package_info.h \
	protobuf_archive/src/google/protobuf/util/time_util.h \
	protobuf_archive/src/google/protobuf/util/type_resolver.h \
	protobuf_archive/src/google/protobuf/util/type_resolver_util.h \
	protobuf_archive/src/google/protobuf/wire_format.h \
	protobuf_archive/src/google/protobuf/wire_format_lite.h \
	protobuf_archive/src/google/protobuf/wire_format_lite_inl.h \
	protobuf_archive/src/google/protobuf/wrappers.pb.h \
	tensorflow/core/lib/core/error_codes.pb.h \
	com_googlesource_code_re2/re2/filtered_re2.h \
	com_googlesource_code_re2/re2/re2.h \
	com_googlesource_code_re2/re2/set.h \
	com_googlesource_code_re2/re2/stringpiece.h \
	farmhash_archive/src/farmhash.h \
	highwayhash/highwayhash/endianess.h \
	highwayhash/highwayhash/sip_hash.h \
	highwayhash/highwayhash/state_helpers.h \
	highwayhash/highwayhash/arch_specific.h \
	highwayhash/highwayhash/compiler_specific.h \
	zlib_archive/zlib.h \
	tensorflow/core/platform/windows/cpu_info.h \
	double_conversion/double-conversion/bignum-dtoa.h \
	double_conversion/double-conversion/bignum.h \
	double_conversion/double-conversion/cached-powers.h \
	double_conversion/double-conversion/diy-fp.h \
	double_conversion/double-conversion/double-conversion.h \
	double_conversion/double-conversion/fast-dtoa.h \
	double_conversion/double-conversion/fixed-dtoa.h \
	double_conversion/double-conversion/ieee.h \
	double_conversion/double-conversion/strtod.h \
	snappy/snappy.h \
	tensorflow/core/grappler/costs/op_performance_data.pb.h \
	tensorflow/core/public/version.h \
	tensorflow/core/kernels/bounds_check.h \
	tensorflow/core/framework/numeric_types.h \
	tensorflow/core/framework/tensor_types.h \
	tensorflow/core/framework/type_traits.h

################################################################################
# //tensorflow/core/platform/default/build_config:logging

tensorflow_core_platform_default_build_config_logging_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

################################################################################
# //tensorflow/tools/proto_text:gen_proto_text_functions_lib

tensorflow_tools_proto_text_gen_proto_text_functions_lib_LDLIBS = \
	-lm \
	-lpthread \
	-lrt

tensorflow_tools_proto_text_gen_proto_text_functions_lib_HEADERS = \
	tensorflow/tools/proto_text/gen_proto_text_functions_lib.h

tensorflow_tools_proto_text_gen_proto_text_functions_lib_LINK = \
	blake-bin/tensorflow/tools/proto_text/libgen_proto_text_functions_lib.so

tensorflow_tools_proto_text_gen_proto_text_functions_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote protobuf_archive \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote double_conversion

tensorflow_tools_proto_text_gen_proto_text_functions_lib_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_tools_proto_text_gen_proto_text_functions_lib_COMPILE_HEADERS = \
	$(tensorflow_tools_proto_text_gen_proto_text_functions_lib_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS)

blake-bin/tensorflow/tools/proto_text/_objs/gen_proto_text_functions_lib/%.pic.o: \
		tensorflow/tools/proto_text/%.cc \
		$(tensorflow_tools_proto_text_gen_proto_text_functions_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_tools_proto_text_gen_proto_text_functions_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_tools_proto_text_gen_proto_text_functions_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/tools/proto_text/_objs/gen_proto_text_functions_lib/%.o: \
		tensorflow/tools/proto_text/%.cc \
		$(tensorflow_tools_proto_text_gen_proto_text_functions_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_tools_proto_text_gen_proto_text_functions_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_tools_proto_text_gen_proto_text_functions_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/tools/proto_text/libgen_proto_text_functions_lib.a: \
		blake-bin/tensorflow/tools/proto_text/_objs/gen_proto_text_functions_lib/gen_proto_text_functions_lib.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_tools_proto_text_gen_proto_text_functions_lib_SBLINK = \
	blake-bin/tensorflow/tools/proto_text/libgen_proto_text_functions_lib.a

blake-bin/tensorflow/tools/proto_text/libgen_proto_text_functions_lib.pic.a: \
		blake-bin/tensorflow/tools/proto_text/_objs/gen_proto_text_functions_lib/gen_proto_text_functions_lib.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_tools_proto_text_gen_proto_text_functions_lib_SPLINK = \
	blake-bin/tensorflow/tools/proto_text/libgen_proto_text_functions_lib.pic.a

blake-bin/tensorflow/tools/proto_text/libgen_proto_text_functions_lib.so: \
		$(tensorflow_tools_proto_text_gen_proto_text_functions_lib_SPLINK) \
		$(tensorflow_core_lib_proto_parsing_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_tools_proto_text_gen_proto_text_functions_lib_SPLINK) $(NOWA) $(tensorflow_core_lib_proto_parsing_LINK) $(tensorflow_tools_proto_text_gen_proto_text_functions_lib_LDLIBS)

################################################################################
# //tensorflow/tools/proto_text:gen_proto_text_functions

tensorflow_tools_proto_text_gen_proto_text_functions_COMPILE_IQUOTES = \
	-iquote . \
	-iquote protobuf_archive \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote double_conversion

tensorflow_tools_proto_text_gen_proto_text_functions_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_tools_proto_text_gen_proto_text_functions_COMPILE_HEADERS = \
	$(tensorflow_tools_proto_text_gen_proto_text_functions_lib_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS)

blake-bin/tensorflow/tools/proto_text/_objs/gen_proto_text_functions/%.o: \
		tensorflow/tools/proto_text/%.cc \
		$(tensorflow_tools_proto_text_gen_proto_text_functions_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_tools_proto_text_gen_proto_text_functions_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_tools_proto_text_gen_proto_text_functions_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/tools/proto_text/libgen_proto_text_functions.a: \
		blake-bin/tensorflow/tools/proto_text/_objs/gen_proto_text_functions/gen_proto_text_functions.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_tools_proto_text_gen_proto_text_functions_SBLINKT = \
	blake-bin/tensorflow/tools/proto_text/libgen_proto_text_functions.a

tensorflow_tools_proto_text_gen_proto_text_functions_SBLINKF = \
	$(WA) $(tensorflow_tools_proto_text_gen_proto_text_functions_SBLINKT) $(NOWA)

blake-bin/tensorflow/tools/proto_text/gen_proto_text_functions: \
		$(tensorflow_tools_proto_text_gen_proto_text_functions_SBLINKT) \
		$(tensorflow_tools_proto_text_gen_proto_text_functions_lib_SBLINK) \
		$(tensorflow_core_lib_proto_parsing_SBLINK) \
		$(double_conversion_double-conversion_SBLINK) \
		$(tensorflow_core_platform_base_SBLINK) \
		$(tensorflow_core_protos_all_proto_cc_impl_SBLINK) \
		$(tensorflow_core_error_codes_proto_cc_impl_SBLINK) \
		$(protobuf_archive_protobuf_SBLINK) \
		$(protobuf_archive_protobuf_lite_SBLINK)
	$(CXX) $(CFLAGS.security)  $(CXXFLAGS) $(LDFLAGS.security)  $(PIE) $(LDFLAGS) $(TARGET_ARCH) $(tensorflow_tools_proto_text_gen_proto_text_functions_SBLINKF) $(tensorflow_tools_proto_text_gen_proto_text_functions_lib_SBLINK) $(tensorflow_core_lib_proto_parsing_SBLINK) $(double_conversion_double-conversion_SBLINK) $(tensorflow_core_platform_base_SBLINK) $(tensorflow_core_protos_all_proto_cc_impl_SBLINK) $(tensorflow_core_error_codes_proto_cc_impl_SBLINK) $(protobuf_archive_protobuf_SBLINK) $(protobuf_archive_protobuf_lite_SBLINK) $(LOADLIBES)  $(LDLIBS) -o $@

################################################################################
# //tensorflow/core:error_codes_proto_text_srcs

tensorflow_core_error_codes_proto_text_srcs_PREREQUISITES = \
	tensorflow/core/lib/core/error_codes.proto \
	tensorflow/tools/proto_text/placeholder.txt \
	blake-bin/tensorflow/tools/proto_text/gen_proto_text_functions

blake-bin/tensorflow/core/error_codes_proto_text_srcs.stamp: \
		$(tensorflow_core_error_codes_proto_text_srcs_PREREQUISITES)
	@mkdir -p tensorflow/core/lib/core
	blake-bin/tensorflow/tools/proto_text/gen_proto_text_functions tensorflow/core tensorflow/core/ tensorflow/core/lib/core/error_codes.proto tensorflow/tools/proto_text/placeholder.txt
	@mkdir -p blake-bin/tensorflow/core
	@touch blake-bin/tensorflow/core/error_codes_proto_text_srcs.stamp

tensorflow/core/lib/core/error_codes.pb_text.h: blake-bin/tensorflow/core/error_codes_proto_text_srcs.stamp;
tensorflow/core/lib/core/error_codes.pb_text-impl.h: blake-bin/tensorflow/core/error_codes_proto_text_srcs.stamp;
tensorflow/core/lib/core/error_codes.pb_text.cc: blake-bin/tensorflow/core/error_codes_proto_text_srcs.stamp;

################################################################################
# //tensorflow/core:error_codes_proto_text

tensorflow_core_error_codes_proto_text_HEADERS = \
	tensorflow/core/lib/core/error_codes.pb_text-impl.h \
	tensorflow/core/lib/core/error_codes.pb_text.h

tensorflow_core_error_codes_proto_text_LINK = \
	blake-bin/tensorflow/core/liberror_codes_proto_text.so

tensorflow_core_error_codes_proto_text_COMPILE_IQUOTES = \
	-iquote . \
	-iquote protobuf_archive \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_error_codes_proto_text_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_error_codes_proto_text_COMPILE_HEADERS = \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS)

blake-bin/tensorflow/core/_objs/error_codes_proto_text/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_error_codes_proto_text_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_error_codes_proto_text_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_error_codes_proto_text_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/error_codes_proto_text/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_error_codes_proto_text_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_error_codes_proto_text_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_error_codes_proto_text_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/liberror_codes_proto_text.a: \
		blake-bin/tensorflow/core/_objs/error_codes_proto_text/lib/core/error_codes.pb_text.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_error_codes_proto_text_SBLINK = \
	blake-bin/tensorflow/core/liberror_codes_proto_text.a

blake-bin/tensorflow/core/liberror_codes_proto_text.pic.a: \
		blake-bin/tensorflow/core/_objs/error_codes_proto_text/lib/core/error_codes.pb_text.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_error_codes_proto_text_SPLINK = \
	blake-bin/tensorflow/core/liberror_codes_proto_text.pic.a

blake-bin/tensorflow/core/liberror_codes_proto_text.so: \
		$(tensorflow_core_error_codes_proto_text_SPLINK) \
		$(tensorflow_core_lib_internal_impl_LINK) \
		$(nsync_nsync_cpp_LINK) \
		$(com_google_absl_absl_base_base_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_error_codes_proto_text_SPLINK) $(NOWA) $(tensorflow_core_lib_internal_impl_LINK) $(nsync_nsync_cpp_LINK) $(com_google_absl_absl_base_base_LINK) 

################################################################################
# //tensorflow/core:protos_all_proto_text_srcs

tensorflow_core_protos_all_proto_text_srcs_PREREQUISITES = \
	tensorflow/core/example/example.proto \
	tensorflow/core/example/feature.proto \
	tensorflow/core/framework/allocation_description.proto \
	tensorflow/core/framework/attr_value.proto \
	tensorflow/core/framework/cost_graph.proto \
	tensorflow/core/framework/device_attributes.proto \
	tensorflow/core/framework/function.proto \
	tensorflow/core/framework/graph.proto \
	tensorflow/core/framework/graph_transfer_info.proto \
	tensorflow/core/framework/iterator.proto \
	tensorflow/core/framework/kernel_def.proto \
	tensorflow/core/framework/log_memory.proto \
	tensorflow/core/framework/node_def.proto \
	tensorflow/core/framework/op_def.proto \
	tensorflow/core/framework/api_def.proto \
	tensorflow/core/framework/reader_base.proto \
	tensorflow/core/framework/remote_fused_graph_execute_info.proto \
	tensorflow/core/framework/resource_handle.proto \
	tensorflow/core/framework/step_stats.proto \
	tensorflow/core/framework/summary.proto \
	tensorflow/core/framework/tensor.proto \
	tensorflow/core/framework/tensor_description.proto \
	tensorflow/core/framework/tensor_shape.proto \
	tensorflow/core/framework/tensor_slice.proto \
	tensorflow/core/framework/types.proto \
	tensorflow/core/framework/variable.proto \
	tensorflow/core/framework/versions.proto \
	tensorflow/core/protobuf/config.proto \
	tensorflow/core/protobuf/cluster.proto \
	tensorflow/core/protobuf/debug.proto \
	tensorflow/core/protobuf/device_properties.proto \
	tensorflow/core/protobuf/queue_runner.proto \
	tensorflow/core/protobuf/rewriter_config.proto \
	tensorflow/core/protobuf/tensor_bundle.proto \
	tensorflow/core/protobuf/saver.proto \
	tensorflow/core/util/event.proto \
	tensorflow/core/util/memmapped_file_system.proto \
	tensorflow/core/util/saved_tensor_slice.proto \
	tensorflow/core/lib/core/error_codes.proto \
	tensorflow/tools/proto_text/placeholder.txt \
	blake-bin/tensorflow/tools/proto_text/gen_proto_text_functions

blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp: \
		$(tensorflow_core_protos_all_proto_text_srcs_PREREQUISITES)
	@mkdir -p tensorflow/core/example
	@mkdir -p tensorflow/core/framework
	@mkdir -p tensorflow/core/protobuf
	@mkdir -p tensorflow/core/util
	blake-bin/tensorflow/tools/proto_text/gen_proto_text_functions tensorflow/core tensorflow/core/ tensorflow/core/example/example.proto tensorflow/core/example/feature.proto tensorflow/core/framework/allocation_description.proto tensorflow/core/framework/attr_value.proto tensorflow/core/framework/cost_graph.proto tensorflow/core/framework/device_attributes.proto tensorflow/core/framework/function.proto tensorflow/core/framework/graph.proto tensorflow/core/framework/graph_transfer_info.proto tensorflow/core/framework/iterator.proto tensorflow/core/framework/kernel_def.proto tensorflow/core/framework/log_memory.proto tensorflow/core/framework/node_def.proto tensorflow/core/framework/op_def.proto tensorflow/core/framework/api_def.proto tensorflow/core/framework/reader_base.proto tensorflow/core/framework/remote_fused_graph_execute_info.proto tensorflow/core/framework/resource_handle.proto tensorflow/core/framework/step_stats.proto tensorflow/core/framework/summary.proto tensorflow/core/framework/tensor.proto tensorflow/core/framework/tensor_description.proto tensorflow/core/framework/tensor_shape.proto tensorflow/core/framework/tensor_slice.proto tensorflow/core/framework/types.proto tensorflow/core/framework/variable.proto tensorflow/core/framework/versions.proto tensorflow/core/protobuf/config.proto tensorflow/core/protobuf/cluster.proto tensorflow/core/protobuf/debug.proto tensorflow/core/protobuf/device_properties.proto tensorflow/core/protobuf/queue_runner.proto tensorflow/core/protobuf/rewriter_config.proto tensorflow/core/protobuf/tensor_bundle.proto tensorflow/core/protobuf/saver.proto tensorflow/core/util/event.proto tensorflow/core/util/memmapped_file_system.proto tensorflow/core/util/saved_tensor_slice.proto tensorflow/core/lib/core/error_codes.proto tensorflow/tools/proto_text/placeholder.txt
	@mkdir -p blake-bin/tensorflow/core
	@touch blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp

tensorflow/core/example/example.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/example/feature.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/allocation_description.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/attr_value.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/cost_graph.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/device_attributes.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/function.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/graph.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/graph_transfer_info.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/iterator.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/kernel_def.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/log_memory.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/node_def.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/op_def.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/api_def.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/reader_base.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/remote_fused_graph_execute_info.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/resource_handle.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/step_stats.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/summary.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor_description.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor_shape.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor_slice.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/types.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/variable.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/versions.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/config.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/cluster.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/debug.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/device_properties.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/queue_runner.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/rewriter_config.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/tensor_bundle.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/saver.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/util/event.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/util/memmapped_file_system.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/util/saved_tensor_slice.pb_text.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/example/example.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/example/feature.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/allocation_description.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/attr_value.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/cost_graph.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/device_attributes.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/function.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/graph.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/graph_transfer_info.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/iterator.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/kernel_def.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/log_memory.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/node_def.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/op_def.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/api_def.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/reader_base.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/remote_fused_graph_execute_info.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/resource_handle.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/step_stats.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/summary.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor_description.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor_shape.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor_slice.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/types.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/variable.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/versions.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/config.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/cluster.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/debug.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/device_properties.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/queue_runner.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/rewriter_config.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/tensor_bundle.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/saver.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/util/event.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/util/memmapped_file_system.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/util/saved_tensor_slice.pb_text-impl.h: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/example/example.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/example/feature.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/allocation_description.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/attr_value.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/cost_graph.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/device_attributes.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/function.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/graph.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/graph_transfer_info.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/iterator.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/kernel_def.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/log_memory.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/node_def.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/op_def.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/api_def.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/reader_base.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/remote_fused_graph_execute_info.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/resource_handle.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/step_stats.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/summary.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor_description.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor_shape.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/tensor_slice.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/types.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/variable.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/framework/versions.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/config.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/cluster.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/debug.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/device_properties.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/queue_runner.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/rewriter_config.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/tensor_bundle.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/protobuf/saver.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/util/event.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/util/memmapped_file_system.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;
tensorflow/core/util/saved_tensor_slice.pb_text.cc: blake-bin/tensorflow/core/protos_all_proto_text_srcs.stamp;

################################################################################
# //tensorflow/core:protos_all_proto_text

tensorflow_core_protos_all_proto_text_HEADERS = \
	tensorflow/core/example/example.pb_text-impl.h \
	tensorflow/core/example/example.pb_text.h \
	tensorflow/core/example/feature.pb_text-impl.h \
	tensorflow/core/example/feature.pb_text.h \
	tensorflow/core/framework/allocation_description.pb_text-impl.h \
	tensorflow/core/framework/allocation_description.pb_text.h \
	tensorflow/core/framework/api_def.pb_text-impl.h \
	tensorflow/core/framework/api_def.pb_text.h \
	tensorflow/core/framework/attr_value.pb_text-impl.h \
	tensorflow/core/framework/attr_value.pb_text.h \
	tensorflow/core/framework/cost_graph.pb_text-impl.h \
	tensorflow/core/framework/cost_graph.pb_text.h \
	tensorflow/core/framework/device_attributes.pb_text-impl.h \
	tensorflow/core/framework/device_attributes.pb_text.h \
	tensorflow/core/framework/function.pb_text-impl.h \
	tensorflow/core/framework/function.pb_text.h \
	tensorflow/core/framework/graph.pb_text-impl.h \
	tensorflow/core/framework/graph.pb_text.h \
	tensorflow/core/framework/graph_transfer_info.pb_text-impl.h \
	tensorflow/core/framework/graph_transfer_info.pb_text.h \
	tensorflow/core/framework/iterator.pb_text-impl.h \
	tensorflow/core/framework/iterator.pb_text.h \
	tensorflow/core/framework/kernel_def.pb_text-impl.h \
	tensorflow/core/framework/kernel_def.pb_text.h \
	tensorflow/core/framework/log_memory.pb_text-impl.h \
	tensorflow/core/framework/log_memory.pb_text.h \
	tensorflow/core/framework/node_def.pb_text-impl.h \
	tensorflow/core/framework/node_def.pb_text.h \
	tensorflow/core/framework/op_def.pb_text-impl.h \
	tensorflow/core/framework/op_def.pb_text.h \
	tensorflow/core/framework/reader_base.pb_text-impl.h \
	tensorflow/core/framework/reader_base.pb_text.h \
	tensorflow/core/framework/remote_fused_graph_execute_info.pb_text-impl.h \
	tensorflow/core/framework/remote_fused_graph_execute_info.pb_text.h \
	tensorflow/core/framework/resource_handle.pb_text-impl.h \
	tensorflow/core/framework/resource_handle.pb_text.h \
	tensorflow/core/framework/step_stats.pb_text-impl.h \
	tensorflow/core/framework/step_stats.pb_text.h \
	tensorflow/core/framework/summary.pb_text-impl.h \
	tensorflow/core/framework/summary.pb_text.h \
	tensorflow/core/framework/tensor.pb_text-impl.h \
	tensorflow/core/framework/tensor.pb_text.h \
	tensorflow/core/framework/tensor_description.pb_text-impl.h \
	tensorflow/core/framework/tensor_description.pb_text.h \
	tensorflow/core/framework/tensor_shape.pb_text-impl.h \
	tensorflow/core/framework/tensor_shape.pb_text.h \
	tensorflow/core/framework/tensor_slice.pb_text-impl.h \
	tensorflow/core/framework/tensor_slice.pb_text.h \
	tensorflow/core/framework/types.pb_text-impl.h \
	tensorflow/core/framework/types.pb_text.h \
	tensorflow/core/framework/variable.pb_text-impl.h \
	tensorflow/core/framework/variable.pb_text.h \
	tensorflow/core/framework/versions.pb_text-impl.h \
	tensorflow/core/framework/versions.pb_text.h \
	tensorflow/core/protobuf/cluster.pb_text-impl.h \
	tensorflow/core/protobuf/cluster.pb_text.h \
	tensorflow/core/protobuf/config.pb_text-impl.h \
	tensorflow/core/protobuf/config.pb_text.h \
	tensorflow/core/protobuf/debug.pb_text-impl.h \
	tensorflow/core/protobuf/debug.pb_text.h \
	tensorflow/core/protobuf/device_properties.pb_text-impl.h \
	tensorflow/core/protobuf/device_properties.pb_text.h \
	tensorflow/core/protobuf/queue_runner.pb_text-impl.h \
	tensorflow/core/protobuf/queue_runner.pb_text.h \
	tensorflow/core/protobuf/rewriter_config.pb_text-impl.h \
	tensorflow/core/protobuf/rewriter_config.pb_text.h \
	tensorflow/core/protobuf/saver.pb_text-impl.h \
	tensorflow/core/protobuf/saver.pb_text.h \
	tensorflow/core/protobuf/tensor_bundle.pb_text-impl.h \
	tensorflow/core/protobuf/tensor_bundle.pb_text.h \
	tensorflow/core/util/event.pb_text-impl.h \
	tensorflow/core/util/event.pb_text.h \
	tensorflow/core/util/memmapped_file_system.pb_text-impl.h \
	tensorflow/core/util/memmapped_file_system.pb_text.h \
	tensorflow/core/util/saved_tensor_slice.pb_text-impl.h \
	tensorflow/core/util/saved_tensor_slice.pb_text.h

tensorflow_core_protos_all_proto_text_LINK = \
	blake-bin/tensorflow/core/libprotos_all_proto_text.so

tensorflow_core_protos_all_proto_text_COMPILE_IQUOTES = \
	-iquote . \
	-iquote protobuf_archive \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_protos_all_proto_text_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_protos_all_proto_text_COMPILE_HEADERS = \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS)

blake-bin/tensorflow/core/_objs/protos_all_proto_text/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_protos_all_proto_text_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_protos_all_proto_text_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_protos_all_proto_text_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/protos_all_proto_text/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_protos_all_proto_text_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_protos_all_proto_text_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_protos_all_proto_text_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libprotos_all_proto_text.a: \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/example/example.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/example/feature.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/allocation_description.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/attr_value.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/cost_graph.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/device_attributes.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/function.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/graph.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/graph_transfer_info.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/iterator.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/kernel_def.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/log_memory.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/node_def.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/op_def.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/api_def.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/reader_base.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/remote_fused_graph_execute_info.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/resource_handle.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/step_stats.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/summary.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/tensor.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/tensor_description.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/tensor_shape.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/tensor_slice.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/types.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/variable.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/versions.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/config.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/cluster.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/debug.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/device_properties.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/queue_runner.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/rewriter_config.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/tensor_bundle.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/saver.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/util/event.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/util/memmapped_file_system.pb_text.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/util/saved_tensor_slice.pb_text.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_protos_all_proto_text_SBLINK = \
	blake-bin/tensorflow/core/libprotos_all_proto_text.a

blake-bin/tensorflow/core/libprotos_all_proto_text.pic.a: \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/example/example.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/example/feature.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/allocation_description.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/attr_value.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/cost_graph.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/device_attributes.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/function.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/graph.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/graph_transfer_info.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/iterator.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/kernel_def.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/log_memory.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/node_def.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/op_def.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/api_def.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/reader_base.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/remote_fused_graph_execute_info.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/resource_handle.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/step_stats.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/summary.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/tensor.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/tensor_description.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/tensor_shape.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/tensor_slice.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/types.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/variable.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/framework/versions.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/config.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/cluster.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/debug.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/device_properties.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/queue_runner.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/rewriter_config.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/tensor_bundle.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/protobuf/saver.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/util/event.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/util/memmapped_file_system.pb_text.pic.o \
		blake-bin/tensorflow/core/_objs/protos_all_proto_text/util/saved_tensor_slice.pb_text.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_protos_all_proto_text_SPLINK = \
	blake-bin/tensorflow/core/libprotos_all_proto_text.pic.a

blake-bin/tensorflow/core/libprotos_all_proto_text.so: \
		$(tensorflow_core_protos_all_proto_text_SPLINK) \
		$(tensorflow_core_error_codes_proto_text_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_protos_all_proto_text_SPLINK) $(NOWA) $(tensorflow_core_error_codes_proto_text_LINK) 

################################################################################
# //tensorflow/core:stats_calculator_portable

tensorflow_core_stats_calculator_portable_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_stats_calculator_portable_HEADERS = \
	tensorflow/core/util/stats_calculator.h

tensorflow_core_stats_calculator_portable_LINK = \
	blake-bin/tensorflow/core/libstats_calculator_portable.so

tensorflow_core_stats_calculator_portable_COMPILE_HEADERS = \
	tensorflow/core/util/stat_summarizer_options.h \
	$(tensorflow_core_stats_calculator_portable_HEADERS)

blake-bin/tensorflow/core/_objs/stats_calculator_portable/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_stats_calculator_portable_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_stats_calculator_portable_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(CPPFLAGS) -iquote . $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/stats_calculator_portable/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_stats_calculator_portable_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_stats_calculator_portable_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security)  $(FPIE) $(CPPFLAGS) -iquote . $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libstats_calculator_portable.a: \
		blake-bin/tensorflow/core/_objs/stats_calculator_portable/util/stats_calculator.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_stats_calculator_portable_SBLINK = \
	blake-bin/tensorflow/core/libstats_calculator_portable.a

blake-bin/tensorflow/core/libstats_calculator_portable.pic.a: \
		blake-bin/tensorflow/core/_objs/stats_calculator_portable/util/stats_calculator.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_stats_calculator_portable_SPLINK = \
	blake-bin/tensorflow/core/libstats_calculator_portable.pic.a

blake-bin/tensorflow/core/libstats_calculator_portable.so: \
		$(tensorflow_core_stats_calculator_portable_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_stats_calculator_portable_SPLINK) $(NOWA) 

################################################################################
# @mkl_darwin//:mkl_headers

mkl_darwin_mkl_headers_CPPFLAGS = -isystem mkl_darwin/include

################################################################################
# @mkl_darwin//:mkl_libs_darwin

################################################################################
# @mkl_linux//:mkl_headers

mkl_linux_mkl_headers_CPPFLAGS = -isystem mkl_linux/include

################################################################################
# @mkl_linux//:mkl_libs_linux

################################################################################
# @mkl_windows//:mkl_headers

mkl_windows_mkl_headers_CPPFLAGS = -isystem mkl_windows/include

################################################################################
# @mkl_windows//:mkl_libs_windows

################################################################################
# //third_party/mkl:intel_binary_blob

################################################################################
# @local_config_cuda//cuda:cuda_headers

local_config_cuda_cuda_cuda_headers_CPPFLAGS = \
	-isystem local_config_cuda/cuda \
	-isystem local_config_cuda/cuda/cuda/include \
	-isystem local_config_cuda/cuda/cuda/include/crt

local_config_cuda_cuda_cuda_headers_HEADERS = \
	local_config_cuda/cuda/cuda/cuda_config.h

################################################################################
# @mkl_dnn//:mkl_dnn

mkl_dnn_mkl_dnn_CFLAGS = -fexceptions -DUSE_MKL -DUSE_CBLAS -fopenmp

mkl_dnn_mkl_dnn_CPPFLAGS = \
	-isystem mkl_dnn/include \
	-isystem mkl_dnn/src \
	-isystem mkl_dnn/src/common \
	-isystem mkl_dnn/src/cpu \
	-isystem mkl_dnn/src/cpu/xbyak

mkl_dnn_mkl_dnn_HEADERS = \
	mkl_dnn/include/mkldnn.h \
	mkl_dnn/include/mkldnn.hpp \
	mkl_dnn/include/mkldnn_debug.h \
	mkl_dnn/include/mkldnn_types.h

mkl_dnn_mkl_dnn_LINK = blake-bin/mkl_dnn/libmkl_dnn.so
mkl_dnn_mkl_dnn_COMPILE_IQUOTES = -iquote mkl_dnn -iquote mkl_linux

mkl_dnn_mkl_dnn_COMPILE_CPPFLAGS = \
	$(mkl_dnn_mkl_dnn_CPPFLAGS) \
	$(mkl_linux_mkl_headers_CPPFLAGS)

blake-bin/mkl_dnn/_objs/mkl_dnn/%.pic.o: \
		mkl_dnn/%.cpp \
		$(mkl_dnn_mkl_dnn_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(mkl_dnn_mkl_dnn_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(mkl_dnn_mkl_dnn_COMPILE_CPPFLAGS) $(CPPFLAGS) $(mkl_dnn_mkl_dnn_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/mkl_dnn/_objs/mkl_dnn/%.o: mkl_dnn/%.cpp $(mkl_dnn_mkl_dnn_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(mkl_dnn_mkl_dnn_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(mkl_dnn_mkl_dnn_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(mkl_dnn_mkl_dnn_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/mkl_dnn/libmkl_dnn.a: \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/batch_normalization.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/convolution_relu.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/deconvolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/eltwise.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/engine.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/inner_product.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/lrn.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/memory.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/memory_desc_wrapper.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/mkldnn_debug.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/pooling.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/primitive.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/primitive_attr.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/primitive_desc.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/primitive_iterator.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/query.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/reorder.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/rnn.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/scratchpad.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/softmax.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/stream.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/utils.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/verbose.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_barrier.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_batch_normalization_utils.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_concat.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_engine.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_reducer.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_reorder.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_sum.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/gemm_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/gemm_convolution_utils.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/gemm_inner_product.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/gemm_u8s8s32x_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx2_1x1_conv_kernel_f32.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx2_1x1_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx2_conv_kernel_f32.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx2_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx2_gemm_f32.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_1x1_conv_kernel.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_1x1_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_conv_kernel.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_conv_winograd_kernel_f32.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_convolution_winograd.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_gemm_f32.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_lrn.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_conv_winograd_kernel_f32.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_convolution_winograd.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_i8i8_pooling.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_u8s8s32x_1x1_conv_kernel.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_u8s8s32x_1x1_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_u8s8s32x_conv_kernel.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_u8s8s32x_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_u8s8s32x_wino_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_sse42_1x1_conv_kernel_f32.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_sse42_1x1_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_sse42_conv_kernel_f32.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_sse42_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_transpose_src_utils.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_batch_normalization.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_dw_conv_kernel_f32.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_dw_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_eltwise.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_inner_product.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_lrn.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_lrn_kernel_f32.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_pool_kernel_f32.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_pooling.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_reorder.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_reorder_utils.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/nchw_pooling.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ncsp_batch_normalization.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/nspc_batch_normalization.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_batch_normalization.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_convolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_deconvolution.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_eltwise.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_inner_product.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_lrn.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_pooling.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_rnn.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_softmax.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/simple_concat.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/simple_sum.o
	$(AR) $(ARFLAGS) $@ $^

mkl_dnn_mkl_dnn_SBLINK = blake-bin/mkl_dnn/libmkl_dnn.a

blake-bin/mkl_dnn/libmkl_dnn.pic.a: \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/batch_normalization.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/convolution_relu.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/deconvolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/eltwise.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/engine.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/inner_product.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/lrn.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/memory.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/memory_desc_wrapper.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/mkldnn_debug.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/pooling.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/primitive.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/primitive_attr.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/primitive_desc.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/primitive_iterator.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/query.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/reorder.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/rnn.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/scratchpad.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/softmax.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/stream.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/utils.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/common/verbose.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_barrier.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_batch_normalization_utils.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_concat.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_engine.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_reducer.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_reorder.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/cpu_sum.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/gemm_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/gemm_convolution_utils.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/gemm_inner_product.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/gemm_u8s8s32x_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx2_1x1_conv_kernel_f32.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx2_1x1_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx2_conv_kernel_f32.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx2_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx2_gemm_f32.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_1x1_conv_kernel.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_1x1_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_conv_kernel.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_conv_winograd_kernel_f32.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_convolution_winograd.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_gemm_f32.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_common_lrn.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_conv_winograd_kernel_f32.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_convolution_winograd.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_i8i8_pooling.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_u8s8s32x_1x1_conv_kernel.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_u8s8s32x_1x1_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_u8s8s32x_conv_kernel.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_u8s8s32x_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_avx512_core_u8s8s32x_wino_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_sse42_1x1_conv_kernel_f32.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_sse42_1x1_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_sse42_conv_kernel_f32.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_sse42_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_transpose_src_utils.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_batch_normalization.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_dw_conv_kernel_f32.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_dw_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_eltwise.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_inner_product.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_lrn.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_lrn_kernel_f32.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_pool_kernel_f32.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_pooling.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_reorder.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/jit_uni_reorder_utils.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/nchw_pooling.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ncsp_batch_normalization.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/nspc_batch_normalization.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_batch_normalization.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_convolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_deconvolution.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_eltwise.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_inner_product.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_lrn.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_pooling.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_rnn.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/ref_softmax.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/simple_concat.pic.o \
		blake-bin/mkl_dnn/_objs/mkl_dnn/src/cpu/simple_sum.pic.o
	$(AR) $(ARFLAGS) $@ $^

mkl_dnn_mkl_dnn_SPLINK = blake-bin/mkl_dnn/libmkl_dnn.pic.a

blake-bin/mkl_dnn/libmkl_dnn.so: $(mkl_dnn_mkl_dnn_SPLINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(mkl_dnn_mkl_dnn_SPLINK) $(NOWA) 

################################################################################
# //tensorflow/core:framework_internal_impl

tensorflow_core_framework_internal_impl_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_framework_internal_impl_LDLIBS = -ldl -lm

tensorflow_core_framework_internal_impl_HEADERS = \
	tensorflow/core/framework/op_segment.h \
	tensorflow/core/framework/rendezvous.h \
	tensorflow/core/framework/resource_var.h \
	tensorflow/core/framework/tensor_reference.h \
	tensorflow/core/framework/tracking_allocator.h \
	tensorflow/core/framework/unique_tensor_references.h \
	tensorflow/core/framework/variant.h \
	tensorflow/core/util/command_line_flags.h \
	tensorflow/core/util/env_var.h \
	tensorflow/core/util/equal_graph_def.h \
	tensorflow/core/util/presized_cuckoo_map.h \
	tensorflow/core/util/tensor_slice_set.h \
	tensorflow/core/util/tensor_slice_util.h

tensorflow_core_framework_internal_impl_LINK = \
	blake-bin/tensorflow/core/libframework_internal_impl.so

tensorflow_core_framework_internal_impl_COMPILE_IQUOTES = \
	-iquote . \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_framework_internal_impl_COMPILE_CPPFLAGS = \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_framework_internal_impl_COMPILE_HEADERS = \
	tensorflow/core/graph/edgeset.h \
	tensorflow/core/graph/graph.h \
	tensorflow/core/graph/graph_def_builder.h \
	tensorflow/core/graph/node_builder.h \
	tensorflow/core/graph/tensor_id.h \
	tensorflow/core/example/feature_util.h \
	tensorflow/core/framework/allocator.h \
	tensorflow/core/framework/allocator_registry.h \
	tensorflow/core/framework/attr_value_util.h \
	tensorflow/core/framework/bfloat16.h \
	tensorflow/core/framework/cancellation.h \
	tensorflow/core/framework/collective.h \
	tensorflow/core/framework/common_shape_fns.h \
	tensorflow/core/framework/control_flow.h \
	tensorflow/core/framework/dataset.h \
	tensorflow/core/framework/dataset_stateful_op_whitelist.h \
	tensorflow/core/framework/device_base.h \
	tensorflow/core/framework/function.h \
	tensorflow/core/framework/graph_def_util.h \
	tensorflow/core/framework/graph_to_functiondef.h \
	tensorflow/core/framework/kernel_def_builder.h \
	tensorflow/core/framework/kernel_def_util.h \
	tensorflow/core/framework/log_memory.h \
	tensorflow/core/framework/lookup_interface.h \
	tensorflow/core/framework/memory_types.h \
	tensorflow/core/framework/node_def_builder.h \
	tensorflow/core/framework/node_def_util.h \
	tensorflow/core/framework/numeric_op.h \
	tensorflow/core/framework/numeric_types.h \
	tensorflow/core/framework/op.h \
	tensorflow/core/framework/op_def_builder.h \
	tensorflow/core/framework/op_def_util.h \
	tensorflow/core/framework/op_kernel.h \
	tensorflow/core/framework/op_segment.h \
	tensorflow/core/framework/partial_tensor_shape.h \
	tensorflow/core/framework/queue_interface.h \
	tensorflow/core/framework/reader_interface.h \
	tensorflow/core/framework/reader_op_kernel.h \
	tensorflow/core/framework/register_types.h \
	tensorflow/core/framework/register_types_traits.h \
	tensorflow/core/framework/rendezvous.h \
	tensorflow/core/framework/resource_handle.h \
	tensorflow/core/framework/resource_mgr.h \
	tensorflow/core/framework/resource_op_kernel.h \
	tensorflow/core/framework/resource_var.h \
	tensorflow/core/framework/selective_registration.h \
	tensorflow/core/framework/session_state.h \
	tensorflow/core/framework/shape_inference.h \
	tensorflow/core/framework/stats_aggregator.h \
	tensorflow/core/framework/tensor.h \
	tensorflow/core/framework/tensor_reference.h \
	tensorflow/core/framework/tensor_shape.h \
	tensorflow/core/framework/tensor_slice.h \
	tensorflow/core/framework/tensor_types.h \
	tensorflow/core/framework/tensor_util.h \
	tensorflow/core/framework/tracking_allocator.h \
	tensorflow/core/framework/type_index.h \
	tensorflow/core/framework/type_traits.h \
	tensorflow/core/framework/types.h \
	tensorflow/core/framework/unique_tensor_references.h \
	tensorflow/core/framework/variant.h \
	tensorflow/core/framework/variant_encode_decode.h \
	tensorflow/core/framework/variant_op_registry.h \
	tensorflow/core/framework/variant_tensor_data.h \
	tensorflow/core/framework/versions.h \
	tensorflow/core/util/activation_mode.h \
	tensorflow/core/util/batch_util.h \
	tensorflow/core/util/bcast.h \
	tensorflow/core/util/command_line_flags.h \
	tensorflow/core/util/cuda_device_functions.h \
	tensorflow/core/util/cuda_kernel_helper.h \
	tensorflow/core/util/cuda_launch_config.h \
	tensorflow/core/util/device_name_utils.h \
	tensorflow/core/util/env_var.h \
	tensorflow/core/util/equal_graph_def.h \
	tensorflow/core/util/events_writer.h \
	tensorflow/core/util/example_proto_fast_parsing.h \
	tensorflow/core/util/example_proto_helper.h \
	tensorflow/core/util/exec_on_stall.h \
	tensorflow/core/util/guarded_philox_random.h \
	tensorflow/core/util/matmul_autotune.h \
	tensorflow/core/util/mirror_pad_mode.h \
	tensorflow/core/util/mkl_util.h \
	tensorflow/core/util/overflow.h \
	tensorflow/core/util/padding.h \
	tensorflow/core/util/permutation_input_iterator.h \
	tensorflow/core/util/port.h \
	tensorflow/core/util/presized_cuckoo_map.h \
	tensorflow/core/util/ptr_util.h \
	tensorflow/core/util/reffed_status_callback.h \
	tensorflow/core/util/saved_tensor_slice_util.h \
	tensorflow/core/util/sparse/dim_comparator.h \
	tensorflow/core/util/sparse/group_iterator.h \
	tensorflow/core/util/sparse/sparse_tensor.h \
	tensorflow/core/util/stat_summarizer.h \
	tensorflow/core/util/stat_summarizer_options.h \
	tensorflow/core/util/stats_calculator.h \
	tensorflow/core/util/status_util.h \
	tensorflow/core/util/stream_executor_util.h \
	tensorflow/core/util/strided_slice_op.h \
	tensorflow/core/util/tensor_format.h \
	tensorflow/core/util/tensor_slice_reader.h \
	tensorflow/core/util/tensor_slice_reader_cache.h \
	tensorflow/core/util/tensor_slice_set.h \
	tensorflow/core/util/tensor_slice_util.h \
	tensorflow/core/util/tensor_slice_writer.h \
	tensorflow/core/util/transform_output_iterator.h \
	tensorflow/core/util/use_cudnn.h \
	tensorflow/core/util/util.h \
	tensorflow/core/util/work_sharder.h \
	tensorflow/core/util/memmapped_file_system.h \
	tensorflow/core/util/memmapped_file_system_writer.h \
	tensorflow/core/graph/while_context.h \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/framework_internal_impl/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_framework_internal_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_framework_internal_impl_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_framework_internal_impl_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_framework_internal_impl_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/framework_internal_impl/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_framework_internal_impl_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_framework_internal_impl_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_framework_internal_impl_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_framework_internal_impl_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libframework_internal_impl.a: \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/example/feature_util.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/allocator.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/allocator_registry.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/attr_value_util.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/bfloat16.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/cancellation.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/collective.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/common_shape_fns.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/dataset.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/device_base.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/function.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/graph_def_util.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/graph_to_functiondef.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/kernel_def_builder.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/kernel_def_util.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/load_library.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/log_memory.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/lookup_interface.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/memory_types.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/node_def_builder.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/node_def_util.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/op.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/op_def_builder.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/op_def_util.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/op_kernel.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/op_segment.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/rendezvous.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/resource_mgr.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/shape_inference.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tensor.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tensor_reference.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tensor_shape.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tensor_slice.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tensor_util.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tracking_allocator.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/types.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/unique_tensor_references.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/variant.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/variant_op_registry.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/variant_tensor_data.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/versions.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/edgeset.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/graph.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/graph_def_builder.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/node_builder.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/tensor_id.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/while_context.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/activation_mode.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/batch_util.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/bcast.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/command_line_flags.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/device_name_utils.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/env_var.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/equal_graph_def.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/events_writer.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/example_proto_fast_parsing.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/example_proto_helper.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/guarded_philox_random.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/matmul_autotune.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/mirror_pad_mode.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/padding.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/port.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/saved_tensor_slice_util.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/sparse/group_iterator.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/stat_summarizer.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/strided_slice_op.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/tensor_format.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/tensor_slice_reader.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/tensor_slice_reader_cache.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/tensor_slice_set.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/tensor_slice_writer.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/use_cudnn.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/util.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/work_sharder.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/memmapped_file_system.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/memmapped_file_system_writer.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_framework_internal_impl_SBLINKT = \
	blake-bin/tensorflow/core/libframework_internal_impl.a

tensorflow_core_framework_internal_impl_SBLINKF = \
	$(WA) $(tensorflow_core_framework_internal_impl_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libframework_internal_impl.pic.a: \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/example/feature_util.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/allocator.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/allocator_registry.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/attr_value_util.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/bfloat16.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/cancellation.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/collective.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/common_shape_fns.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/dataset.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/device_base.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/function.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/graph_def_util.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/graph_to_functiondef.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/kernel_def_builder.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/kernel_def_util.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/load_library.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/log_memory.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/lookup_interface.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/memory_types.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/node_def_builder.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/node_def_util.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/op.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/op_def_builder.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/op_def_util.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/op_kernel.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/op_segment.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/rendezvous.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/resource_mgr.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/shape_inference.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tensor.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tensor_reference.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tensor_shape.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tensor_slice.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tensor_util.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/tracking_allocator.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/types.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/unique_tensor_references.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/variant.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/variant_op_registry.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/variant_tensor_data.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/framework/versions.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/edgeset.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/graph.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/graph_def_builder.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/node_builder.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/tensor_id.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/graph/while_context.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/activation_mode.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/batch_util.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/bcast.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/command_line_flags.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/device_name_utils.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/env_var.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/equal_graph_def.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/events_writer.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/example_proto_fast_parsing.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/example_proto_helper.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/guarded_philox_random.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/matmul_autotune.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/mirror_pad_mode.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/padding.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/port.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/saved_tensor_slice_util.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/sparse/group_iterator.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/stat_summarizer.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/strided_slice_op.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/tensor_format.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/tensor_slice_reader.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/tensor_slice_reader_cache.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/tensor_slice_set.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/tensor_slice_writer.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/use_cudnn.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/util.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/work_sharder.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/memmapped_file_system.pic.o \
		blake-bin/tensorflow/core/_objs/framework_internal_impl/util/memmapped_file_system_writer.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_framework_internal_impl_SPLINKT = \
	blake-bin/tensorflow/core/libframework_internal_impl.pic.a

tensorflow_core_framework_internal_impl_SPLINKF = \
	$(WA) $(tensorflow_core_framework_internal_impl_SPLINKT) $(NOWA)

blake-bin/tensorflow/core/libframework_internal_impl.so: \
		$(tensorflow_core_framework_internal_impl_SPLINKT) \
		$(protobuf_archive_protobuf_LINK) \
		$(nsync_nsync_cpp_LINK) \
		$(tensorflow_core_version_lib_LINK) \
		$(tensorflow_core_stats_calculator_portable_LINK) \
		$(tensorflow_core_error_codes_proto_text_LINK) \
		$(tensorflow_core_protos_all_proto_text_LINK)
	$(CXX) -shared $(LDFLAGS.security)  $(LDFLAGS) -o $@ $(WA) $(tensorflow_core_framework_internal_impl_SPLINKT) $(NOWA) $(protobuf_archive_protobuf_LINK) $(nsync_nsync_cpp_LINK) $(tensorflow_core_version_lib_LINK) $(tensorflow_core_stats_calculator_portable_LINK) $(tensorflow_core_error_codes_proto_text_LINK) $(tensorflow_core_protos_all_proto_text_LINK) $(tensorflow_core_framework_internal_impl_LDLIBS)

################################################################################
# //tensorflow/core:framework_internal

tensorflow_core_framework_internal_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_framework_internal_HEADERS = \
	tensorflow/core/framework/op_segment.h \
	tensorflow/core/framework/rendezvous.h \
	tensorflow/core/framework/resource_var.h \
	tensorflow/core/framework/tensor_reference.h \
	tensorflow/core/framework/tracking_allocator.h \
	tensorflow/core/framework/unique_tensor_references.h \
	tensorflow/core/framework/variant.h \
	tensorflow/core/util/command_line_flags.h \
	tensorflow/core/util/env_var.h \
	tensorflow/core/util/equal_graph_def.h \
	tensorflow/core/util/presized_cuckoo_map.h \
	tensorflow/core/util/tensor_slice_set.h \
	tensorflow/core/util/tensor_slice_util.h

################################################################################
# //tensorflow/core:framework

tensorflow_core_framework_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_framework_HEADERS = \
	tensorflow/core/example/feature_util.h \
	tensorflow/core/framework/allocator.h \
	tensorflow/core/framework/variant.h \
	tensorflow/core/framework/variant_encode_decode.h \
	tensorflow/core/framework/variant_op_registry.h \
	tensorflow/core/framework/variant_tensor_data.h \
	tensorflow/core/framework/allocator_registry.h \
	tensorflow/core/framework/attr_value_util.h \
	tensorflow/core/framework/bfloat16.h \
	tensorflow/core/framework/cancellation.h \
	tensorflow/core/framework/collective.h \
	tensorflow/core/framework/common_shape_fns.h \
	tensorflow/core/framework/control_flow.h \
	tensorflow/core/framework/dataset.h \
	tensorflow/core/framework/dataset_stateful_op_whitelist.h \
	tensorflow/core/framework/device_base.h \
	tensorflow/core/framework/function.h \
	tensorflow/core/framework/graph_def_util.h \
	tensorflow/core/framework/graph_to_functiondef.h \
	tensorflow/core/framework/kernel_def_builder.h \
	tensorflow/core/framework/kernel_def_util.h \
	tensorflow/core/framework/log_memory.h \
	tensorflow/core/framework/lookup_interface.h \
	tensorflow/core/framework/memory_types.h \
	tensorflow/core/framework/node_def_builder.h \
	tensorflow/core/framework/node_def_util.h \
	tensorflow/core/framework/numeric_op.h \
	tensorflow/core/framework/numeric_types.h \
	tensorflow/core/framework/op.h \
	tensorflow/core/framework/op_def_builder.h \
	tensorflow/core/framework/op_def_util.h \
	tensorflow/core/framework/op_kernel.h \
	tensorflow/core/framework/partial_tensor_shape.h \
	tensorflow/core/framework/queue_interface.h \
	tensorflow/core/framework/reader_interface.h \
	tensorflow/core/framework/reader_op_kernel.h \
	tensorflow/core/framework/register_types.h \
	tensorflow/core/framework/register_types_traits.h \
	tensorflow/core/framework/resource_mgr.h \
	tensorflow/core/framework/resource_op_kernel.h \
	tensorflow/core/framework/selective_registration.h \
	tensorflow/core/framework/session_state.h \
	tensorflow/core/framework/shape_inference.h \
	tensorflow/core/framework/stats_aggregator.h \
	tensorflow/core/framework/tensor.h \
	tensorflow/core/framework/tensor_shape.h \
	tensorflow/core/framework/tensor_slice.h \
	tensorflow/core/framework/tensor_types.h \
	tensorflow/core/framework/tensor_util.h \
	tensorflow/core/framework/tracking_allocator.h \
	tensorflow/core/framework/type_index.h \
	tensorflow/core/framework/type_traits.h \
	tensorflow/core/framework/types.h \
	tensorflow/core/public/version.h \
	tensorflow/core/util/activation_mode.h \
	tensorflow/core/util/batch_util.h \
	tensorflow/core/util/bcast.h \
	tensorflow/core/util/cuda_kernel_helper.h \
	tensorflow/core/util/device_name_utils.h \
	tensorflow/core/util/env_var.h \
	tensorflow/core/util/events_writer.h \
	tensorflow/core/util/example_proto_fast_parsing.h \
	tensorflow/core/util/example_proto_helper.h \
	tensorflow/core/util/guarded_philox_random.h \
	tensorflow/core/util/mirror_pad_mode.h \
	tensorflow/core/util/padding.h \
	tensorflow/core/util/port.h \
	tensorflow/core/util/ptr_util.h \
	tensorflow/core/util/reffed_status_callback.h \
	tensorflow/core/util/saved_tensor_slice_util.h \
	tensorflow/core/util/sparse/group_iterator.h \
	tensorflow/core/util/sparse/sparse_tensor.h \
	tensorflow/core/util/stat_summarizer.h \
	tensorflow/core/util/stat_summarizer_options.h \
	tensorflow/core/util/stream_executor_util.h \
	tensorflow/core/util/strided_slice_op.h \
	tensorflow/core/util/tensor_format.h \
	tensorflow/core/util/tensor_slice_reader.h \
	tensorflow/core/util/tensor_slice_reader_cache.h \
	tensorflow/core/util/tensor_slice_writer.h \
	tensorflow/core/util/use_cudnn.h \
	tensorflow/core/util/matmul_autotune.h \
	tensorflow/core/util/util.h \
	tensorflow/core/util/work_sharder.h \
	tensorflow/core/util/memmapped_file_system.h \
	tensorflow/core/util/memmapped_file_system_writer.h

################################################################################
# //tensorflow/contrib/cloud:bigquery_reader_ops_op_lib

tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_LINKT = \
	$(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_SPLINKT) \
	$(protobuf_archive_protobuf_LINK) \
	$(tensorflow_core_framework_internal_impl_LINK)

tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_LINKF = \
	$(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_SPLINKF) \
	$(protobuf_archive_protobuf_LINK) \
	$(tensorflow_core_framework_internal_impl_LINK)

tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_COMPILE_CPPFLAGS = \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/contrib/cloud/_objs/bigquery_reader_ops_op_lib/%.pic.o: \
		tensorflow/contrib/cloud/%.cc \
		$(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/contrib/cloud/_objs/bigquery_reader_ops_op_lib/%.o: \
		tensorflow/contrib/cloud/%.cc \
		$(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/contrib/cloud/libbigquery_reader_ops_op_lib.a: \
		blake-bin/tensorflow/contrib/cloud/_objs/bigquery_reader_ops_op_lib/ops/bigquery_reader_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/contrib/cloud/libbigquery_reader_ops_op_lib.a

tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/contrib/cloud/libbigquery_reader_ops_op_lib.pic.a: \
		blake-bin/tensorflow/contrib/cloud/_objs/bigquery_reader_ops_op_lib/ops/bigquery_reader_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/contrib/cloud/libbigquery_reader_ops_op_lib.pic.a

tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_contrib_cloud_bigquery_reader_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/contrib/cloud:gcs_config_ops_op_lib

tensorflow_contrib_cloud_gcs_config_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_contrib_cloud_gcs_config_ops_op_lib_LINKT = \
	$(tensorflow_contrib_cloud_gcs_config_ops_op_lib_SPLINKT)

tensorflow_contrib_cloud_gcs_config_ops_op_lib_LINKF = \
	$(tensorflow_contrib_cloud_gcs_config_ops_op_lib_SPLINKF)

tensorflow_contrib_cloud_gcs_config_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_contrib_cloud_gcs_config_ops_op_lib_COMPILE_CPPFLAGS = \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_contrib_cloud_gcs_config_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/contrib/cloud/_objs/gcs_config_ops_op_lib/%.pic.o: \
		tensorflow/contrib/cloud/%.cc \
		$(tensorflow_contrib_cloud_gcs_config_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_contrib_cloud_gcs_config_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_contrib_cloud_gcs_config_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_contrib_cloud_gcs_config_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/contrib/cloud/_objs/gcs_config_ops_op_lib/%.o: \
		tensorflow/contrib/cloud/%.cc \
		$(tensorflow_contrib_cloud_gcs_config_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_contrib_cloud_gcs_config_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_contrib_cloud_gcs_config_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_contrib_cloud_gcs_config_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/contrib/cloud/libgcs_config_ops_op_lib.a: \
		blake-bin/tensorflow/contrib/cloud/_objs/gcs_config_ops_op_lib/ops/gcs_config_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_contrib_cloud_gcs_config_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/contrib/cloud/libgcs_config_ops_op_lib.a

tensorflow_contrib_cloud_gcs_config_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_contrib_cloud_gcs_config_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/contrib/cloud/libgcs_config_ops_op_lib.pic.a: \
		blake-bin/tensorflow/contrib/cloud/_objs/gcs_config_ops_op_lib/ops/gcs_config_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_contrib_cloud_gcs_config_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/contrib/cloud/libgcs_config_ops_op_lib.pic.a

tensorflow_contrib_cloud_gcs_config_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_contrib_cloud_gcs_config_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:array_ops_op_lib

tensorflow_core_array_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_array_ops_op_lib_LINKT = \
	$(tensorflow_core_array_ops_op_lib_SPLINKT)

tensorflow_core_array_ops_op_lib_LINKF = \
	$(tensorflow_core_array_ops_op_lib_SPLINKF)

tensorflow_core_array_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote protobuf_archive \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_array_ops_op_lib_COMPILE_CPPFLAGS = \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_array_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/array_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_array_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_array_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_array_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_array_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/array_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_array_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_array_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_array_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_array_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libarray_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/array_ops_op_lib/ops/array_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_array_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libarray_ops_op_lib.a

tensorflow_core_array_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_array_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libarray_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/array_ops_op_lib/ops/array_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_array_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libarray_ops_op_lib.pic.a

tensorflow_core_array_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_array_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:audio_ops_op_lib

tensorflow_core_audio_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_audio_ops_op_lib_LINKT = \
	$(tensorflow_core_audio_ops_op_lib_SPLINKT)

tensorflow_core_audio_ops_op_lib_LINKF = \
	$(tensorflow_core_audio_ops_op_lib_SPLINKF)

tensorflow_core_audio_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_audio_ops_op_lib_COMPILE_CPPFLAGS = \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_audio_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/audio_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_audio_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_audio_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_audio_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_audio_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/audio_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_audio_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_audio_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_audio_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_audio_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libaudio_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/audio_ops_op_lib/ops/audio_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_audio_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libaudio_ops_op_lib.a

tensorflow_core_audio_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_audio_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libaudio_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/audio_ops_op_lib/ops/audio_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_audio_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libaudio_ops_op_lib.pic.a

tensorflow_core_audio_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_audio_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:batch_ops_op_lib

tensorflow_core_batch_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_batch_ops_op_lib_LINKT = \
	$(tensorflow_core_batch_ops_op_lib_SPLINKT)

tensorflow_core_batch_ops_op_lib_LINKF = \
	$(tensorflow_core_batch_ops_op_lib_SPLINKF)

tensorflow_core_batch_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_batch_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_batch_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/batch_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_batch_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_batch_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_batch_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_batch_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/batch_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_batch_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_batch_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_batch_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_batch_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libbatch_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/batch_ops_op_lib/ops/batch_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_batch_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libbatch_ops_op_lib.a

tensorflow_core_batch_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_batch_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libbatch_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/batch_ops_op_lib/ops/batch_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_batch_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libbatch_ops_op_lib.pic.a

tensorflow_core_batch_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_batch_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:bitwise_ops_op_lib

tensorflow_core_bitwise_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_bitwise_ops_op_lib_LINKT = \
	$(tensorflow_core_bitwise_ops_op_lib_SPLINKT)

tensorflow_core_bitwise_ops_op_lib_LINKF = \
	$(tensorflow_core_bitwise_ops_op_lib_SPLINKF)

tensorflow_core_bitwise_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_bitwise_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_bitwise_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/bitwise_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_bitwise_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_bitwise_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_bitwise_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_bitwise_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/bitwise_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_bitwise_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_bitwise_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_bitwise_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_bitwise_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libbitwise_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/bitwise_ops_op_lib/ops/bitwise_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_bitwise_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libbitwise_ops_op_lib.a

tensorflow_core_bitwise_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_bitwise_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libbitwise_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/bitwise_ops_op_lib/ops/bitwise_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_bitwise_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libbitwise_ops_op_lib.pic.a

tensorflow_core_bitwise_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_bitwise_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:boosted_trees_ops_op_lib

tensorflow_core_boosted_trees_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_boosted_trees_ops_op_lib_LINKT = \
	$(tensorflow_core_boosted_trees_ops_op_lib_SPLINKT)

tensorflow_core_boosted_trees_ops_op_lib_LINKF = \
	$(tensorflow_core_boosted_trees_ops_op_lib_SPLINKF)

tensorflow_core_boosted_trees_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_boosted_trees_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_boosted_trees_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/boosted_trees_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_boosted_trees_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_boosted_trees_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_boosted_trees_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_boosted_trees_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/boosted_trees_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_boosted_trees_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_boosted_trees_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_boosted_trees_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_boosted_trees_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libboosted_trees_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/boosted_trees_ops_op_lib/ops/boosted_trees_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_boosted_trees_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libboosted_trees_ops_op_lib.a

tensorflow_core_boosted_trees_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_boosted_trees_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libboosted_trees_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/boosted_trees_ops_op_lib/ops/boosted_trees_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_boosted_trees_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libboosted_trees_ops_op_lib.pic.a

tensorflow_core_boosted_trees_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_boosted_trees_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:candidate_sampling_ops_op_lib

tensorflow_core_candidate_sampling_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_candidate_sampling_ops_op_lib_LINKT = \
	$(tensorflow_core_candidate_sampling_ops_op_lib_SPLINKT)

tensorflow_core_candidate_sampling_ops_op_lib_LINKF = \
	$(tensorflow_core_candidate_sampling_ops_op_lib_SPLINKF)

tensorflow_core_candidate_sampling_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_candidate_sampling_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_candidate_sampling_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/candidate_sampling_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_candidate_sampling_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_candidate_sampling_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_candidate_sampling_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_candidate_sampling_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/candidate_sampling_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_candidate_sampling_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_candidate_sampling_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_candidate_sampling_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_candidate_sampling_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libcandidate_sampling_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/candidate_sampling_ops_op_lib/ops/candidate_sampling_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_candidate_sampling_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libcandidate_sampling_ops_op_lib.a

tensorflow_core_candidate_sampling_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_candidate_sampling_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libcandidate_sampling_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/candidate_sampling_ops_op_lib/ops/candidate_sampling_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_candidate_sampling_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libcandidate_sampling_ops_op_lib.pic.a

tensorflow_core_candidate_sampling_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_candidate_sampling_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:checkpoint_ops_op_lib

tensorflow_core_checkpoint_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_checkpoint_ops_op_lib_LINKT = \
	$(tensorflow_core_checkpoint_ops_op_lib_SPLINKT)

tensorflow_core_checkpoint_ops_op_lib_LINKF = \
	$(tensorflow_core_checkpoint_ops_op_lib_SPLINKF)

tensorflow_core_checkpoint_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_checkpoint_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_checkpoint_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/checkpoint_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_checkpoint_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_checkpoint_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_checkpoint_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_checkpoint_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/checkpoint_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_checkpoint_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_checkpoint_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_checkpoint_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_checkpoint_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libcheckpoint_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/checkpoint_ops_op_lib/ops/checkpoint_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_checkpoint_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libcheckpoint_ops_op_lib.a

tensorflow_core_checkpoint_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_checkpoint_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libcheckpoint_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/checkpoint_ops_op_lib/ops/checkpoint_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_checkpoint_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libcheckpoint_ops_op_lib.pic.a

tensorflow_core_checkpoint_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_checkpoint_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:collective_ops_op_lib

tensorflow_core_collective_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_collective_ops_op_lib_LINKT = \
	$(tensorflow_core_collective_ops_op_lib_SPLINKT)

tensorflow_core_collective_ops_op_lib_LINKF = \
	$(tensorflow_core_collective_ops_op_lib_SPLINKF)

tensorflow_core_collective_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_collective_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_collective_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/collective_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_collective_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_collective_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_collective_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_collective_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/collective_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_collective_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_collective_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_collective_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_collective_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libcollective_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/collective_ops_op_lib/ops/collective_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_collective_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libcollective_ops_op_lib.a

tensorflow_core_collective_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_collective_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libcollective_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/collective_ops_op_lib/ops/collective_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_collective_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libcollective_ops_op_lib.pic.a

tensorflow_core_collective_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_collective_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:control_flow_ops_op_lib

tensorflow_core_control_flow_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_control_flow_ops_op_lib_LINKT = \
	$(tensorflow_core_control_flow_ops_op_lib_SPLINKT)

tensorflow_core_control_flow_ops_op_lib_LINKF = \
	$(tensorflow_core_control_flow_ops_op_lib_SPLINKF)

tensorflow_core_control_flow_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_control_flow_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_control_flow_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/control_flow_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_control_flow_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_control_flow_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_control_flow_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_control_flow_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/control_flow_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_control_flow_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_control_flow_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_control_flow_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_control_flow_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libcontrol_flow_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/control_flow_ops_op_lib/ops/control_flow_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_control_flow_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libcontrol_flow_ops_op_lib.a

tensorflow_core_control_flow_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_control_flow_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libcontrol_flow_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/control_flow_ops_op_lib/ops/control_flow_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_control_flow_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libcontrol_flow_ops_op_lib.pic.a

tensorflow_core_control_flow_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_control_flow_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:ctc_ops_op_lib

tensorflow_core_ctc_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_ctc_ops_op_lib_LINKT = $(tensorflow_core_ctc_ops_op_lib_SPLINKT)
tensorflow_core_ctc_ops_op_lib_LINKF = $(tensorflow_core_ctc_ops_op_lib_SPLINKF)

tensorflow_core_ctc_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_ctc_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_ctc_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/ctc_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_ctc_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_ctc_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_ctc_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_ctc_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/ctc_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_ctc_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_ctc_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_ctc_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_ctc_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libctc_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/ctc_ops_op_lib/ops/ctc_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_ctc_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libctc_ops_op_lib.a

tensorflow_core_ctc_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_ctc_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libctc_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/ctc_ops_op_lib/ops/ctc_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_ctc_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libctc_ops_op_lib.pic.a

tensorflow_core_ctc_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_ctc_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:cudnn_rnn_ops_op_lib

tensorflow_core_cudnn_rnn_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_cudnn_rnn_ops_op_lib_LINKT = \
	$(tensorflow_core_cudnn_rnn_ops_op_lib_SPLINKT)

tensorflow_core_cudnn_rnn_ops_op_lib_LINKF = \
	$(tensorflow_core_cudnn_rnn_ops_op_lib_SPLINKF)

tensorflow_core_cudnn_rnn_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_cudnn_rnn_ops_op_lib_COMPILE_CPPFLAGS = \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_cudnn_rnn_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/cudnn_rnn_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_cudnn_rnn_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_cudnn_rnn_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_cudnn_rnn_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_cudnn_rnn_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/cudnn_rnn_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_cudnn_rnn_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_cudnn_rnn_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_cudnn_rnn_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_cudnn_rnn_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libcudnn_rnn_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/cudnn_rnn_ops_op_lib/ops/cudnn_rnn_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_cudnn_rnn_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libcudnn_rnn_ops_op_lib.a

tensorflow_core_cudnn_rnn_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_cudnn_rnn_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libcudnn_rnn_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/cudnn_rnn_ops_op_lib/ops/cudnn_rnn_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_cudnn_rnn_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libcudnn_rnn_ops_op_lib.pic.a

tensorflow_core_cudnn_rnn_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_cudnn_rnn_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:data_flow_ops_op_lib

tensorflow_core_data_flow_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_data_flow_ops_op_lib_LINKT = \
	$(tensorflow_core_data_flow_ops_op_lib_SPLINKT)

tensorflow_core_data_flow_ops_op_lib_LINKF = \
	$(tensorflow_core_data_flow_ops_op_lib_SPLINKF)

tensorflow_core_data_flow_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_data_flow_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_data_flow_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/data_flow_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_data_flow_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_data_flow_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_data_flow_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_data_flow_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/data_flow_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_data_flow_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_data_flow_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_data_flow_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_data_flow_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libdata_flow_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/data_flow_ops_op_lib/ops/data_flow_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_data_flow_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libdata_flow_ops_op_lib.a

tensorflow_core_data_flow_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_data_flow_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libdata_flow_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/data_flow_ops_op_lib/ops/data_flow_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_data_flow_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libdata_flow_ops_op_lib.pic.a

tensorflow_core_data_flow_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_data_flow_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:dataset_ops_op_lib

tensorflow_core_dataset_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_dataset_ops_op_lib_LINKT = \
	$(tensorflow_core_dataset_ops_op_lib_SPLINKT)

tensorflow_core_dataset_ops_op_lib_LINKF = \
	$(tensorflow_core_dataset_ops_op_lib_SPLINKF)

tensorflow_core_dataset_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_dataset_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_dataset_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/dataset_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_dataset_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_dataset_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_dataset_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_dataset_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/dataset_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_dataset_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_dataset_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_dataset_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_dataset_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libdataset_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/dataset_ops_op_lib/ops/dataset_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_dataset_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libdataset_ops_op_lib.a

tensorflow_core_dataset_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_dataset_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libdataset_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/dataset_ops_op_lib/ops/dataset_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_dataset_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libdataset_ops_op_lib.pic.a

tensorflow_core_dataset_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_dataset_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:decode_proto_ops_op_lib

tensorflow_core_decode_proto_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_decode_proto_ops_op_lib_LINKT = \
	$(tensorflow_core_decode_proto_ops_op_lib_SPLINKT)

tensorflow_core_decode_proto_ops_op_lib_LINKF = \
	$(tensorflow_core_decode_proto_ops_op_lib_SPLINKF)

tensorflow_core_decode_proto_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_decode_proto_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_decode_proto_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/decode_proto_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_decode_proto_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_decode_proto_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_decode_proto_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_decode_proto_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/decode_proto_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_decode_proto_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_decode_proto_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_decode_proto_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_decode_proto_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libdecode_proto_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/decode_proto_ops_op_lib/ops/decode_proto_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_decode_proto_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libdecode_proto_ops_op_lib.a

tensorflow_core_decode_proto_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_decode_proto_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libdecode_proto_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/decode_proto_ops_op_lib/ops/decode_proto_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_decode_proto_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libdecode_proto_ops_op_lib.pic.a

tensorflow_core_decode_proto_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_decode_proto_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:encode_proto_ops_op_lib

tensorflow_core_encode_proto_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_encode_proto_ops_op_lib_LINKT = \
	$(tensorflow_core_encode_proto_ops_op_lib_SPLINKT)

tensorflow_core_encode_proto_ops_op_lib_LINKF = \
	$(tensorflow_core_encode_proto_ops_op_lib_SPLINKF)

tensorflow_core_encode_proto_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_encode_proto_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_encode_proto_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/encode_proto_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_encode_proto_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_encode_proto_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_encode_proto_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_encode_proto_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/encode_proto_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_encode_proto_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_encode_proto_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_encode_proto_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_encode_proto_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libencode_proto_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/encode_proto_ops_op_lib/ops/encode_proto_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_encode_proto_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libencode_proto_ops_op_lib.a

tensorflow_core_encode_proto_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_encode_proto_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libencode_proto_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/encode_proto_ops_op_lib/ops/encode_proto_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_encode_proto_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libencode_proto_ops_op_lib.pic.a

tensorflow_core_encode_proto_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_encode_proto_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:function_ops_op_lib

tensorflow_core_function_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_function_ops_op_lib_LINKT = \
	$(tensorflow_core_function_ops_op_lib_SPLINKT)

tensorflow_core_function_ops_op_lib_LINKF = \
	$(tensorflow_core_function_ops_op_lib_SPLINKF)

tensorflow_core_function_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_function_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_function_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/function_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_function_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_function_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_function_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_function_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/function_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_function_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_function_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_function_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_function_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libfunction_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/function_ops_op_lib/ops/function_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_function_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libfunction_ops_op_lib.a

tensorflow_core_function_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_function_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libfunction_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/function_ops_op_lib/ops/function_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_function_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libfunction_ops_op_lib.pic.a

tensorflow_core_function_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_function_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:functional_ops_op_lib

tensorflow_core_functional_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_functional_ops_op_lib_LINKT = \
	$(tensorflow_core_functional_ops_op_lib_SPLINKT)

tensorflow_core_functional_ops_op_lib_LINKF = \
	$(tensorflow_core_functional_ops_op_lib_SPLINKF)

tensorflow_core_functional_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_functional_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_functional_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/functional_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_functional_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_functional_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_functional_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_functional_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/functional_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_functional_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_functional_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_functional_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_functional_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libfunctional_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/functional_ops_op_lib/ops/functional_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_functional_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libfunctional_ops_op_lib.a

tensorflow_core_functional_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_functional_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libfunctional_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/functional_ops_op_lib/ops/functional_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_functional_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libfunctional_ops_op_lib.pic.a

tensorflow_core_functional_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_functional_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:image_ops_op_lib

tensorflow_core_image_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_image_ops_op_lib_LINKT = \
	$(tensorflow_core_image_ops_op_lib_SPLINKT)

tensorflow_core_image_ops_op_lib_LINKF = \
	$(tensorflow_core_image_ops_op_lib_SPLINKF)

tensorflow_core_image_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_image_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_image_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/image_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_image_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_image_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_image_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_image_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/image_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_image_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_image_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_image_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_image_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libimage_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/image_ops_op_lib/ops/image_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_image_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libimage_ops_op_lib.a

tensorflow_core_image_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_image_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libimage_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/image_ops_op_lib/ops/image_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_image_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libimage_ops_op_lib.pic.a

tensorflow_core_image_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_image_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:io_ops_op_lib

tensorflow_core_io_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_io_ops_op_lib_LINKT = $(tensorflow_core_io_ops_op_lib_SPLINKT)
tensorflow_core_io_ops_op_lib_LINKF = $(tensorflow_core_io_ops_op_lib_SPLINKF)

tensorflow_core_io_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_io_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_io_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/io_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_io_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_io_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_io_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_io_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/io_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_io_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_io_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_io_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_io_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libio_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/io_ops_op_lib/ops/io_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_io_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libio_ops_op_lib.a

tensorflow_core_io_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_io_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libio_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/io_ops_op_lib/ops/io_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_io_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libio_ops_op_lib.pic.a

tensorflow_core_io_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_io_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:linalg_ops_op_lib

tensorflow_core_linalg_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_linalg_ops_op_lib_LINKT = \
	$(tensorflow_core_linalg_ops_op_lib_SPLINKT)

tensorflow_core_linalg_ops_op_lib_LINKF = \
	$(tensorflow_core_linalg_ops_op_lib_SPLINKF)

tensorflow_core_linalg_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_linalg_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_linalg_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/linalg_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_linalg_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_linalg_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_linalg_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_linalg_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/linalg_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_linalg_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_linalg_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_linalg_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_linalg_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/liblinalg_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/linalg_ops_op_lib/ops/linalg_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_linalg_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/liblinalg_ops_op_lib.a

tensorflow_core_linalg_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_linalg_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/liblinalg_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/linalg_ops_op_lib/ops/linalg_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_linalg_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/liblinalg_ops_op_lib.pic.a

tensorflow_core_linalg_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_linalg_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:list_ops_op_lib

tensorflow_core_list_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_list_ops_op_lib_LINKT = \
	$(tensorflow_core_list_ops_op_lib_SPLINKT)

tensorflow_core_list_ops_op_lib_LINKF = \
	$(tensorflow_core_list_ops_op_lib_SPLINKF)

tensorflow_core_list_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_list_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_list_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/list_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_list_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_list_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_list_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_list_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/list_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_list_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_list_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_list_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_list_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/liblist_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/list_ops_op_lib/ops/list_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_list_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/liblist_ops_op_lib.a

tensorflow_core_list_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_list_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/liblist_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/list_ops_op_lib/ops/list_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_list_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/liblist_ops_op_lib.pic.a

tensorflow_core_list_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_list_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:logging_ops_op_lib

tensorflow_core_logging_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_logging_ops_op_lib_LINKT = \
	$(tensorflow_core_logging_ops_op_lib_SPLINKT)

tensorflow_core_logging_ops_op_lib_LINKF = \
	$(tensorflow_core_logging_ops_op_lib_SPLINKF)

tensorflow_core_logging_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_logging_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_logging_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/logging_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_logging_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_logging_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_logging_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_logging_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/logging_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_logging_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_logging_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_logging_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_logging_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/liblogging_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/logging_ops_op_lib/ops/logging_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_logging_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/liblogging_ops_op_lib.a

tensorflow_core_logging_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_logging_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/liblogging_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/logging_ops_op_lib/ops/logging_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_logging_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/liblogging_ops_op_lib.pic.a

tensorflow_core_logging_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_logging_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:lookup_ops_op_lib

tensorflow_core_lookup_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_lookup_ops_op_lib_LINKT = \
	$(tensorflow_core_lookup_ops_op_lib_SPLINKT)

tensorflow_core_lookup_ops_op_lib_LINKF = \
	$(tensorflow_core_lookup_ops_op_lib_SPLINKF)

tensorflow_core_lookup_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_lookup_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_lookup_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/lookup_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_lookup_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_lookup_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_lookup_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_lookup_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/lookup_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_lookup_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_lookup_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_lookup_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_lookup_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/liblookup_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/lookup_ops_op_lib/ops/lookup_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_lookup_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/liblookup_ops_op_lib.a

tensorflow_core_lookup_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_lookup_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/liblookup_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/lookup_ops_op_lib/ops/lookup_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_lookup_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/liblookup_ops_op_lib.pic.a

tensorflow_core_lookup_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_lookup_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:manip_ops_op_lib

tensorflow_core_manip_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_manip_ops_op_lib_LINKT = \
	$(tensorflow_core_manip_ops_op_lib_SPLINKT)

tensorflow_core_manip_ops_op_lib_LINKF = \
	$(tensorflow_core_manip_ops_op_lib_SPLINKF)

tensorflow_core_manip_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_manip_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_manip_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/manip_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_manip_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_manip_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_manip_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_manip_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/manip_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_manip_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_manip_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_manip_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_manip_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libmanip_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/manip_ops_op_lib/ops/manip_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_manip_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libmanip_ops_op_lib.a

tensorflow_core_manip_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_manip_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libmanip_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/manip_ops_op_lib/ops/manip_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_manip_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libmanip_ops_op_lib.pic.a

tensorflow_core_manip_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_manip_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:math_ops_op_lib

tensorflow_core_math_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_math_ops_op_lib_LINKT = \
	$(tensorflow_core_math_ops_op_lib_SPLINKT)

tensorflow_core_math_ops_op_lib_LINKF = \
	$(tensorflow_core_math_ops_op_lib_SPLINKF)

tensorflow_core_math_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_math_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_math_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/math_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_math_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_math_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_math_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_math_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/math_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_math_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_math_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_math_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_math_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libmath_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/math_ops_op_lib/ops/math_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_math_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libmath_ops_op_lib.a

tensorflow_core_math_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_math_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libmath_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/math_ops_op_lib/ops/math_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_math_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libmath_ops_op_lib.pic.a

tensorflow_core_math_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_math_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:nn_ops_op_lib

tensorflow_core_nn_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_nn_ops_op_lib_LINKT = $(tensorflow_core_nn_ops_op_lib_SPLINKT)
tensorflow_core_nn_ops_op_lib_LINKF = $(tensorflow_core_nn_ops_op_lib_SPLINKF)

tensorflow_core_nn_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_nn_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_nn_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/nn_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_nn_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_nn_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_nn_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_nn_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/nn_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_nn_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_nn_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_nn_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_nn_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libnn_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/nn_ops_op_lib/ops/nn_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_nn_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libnn_ops_op_lib.a

tensorflow_core_nn_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_nn_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libnn_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/nn_ops_op_lib/ops/nn_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_nn_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libnn_ops_op_lib.pic.a

tensorflow_core_nn_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_nn_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:no_op_op_lib

tensorflow_core_no_op_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_no_op_op_lib_LINKT = $(tensorflow_core_no_op_op_lib_SPLINKT)
tensorflow_core_no_op_op_lib_LINKF = $(tensorflow_core_no_op_op_lib_SPLINKF)

tensorflow_core_no_op_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_no_op_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_no_op_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/no_op_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_no_op_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_no_op_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_no_op_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_no_op_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/no_op_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_no_op_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_no_op_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_no_op_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_no_op_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libno_op_op_lib.a: \
		blake-bin/tensorflow/core/_objs/no_op_op_lib/ops/no_op.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_no_op_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libno_op_op_lib.a

tensorflow_core_no_op_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_no_op_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libno_op_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/no_op_op_lib/ops/no_op.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_no_op_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libno_op_op_lib.pic.a

tensorflow_core_no_op_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_no_op_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:parsing_ops_op_lib

tensorflow_core_parsing_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_parsing_ops_op_lib_LINKT = \
	$(tensorflow_core_parsing_ops_op_lib_SPLINKT)

tensorflow_core_parsing_ops_op_lib_LINKF = \
	$(tensorflow_core_parsing_ops_op_lib_SPLINKF)

tensorflow_core_parsing_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_parsing_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_parsing_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/parsing_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_parsing_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_parsing_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_parsing_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_parsing_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/parsing_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_parsing_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_parsing_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_parsing_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_parsing_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libparsing_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/parsing_ops_op_lib/ops/parsing_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_parsing_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libparsing_ops_op_lib.a

tensorflow_core_parsing_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_parsing_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libparsing_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/parsing_ops_op_lib/ops/parsing_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_parsing_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libparsing_ops_op_lib.pic.a

tensorflow_core_parsing_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_parsing_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:random_ops_op_lib

tensorflow_core_random_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_random_ops_op_lib_LINKT = \
	$(tensorflow_core_random_ops_op_lib_SPLINKT)

tensorflow_core_random_ops_op_lib_LINKF = \
	$(tensorflow_core_random_ops_op_lib_SPLINKF)

tensorflow_core_random_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_random_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_random_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/random_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_random_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_random_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_random_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_random_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/random_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_random_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_random_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_random_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_random_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/librandom_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/random_ops_op_lib/ops/random_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_random_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/librandom_ops_op_lib.a

tensorflow_core_random_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_random_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/librandom_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/random_ops_op_lib/ops/random_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_random_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/librandom_ops_op_lib.pic.a

tensorflow_core_random_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_random_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:remote_fused_graph_ops_op_lib

tensorflow_core_remote_fused_graph_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_remote_fused_graph_ops_op_lib_LINKT = \
	$(tensorflow_core_remote_fused_graph_ops_op_lib_SPLINKT)

tensorflow_core_remote_fused_graph_ops_op_lib_LINKF = \
	$(tensorflow_core_remote_fused_graph_ops_op_lib_SPLINKF)

tensorflow_core_remote_fused_graph_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_remote_fused_graph_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_remote_fused_graph_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/remote_fused_graph_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_remote_fused_graph_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_remote_fused_graph_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_remote_fused_graph_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_remote_fused_graph_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/remote_fused_graph_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_remote_fused_graph_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_remote_fused_graph_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_remote_fused_graph_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_remote_fused_graph_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libremote_fused_graph_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/remote_fused_graph_ops_op_lib/ops/remote_fused_graph_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_remote_fused_graph_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libremote_fused_graph_ops_op_lib.a

tensorflow_core_remote_fused_graph_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_remote_fused_graph_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libremote_fused_graph_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/remote_fused_graph_ops_op_lib/ops/remote_fused_graph_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_remote_fused_graph_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libremote_fused_graph_ops_op_lib.pic.a

tensorflow_core_remote_fused_graph_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_remote_fused_graph_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:resource_variable_ops_op_lib

tensorflow_core_resource_variable_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_resource_variable_ops_op_lib_LINKT = \
	$(tensorflow_core_resource_variable_ops_op_lib_SPLINKT)

tensorflow_core_resource_variable_ops_op_lib_LINKF = \
	$(tensorflow_core_resource_variable_ops_op_lib_SPLINKF)

tensorflow_core_resource_variable_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_resource_variable_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_resource_variable_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/resource_variable_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_resource_variable_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_resource_variable_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_resource_variable_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_resource_variable_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/resource_variable_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_resource_variable_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_resource_variable_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_resource_variable_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_resource_variable_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libresource_variable_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/resource_variable_ops_op_lib/ops/resource_variable_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_resource_variable_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libresource_variable_ops_op_lib.a

tensorflow_core_resource_variable_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_resource_variable_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libresource_variable_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/resource_variable_ops_op_lib/ops/resource_variable_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_resource_variable_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libresource_variable_ops_op_lib.pic.a

tensorflow_core_resource_variable_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_resource_variable_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:rpc_ops_op_lib

tensorflow_core_rpc_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_rpc_ops_op_lib_LINKT = $(tensorflow_core_rpc_ops_op_lib_SPLINKT)
tensorflow_core_rpc_ops_op_lib_LINKF = $(tensorflow_core_rpc_ops_op_lib_SPLINKF)

tensorflow_core_rpc_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_rpc_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_rpc_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/rpc_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_rpc_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_rpc_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_rpc_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_rpc_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/rpc_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_rpc_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_rpc_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_rpc_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_rpc_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/librpc_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/rpc_ops_op_lib/ops/rpc_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_rpc_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/librpc_ops_op_lib.a

tensorflow_core_rpc_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_rpc_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/librpc_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/rpc_ops_op_lib/ops/rpc_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_rpc_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/librpc_ops_op_lib.pic.a

tensorflow_core_rpc_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_rpc_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:scoped_allocator_ops_op_lib

tensorflow_core_scoped_allocator_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_scoped_allocator_ops_op_lib_LINKT = \
	$(tensorflow_core_scoped_allocator_ops_op_lib_SPLINKT)

tensorflow_core_scoped_allocator_ops_op_lib_LINKF = \
	$(tensorflow_core_scoped_allocator_ops_op_lib_SPLINKF)

tensorflow_core_scoped_allocator_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_scoped_allocator_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_scoped_allocator_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/scoped_allocator_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_scoped_allocator_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_scoped_allocator_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_scoped_allocator_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_scoped_allocator_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/scoped_allocator_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_scoped_allocator_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_scoped_allocator_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_scoped_allocator_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_scoped_allocator_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libscoped_allocator_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/scoped_allocator_ops_op_lib/ops/scoped_allocator_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_scoped_allocator_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libscoped_allocator_ops_op_lib.a

tensorflow_core_scoped_allocator_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_scoped_allocator_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libscoped_allocator_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/scoped_allocator_ops_op_lib/ops/scoped_allocator_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_scoped_allocator_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libscoped_allocator_ops_op_lib.pic.a

tensorflow_core_scoped_allocator_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_scoped_allocator_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:script_ops_op_lib

tensorflow_core_script_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_script_ops_op_lib_LINKT = \
	$(tensorflow_core_script_ops_op_lib_SPLINKT)

tensorflow_core_script_ops_op_lib_LINKF = \
	$(tensorflow_core_script_ops_op_lib_SPLINKF)

tensorflow_core_script_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_script_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_script_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/script_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_script_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_script_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_script_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_script_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/script_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_script_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_script_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_script_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_script_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libscript_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/script_ops_op_lib/ops/script_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_script_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libscript_ops_op_lib.a

tensorflow_core_script_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_script_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libscript_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/script_ops_op_lib/ops/script_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_script_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libscript_ops_op_lib.pic.a

tensorflow_core_script_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_script_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:sdca_ops_op_lib

tensorflow_core_sdca_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_sdca_ops_op_lib_LINKT = \
	$(tensorflow_core_sdca_ops_op_lib_SPLINKT)

tensorflow_core_sdca_ops_op_lib_LINKF = \
	$(tensorflow_core_sdca_ops_op_lib_SPLINKF)

tensorflow_core_sdca_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_sdca_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_sdca_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/sdca_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_sdca_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_sdca_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_sdca_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_sdca_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/sdca_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_sdca_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_sdca_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_sdca_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_sdca_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libsdca_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/sdca_ops_op_lib/ops/sdca_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_sdca_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libsdca_ops_op_lib.a

tensorflow_core_sdca_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_sdca_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libsdca_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/sdca_ops_op_lib/ops/sdca_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_sdca_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libsdca_ops_op_lib.pic.a

tensorflow_core_sdca_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_sdca_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:sendrecv_ops_op_lib

tensorflow_core_sendrecv_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_sendrecv_ops_op_lib_LINKT = \
	$(tensorflow_core_sendrecv_ops_op_lib_SPLINKT)

tensorflow_core_sendrecv_ops_op_lib_LINKF = \
	$(tensorflow_core_sendrecv_ops_op_lib_SPLINKF)

tensorflow_core_sendrecv_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_sendrecv_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_sendrecv_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/sendrecv_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_sendrecv_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_sendrecv_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_sendrecv_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_sendrecv_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/sendrecv_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_sendrecv_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_sendrecv_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_sendrecv_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_sendrecv_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libsendrecv_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/sendrecv_ops_op_lib/ops/sendrecv_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_sendrecv_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libsendrecv_ops_op_lib.a

tensorflow_core_sendrecv_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_sendrecv_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libsendrecv_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/sendrecv_ops_op_lib/ops/sendrecv_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_sendrecv_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libsendrecv_ops_op_lib.pic.a

tensorflow_core_sendrecv_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_sendrecv_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:set_ops_op_lib

tensorflow_core_set_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_set_ops_op_lib_LINKT = $(tensorflow_core_set_ops_op_lib_SPLINKT)
tensorflow_core_set_ops_op_lib_LINKF = $(tensorflow_core_set_ops_op_lib_SPLINKF)

tensorflow_core_set_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_set_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_set_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/set_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_set_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_set_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_set_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_set_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/set_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_set_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_set_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_set_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_set_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libset_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/set_ops_op_lib/ops/set_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_set_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libset_ops_op_lib.a

tensorflow_core_set_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_set_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libset_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/set_ops_op_lib/ops/set_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_set_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libset_ops_op_lib.pic.a

tensorflow_core_set_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_set_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:sparse_ops_op_lib

tensorflow_core_sparse_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_sparse_ops_op_lib_LINKT = \
	$(tensorflow_core_sparse_ops_op_lib_SPLINKT)

tensorflow_core_sparse_ops_op_lib_LINKF = \
	$(tensorflow_core_sparse_ops_op_lib_SPLINKF)

tensorflow_core_sparse_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_sparse_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_sparse_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/sparse_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_sparse_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_sparse_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_sparse_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_sparse_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/sparse_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_sparse_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_sparse_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_sparse_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_sparse_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libsparse_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/sparse_ops_op_lib/ops/sparse_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_sparse_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libsparse_ops_op_lib.a

tensorflow_core_sparse_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_sparse_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libsparse_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/sparse_ops_op_lib/ops/sparse_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_sparse_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libsparse_ops_op_lib.pic.a

tensorflow_core_sparse_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_sparse_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:spectral_ops_op_lib

tensorflow_core_spectral_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_spectral_ops_op_lib_LINKT = \
	$(tensorflow_core_spectral_ops_op_lib_SPLINKT)

tensorflow_core_spectral_ops_op_lib_LINKF = \
	$(tensorflow_core_spectral_ops_op_lib_SPLINKF)

tensorflow_core_spectral_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_spectral_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_spectral_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/spectral_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_spectral_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_spectral_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_spectral_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_spectral_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/spectral_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_spectral_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_spectral_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_spectral_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_spectral_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libspectral_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/spectral_ops_op_lib/ops/spectral_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_spectral_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libspectral_ops_op_lib.a

tensorflow_core_spectral_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_spectral_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libspectral_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/spectral_ops_op_lib/ops/spectral_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_spectral_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libspectral_ops_op_lib.pic.a

tensorflow_core_spectral_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_spectral_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:state_ops_op_lib

tensorflow_core_state_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_state_ops_op_lib_LINKT = \
	$(tensorflow_core_state_ops_op_lib_SPLINKT)

tensorflow_core_state_ops_op_lib_LINKF = \
	$(tensorflow_core_state_ops_op_lib_SPLINKF)

tensorflow_core_state_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_state_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_state_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/state_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_state_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_state_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_state_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_state_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/state_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_state_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_state_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_state_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_state_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libstate_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/state_ops_op_lib/ops/state_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_state_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libstate_ops_op_lib.a

tensorflow_core_state_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_state_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libstate_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/state_ops_op_lib/ops/state_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_state_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libstate_ops_op_lib.pic.a

tensorflow_core_state_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_state_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:stateless_random_ops_op_lib

tensorflow_core_stateless_random_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_stateless_random_ops_op_lib_LINKT = \
	$(tensorflow_core_stateless_random_ops_op_lib_SPLINKT)

tensorflow_core_stateless_random_ops_op_lib_LINKF = \
	$(tensorflow_core_stateless_random_ops_op_lib_SPLINKF)

tensorflow_core_stateless_random_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_stateless_random_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_stateless_random_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/stateless_random_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_stateless_random_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_stateless_random_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_stateless_random_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_stateless_random_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/stateless_random_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_stateless_random_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_stateless_random_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_stateless_random_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_stateless_random_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libstateless_random_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/stateless_random_ops_op_lib/ops/stateless_random_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_stateless_random_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libstateless_random_ops_op_lib.a

tensorflow_core_stateless_random_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_stateless_random_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libstateless_random_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/stateless_random_ops_op_lib/ops/stateless_random_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_stateless_random_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libstateless_random_ops_op_lib.pic.a

tensorflow_core_stateless_random_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_stateless_random_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:string_ops_op_lib

tensorflow_core_string_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_string_ops_op_lib_LINKT = \
	$(tensorflow_core_string_ops_op_lib_SPLINKT)

tensorflow_core_string_ops_op_lib_LINKF = \
	$(tensorflow_core_string_ops_op_lib_SPLINKF)

tensorflow_core_string_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_string_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_string_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/string_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_string_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_string_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_string_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_string_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/string_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_string_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_string_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_string_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_string_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libstring_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/string_ops_op_lib/ops/string_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_string_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libstring_ops_op_lib.a

tensorflow_core_string_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_string_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libstring_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/string_ops_op_lib/ops/string_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_string_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libstring_ops_op_lib.pic.a

tensorflow_core_string_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_string_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:summary_ops_op_lib

tensorflow_core_summary_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_summary_ops_op_lib_LINKT = \
	$(tensorflow_core_summary_ops_op_lib_SPLINKT)

tensorflow_core_summary_ops_op_lib_LINKF = \
	$(tensorflow_core_summary_ops_op_lib_SPLINKF)

tensorflow_core_summary_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_summary_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_summary_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/summary_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_summary_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_summary_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_summary_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_summary_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/summary_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_summary_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_summary_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_summary_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_summary_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libsummary_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/summary_ops_op_lib/ops/summary_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_summary_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libsummary_ops_op_lib.a

tensorflow_core_summary_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_summary_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libsummary_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/summary_ops_op_lib/ops/summary_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_summary_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libsummary_ops_op_lib.pic.a

tensorflow_core_summary_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_summary_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:training_ops_op_lib

tensorflow_core_training_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_training_ops_op_lib_LINKT = \
	$(tensorflow_core_training_ops_op_lib_SPLINKT)

tensorflow_core_training_ops_op_lib_LINKF = \
	$(tensorflow_core_training_ops_op_lib_SPLINKF)

tensorflow_core_training_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_training_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_training_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/training_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_training_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_training_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_training_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_training_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/training_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_training_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_training_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_training_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_training_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libtraining_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/training_ops_op_lib/ops/training_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_training_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libtraining_ops_op_lib.a

tensorflow_core_training_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_training_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libtraining_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/training_ops_op_lib/ops/training_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_training_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libtraining_ops_op_lib.pic.a

tensorflow_core_training_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_training_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:user_ops_op_lib

tensorflow_core_user_ops_op_lib_CFLAGS = \
	-DEIGEN_AVOID_STL_ARRAY \
	-Iexternal/gemmlowp \
	-Wno-sign-compare \
	-fno-exceptions \
	-ftemplate-depth=900 \
	-msse3 \
	-DTENSORFLOW_MONOLITHIC_BUILD \
	-pthread

tensorflow_core_user_ops_op_lib_LINKT = \
	$(tensorflow_core_user_ops_op_lib_SPLINKT)

tensorflow_core_user_ops_op_lib_LINKF = \
	$(tensorflow_core_user_ops_op_lib_SPLINKF)

tensorflow_core_user_ops_op_lib_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_user_ops_op_lib_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_user_ops_op_lib_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/user_ops_op_lib/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_user_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_user_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_user_ops_op_lib_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_user_ops_op_lib_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/user_ops_op_lib/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_user_ops_op_lib_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security) $(tensorflow_core_user_ops_op_lib_CFLAGS) $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_user_ops_op_lib_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_user_ops_op_lib_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libuser_ops_op_lib.a: \
		blake-bin/tensorflow/core/_objs/user_ops_op_lib/user_ops/fact.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_user_ops_op_lib_SBLINKT = \
	blake-bin/tensorflow/core/libuser_ops_op_lib.a

tensorflow_core_user_ops_op_lib_SBLINKF = \
	$(WA) $(tensorflow_core_user_ops_op_lib_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libuser_ops_op_lib.pic.a: \
		blake-bin/tensorflow/core/_objs/user_ops_op_lib/user_ops/fact.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_user_ops_op_lib_SPLINKT = \
	blake-bin/tensorflow/core/libuser_ops_op_lib.pic.a

tensorflow_core_user_ops_op_lib_SPLINKF = \
	$(WA) $(tensorflow_core_user_ops_op_lib_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:word2vec_ops

tensorflow_core_word2vec_ops_LINKT = $(tensorflow_core_word2vec_ops_SPLINKT)
tensorflow_core_word2vec_ops_LINKF = $(tensorflow_core_word2vec_ops_SPLINKF)

tensorflow_core_word2vec_ops_COMPILE_IQUOTES = \
	-iquote . \
	-iquote eigen_archive \
	-iquote local_config_sycl \
	-iquote com_google_absl \
	-iquote nsync \
	-iquote gif_archive \
	-iquote jpeg \
	-iquote protobuf_archive \
	-iquote com_googlesource_code_re2 \
	-iquote farmhash_archive \
	-iquote fft2d \
	-iquote highwayhash \
	-iquote zlib_archive \
	-iquote double_conversion \
	-iquote snappy

tensorflow_core_word2vec_ops_COMPILE_CPPFLAGS = \
	$(eigen_archive_eigen_CPPFLAGS) \
	$(tensorflow_core_lib_internal_CPPFLAGS) \
	$(com_google_absl_absl_base_dynamic_annotations_CPPFLAGS) \
	$(nsync_nsync_cpp_CPPFLAGS) \
	$(gif_archive_gif_CPPFLAGS) \
	$(protobuf_archive_protobuf_headers_CPPFLAGS) \
	$(protobuf_archive_protobuf_CPPFLAGS) \
	$(protobuf_archive_protobuf_lite_CPPFLAGS) \
	$(farmhash_archive_farmhash_CPPFLAGS) \
	$(zlib_archive_zlib_CPPFLAGS) \
	$(tensorflow_core_lib_internal_impl_CPPFLAGS) \
	$(double_conversion_double-conversion_CPPFLAGS)

tensorflow_core_word2vec_ops_COMPILE_HEADERS = \
	$(tensorflow_core_framework_HEADERS) \
	$(tensorflow_core_framework_internal_HEADERS) \
	$(tensorflow_core_framework_internal_headers_lib_HEADERS) \
	$(third_party_eigen3_eigen3_HEADERS) \
	$(eigen_archive_eigen_HEADERS) \
	$(tensorflow_core_lib_HEADERS) \
	$(tensorflow_core_lib_internal_HEADERS) \
	$(com_google_absl_absl_base_base_HEADERS) \
	$(com_google_absl_absl_base_base_internal_HEADERS) \
	$(com_google_absl_absl_base_config_HEADERS) \
	$(com_google_absl_absl_base_core_headers_HEADERS) \
	$(com_google_absl_absl_base_dynamic_annotations_HEADERS) \
	$(com_google_absl_absl_base_spinlock_wait_HEADERS) \
	$(nsync_nsync_cpp_HEADERS) \
	$(gif_archive_gif_HEADERS) \
	$(jpeg_jpeg_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_HEADERS) \
	$(protobuf_archive_protobuf_headers_HEADERS) \
	$(tensorflow_core_protos_all_proto_cc_impl_HEADERS) \
	$(protobuf_archive_protobuf_HEADERS) \
	$(protobuf_archive_protobuf_lite_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_HEADERS) \
	$(tensorflow_core_error_codes_proto_cc_impl_HEADERS) \
	$(com_googlesource_code_re2_re2_HEADERS) \
	$(farmhash_archive_farmhash_HEADERS) \
	$(highwayhash_sip_hash_HEADERS) \
	$(highwayhash_arch_specific_HEADERS) \
	$(highwayhash_compiler_specific_HEADERS) \
	$(zlib_archive_zlib_HEADERS) \
	$(tensorflow_core_lib_internal_impl_HEADERS) \
	$(tensorflow_core_lib_proto_parsing_HEADERS) \
	$(tensorflow_core_platform_base_HEADERS) \
	$(tensorflow_core_lib_platform_HEADERS) \
	$(double_conversion_double-conversion_HEADERS) \
	$(tensorflow_core_abi_HEADERS) \
	$(tensorflow_core_core_stringpiece_HEADERS) \
	$(snappy_snappy_HEADERS) \
	$(tensorflow_core_grappler_costs_op_performance_data_cc_impl_HEADERS) \
	$(tensorflow_core_framework_internal_impl_HEADERS) \
	$(tensorflow_core_protos_all_proto_text_HEADERS) \
	$(tensorflow_core_error_codes_proto_text_HEADERS) \
	$(tensorflow_core_stats_calculator_portable_HEADERS) \
	$(tensorflow_core_version_lib_HEADERS) \
	$(tensorflow_core_kernels_bounds_check_HEADERS) \
	$(tensorflow_core_framework_lite_HEADERS)

blake-bin/tensorflow/core/_objs/word2vec_ops/%.pic.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_word2vec_ops_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_word2vec_ops_COMPILE_CPPFLAGS) $(CPPFLAGS) $(tensorflow_core_word2vec_ops_COMPILE_IQUOTES) $(FPIC) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/_objs/word2vec_ops/%.o: \
		tensorflow/core/%.cc \
		$(tensorflow_core_word2vec_ops_COMPILE_HEADERS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS.security)  $(CXXFLAGS) $(CPPFLAGS.security) $(tensorflow_core_word2vec_ops_COMPILE_CPPFLAGS) $(FPIE) $(CPPFLAGS) $(tensorflow_core_word2vec_ops_COMPILE_IQUOTES) $(TARGET_ARCH) -c -o $@ $<

blake-bin/tensorflow/core/libword2vec_ops.a: \
		blake-bin/tensorflow/core/_objs/word2vec_ops/ops/word2vec_ops.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_word2vec_ops_SBLINKT = \
	blake-bin/tensorflow/core/libword2vec_ops.a

tensorflow_core_word2vec_ops_SBLINKF = \
	$(WA) $(tensorflow_core_word2vec_ops_SBLINKT) $(NOWA)

blake-bin/tensorflow/core/libword2vec_ops.pic.a: \
		blake-bin/tensorflow/core/_objs/word2vec_ops/ops/word2vec_ops.pic.o
	$(AR) $(ARFLAGS) $@ $^

tensorflow_core_word2vec_ops_SPLINKT = \
	blake-bin/tensorflow/core/libword2vec_ops.pic.a

tensorflow_core_word2vec_ops_SPLINKF = \
	$(WA) $(tensorflow_core_word2vec_ops_SPLINKT) $(NOWA)

################################################################################
# //tensorflow/core:ops

################################################################################
# Extra Stuff

.PHONY: clean

clean: 
	rm -rf blake-bin
