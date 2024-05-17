include(GlobCopy)
include(PlatformInfo)
include(CMakeDependentOption)
find_package(Git REQUIRED)

project(
  luajit
  VERSION 2.1
  LANGUAGES C
)

query_platform_info(
  OS
  PLATFORM_OS
  WORD
  PLATFORM_WORD_SIZE
  ARCH
  PLATFORM_ARCH
  PLATFORM
  PLATFORM_NAME
)

set(default_static_build ON)
if(${PLATFORM_OS} STREQUAL "Windows")
  set(default_static_build OFF)
endif()

option(LUAJIT_BUILD_STATIC "Build LuaJIT as static library" ${default_static_build})
option(LUAJIT_DISABLE_FFI "Disable FFI support" OFF)
option(LUAJIT_DISABLE_JIT "Disable JIT compiler" OFF)
option(LUAJIT_ENABLE_LUA52COMPAT "Enable additional Lua 5.2 features could break some existing code" OFF)
set(LUAJIT_NUMMODE
    1
    CACHE STRING "Number mode: single-number (1) or dual-number (2)"
)
option(LUAJIT_DISABLE_GC64 "Disable 64-bit memory allocator" OFF)

# Debug options
cmake_dependent_option(
  LUAJIT_USE_SYSMALLOC
  "Use system allocator (slow)"
  OFF
  "NOT ${PLATFORM_ARCH} STREQUAL \"x86_64\" OR NOT ${LUAJIT_DISABLE_GC64}"
  OFF
)
option(LUAJIT_USE_VALGRIND "Enable Valgrind support" OFF)
option(LUAJIT_USE_GDBJIT "Use GDBJIT (slow)" OFF)
option(LUAJIT_USE_APICHECK "Enable Lua/C API assertions (slow)" OFF)
option(LUAJIT_USE_ASSERT "Enable LuaJIT VM assertions (slow)" OFF)

mark_as_advanced(
  LUAJIT_DISABLE_JIT
  LUAJIT_ENABLE_LUA52COMPAT
  LUAJIT_NUMMODE
  LUAJIT_DISABLE_GC64
  LUAJIT_USE_SYSMALLOC
  LUAJIT_USE_VALGRIND
  LUAJIT_USE_GDBJIT
  LUA_USE_APICHECK
  LUA_USE_ASSERT
)

set(luajit_lib
    src/lib_base.c
    src/lib_bit.c
    src/lib_buffer.c
    src/lib_debug.c
    src/lib_ffi.c
    src/lib_io.c
    src/lib_jit.c
    src/lib_math.c
    src/lib_os.c
    src/lib_package.c
    src/lib_string.c
    src/lib_table.c
)
set(luajit_core
    ${luajit_lib}
    src/lib_init.c
    src/lib_aux.c
    src/lj_assert.c
    src/lj_gc.c
    src/lj_err.c
    src/lj_char.c
    src/lj_bc.c
    src/lj_obj.c
    src/lj_buf.c
    src/lj_str.c
    src/lj_tab.c
    src/lj_func.c
    src/lj_udata.c
    src/lj_meta.c
    src/lj_debug.c
    src/lj_prng.c
    src/lj_state.c
    src/lj_dispatch.c
    src/lj_vmevent.c
    src/lj_vmmath.c
    src/lj_strscan.c
    src/lj_strfmt.c
    src/lj_strfmt_num.c
    src/lj_serialize.c
    src/lj_api.c
    src/lj_profile.c
    src/lj_lex.c
    src/lj_parse.c
    src/lj_bcread.c
    src/lj_bcwrite.c
    src/lj_load.c
    src/lj_ir.c
    src/lj_opt_mem.c
    src/lj_opt_fold.c
    src/lj_opt_narrow.c
    src/lj_opt_dce.c
    src/lj_opt_loop.c
    src/lj_opt_split.c
    src/lj_opt_sink.c
    src/lj_mcode.c
    src/lj_snap.c
    src/lj_record.c
    src/lj_crecord.c
    src/lj_ffrecord.c
    src/lj_asm.c
    src/lj_trace.c
    src/lj_gdbjit.c
    src/lj_ctype.c
    src/lj_cdata.c
    src/lj_cconv.c
    src/lj_ccall.c
    src/lj_ccallback.c
    src/lj_carith.c
    src/lj_clib.c
    src/lj_cparse.c
    src/lj_lib.c
    src/lj_alloc.c
)
set(luajit_sources ${luajit_core} src/luajit.c)

