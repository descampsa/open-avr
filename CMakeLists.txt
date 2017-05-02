project ("icestorm_blink")
cmake_minimum_required(VERSION 2.8)

include(hdl.cmake)

include_directories(src)

add_subdirectory(software)
add_subdirectory(bench)
add_subdirectory(synthesis)

