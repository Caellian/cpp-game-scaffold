function(glob_copy SOURCE TARGET)
  if(NOT ARGV2)
    set(BASE_PATH "")
  else()
    set(BASE_PATH "${ARGV2}/")
  endif()

  block(SCOPE_FOR VARIABLES)
  string(FIND "${SOURCE}" "*" source_glob_index)
  if(${source_glob_index} EQUAL -1)
    if(IS_DIRECTORY "${BASE_PATH}${SOURCE}")
      # glob contents
      file(GLOB_RECURSE source_files "${BASE_PATH}${SOURCE}/*")
      if(NOT source_files)
        message(WARNING "'${SOURCE}' directory is empty")
      endif()

      # Generally want to create a directory if it doesn't exist
      if(NOT EXISTS "${TARGET}")
        file(MAKE_DIRECTORY "${TARGET}")
      elseif(IS_FILE "${TARGET}")
        message(FATAL_ERROR "Cannot copy '${SOURCE}' to '${TARGET}', target is a file")
      endif()

      # copy contents
      foreach(file ${source_files})
        # file parent directory
        get_filename_component(source_parent "${file}" DIRECTORY)
        # file parent directory path relative to source dir
        file(
          RELATIVE_PATH
          relative_path
          "${BASE_PATH}${SOURCE}"
          "${source_parent}"
        )

        file(COPY ${file} DESTINATION "${TARGET}/${relative_path}")
      endforeach()
    else()
      if(IS_DIRECTORY "${TARGET}")
        file(COPY "${BASE_PATH}${SOURCE}" DESTINATION "${TARGET}")
      else()
        # Files allow target to specify name
        get_filename_component(target_dir "${TARGET}" DIRECTORY)
        get_filename_component(target_name "${TARGET}" NAME)
        get_filename_component(source_name "${SOURCE}" NAME)

        # Generally want to create a directory if it doesn't exist
        if(NOT EXISTS "${target_dir}")
          file(MAKE_DIRECTORY "${target_dir}")
        endif()

        file(COPY "${BASE_PATH}${SOURCE}" DESTINATION "${target_dir}")
        file(RENAME "${target_dir}/${source_name}" "${target_dir}/${target_name}")
      endif()
    endif()
  else()
    math(EXPR source_glob_index "${source_glob_index} - 1" OUTPUT_FORMAT DECIMAL)
    # base path
    string(
      SUBSTRING "${SOURCE}"
                0
                ${source_glob_index}
                source_base_path
    )

    file(GLOB source_files "${BASE_PATH}${SOURCE}")

    # CMake doesn't properly collapse '**' to nothing in 'example/path/**/*.h'
    string(FIND "${SOURCE}" "**" source_doubleglob)
    if(NOT
       ${source_doubleglob}
       EQUAL
       -1
    )
      string(
        REPLACE "/**/"
                "/"
                source_direct
                "${SOURCE}"
      )
      file(GLOB source_files_additional "${BASE_PATH}${source_direct}")
      list(APPEND source_files ${source_files_additional})
    endif()

    foreach(file ${source_files})
      # source file parent directory
      get_filename_component(source_parent "${file}" DIRECTORY)
      # file parent directory path relative to source dir
      file(
        RELATIVE_PATH
        relative_path
        "${BASE_PATH}${source_base_path}"
        "${source_parent}"
      )

      file(COPY ${file} DESTINATION "${TARGET}/${relative_path}")
    endforeach()
  endif()
  endblock()
endfunction()