set(dynasm_sources
    dynasm/dasm_proto.h
    dynasm/dasm_arm.h
    dynasm/dasm_x86.h
    dynasm/dasm_mips.h
    dynasm/dasm_ppc.h
    dynasm/dasm_arm64.h
)

if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/include")
  glob_copy("${CMAKE_CURRENT_SOURCE_DIR}/src/*.h" "${CMAKE_CURRENT_BINARY_DIR}/include")
  file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/include/luajit-rolling.h")
endif()

execute_process(
  COMMAND ${GIT_EXECUTABLE} show -s --format=%ct
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  RESULT_VARIABLE version_result
  OUTPUT_VARIABLE version_output
  ERROR_VARIABLE version_error
)

if(NOT
   version_result
   EQUAL
   0
)
  message(FATAL_ERROR "Failed to get version no. from git: ${version_error}")
else()
  file(WRITE "${CMAKE_CURRENT_SOURCE_DIR}/luajit_relver.txt" "${version_output}")
endif()

# Host build environment
set(minilua_sources src/host/minilua.c)
add_executable(minilua ${minilua_sources})
set_target_properties(
  minilua
  PROPERTIES LANGUAGE C
             C_STANDARD 11
             C_EXTENSIONS FALSE
)
target_link_libraries(minilua PRIVATE m)
set(buildvm_sources
    src/lj_arch.h
    src/lua.h
    src/luaconf.h
    src/host/buildvm_asm.c
    src/host/buildvm_arch.h
    src/host/buildvm_fold.c
    src/host/buildvm_lib.c
    src/host/buildvm_peobj.c
    src/host/buildvm.c
    src/host/buildvm.h
    src/host/buildvm_libbc.h
)
add_executable(buildvm ${buildvm_sources})
set_target_properties(
  buildvm
  PROPERTIES LANGUAGE C
             C_STANDARD 11
             C_EXTENSIONS FALSE
)

# Platform configuration
set(compiler_options -O2 -fomit-frame-pointer)
if(${PLATFORM_ARCH} STREQUAL "x86_64")
  set(compiler_options
      ${compiler_options}
      -march=i686
      -msse
      -msse2
      -mfpmath=sse
  )
  set(luajit_arch x64)
elseif(${PLATFORM_ARCH} STREQUAL "x86")
  set(compiler_options ${compiler_options} -m32)
  set(luajit_arch x86)
elseif(${PLATFORM_ARCH} STREQUAL "arm")
  set(compiler_options ${compiler_options} -marm)
  set(luajit_arch arm)
elseif(${PLATFORM_ARCH} STREQUAL "arm64")
  set(compiler_options ${compiler_options} -march=armv8-a)
  set(luajit_arch arm64)
elseif(${PLATFORM_ARCH} STREQUAL "ppc")
  set(compiler_options
      ${compiler_options}
      -mcpu=750
      -mtune=750
      -maltivec
      -mabi=altivec
  )
  set(luajit_arch ppc)
elseif(${PLATFORM_ARCH} STREQUAL "mips")
  set(compiler_options ${compiler_options})
  if(${PLATFORM_WORD_SIZE} EQUAL 64)
    set(luajit_arch mips64)
  else()
    set(luajit_arch mips)
  endif()
endif()

set(build_definitions LUAJIT_TARGET=LUAJIT_ARCH_${luajit_arch})
if(${PLATFORM_OS} STREQUAL "Windows" AND NOT ${LUAJIT_BUILD_STATIC})
  message(
    WARNING
      "LuaJIT static build doesn't work well on Windows. C modules cannot be loaded, because they bind to lua51.dll."
  )
endif()
# TODO: Add handling form PS3
# ifneq (,$(findstring LJ_TARGET_PS3 1,$(TARGET_TESTARCH)))
# TARGET_SYS= PS3
# TARGET_ARCH+= -D__CELLOS_LV2__
# TARGET_XCFLAGS+= -DLUAJIT_USE_SYSMALLOC
# TARGET_XLIBS+= -lpthread
# endif

set(luajit_mode elfasm)
if(${PLATFORM_OS} STREQUAL "Windows")
  set(luajit_mode peasm)
