project(
  cr
  VERSION 0.1
  LANGUAGES C
)

add_library(cr INTERFACE)
target_include_directories(cr INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)
