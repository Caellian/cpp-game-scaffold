find_package(Git REQUIRED)

function(apply_patches SOURCE_DIR TARGET_DIR)
  block(SCOPE_FOR VARIABLES)
  get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)
  set(PATCH_STATE_DIR "${CMAKE_BINARY_DIR}/patch-state/${TARGET_NAME}")

  file(GLOB patches "${SOURCE_DIR}/*.patch")

  foreach(patch ${patches})
    get_filename_component(patch_name "${patch}" NAME_WE)
    set(PATCH_STATE "${PATCH_STATE_DIR}/${patch_name}-applied")

    if(NOT EXISTS "${PATCH_STATE}")
      message(STATUS "Applying patch ${patch_name} to ${TARGET_NAME}")

      # Applies patch to target directory
      execute_process(
        COMMAND ${GIT_EXECUTABLE} apply "${patch}"
        WORKING_DIRECTORY "${TARGET_DIR}"
        RESULT_VARIABLE patch_result
        OUTPUT_VARIABLE patch_output
        ERROR_VARIABLE patch_error)

      # Checks if patch was applied successfully
      if(NOT
         ${patch_result}
         EQUAL
         0)
        message(
          FATAL_ERROR "Failed to apply patch ${patch_name} to ${TARGET_NAME}.\nError: ${patch_result}\n${patch_error}")
      else()
        file(MAKE_DIRECTORY "${PATCH_STATE_DIR}")
        file(TOUCH "${PATCH_STATE}")
        message(STATUS "Applying patch ${patch_name} to ${TARGET_NAME} - Success")
      endif()
    else()
      message(VERBOSE "Patch ${patch_name} already applied to ${TARGET_NAME}")
    endif()
  endforeach()
  endblock()
endfunction()
