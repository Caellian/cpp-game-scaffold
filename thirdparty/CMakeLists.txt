include(ApplyPatches)
include(FetchContent)
include(GlobCopy)
include(Links)
include(Nuget)
include(PlatformInfo)

fetchcontent_declare(
  cpu_features
  GIT_REPOSITORY https://github.com/google/cpu_features.git
  GIT_TAG v0.9.0
)

fetchcontent_declare(
  cgltf
  GIT_REPOSITORY https://github.com/jkuhlmann/cgltf.git
  GIT_TAG v1.14
)

fetchcontent_declare(
  cjson
  GIT_REPOSITORY https://github.com/DaveGamble/cJSON.git
  GIT_TAG v1.7.18
)

fetchcontent_declare(
  bstrlib
  GIT_REPOSITORY https://github.com/websnarf/bstrlib.git
  GIT_TAG v1.0.0
)

fetchcontent_declare(
  flecs
  GIT_REPOSITORY https://github.com/SanderMertens/flecs.git
  GIT_TAG v3.2.11
)

fetchcontent_declare(
  fontstash
  GIT_REPOSITORY https://github.com/memononen/fontstash.git
  GIT_TAG b5ddc9741061343740d85d636d782ed3e07cf7be # End of maintainence
)

fetchcontent_declare(
  d3d12memoryallocator
  GIT_REPOSITORY https://github.com/GPUOpen-LibrariesAndSDKs/D3D12MemoryAllocator.git
  GIT_TAG v2.0.1
)

fetchcontent_declare(
  dxsc
  URL https://github.com/microsoft/DirectXShaderCompiler/releases/download/v1.8.2403.2/dxc_2024_03_29.zip
  URL_HASH MD5=4709b30d5b3661619bb9846bd9a79a48 # dxc_2024_03_29.zip
)

fetchcontent_declare(
  ois
  GIT_REPOSITORY https://github.com/wgois/OIS.git
  GIT_TAG v1.5.1
)

fetchcontent_declare(
  imgui
  GIT_REPOSITORY https://github.com/ocornut/imgui.git
  GIT_TAG v1.90.6
)

fetchcontent_declare(
  luajit
  GIT_REPOSITORY https://luajit.org/git/luajit.git
  GIT_TAG v2.1
)

query_platform_info(
  OS
  PLATFORM_OS
  WORD
  PLATFORM_WORD_SIZE
  ARCH
  PLATFORM_ARCH
)

macro(patch PROJECT)
  apply_patches("${CMAKE_CURRENT_SOURCE_DIR}/patches/${PROJECT}" "${${PROJECT}_SOURCE_DIR}")
endmacro()

fetchcontent_getproperties(cpu_features)
if(NOT cpu_features_POPULATED)
  fetchcontent_populate(cpu_features)

  block(SCOPE_FOR VARIABLES)
  if(NOT ENABLE_TESTS)
    set(BUILD_TESTING OFF)
  endif()

  add_subdirectory("${cpu_features_SOURCE_DIR}" "${cpu_features_BINARY_DIR}")
  mark_as_advanced(BUILD_TESTING)
  endblock()
endif()

fetchcontent_getproperties(cgltf)
if(NOT cgltf_POPULATED)
  fetchcontent_populate(cgltf)

  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/cgltf.cmake" "${cgltf_SOURCE_DIR}/CMakeLists.txt")

  add_subdirectory("${cgltf_SOURCE_DIR}" "${cgltf_BINARY_DIR}")
endif()

fetchcontent_getproperties(cjson)
if(NOT cjson_POPULATED)
  fetchcontent_populate(cjson)

  patch("cjson")

  block(SCOPE_FOR VARIABLES)
  option(ENABLE_CJSON_TEST "Enable building cJSON test" OFF)
  add_subdirectory("${cjson_SOURCE_DIR}" "${cjson_BINARY_DIR}")

  mark_as_advanced(
    BUILD_SHARED_AND_STATIC_LIBS
    BUILD_SHARED_LIBS
    CJSON_BUILD_SHARED_LIBS
    CJSON_OVERRIDE_BUILD_SHARED_LIBS
    ENABLE_CJSON_TEST
    ENABLE_CJSON_UNINSTALL
    ENABLE_CJSON_UTILS
    ENABLE_CJSON_VERSION_SO
    ENABLE_CUSTOM_COMPILER_FLAGS
    ENABLE_FUZZING
    ENABLE_HIDDEN_SYMBOLS
    ENABLE_INSTALL
    ENABLE_LOCALES
    ENABLE_PUBLIC_SYMBOLS
    ENABLE_SAFE_STACK
    ENABLE_TARGET_EXPORT
  )
  endblock()
endif()

