project(dxc LANGUAGES C)

# match platforms
if(NOT ${dxc_PLATFORM})
  message(
    FATAL_ERROR
      "Unsupported platform: ${PLATFORM_WORD_SIZE}-bit ${PLATFORM_OS} (${PLATFORM_ARCH})"
  )
endif()

file(GLOB dxc_BINARIES ${dxc_SOURCE_DIR}/bin/${dxc_PLATFORM}/*.dll)

add_library(dxc INTERFACE ${dxc_BINARIES})
target_link_libraries(dxc INTERFACE ${dxc_BINARIES})
target_include_directories(dxc INTERFACE ${dxc_SOURCE_DIR}/inc)
