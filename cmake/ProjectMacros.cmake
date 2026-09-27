function(project_template TARGET_NAME)
    set(options EXECUTABLE LIBRARY) # Booleans
    set(oneValueArgs "")
    set(multiValueArgs HDRS SRCS DEPENDS PUBLIC_DEPENDS SUB_DIRS PUBLIC_INCLUDES PRIVATE_INCLUDES TEST_SRCS)

    # Parse out ${ARGN}
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Unexpected arguments
    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "project_template called with unrecognized arguments: ${ARG_UNPARSED_ARGUMENTS}")
    endif()

    if(ARG_EXECUTABLE)
        add_simulation_executable(${TARGET_NAME}
                HDRS ${ARG_HDRS}
                SRCS ${ARG_SRCS}
                DEPENDS ${ARG_DEPENDS}
                PUBLIC_DEPENDS ${ARG_PUBLIC_DEPENDS}
                SUB_DIRS ${ARG_SUB_DIRS}
                PUBLIC_INCLUDES ${ARG_PUBLIC_INCLUDES}
                PRIVATE_INCLUDES ${ARG_PRIVATE_INCLUDES}
                TEST_SRCS ${ARG_TEST_SRCS}
            )
    elseif(ARG_LIBRARY)
        add_simulation_library(${TARGET_NAME}
                HDRS ${ARG_HDRS}
                SRCS ${ARG_SRCS}
                DEPENDS ${ARG_DEPENDS}
                PUBLIC_DEPENDS ${ARG_PUBLIC_DEPENDS}
                SUB_DIRS ${ARG_SUB_DIRS}
                PUBLIC_INCLUDES ${ARG_PUBLIC_INCLUDES}
                PRIVATE_INCLUDES ${ARG_PRIVATE_INCLUDES}
                TEST_SRCS ${ARG_TEST_SRCS}
            )
    else()
        message(FATAL_ERROR "project_template requires an EXECUTABLE or LIBRARY specification")
        endif()
endfunction()

function(add_simulation_executable TARGET_NAME)
    # Parse the forwarded arguments again
    set(options "")
    set(oneValueArgs "")
    set(multiValueArgs HDRS SRCS DEPENDS PUBLIC_DEPENDS SUB_DIRS PUBLIC_INCLUDES PRIVATE_INCLUDES TEST_SRCS)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Create the executable
    add_executable(${TARGET_NAME} ${ARG_SRCS} ${ARG_HDRS})

    # Link dependencies
    # Private Dependencies
    if(ARG_DEPENDS)
        target_link_libraries(${TARGET_NAME} PRIVATE ${ARG_DEPENDS})
    endif()

    # Public Dependencies
    if(ARG_PUBLIC_DEPENDS)
        target_link_libraries(${TARGET_NAME} PUBLIC ${ARG_PUBLIC_DEPENDS})
    endif()
    
    # Process subdirectories if any were provided
    foreach(dir IN LISTS ARG_SUB_DIRS)
        add_subdirectory(${dir})
    endforeach()

    # Public Includes (Transitive: consumers will see these)
    if(ARG_PUBLIC_INCLUDES)
        foreach(inc_dir IN LISTS ARG_PUBLIC_INCLUDES)
            target_include_directories(${TARGET_NAME} PUBLIC 
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${inc_dir}>
                $<INSTALL_INTERFACE:${inc_dir}>
            )
        endforeach()
    endif()

    # Private Includes (Non-transitive: internal to this library only)
    if(ARG_PRIVATE_INCLUDES)
        foreach(inc_dir IN LISTS ARG_PRIVATE_INCLUDES)
            target_include_directories(${TARGET_NAME} PRIVATE 
                ${CMAKE_CURRENT_SOURCE_DIR}/${inc_dir}
            )
        endforeach()
    endif()

    if(BUILD_TESTING AND ARG_TEST_SRCS)
        set(TEST_TARGET_NAME "${TARGET_NAME}_tests")
        
        add_executable(${TEST_TARGET_NAME} ${ARG_TEST_SRCS})
        
        target_link_libraries(${TEST_TARGET_NAME} 
            PRIVATE 
            ${TARGET_NAME} 
            GTest::gtest_main
        )
        
        add_test(NAME ${TEST_TARGET_NAME} COMMAND ${TEST_TARGET_NAME})
    endif()
endfunction()

function(add_simulation_library TARGET_NAME)
    # Parse the forwarded arguments
    set(options "")
    set(oneValueArgs "")
    set(multiValueArgs HDRS SRCS DEPENDS PUBLIC_DEPENDS SUB_DIRS PUBLIC_INCLUDES PRIVATE_INCLUDES TEST_SRCS)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Create the library (STATIC, SHARED, or let CMake decide based on BUILD_SHARED_LIBS)
    add_library(${TARGET_NAME} ${ARG_SRCS} ${ARG_HDRS})

    # Link dependencies
    # Private Dependencies
    if(ARG_DEPENDS)
        target_link_libraries(${TARGET_NAME} PRIVATE ${ARG_DEPENDS})
    endif()

    # Public Dependencies
    if(ARG_PUBLIC_DEPENDS)
        target_link_libraries(${TARGET_NAME} PUBLIC ${ARG_PUBLIC_DEPENDS})
    endif()

    # Public Includes (Transitive: consumers will see these)
    if(ARG_PUBLIC_INCLUDES)
        foreach(inc_dir IN LISTS ARG_PUBLIC_INCLUDES)
            target_include_directories(${TARGET_NAME} PUBLIC 
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${inc_dir}>
                $<INSTALL_INTERFACE:${inc_dir}>
            )
        endforeach()
    endif()

    # Private Includes (Non-transitive: internal to this library only)
    if(ARG_PRIVATE_INCLUDES)
        foreach(inc_dir IN LISTS ARG_PRIVATE_INCLUDES)
            target_include_directories(${TARGET_NAME} PRIVATE 
                ${CMAKE_CURRENT_SOURCE_DIR}/${inc_dir}
            )
        endforeach()
    endif()

    # Process subdirectories
    foreach(dir IN LISTS ARG_SUB_DIRS)
        add_subdirectory(${dir})
    endforeach()

    if(BUILD_TESTING AND ARG_TEST_SRCS)
        set(TEST_TARGET_NAME "${TARGET_NAME}_tests")
        
        add_executable(${TEST_TARGET_NAME} ${ARG_TEST_SRCS})
        
        target_link_libraries(${TEST_TARGET_NAME} 
            PRIVATE 
            ${TARGET_NAME} 
            GTest::gtest_main
        )
        
        add_test(NAME ${TEST_TARGET_NAME} COMMAND ${TEST_TARGET_NAME})
    endif()
endfunction()