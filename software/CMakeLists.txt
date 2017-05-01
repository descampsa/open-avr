add_custom_target(software DEPENDS ${PROJECT_BINARY_DIR}/bench/prog.hex)
add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/prog.hex
	COMMAND avra -I /usr/share/avra ${CMAKE_CURRENT_SOURCE_DIR}/prog.asm
	COMMAND mv ${CMAKE_CURRENT_SOURCE_DIR}/prog.hex ${CMAKE_CURRENT_BINARY_DIR}
	COMMAND touch ${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_progmem.v
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/prog.asm
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
add_custom_command(OUTPUT ${PROJECT_BINARY_DIR}/bench/prog.hex
	COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/convert_hex.awk ${CMAKE_CURRENT_BINARY_DIR}/prog.hex 512 > ${PROJECT_BINARY_DIR}/bench/prog.hex
	DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/prog.hex)
