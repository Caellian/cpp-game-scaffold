project(FontStash LANGUAGES CXX)

add_library(FontStash INTERFACE)

set_target_properties(FontStash PROPERTIES CXX_STANDARD 17)

target_include_directories(FontStash INTERFACE $<BUILD_INTERFACE:${fontstash_SOURCE_DIR}/src>)
