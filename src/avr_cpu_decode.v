
`include "avr_cpu_common.vh"

module avr_cpu_decode
	(input [15:0] opcode,
	output reg [3:0] alu,
	output reg [4:0] r_addr,
	output reg [4:0] d_addr,
	output reg [7:0] immediate,
	output reg use_immediate,
	output reg [5:0] io_addr,
	output reg io_read,
	output reg io_write);

	always @(opcode)
	begin
		//default value (result in nop)
		alu = `ALU_OP_MOVE;
		r_addr = 0;
		d_addr = 0;
		immediate = {opcode[11:8], opcode[3:0]};
		use_immediate = 0;
		io_addr = {opcode[10:9], opcode[3:0]};
		io_read = 0;
		io_write = 0;
		
		case(opcode[15:12])
			4'b1110: //LDI
			begin
				d_addr = {1'b1,opcode[7:4]};
				use_immediate = 1;
			end
			4'b1011: //IN or OUT
			begin
				r_addr = opcode[8:4];
				d_addr = opcode[8:4];
				io_write = opcode[11];
				io_read = !opcode[11];
			end
		endcase
	end

endmodule
