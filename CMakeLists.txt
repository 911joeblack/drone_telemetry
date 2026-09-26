cmake_minimum_required(VERSION 4.2)
set(PROJECT_NAME drone_telemetry)

project(${PROJECT_NAME} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB_RECURSE SRCS "src/*.cpp")
file(GLOB_RECURSE HDRS "include/*.h")

add_executable(${PROJECT_NAME} ${SRCS} ${HDRS})

target_include_directories(${PROJECT_NAME} 
    PRIVATE src
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc>
    $<INSTALL_INTERFACE:inc>
)