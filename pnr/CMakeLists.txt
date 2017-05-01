add_synthesis_target(attiny11 ${CMAKE_CURRENT_SOURCE_DIR}/attiny11.pcf 
	${CMAKE_CURRENT_SOURCE_DIR}/../src/attiny11.v
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu.v 
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_progmem.v
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_fetch.v 
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_decode.v
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_exec.v
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_alu.v
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_cpu_register.v
	${CMAKE_CURRENT_SOURCE_DIR}/../src/avr_gpio.v)