fetchcontent_getproperties(bstrlib)
if(NOT bstrlib_POPULATED)
  fetchcontent_populate(bstrlib)

  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/bstrlib.cmake" "${bstrlib_SOURCE_DIR}/CMakeLists.txt")
  apply_patches("${CMAKE_CURRENT_SOURCE_DIR}/patches/bstrlib" "${bstrlib_SOURCE_DIR}")

  add_subdirectory("${bstrlib_SOURCE_DIR}" "${bstrlib_BINARY_DIR}")
  set(BSTRLIB_INCLUDE_DIRS
      "${bstrlib_SOURCE_DIR}"
      CACHE INTERNAL "BSTRLIB_INCLUDE_DIRS"
  )
endif()

fetchcontent_getproperties(flecs)
if(NOT flecs_POPULATED)
  fetchcontent_populate(flecs)

  block(SCOPE_FOR VARIABLES)
  option(FLECS_PIC "Compile static flecs lib with position independent code (PIC)" ON)
  option(FLECS_SHARED "Build shared flecs lib" OFF)
  option(FLECS_STATIC "Build static flecs lib" ON)
  if(ENABLE_DEVELOPER_MODE)
    option(FLECS_STRICT ON)
  endif()
  option(FLECS_TESTS "Build flecs tests" OFF)

  add_subdirectory("${flecs_SOURCE_DIR}" "${flecs_BINARY_DIR}")

  mark_as_advanced(
    FLECS_PIC
    FLECS_SHARED
    FLECS_STATIC
    FLECS_STRICT
    FLECS_TESTS
  )
  endblock()
endif()

fetchcontent_getproperties(fontstash)
if(NOT fontstash_POPULATED)
  fetchcontent_populate(fontstash)

  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/FontStash.cmake" "${fontstash_SOURCE_DIR}/CMakeLists.txt")

  add_subdirectory("${fontstash_SOURCE_DIR}" "${fontstash_BINARY_DIR}")
endif()

