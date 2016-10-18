
`include "avr_cpu_common.vh"

module avr_cpu_alu(
	input [3:0] opcode,
	input use_carry,
	input [7:0] r_in, d_in,
	output reg [7:0] out,
	input [7:0] status_in,
	output reg [7:0] status_out,
	input [3:0] bits);

	wire carry_in;
	assign carry_in = use_carry & status_in[0];

	wire [7:0] com, neg;
	assign com = ~d_in;
	assign neg = com + 1;

	wire [7:0] inc, dec;
	assign inc = d_in + 1;
	assign dec = d_in - 1;

	wire [8:0] add, sub;
	assign add = d_in + r_in + carry_in;
	assign sub = d_in - r_in - carry_in;

	wire [7:0] and_, or_, xor_;
	assign and_ = d_in & r_in;
	assign or_ = d_in | r_in;
	assign xor_ = d_in ^ r_in;

	wire zero = (out == 0);
	
	always @ (opcode, use_carry, r_in, d_in, status_in, bits,
			carry_in, com, neg, inc, dec, add, sub, and_, or_, xor_)
	begin
		//default values
		out = r_in;
		status_out = status_in;
		
		case(opcode)

			`ALU_OP_COM: begin //com
				out = com;
				status_out[0] = 1;
				status_out[3] = 0;
			end
			`ALU_OP_NEG: begin //neg
				out = neg;
				status_out[0] = ~zero;
				status_out[3] = (out == 8'b10000000);
				status_out[5] = out[3] | ~r_in[3];
			end
			`ALU_OP_INC: begin //inc
				out = inc;
				status_out[3] = (out == 8'b10000000);
			end
			`ALU_OP_DEC: begin //dec
				out = dec;
				status_out[3] = (out == 8'b01111111);
			end

			`ALU_OP_ADD: begin //add
				{status_out[0],out} = add;
				status_out[3] = (d_in[7] & r_in[7] & ~out[7]) | (~d_in[7] & ~r_in[7] & out[7]);
				status_out[5] = (d_in[3] & r_in[3]) | (d_in[3] & ~out[3]) | (r_in[3] & ~out[3]);
			end
			`ALU_OP_SUB: begin //subtract with carry
				{status_out[0],out} = sub;
				status_out[3] = (d_in[7] & ~r_in[7] & ~out[7]) | (~d_in[7] & r_in[7] & out[7]);
				status_out[5] = (~d_in[3] & r_in[3]) | (r_in[3] & out[3]) | (~d_in[3] & out[3]);
			end

			`ALU_OP_AND: begin //and
				out = and_;
				status_out[3] = 0;
			end
			`ALU_OP_OR: begin //or
				out = or_;
				status_out[3] = 0;
			end
			`ALU_OP_XOR: begin //xor
				out = xor_;
				status_out[3] = 0;
			end

			`ALU_OP_RIGHT_SHIFT: begin //right shift
				{out[6:0],status_out[0]} = d_in[7:0];
				out[7] = carry_in;
			end
			`ALU_OP_ARITH_RIGHT_SHIFT: begin //arith right shift
				{out[6:0],status_out[0]} = d_in[7:0];
				out[7] = d_in[7];
			end

			`ALU_OP_SWAP: begin //swap
				{out[3:0],out[7:4]} = d_in[7:0];
			end
			`ALU_OP_SET_BIT: begin //set/reset flag/bit
				out[bits[2:0]] = bits[3];
				status_out[bits[2:0]] = bits[3];
			end
			`ALU_OP_TRANSFERT: begin // read and write T flag
				out[bits[2:0]] = status_in[6] ^ bits[3];
				status_out[6] = r_in[bits[2:0]] ^ bits[3];
			end
			`ALU_OP_COPY_TEST: begin // copy output and test status bits
				status_out[6] = status_in[bits[2:0]] ^ bits[3];
			end

		endcase
		if(opcode[1:0] != 2'b11)
		begin
			if(opcode != `ALU_OP_SUB)
				status_out[1] = zero;
			else
				status_out[1] = zero & (status_in[1] | ~use_carry);
			status_out[2] = out[7];
			if(opcode == `ALU_OP_RIGHT_SHIFT | opcode == `ALU_OP_ARITH_RIGHT_SHIFT)
				status_out[3] = status_out[0] ^ status_out[2];
			status_out[4] = status_out[2] ^ status_out[3];

		end
	end
endmodule


