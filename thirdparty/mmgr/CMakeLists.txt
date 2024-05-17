include(CMakeDependentOption)

project(mmgr LANGUAGES CXX)

option(ENABLE_MMGR "Enable MMGR (for allocation debugging)" FALSE)
cmake_dependent_option(
  ENABLE_MMGR_STRESS_TEST
  "Enable MMGR stress test (slow)"
  FALSE
  "ENABLE_MMGR"
  FALSE)

add_library(mmgr STATIC)

set_target_properties(
  mmgr
  PROPERTIES CXX_STANDARD 17
             CXX_STANDARD_REQUIRED ON
             CXX_EXTENSIONS OFF)

target_include_directories(mmgr PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

if(ENABLE_MMGR)
  target_compile_definitions(mmgr PRIVATE IS_MMGR_ENABLED)
endif()
if(ENABLE_MMGR_STRESS_TEST)
  target_compile_definitions(mmgr PRIVATE STRESS_TEST)
endif()

target_sources(mmgr PUBLIC mmgr.cpp)
