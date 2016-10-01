file(GLOB src_files ${CMAKE_CURRENT_SOURCE_DIR}/../src/*.v)
file(GLOB simul_src_files ${CMAKE_CURRENT_SOURCE_DIR}/../src/simul/*.v)
file(GLOB bench_files ${CMAKE_CURRENT_SOURCE_DIR}/*.v)

foreach(bench ${bench_files})
	get_filename_component(target ${bench} NAME_WE)
	add_simulation_target(${target} ${bench} ${src_files} ${simul_src_files})
endforeach(bench)
