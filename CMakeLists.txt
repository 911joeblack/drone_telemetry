cmake_minimum_required(VERSION 3.20)
set(PROJECT_NAME SimulationPlatform)

project(${PROJECT_NAME} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(BUILD_TESTING TRUE)

# Make our custom cmake available globally
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(ProjectMacros)

if(BUILD_TESTING)
    include(GTest_Dependencies)
    enable_testing()
endif()

# Begin Compiling Everything
add_subdirectory(Libraries)
add_subdirectory(Entities)