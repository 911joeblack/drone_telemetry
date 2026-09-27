# This will collect all the folders in this folder
# And add_subdirectory() if a CMakeLists.txt exists in it
file(GLOB ALL_CHILDREN CONFIGURE_DEPENDS "*")

foreach(CHILD IN LISTS ALL_CHILDREN)
    if(IS_DIRECTORY "${CHILD}")
        
        if(EXISTS "${CHILD}/CMakeLists.txt")
            
            get_filename_component(DIR_NAME "${CHILD}" NAME)
            message(STATUS "Discovered and adding: ${DIR_NAME}")
            
            add_subdirectory("${CHILD}")
            
        endif()
    endif()
endforeach()