if(BUILD_DX12)
  block(SCOPE_FOR VARIABLES)
  set(dx12sdk_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/Direct3d12SDK-src")
  set(dx12sdk_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/Direct3d12SDK-build")
  extract_nuget(
    PACKAGE
    "Microsoft.Direct3D.D3D12"
    VERSION
    "1.613.3"
    EXTRACT_PATHS
    "build/native/bin"
    INTO
    "${dx12sdk_SOURCE_DIR}/bin"
    "build/native/include/**/*.h"
    INTO
    "${dx12sdk_SOURCE_DIR}/include"
    "build/native/include/**/*.hpp"
    INTO
    "${dx12sdk_SOURCE_DIR}/include"
  )

  set(dx12sdk_PLATFORM FALSE)
  if(${PLATFORM_OS} STREQUAL "Windows")
    if(${PLATFORM_ARCH} STREQUAL "arm64")
      set(dx12sdk_PLATFORM "arm64")
    elseif(${PLATFORM_ARCH} STREQUAL "x86")
      set(dx12sdk_PLATFORM "win32")
    elseif(${PLATFORM_ARCH} STREQUAL "x86_64")
      set(dx12sdk_PLATFORM "x64")
    endif()
  endif()

  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/dx12sdk.cmake" "${dx12sdk_SOURCE_DIR}/CMakeLists.txt")
  add_subdirectory("${dx12sdk_SOURCE_DIR}" "${dx12sdk_BUILD_DIR}")
  endblock()

  fetchcontent_getproperties(d3d12memoryallocator)
  if(NOT d3d12memoryallocator_POPULATED)
    fetchcontent_populate(d3d12memoryallocator)

    block(SCOPE_FOR VARIABLES)
    option(D3D12MA_BUILD_SAMPLE "Build D3D12MemoryAllocator sample application" OFF)

    add_subdirectory("${d3d12memoryallocator_SOURCE_DIR}" "${d3d12memoryallocator_BINARY_DIR}")

    mark_as_advanced(D3D12MA_BUILD_SAMPLE BUILD_DOCUMENTATION)
    endblock()
  endif()

  fetchcontent_getproperties(dxsc)
  if(NOT dxsc_POPULATED)
    fetchcontent_populate(dxsc)

    block(SCOPE_FOR VARIABLES)
    set(dxsc_PLATFORM FALSE)
    if(${PLATFORM_OS} STREQUAL "Windows")
      if(${PLATFORM_ARCH} STREQUAL "arm64")
        set(dxsc_PLATFORM "arm64")
      elseif(${PLATFORM_ARCH} STREQUAL "x86")
        set(dxsc_PLATFORM "x86")
      elseif(${PLATFORM_ARCH} STREQUAL "x86_64")
        set(dxsc_PLATFORM "x64")
      endif()
    endif()

    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/dxc.cmake" "${dxsc_SOURCE_DIR}/CMakeLists.txt")
    add_subdirectory("${dxsc_SOURCE_DIR}" "${dxsc_BINARY_DIR}")

    create_link("${dxsc_SOURCE_DIR}/bin/${dxsc_PLATFORM}/dxc.exe" "${CMAKE_SOURCE_DIR}/tools/dxc.exe")
    endblock()
  endif()
endif()

# fetchcontent_getproperties(ois)
# if(NOT ois_POPULATED)
#   fetchcontent_populate(ois)

#   block(SCOPE_FOR VARIABLES)
#   option(OIS_BUILD_SHARED_LIBS "Build shared libraries" OFF)
#   option(OIS_BUILD_DEMOS "Build demo applications" OFF)

#   add_subdirectory("${ois_SOURCE_DIR}" "${ois_BINARY_DIR}")
#   mark_as_advanced(OIS_BUILD_SHARED_LIBS OIS_BUILD_DEMOS)

#   if(X11_xcb_xkb_INCLUDE_PATH)
#     mark_as_advanced(X11_xcb_xkb_INCLUDE_PATH)
#   endif()
#   endblock()
# endif()

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/imgui/CMakeLists.txt")
  fetchcontent_makeavailable(imgui)

  glob_copy("${imgui_SOURCE_DIR}/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/imgui")
  glob_copy("${imgui_SOURCE_DIR}/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/imgui")

  glob_copy("${CMAKE_CURRENT_SOURCE_DIR}/imgui.cmake" "${CMAKE_CURRENT_SOURCE_DIR}/imgui/CMakeLists.txt")
endif()

set(CR_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/cr-src")
set(CR_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/cr-build")
if(NOT EXISTS ${CR_SOURCE_DIR})
  set(CR_GIT_SHA "bb3cb9fc338ac752a0a4e10fd8b00cc558c75649") # Reverted clang support but kept .dll name fix
  set(CR_DOWNLOAD_PATH "https://raw.githubusercontent.com/fungos/cr/${CR_GIT_SHA}/cr.h")
  file(DOWNLOAD ${CR_DOWNLOAD_PATH} "${CR_SOURCE_DIR}/cr.h")
  glob_copy("${CMAKE_CURRENT_SOURCE_DIR}/cr.cmake" "${CR_SOURCE_DIR}/CMakeLists.txt")
  add_subdirectory("${CR_SOURCE_DIR}" "${CR_BINARY_DIR}")
endif()

fetchcontent_getproperties(luajit)
if(NOT luajit_POPULATED)
  fetchcontent_populate(luajit)

  glob_copy("${CMAKE_CURRENT_SOURCE_DIR}/luajit.cmake" "${luajit_SOURCE_DIR}/CMakeLists.txt")

  add_subdirectory("${luajit_SOURCE_DIR}" "${luajit_BINARY_DIR}")
endif()

# Vendored
add_subdirectory(imgui)
add_subdirectory(mmgr)

mark_as_advanced(
  FETCHCONTENT_BASE_DIR
  FETCHCONTENT_FULLY_DISCONNECTED
  FETCHCONTENT_QUIET
  FETCHCONTENT_SOURCE_DIR_BSTRLIB
  FETCHCONTENT_SOURCE_DIR_CGLTF
  FETCHCONTENT_SOURCE_DIR_CJSON
  FETCHCONTENT_SOURCE_DIR_CPU_FEATURES
  FETCHCONTENT_SOURCE_DIR_D3D12MEMORYALLOCATOR
  FETCHCONTENT_SOURCE_DIR_DXSC
  FETCHCONTENT_SOURCE_DIR_FLECS
  FETCHCONTENT_SOURCE_DIR_FONTSTASH
  FETCHCONTENT_SOURCE_DIR_OIS
  FETCHCONTENT_UPDATES_DISCONNECTED
  FETCHCONTENT_UPDATES_DISCONNECTED_BSTRLIB
  FETCHCONTENT_UPDATES_DISCONNECTED_CGLTF
  FETCHCONTENT_UPDATES_DISCONNECTED_CJSON
  FETCHCONTENT_UPDATES_DISCONNECTED_CPU_FEATURES
  FETCHCONTENT_UPDATES_DISCONNECTED_D3D12MEMORYALLOCATOR
  FETCHCONTENT_UPDATES_DISCONNECTED_DXSC
  FETCHCONTENT_UPDATES_DISCONNECTED_FLECS
  FETCHCONTENT_UPDATES_DISCONNECTED_FONTSTASH
  FETCHCONTENT_UPDATES_DISCONNECTED_OIS
)

# Everything else is a leak: ENABLE_MMGR_STRESS_TEST BUILD_EXECUTABLE
# CMAKE_BUILD_TYPE CMAKE_INSTALL_PREFIX ENABLE_DEVELOPER_MODE ENABLE_MMGR
# ENABLE_SANITIZERS ENABLE_TESTS
