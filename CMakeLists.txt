cmake_minimum_required(VERSION 3.16...3.29)

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(FATAL_ERROR "In-source builds not allowed. Please run CMake with `-B <target_build_directory>` argument.")
endif()

# Setup some standard CMake requirements
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_EXTENSIONS OFF)
cmake_policy(SET CMP0135 NEW)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(BuildOptions)

# Change this to false if you want to disable warnings_as_errors in developer mode
set(OPT_WARNINGS_AS_ERRORS_DEVELOPER_DEFAULT TRUE)

# include(FetchContent)
# FetchContent_Declare(_project_options URL https://github.com/aminya/project_options/archive/refs/tags/v0.35.1.zip)
# FetchContent_MakeAvailable(_project_options)
# include(${_project_options_SOURCE_DIR}/Index.cmake)

project(
  MyGame
  VERSION 0.0.1
  DESCRIPTION ""
  LANGUAGES CXX C
)

if(ENABLE_DEVELOPER_MODE)
  set(ENABLE_CLANG_TIDY "ENABLE_CLANG_TIDY")
  set(ENABLE_CPPCHECK "ENABLE_CPPCHECK")
endif()

if(ENABLE_TESTS)
  set(ENABLE_COVERAGE "ENABLE_COVERAGE")

  # check_sanitizers_support(
  #   ENABLE_SANITIZER_ADDRESS
  #   ENABLE_SANITIZER_UNDEFINED_BEHAVIOR
  #   ENABLE_SANITIZER_LEAK
  #   ENABLE_SANITIZER_THREAD
  #   ENABLE_SANITIZER_MEMORY)
endif()

get_property(BUILDING_MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(BUILDING_MULTI_CONFIG)
  if(NOT CMAKE_BUILD_TYPE)
    # Make sure that all supported configuration types have their
    # associated conan packages available. You can reduce this
    # list to only the configuration types you use, but only if one
    # is not forced-set on the command line for VS
    message(TRACE "Setting up multi-config build types")
    set(CMAKE_CONFIGURATION_TYPES
        Debug
        Release
        RelWithDebInfo
        MinSizeRel
        CACHE STRING "Enabled build types" FORCE
    )
  else()
    message(TRACE "User chose a specific build type, so we are using that")
    set(CMAKE_CONFIGURATION_TYPES
        ${CMAKE_BUILD_TYPE}
        CACHE STRING "Enabled build types" FORCE
    )
  endif()
endif()

# Include third-party dependencies
add_subdirectory(thirdparty)

# include(${_project_options_SOURCE_DIR}/src/DynamicProjectOptions.cmake)

# project_options(
#   PREFIX
#   myenginename
#   ENABLE_CACHE
#   ${ENABLE_CLANG_TIDY}
#   ${ENABLE_CPPCHECK}
#   CPPCHECK_OPTIONS
#   --enable=style,performance,warning,portability
#   --inline-suppr
#   # We cannot act on a bug/missing feature of cppcheck
#   --suppress=cppcheckError
#   --suppress=internalAstError
#   # if a file does not have an internalAstError, we get an unmatchedSuppression error
#   --suppress=unmatchedSuppression
#   --suppress=passedByValue
#   --suppress=syntaxError
#   --inconclusive
#   ${ENABLE_COVERAGE}
#   ${ENABLE_SANITIZER_ADDRESS}
#   ${ENABLE_SANITIZER_UNDEFINED_BEHAVIOR})

# target_compile_features(myenginename_project_options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})
add_library(myenginename::myenginename_project_options INTERFACE IMPORTED)
add_library(myenginename::myenginename_warnings INTERFACE IMPORTED)

# Add sources
add_subdirectory(modules/engine)
add_subdirectory(modules/game)

# set the startup project for the "play" button in MSVC
set_property(DIRECTORY PROPERTY VS_STARTUP_PROJECT intro)
