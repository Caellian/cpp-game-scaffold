set(game_sources src/main.cpp)

# Generic test that uses conan libs
add_executable(mygamename ${game_sources})
target_link_libraries(mygamename PRIVATE engine)
