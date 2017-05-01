module avr_cpu_stack
	#(parameter DATA_WIDTH = 9,
	parameter STACK_DEPTH = 3,
	parameter ADDR_WIDTH = $clog2(STACK_DEPTH+1))
	(input clk,
	input rst,
	input read,
	input write,
	inout [DATA_WIDTH-1:0] data);

	reg [ADDR_WIDTH-1:0] addr;
	reg [DATA_WIDTH-1:0] buffer [0:STACK_DEPTH-1];
	reg [DATA_WIDTH-1:0] data_out;

	assign data = read ? data_out : {DATA_WIDTH{1'bz}};

	always @(posedge clk)
	begin
		if(rst)
			addr <= 0;
		else if(read)
			addr <= addr-1;
		else if(write)
			addr <= addr+1;

		if(write)
			buffer[addr] <= data;

		data_out <= buffer[addr-1];
	end

endmodule
