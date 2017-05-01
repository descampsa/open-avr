module avr_cpu_exec
	(input clk,
	input rst,
	input [15:0] opcode,
	output [5:0] io_addr,
	inout [7:0] io_data,
	output io_read,
	output io_write);
	
	wire [3:0] alu_opcode;
	wire [4:0] r_addr;
	wire [4:0] d_addr;
	wire [7:0] r_reg;
	wire [7:0] d_reg;
	wire [7:0] immediate;
	wire use_immediate;
	wire [7:0] alu_r_in;
	wire[7:0] alu_out;
	
	assign alu_r_in = use_immediate ? immediate : io_read ? io_data : r_reg;
	assign io_data = io_write ? alu_out : 8'bZ;
	
	avr_cpu_decode decode(.opcode(opcode), .alu(alu_opcode), .r_addr(r_addr), .d_addr(d_addr), .immediate(immediate), .use_immediate(use_immediate), .io_addr(io_addr), .io_read(io_read), .io_write(io_write));
	avr_cpu_register register(.clk(clk), .rst(rst), .r_addr(r_addr), .d_addr(d_addr), .r_out(r_reg), .d_out(d_reg), .d_in(alu_out));
	avr_cpu_alu alu(.opcode(alu_opcode), .r_in(alu_r_in), .d_in(d_reg), .out(alu_out));
endmodule

