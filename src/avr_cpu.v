module avr_cpu
	(input clk,
	input rst,
	output [5:0] io_addr,
	inout [7:0] io_data,
	output io_read,
	output io_write);
	
	wire [15:0] opcode;
	wire opcode_cycle;
	wire hold;
	wire [11:0] rjmp;
	
	avr_cpu_fetch fetch(.clk(clk), .rst(rst), .opcode(opcode), .opcode_cycle(opcode_cycle), .hold(hold), .rjmp(rjmp));
	
	avr_cpu_exec exec(.clk(clk), .rst(rst), .opcode(opcode), .opcode_cycle(opcode_cycle), .hold(hold), .rjmp(rjmp), .io_addr(io_addr), .io_data(io_data), .io_read(io_read), .io_write(io_write));
	
endmodule
