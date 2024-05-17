project(dx12sdk LANGUAGES C)

# match platforms
if(NOT ${dx12sdk_PLATFORM})
  message(
    FATAL_ERROR
      "Unsupported platform: ${PLATFORM_WORD_SIZE}-bit ${PLATFORM_OS} (${PLATFORM_ARCH})"
  )
endif()

file(GLOB dx12sdk_BINARIES ${dx12sdk_SOURCE_DIR}/bin/${dx12sdk_PLATFORM}/*.dll)

add_library(dx12sdk INTERFACE ${dx12sdk_BINARIES})
target_link_libraries(dx12sdk INTERFACE ${dx12sdk_BINARIES})
target_include_directories(dx12sdk INTERFACE ${dx12sdk_SOURCE_DIR}/include)
