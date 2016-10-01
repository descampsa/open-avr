module avr_cpu(
	input clk,
	input rst,
	output [5:0] io_addr,
	output io_read,
	output io_write,
	input [7:0] io_in,
	output [7:0] io_out);
	
	wire [15:0] opcode;
	wire cycle;
	wire [15:0] pc_update;
	wire read_stack;
	wire write_stack;
	wire hold;
	wire lpm_read;
	wire [15:0] lpm_addr;
	wire [7:0] lpm_data;
	
	avr_cpu_fetch fetch(.clk(clk), .rst(rst), .opcode(opcode), .cycle(cycle), .pc_update(pc_update), 
		.read_stack(read_stack), .write_stack(write_stack), .hold(hold), 
		.lpm_read(lpm_read), .lpm_addr(lpm_addr), .lpm_data(lpm_data));
	
	avr_cpu_exec exec(.clk(clk), .rst(rst), .opcode(opcode), .cycle(cycle), 
		.io_addr(io_addr), .io_read(io_read), .io_write(io_write), .io_in(io_in), .io_out(io_out),
		.pc_update(pc_update), .hold(hold), .stack_read(read_stack), .stack_write(write_stack),
		.lpm_read(lpm_read), .lpm_addr(lpm_addr), .lpm_data(lpm_data));
	
endmodule
