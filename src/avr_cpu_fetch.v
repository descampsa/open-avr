module avr_cpu_fetch(
	input clk,
	input rst,
	output reg [15:0] opcode,
	output reg cycle,
	input [15:0] pc_update,
	input read_stack,
	input write_stack,
	input hold,
	input lpm_read,
	input [15:0] lpm_addr,
	output [7:0] lpm_data);

	reg [15:0] pc;

	wire [15:0] new_pc;
	wire [8:0] read_addr;
	wire [2:0] new_cycle;
	wire [15:0] new_opcode;
	
	avr_cpu_progmem mem(.clk(clk), .addr(read_addr), .data(new_opcode));

	wire [8:0] stack_pc;
	assign stack_pc = read_stack ? 9'bZ : pc[8:0];
	avr_cpu_stack stack(.clk(clk), .data(stack_pc), .read(read_stack), .write(write_stack));

	// compute new pc/ value
	assign new_pc = read_stack ? {7'b0,stack_pc} : pc + pc_update + {15'b0,~hold};
	assign new_cycle = hold ? ~cycle : 0;
	
	assign read_addr = lpm_read ? lpm_addr[9:1] : new_pc[8:0];

	assign lpm_data = lpm_addr[0] ? new_opcode[15:8] : new_opcode[7:0];

	// used to delay output by one clock after reset goes down
	reg valid = 1'b0;

	// update registers
	always @ (posedge clk)
	begin
		if(rst)
		begin
			cycle <= 1'b0;
			pc <= 16'b1111111111111111;
			opcode <= 16'b0000000000000000;
			valid <= 1'b0;
		end
		else
		begin
			valid <= 1'b1;
			if(~lpm_read)
			begin
				if(~hold & valid)
					opcode <= new_opcode;
				pc <= new_pc;
			end
			cycle <= new_cycle;
		end
	end

endmodule
