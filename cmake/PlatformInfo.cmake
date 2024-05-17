function(query_platform_info)
  set(oneValueArgs
      ARCH
      WORD
      OS
      PLATFORM
      ENDIAN
  )
  cmake_parse_arguments(
    VAR_NAME
    ""
    "${oneValueArgs}"
    ""
    ${ARGN}
  )

  enable_language(C)

  try_run(
    runResultVar
    compileResultVar
    SOURCES
    "${CMAKE_SOURCE_DIR}/tools/platform-info.c"
    NO_LOG
    C_STANDARD
    11
    RUN_OUTPUT_VARIABLE platform_info
    ARGS "\"%a;%s;%o;%p;%e\""
  )

  list(
    POP_FRONT
    platform_info
    RETURN_ARCH
    RETURN_WORD
    RETURN_OS
    RETURN_PLATFORM
    RETURN_ENDIAN
  )

  if(VAR_NAME_ARCH)
    set(${VAR_NAME_ARCH}
        "${RETURN_ARCH}"
        PARENT_SCOPE
    )
  endif()

  if(VAR_NAME_WORD)
    set(${VAR_NAME_WORD}
        "${RETURN_WORD}"
        PARENT_SCOPE
    )
  endif()

  if(VAR_NAME_OS)
    set(${VAR_NAME_OS}
        "${RETURN_OS}"
        PARENT_SCOPE
    )
  endif()

  if(VAR_NAME_PLATFORM)
    set(${VAR_NAME_PLATFORM}
        "${RETURN_PLATFORM}"
        PARENT_SCOPE
    )
  endif()

  if(VAR_NAME_ENDIAN)
    set(${VAR_NAME_ENDIAN}
        "${RETURN_ENDIAN}"
        PARENT_SCOPE
    )
  endif()
endfunction()
