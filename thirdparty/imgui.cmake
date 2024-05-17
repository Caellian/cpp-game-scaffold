project(
  imgui
  VERSION 1.90.6
  LANGUAGES CXX)

add_library(imgui STATIC)

set_target_properties(
  imgui
  PROPERTIES CXX_STANDARD 17
             CXX_STANDARD_REQUIRED ON
             CXX_EXTENSIONS OFF)

target_include_directories(
  imgui PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

target_sources(imgui PRIVATE imgui.cpp imgui_draw.cpp imgui_tables.cpp
                             imgui_widgets.cpp)
