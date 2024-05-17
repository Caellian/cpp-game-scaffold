set(engine_sources src/engine.cpp)

# Generic test that uses conan libs
add_library(engine SHARED ${engine_sources})
target_include_directories(
  engine
  PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include"
  PRIVATE ${ENGINE_CONFIG_DIRS} ${BSTRLIB_INCLUDE_DIRS}
)
target_link_libraries(engine PUBLIC FontStash luajit)
