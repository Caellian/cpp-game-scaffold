project(
  bstrlib
  VERSION 1.0.0
  LANGUAGES CXX C)

add_library(bstrlib STATIC)

set_target_properties(
  bstrlib
  PROPERTIES CXX_STANDARD 11
             CXX_STANDARD_REQUIRED ON
             CXX_EXTENSIONS OFF)
target_compile_options(bstrlib
                       PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-Wno-old-style-cast>)

target_include_directories(bstrlib
                           PUBLIC $<BUILD_INTERFACE:${bstrlib_SOURCE_DIR}>)

target_sources(bstrlib PRIVATE bsafe.c bstraux.c bstrlib.c buniutil.c
                               utf8util.c bstrwrap.cpp)
