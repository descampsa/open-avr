
`include "avr_cpu_common.vh"

module avr_cpu_decode(
	input [15:0] opcode,
	input cycle,
	output reg [3:0] alu_opcode,
	output reg alu_use_carry,
	output reg [4:0] r_addr,
	output reg [4:0] d_addr,
	output reg register_write,
	output reg status_write,
	output reg [7:0] immediate,
	output reg use_immediate,
	output reg [15:0] pc_update,
	output reg stack_write,
	output reg stack_read,
	output reg hold,
	output reg z_hold,
	output reg t_hold,
	output reg [3:0] alu_bits,
	output reg [5:0] io_addr,
	output reg io_read,
	output reg io_write,
	output reg z_r_addr,
	output reg z_d_addr,
	output reg lpm_access,
	output reg lpm_read);


	always @ (opcode,cycle)
	begin
		// default output (NOP)
		alu_opcode = 0;
		alu_use_carry = 0;
		r_addr = 0;
		d_addr = 0;
		register_write = 0;
		status_write = 0;
		immediate = {opcode[11:8],opcode[3:0]};
		use_immediate = 0;
		hold = 0;
		pc_update = 0;
		stack_write = 0;
		stack_read = 0;
		hold = 0;
		z_hold = 0;
		t_hold = 0;
		alu_bits = 0;
		io_addr = 0;
		io_read = 0;
		io_write = 0;
		z_r_addr = 0;
		z_d_addr = 0;
		lpm_access = 0;
		lpm_read = 0;

		case(opcode[15:12])
			4'b0000: begin
				if(opcode[11:10] == 2'b11) //ADD, LSL
				begin
					alu_opcode = `ALU_OP_ADD;
					r_addr = {opcode[9],opcode[3:0]};
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if(opcode[11:10] == 2'b10) //SBC
				begin
					alu_opcode = `ALU_OP_SUB;
					alu_use_carry = 1;
					r_addr = {opcode[9],opcode[3:0]};
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if(opcode[11:10] == 2'b01) //CPC
				begin
					alu_opcode = `ALU_OP_SUB;
					alu_use_carry = 1;
					r_addr = {opcode[9],opcode[3:0]};
					d_addr = opcode[8:4];
					status_write = 1;
				end
			end
			4'b0001: begin
				if(opcode[11:10] == 2'b11) //ADC
				begin
					alu_opcode = `ALU_OP_ADD;
					alu_use_carry = 1;
					r_addr = {opcode[9],opcode[3:0]};
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if(opcode[11:10] == `ALU_OP_SUB) //SUB
				begin
					alu_opcode = `ALU_OP_SUB;
					r_addr = {opcode[9],opcode[3:0]};
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if(opcode[11:10] == 2'b00) //CPSE
				begin
					if(cycle == 1'b0)
					begin
						alu_opcode = `ALU_OP_SUB;
						r_addr = {opcode[9],opcode[3:0]};
						d_addr = opcode[8:4];
						register_write = 0;
						z_hold = 1;
					end
				end
				if(opcode[11:10] == 2'b01) //CP
				begin
					alu_opcode = `ALU_OP_SUB;
					r_addr = {opcode[9],opcode[3:0]};
					d_addr = opcode[8:4];
					status_write = 1;
				end
			end
			4'b0010: begin
				if(opcode[11:10] == 2'b00) //AND, TST
				begin
					alu_opcode = `ALU_OP_AND;
					r_addr = {opcode[9],opcode[3:0]};
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if(opcode[11:10] == 2'b10) //OR
				begin
					alu_opcode = `ALU_OP_OR;
					r_addr = {opcode[9],opcode[3:0]};
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if(opcode[11:10] == 2'b01) //EOR, CLR
				begin
					alu_opcode = `ALU_OP_XOR;
					r_addr = {opcode[9],opcode[3:0]};
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if(opcode[11:10] == 2'b11) //MOV
				begin
					alu_opcode = `ALU_OP_COPY_TEST;
					r_addr = {opcode[9],opcode[3:0]};
					d_addr = opcode[8:4];
					register_write = 1;
				end
			end
			4'b0011: begin //CPI
				alu_opcode = `ALU_OP_SUB;
				d_addr = {1'b1,opcode[7:4]};
				use_immediate = 1;
				status_write = 1;
			end
			4'b0100: begin //SBCI
				alu_opcode = `ALU_OP_SUB;
				alu_use_carry = 1;
				d_addr = {1'b1,opcode[7:4]};
				register_write = 1;
				status_write = 1;
				use_immediate = 1;
			end
			4'b0101: begin //SUBI
				alu_opcode = `ALU_OP_SUB;
				d_addr = {1'b1,opcode[7:4]};
				register_write = 1;
				status_write = 1;
				use_immediate = 1;
			end
			4'b0110: begin //ORI, SBR
				alu_opcode = `ALU_OP_OR;
				d_addr = {1'b1,opcode[7:4]};
				register_write = 1;
				status_write = 1;
				use_immediate = 1;
			end
			4'b0111: begin //ANDI, CBR
				alu_opcode = `ALU_OP_AND;
				d_addr = {1'b1,opcode[7:4]};
				register_write = 1;
				status_write = 1;
				use_immediate = 1;
			end
			4'b1000: begin
				if({opcode[11:9],opcode[3:0]} == 7'b0000000) // LD
				begin
					alu_opcode = `ALU_OP_COPY_TEST;
					d_addr = opcode[8:4];
					register_write = 1;
					z_r_addr = 1;
				end
				if({opcode[11:9],opcode[3:0]} == 7'b0010000) // ST
				begin
					alu_opcode = `ALU_OP_COPY_TEST;
					r_addr = opcode[8:4];
					register_write = 1;
					z_d_addr = 1;
				end
			end
			4'b1001: begin
				if({opcode[11:9],opcode[3:0]} == 7'b0100000) //COM
				begin
					alu_opcode = `ALU_OP_COM;
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if({opcode[11:9],opcode[3:0]} == 7'b0100001) //NEG
				begin
					alu_opcode = `ALU_OP_NEG;
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if({opcode[11:9],opcode[3:0]} == 7'b0100011) //INC
				begin
					alu_opcode = `ALU_OP_INC;
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if({opcode[11:9],opcode[3:0]} == 7'b0101010) //DEC
				begin
					alu_opcode = `ALU_OP_DEC;
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if(opcode[11:0] == 12'b010100001000) //RET
				begin
					if(cycle == 1'b0)
					begin
						stack_read = 1;
						hold = 1;
					end
				end
				if(opcode[11:0] == 12'b01000011000) //RETI
				begin
					if(cycle == 1'b0)
					begin
						stack_read = 1;
						alu_opcode = `ALU_OP_SET_BIT;
						alu_bits = 4'b1111;
						status_write = 1;
						hold = 1;
					end
				end
				if(opcode[11:8] == 4'b1001) //SBIC
				begin
					alu_opcode = `ALU_OP_TRANSFERT;
					alu_bits = {1'b1,opcode[2:0]};
					io_addr = opcode[8:3];
					io_read = 1;
					t_hold = 1;
				end
				if(opcode[11:8] == 4'b1011) //SBIS
				begin
					alu_opcode = `ALU_OP_TRANSFERT;
					alu_bits = {1'b0,opcode[2:0]};
					io_addr = opcode[8:3];
					io_read = 1;
					t_hold = 1;
				end
				if(opcode[11:0] == 12'b010111001000) //LPM
				begin
					if(cycle == 1'b0)
					begin
						lpm_access = 1;
						hold = 1;
					end
					else if(cycle == 1'b1)
					begin
						alu_opcode = `ALU_OP_COPY_TEST;
						register_write = 1;
						d_addr = 0;
						lpm_read = 1;
					end
				end
				if(opcode[11:8] == 4'b1010) //SBI
				begin
					if(cycle == 1'b0)
					begin
						io_read = 1;
						io_addr = opcode[7:4];
						hold = 1;
					end
					else if(cycle == 1'b1)
					begin
						alu_opcode = `ALU_OP_SET_BIT;
						alu_bits = {1'b1,opcode[2:0]};
						io_write = 1;
						io_addr = opcode[7:4];
					end
				end
				if({opcode[11:9],opcode[3:0]} == 7'b0100110) //LSR
				begin
					alu_opcode = `ALU_OP_RIGHT_SHIFT;
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if({opcode[11:9],opcode[3:0]} == 7'b0100111) //ROR
				begin
					alu_opcode = `ALU_OP_RIGHT_SHIFT;
					d_addr = opcode[8:4];
					alu_use_carry = 1;
					register_write = 1;
					status_write = 1;
				end
				if({opcode[11:9],opcode[3:0]} == 7'b0100101) //ASR
				begin
					alu_opcode = `ALU_OP_ARITH_RIGHT_SHIFT;
					d_addr = opcode[8:4];
					register_write = 1;
					status_write = 1;
				end
				if({opcode[11:9],opcode[3:0]} == 7'b0100010) //SWAP
				begin
					alu_opcode = `ALU_OP_RIGHT_SHIFT;
					d_addr = opcode[8:4];
					register_write = 1;
				end
				if({opcode[11:7],opcode[3:0]} == 9'b010001000) //BSET, etc
				begin
					alu_opcode = `ALU_OP_SET_BIT;
					alu_bits = {1'b1,opcode[6:4]};
					status_write = 1;
				end
				if({opcode[11:7],opcode[3:0]} == 9'b010001000) //BCLR, etc
				begin
					alu_opcode = `ALU_OP_SET_BIT;
					alu_bits = {1'b0,opcode[6:4]};
					status_write = 1;
				end
			end
			4'b1010: begin
			end
			4'b1011: begin
				if(opcode[11] == 1'b0) //IN
				begin
					alu_opcode = `ALU_OP_COPY_TEST;
					d_addr = opcode[8:4];
					io_addr = {opcode[10:9],opcode[3:0]};
					io_read = 1;
					register_write = 1;
				end
				if(opcode[11] == 1'b1) //OUT
				begin
					alu_opcode = `ALU_OP_COPY_TEST;
					r_addr = opcode[8:4];
					io_addr = {opcode[10:9],opcode[3:0]};
					io_write = 1;
				end
			end
			4'b1100: begin //RJMP
				if(cycle == 1'b0)
				begin
					pc_update = {opcode[11],opcode[11],opcode[11],opcode[11],opcode[11:0]};
					hold = 1;
				end
			end
			4'b1101: begin //RCALL
				if(cycle == 1'b0)
				begin
					pc_update = {opcode[11],opcode[11],opcode[11],opcode[11],opcode[11:0]};
					stack_write = 1;
					hold = 1;
				end
			end
			4'b1110: begin //SER,LDI
				alu_opcode = `ALU_OP_COPY_TEST;
				d_addr = {1'b1,opcode[7:4]};
				use_immediate = 1;
				register_write = 1;
			end
			4'b1111: begin
				if({opcode[11:9],opcode[3]} == 4'b1100) //SBRC
				begin
					alu_opcode = `ALU_OP_TRANSFERT;
					alu_bits = {1'b1,opcode[2:0]};
					d_addr = opcode[8:4];
					t_hold = 1;
				end
				if({opcode[11:9],opcode[3]} == 4'b1110) //SBRS
				begin
					alu_opcode = `ALU_OP_TRANSFERT;
					alu_bits = {1'b0,opcode[2:0]};
					d_addr = opcode[8:4];
					t_hold = 1;
				end
				if(opcode[11:10] == 2'b00) //BRBS, etc
				begin
					alu_opcode = `ALU_OP_COPY_TEST;
					alu_bits = {1'b0,opcode[2:0]};
					t_hold = 1;
					pc_update = {opcode[9],opcode[9],opcode[9],opcode[9],opcode[9],opcode[9],opcode[9],opcode[9],opcode[9],opcode[9:3]};
				end
				if(opcode[11:10] == 2'b01) //BRBC, etc
				begin
					alu_opcode = `ALU_OP_COPY_TEST;
					alu_bits = {1'b1,opcode[2:0]};
					t_hold = 1;
					pc_update = {opcode[9],opcode[9],opcode[9],opcode[9],opcode[9],opcode[9],opcode[9],opcode[9],opcode[9],opcode[9:3]};
				end
				if({opcode[11:9],opcode[3]} == 4'b1010) //BST
				begin
					alu_opcode = `ALU_OP_TRANSFERT;
					alu_bits = {1'b0,opcode[2:0]};
					r_addr = opcode[8:4];
					status_write = 1;
				end
				if({opcode[11:9],opcode[3]} == 4'b1000) //BLD
				begin
					alu_opcode = `ALU_OP_TRANSFERT;
					alu_bits = {1'b0,opcode[2:0]};
					d_addr = opcode[8:4];
					register_write = 1;
				end
			end
		endcase
	end
endmodule
