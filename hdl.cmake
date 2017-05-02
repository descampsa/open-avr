
function(add_simulation_target target)
	get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
	add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target}.sim
		COMMAND iverilog -DSIMULATION=1 -I ${dirs} -o ${CMAKE_CURRENT_BINARY_DIR}/${target}.sim ${ARGN}
		DEPENDS ${ARGN})
	add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target}.vcd
		COMMAND vvp ${CMAKE_CURRENT_BINARY_DIR}/${target}.sim
		DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${target}.sim)
	add_custom_target(${target}_simulation
		COMMAND gtkwave ${CMAKE_CURRENT_BINARY_DIR}/${target}.vcd
		DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${target}.vcd)
endfunction(add_simulation_target)

function(add_synthesis_target target pcf_file)
	get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
	add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target}.blif
		COMMAND yosys -q -p \"read_verilog -DICE40_SYNTHESIS=1 -I${dirs} ${ARGN}\; synth_ice40 -blif ${CMAKE_CURRENT_BINARY_DIR}/${target}.blif\"
		DEPENDS ${ARGN})
	add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target}.asf
		COMMAND arachne-pnr -d 1k -P tq144 -p ${pcf_file} ${CMAKE_CURRENT_BINARY_DIR}/${target}.blif -o ${CMAKE_CURRENT_BINARY_DIR}/${target}.asf
		COMMAND icetime -d hx1k -P tq144 ${CMAKE_CURRENT_BINARY_DIR}/${target}.asf
		DEPENDS ${pcf_file} ${CMAKE_CURRENT_BINARY_DIR}/${target}.blif)
	add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target}.bin
		COMMAND icepack ${CMAKE_CURRENT_BINARY_DIR}/${target}.asf ${CMAKE_CURRENT_BINARY_DIR}/${target}.bin
		DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${target}.asf)
	add_custom_target(${target}_synthesis
		DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${target}.bin)
	add_custom_target(${target}_upload
		COMMAND iceprog ${CMAKE_CURRENT_BINARY_DIR}/${target}.bin
		DEPENDS ${target}_synthesis)
endfunction(add_synthesis_target)


