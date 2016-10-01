
`include "avr_cpu_common.vh"

module avr_cpu_alu(
	input [3:0] opcode,
	input use_carry,
	input [7:0] r_in, d_in,
	output reg [7:0] out,
	input [7:0] status_in,
	output reg [7:0] status_out,
	input [3:0] bits);

	reg carry_in;

	always @ (opcode, use_carry, r_in, d_in, status_in, bits)
	begin
		//default values
		out = r_in;
		status_out = status_in;
		
		carry_in = use_carry & status_in[0];
		
		case(opcode)
			`ALU_OP_COPY_TEST: begin // set output and test status bits
				out = r_in;
				status_out[6] = status_in[bits[2:0]] ^ bits[3];
			end
			`ALU_OP_COM: begin //com
				out = ~d_in;
				status_out[0] = 1;
				status_out[1] = (out == 0);
				status_out[2] = out[7];
				status_out[3] = 0;
				status_out[4] = status_out[2] ^ status_out[3];
			end
			`ALU_OP_NEG: begin //neg
				out = -d_in;
				status_out[0] = (out != 0);
				status_out[1] = (out == 0);
				status_out[2] = out[7];
				status_out[3] = (out == 8'b10000000);
				status_out[4] = status_out[2] ^ status_out[3];
				status_out[5] = out[3] | ~r_in[3];
			end
			`ALU_OP_INC: begin //inc
				out = d_in + 1;
				status_out[1] = (out == 0);
				status_out[2] = out[7];
				status_out[3] = (out == 8'b10000000);
				status_out[4] = status_out[2] ^ status_out[3];
			end
			`ALU_OP_DEC: begin //dec
				out = d_in - 1;
				status_out[1] = (out == 0);
				status_out[2] = out[7];
				status_out[3] = (out == 8'b01111111);
				status_out[4] = status_out[2] ^ status_out[3];
			end
			`ALU_OP_SET_BIT: begin //set/reset flag/bit
				out = r_in;
				out[bits[2:0]] = bits[3];
				status_out[bits[2:0]] = bits[3];
			end
			`ALU_OP_TRANSFERT: begin // read and write T flag
				out = r_in;
				out[bits[2:0]] = status_in[6] ^ bits[3];
				status_out[6] = r_in[bits[2:0]] ^ bits[3];
			end
			`ALU_OP_ADD: begin //add
				{status_out[0],out} = d_in + r_in + carry_in;
				status_out[1] = (out == 0);
				status_out[2] = out[7];
				status_out[3] = (d_in[7] & r_in[7] & ~out[7]) | (~d_in[7] & ~r_in[7] & out[7]);
				status_out[4] = status_out[2] ^ status_out[3];
				status_out[5] = (d_in[3] & r_in[3]) | (d_in[3] & ~out[3]) | (r_in[3] & ~out[3]);
			end
			`ALU_OP_SUB: begin //subtract
				{status_out[0],out} = d_in - d_in - carry_in;
				status_out[1] = (out==0) & status_in[0];
				status_out[2] = out[7];
				status_out[3] = (d_in[7] & ~r_in[7] & ~out[7]) | (~d_in[7] & r_in[7] & out[7]);
				status_out[4] = status_out[2] ^ status_out[3];
				status_out[5] = (~d_in[3] & r_in[3]) | (r_in[3] & out[3]) | (~d_in[3] & out[3]);
			end
			`ALU_OP_AND: begin //and
				out = d_in & r_in;
				status_out[1] = (out == 0);
				status_out[2] = out[7];
				status_out[3] = 0;
				status_out[4] = status_out[2] ^ status_out[3];
			end
			`ALU_OP_OR: begin //or
				out = d_in | r_in;
				status_out[1] = (out == 0);
				status_out[2] = out[7];
				status_out[3] = 0;
				status_out[4] = status_out[2] ^ status_out[3];
			end
			`ALU_OP_XOR: begin //xor
				out = d_in ^ r_in;
				status_out[1] = (out == 0);
				status_out[2] = out[7];
				status_out[3] = 0;
				status_out[4] = status_out[2] ^ status_out[3];
			end
			`ALU_OP_SWAP: begin //swap
				{out[3:0],out[7:4]} = d_in[7:0];
			end
			`ALU_OP_RIGHT_SHIFT: begin //right shift
				{out[6:0],status_out[0]} = d_in[7:0];
				out[7] = bits[0] ? d_in[7] : carry_in;
				status_out[1] = (out == 0);
				status_out[2] = out[7];
				status_out[3] = status_out[0] ^ status_out[2];
				status_out[4] = status_out[2] ^ status_out[3];
			end
		endcase
	end
endmodule


