add_synthesis_target(avr_cpu_alu ${CMAKE_CURRENT_SOURCE_DIR}/avr_cpu_alu.pcf ${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_alu.v)
add_synthesis_target(avr_cpu ${CMAKE_CURRENT_SOURCE_DIR}/avr_cpu.pcf 
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu.v 
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_stack.v
	${CMAKE_CURRENT_SOURCE_DIR}/../src/synth/ice40/avr_cpu_progmem.v
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_fetch.v 
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_alu.v
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_decode.v
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_register.v
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_exec.v)
