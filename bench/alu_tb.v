`include "avr_cpu_common.vh"

module alu_tb;

	reg [3:0] opcode = 0;
	reg use_carry = 0;
	reg [7:0] r_in = 0;
	reg [7:0] d_in = 0;
	reg [7:0] status_in = 0;
	wire [7:0] out;
	wire [7:0] status_out;

	avr_cpu_alu alu(.opcode(opcode), .use_carry(use_carry), 
		.r_in(r_in), .d_in(d_in), 
		.status_in(status_in), .out(out), .status_out(status_out));

	initial
	begin
		$dumpfile("alu_tb.vcd");
		$dumpvars(0, alu_tb);
		
		#1 opcode <= `ALU_OP_ADD;
		r_in <= 8'd40;
		d_in <= 8'd50;
		
		#1 d_in <= 8'd240;
		
		#1 opcode <= `ALU_OP_XOR;
		r_in <= 8'hFF;
		d_in <= 8'hFF;
		
		#10 $finish;
	end

endmodule
