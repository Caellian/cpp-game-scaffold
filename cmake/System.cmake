set(supported_operating_systems
    Android
    Darwin
    Linux
    Quest
    Windows
    CACHE STRING "List of supported platforms" INTERNAL)

if(CMAKE_SYSTEM_NAME STREQUAL "Android")
  set(TARGET_SYSTEM "ANDROID")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(TARGET_SYSTEM "DARWIN")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(TARGET_SYSTEM "LINUX")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  set(TARGET_SYSTEM "WINDOWS")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  set(TARGET_SYSTEM "WINDOWS")
elseif(CMAKE_SYSTEM_NAME STREQUAL "CACHE")
  set(CACHE 1)
else()
  message(FATAL_ERROR "Unsupported system: ${CMAKE_SYSTEM_NAME}")
endif()
