
`include "avr_cpu_common.vh"

module avr_cpu_alu
	(input [3:0] opcode,
	input [7:0] r_in,
	input [7:0] d_in,
	output reg [7:0] out);
	
	always @ (opcode, r_in, d_in)
	begin
		//default values
		out = r_in;
		
		case(opcode)
			`ALU_OP_MOVE:
			begin //nothing to do, default behaviour
			end
		endcase
	end
endmodule


