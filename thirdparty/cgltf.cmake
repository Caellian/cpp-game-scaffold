project(
  cgltf
  VERSION 1.14
  LANGUAGES C)

add_library(cgltf INTERFACE)

set_target_properties(cgltf PROPERTIES C_STANDARD 99)

target_include_directories(
  cgltf INTERFACE $<BUILD_INTERFACE:${cgltf_SOURCE_DIR}>)
