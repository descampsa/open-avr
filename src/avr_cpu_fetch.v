module avr_cpu_fetch
	#(parameter PROG_MEM_SIZE = 512,
	parameter PROG_MEM_ADDR_WIDTH = $clog2(PROG_MEM_SIZE))
	(input clk,
	input rst,
	output reg [15:0] opcode);

	reg [15:0] pc;

	wire [15:0] new_opcode;

	avr_cpu_progmem #(.DATA_WIDTH(16), .ADDR_WIDTH(PROG_MEM_ADDR_WIDTH), .MEM_SIZE(PROG_MEM_SIZE))
		mem (.clk(clk), .addr(pc[PROG_MEM_ADDR_WIDTH-1:0]), .data(new_opcode));

	always @ (posedge clk)
	begin
		if(rst)
			pc <= 16'b0;
		else
			pc <= pc+1;
		
		opcode <=new_opcode;
	end

endmodule