elseif(${PLATFORM_OS} STREQUAL "MacOS" OR ${PLATFORM_OS} STREQUAL "iOS")
  set(luajit_mode machasm)
endif()

# Build definitions
if(NOT ${LUAJIT_BUILD_STATIC})
  list(APPEND build_definitions LUA_BUILD_AS_DLL)
endif()

if(${LUAJIT_DISABLE_FFI})
  list(APPEND build_definitions LUAJIT_DISABLE_FFI)
endif()

if(${LUAJIT_DISABLE_JIT})
  list(APPEND build_definitions LUAJIT_DISABLE_JIT)
endif()

if(${LUAJIT_ENABLE_LUA52COMPAT})
  list(APPEND build_definitions LUAJIT_ENABLE_LUA52COMPAT)
endif()

if(${LUAJIT_NUMMODE} STREQUAL "1")
  list(APPEND build_definitions LUAJIT_NUMMODE=1)
elseif(${LUAJIT_NUMMODE} STREQUAL "2")
  list(APPEND build_definitions LUAJIT_NUMMODE=2)
else()
  message(FATAL_ERROR "Invalid value for LUAJIT_NUMMODE: ${LUAJIT_NUMMODE}\nExpected '1' or '2'.")
endif()

# Debug options
if(${LUAJIT_USE_SYSMALLOC})
  list(APPEND build_definitions LUAJIT_USE_SYSMALLOC)
endif()
if(${LUAJIT_USE_VALGRIND})
  list(APPEND build_definitions LUAJIT_USE_VALGRIND)
endif()
if(${LUAJIT_USE_GDBJIT})
  list(APPEND build_definitions LUAJIT_USE_GDBJIT)
endif()
if(${LUAJIT_USE_APICHECK})
  list(APPEND build_definitions LUA_USE_APICHECK)
endif()
if(${LUAJIT_USE_ASSERT})
  list(APPEND build_definitions LUA_USE_ASSERT)
endif()

# Generated files
add_custom_command(
  OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/src/luajit.h"
  COMMAND ${CMAKE_COMMAND} -E $<TARGET_FILE:minilua> "${CMAKE_CURRENT_SOURCE_DIR}/src/host/genversion.lua"
  DEPENDS minilua
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/src/"
  DEPFILE "${CMAKE_CURRENT_SOURCE_DIR}/src/luajit_rolling.h"
)
add_library(luajit_header INTERFACE)
target_sources(luajit_header INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/src/luajit.h")

set(generated_hdrs
  src/host/buildvm_arch.h
)
macro(buildvm_obj OBJ FILE)
  list(
    SUBLIST
    "${ARGV}"
    2
    -1
    requirements
  )

  add_custom_command(
    OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/src/${FILE}"
    COMMAND ${CMAKE_COMMAND} -E $<TARGET_FILE:buildvm> -m ${OBJ} -o "${CMAKE_CURRENT_SOURCE_DIR}/src/${FILE}"
            ${requirements}
    DEPENDS buildvm
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/src/"
  )
  add_library(${OBJ} INTERFACE)
  target_sources(${OBJ} INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/src/${FILE}")
  list(APPEND generated_hdrs "${CMAKE_CURRENT_SOURCE_DIR}/src/${FILE}")
endmacro()

buildvm_obj(bcdef lj_bcdef.h ${luajit_lib})
buildvm_obj(ffdef lj_ffdef.h ${luajit_lib})
buildvm_obj(libdef lj_libdef.h ${luajit_lib})
buildvm_obj(recdef lj_recdef.h ${luajit_lib})
buildvm_obj(vmdef jit/vmdef.lua ${luajit_lib})
buildvm_obj(folddef lj_folddef.h src/lj_opt_fold.c)

add_library(luajit STATIC)
set_target_properties(
  luajit
  PROPERTIES LANGUAGE C
             C_STANDARD 11
             C_EXTENSIONS FALSE
)
add_dependencies(luajit luajit_header)
target_include_directories(luajit PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>)
target_link_libraries(luajit PRIVATE m)
target_sources(luajit PRIVATE ${luajit_sources} ${generated_hdrs})
target_compile_definitions(luajit PRIVATE ${build_definitions})
target_compile_options(luajit PRIVATE ${compiler_options})
