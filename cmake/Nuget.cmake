include(GlobCopy)

function(extract_nuget)
  set(options)
  set(oneValueArgs PACKAGE VERSION)
  set(multiValueArgs)
  cmake_parse_arguments(
    EXTRACT_NUGET
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  set(_extract_nuget_args PACKAGE VERSION)
  if(NOT EXTRACT_NUGET_PACKAGE)
    message(FATAL_ERROR "Package name is required")
  endif()

  if(NOT EXTRACT_NUGET_VERSION)
    message(FATAL_ERROR "Package version is required")
  endif()

  string(
    REPLACE "."
            "_"
            safe_pkg_name
            ${EXTRACT_NUGET_PACKAGE}
  )
  set(pkg_download_path "${CMAKE_BINARY_DIR}/nuget/${safe_pkg_name}-${EXTRACT_NUGET_VERSION}.zip")

  # if not downloaded, download nuget package
  if(NOT EXISTS "${pkg_download_path}")
    message(STATUS "Downloading nuget package ${EXTRACT_NUGET_PACKAGE} v${EXTRACT_NUGET_VERSION}")
    file(
      DOWNLOAD "http://packages.nuget.org/api/v1/package/${EXTRACT_NUGET_PACKAGE}/${EXTRACT_NUGET_VERSION}"
      "${pkg_download_path}"
      STATUS status
      LOG log
    )
    list(
      GET
      status
      0
      status_code
    )
    if(NOT
       status_code
       EQUAL
       0
    )
      message(FATAL_ERROR "Failed to download nuget package: ${EXTRACT_NUGET_PACKAGE} v${EXTRACT_NUGET_VERSION}")
    endif()
  endif()

  # extract all files from package paths listed in EXTRACT_PATHS
  # package is a zip

  # extract package
  set(pkg_extract_path "${CMAKE_BINARY_DIR}/nuget/${EXTRACT_NUGET_PACKAGE}-${EXTRACT_NUGET_VERSION}")
  if(NOT EXISTS ${pkg_extract_path})
    message(STATUS "Extracting nuget package ${pkg_download_path}")
    file(MAKE_DIRECTORY "${pkg_extract_path}")
    file(
      ARCHIVE_EXTRACT
      INPUT
      "${pkg_download_path}"
      DESTINATION
      "${pkg_extract_path}"
    )
  endif()

  file(MAKE_DIRECTORY "${EXTRACT_NUGET_OUTPUT}")

  set(_extracted_map ${ARGN})
  set(_extract_list_found FALSE)
  set(_extract_list_current)
  while(NOT ${_extract_list_found})
    list(LENGTH _extracted_map _extracted_map_len)
    if(${_extracted_map_len} EQUAL 0)
      message(FATAL_ERROR "Missing EXTRACT_PATHS argument")
    endif()
    list(POP_FRONT _extracted_map _extract_list_current)
    if(${_extract_list_current} STREQUAL "EXTRACT_PATHS")
      set(_extract_list_found TRUE)
    endif()
  endwhile()

  list(LENGTH _extracted_map _extracted_map_len)
  while(${_extracted_map_len} GREATER 0)
    list(POP_FRONT _extracted_map _left)
    list(
      FIND
      _extract_nuget_args
      ${_left}
      _is_other
    )
    if(NOT
       ${_is_other}
       EQUAL
       -1
    )
      break()
    endif()
    list(
      POP_FRONT
      _extracted_map
      _mapping_key
      _right
    )
    if(NOT
       ${_mapping_key}
       STREQUAL
       "INTO"
    )
      message(FATAL_ERROR "Missing INTO after '${_left}'; expected format: '<archive_path> INTO <target_path>'")
    endif()

    message(STATUS "Copying '${_left}' to '${_right}'")
    glob_copy("${_left}" "${_right}" "${pkg_extract_path}")

    list(LENGTH _extracted_map _extracted_map_len)
  endwhile()
endfunction()
