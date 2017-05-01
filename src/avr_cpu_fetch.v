module avr_cpu_fetch
	#(parameter PROG_MEM_SIZE = 512,
	parameter PROG_MEM_ADDR_WIDTH = $clog2(PROG_MEM_SIZE))
	(input clk,
	input rst,
	input hold,
	input [11:0] rjmp,
	output reg [15:0] opcode,
	output reg opcode_cycle);

	reg [15:0] pc;
	wire [15:0] new_pc;
	wire [15:0] new_opcode;
	
	assign new_pc = rst ? 0 : pc + extended_rjmp + (hold? 0 : 1);
	
	wire [15:0] extended_rjmp;
	
	assign extended_rjmp = {{4{rjmp[11]}}, rjmp};

	avr_cpu_progmem #(.DATA_WIDTH(16), .ADDR_WIDTH(PROG_MEM_ADDR_WIDTH), .MEM_SIZE(PROG_MEM_SIZE))
		mem (.clk(clk), .addr(new_pc[PROG_MEM_ADDR_WIDTH-1:0]), .data(new_opcode));

	always @ (posedge clk)
	begin
		if(rst)
		begin
			pc <= 16'b0;
			opcode_cycle <= 0;
			opcode <= 0;
		end
		else
		begin
			pc <= new_pc;
			if(hold)
				opcode_cycle <= opcode_cycle+1;
			else
			begin
				opcode <= new_opcode;
				opcode_cycle <= 0;
			end
		end
		
	end

endmodule
