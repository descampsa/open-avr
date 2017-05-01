module avr_cpu_progmem
	#(parameter ADDR_WIDTH = 9,
	parameter DATA_WIDTH = 16,
	parameter MEM_SIZE = 512)
	(input clk,
	input [ADDR_WIDTH-1:0] addr,
	output reg [DATA_WIDTH-1:0] data);
	
	reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];
	
`ifdef SIMULATION
	initial
	begin
		$readmemh("prog.hex", mem);
	end
`endif
	
	always @ (posedge clk)
	begin
		data <= mem[addr];
	end
	
	/*wire [15:0] data0;
	wire [15:0] data1;
	
	assign data = addr[8] ? data1 : data0;
	
	SB_RAM256x16 ram0 (
		.RDATA(data0),
		.RADDR(addr[7:0]),
		.RCLK(clk),
		.RCLKE(1'b1),
		.RE(1'b1),
		.WADDR(7'b0),
		.WCLK(1'b0),
		.WCLKE(1'b0),
		.WDATA(16'b0),
		.WE(1'b1),
		.MASK(16'b0));
	
	SB_RAM256x16 ram1 (
		.RDATA(data0),
		.RADDR(addr[7:0]),
		.RCLK(clk),
		.RCLKE(1'b1),
		.RE(1'b1),
		.WADDR(7'b0),
		.WCLK(1'b0),
		.WCLKE(1'b0),
		.WDATA(16'b0),
		.WE(1'b1),
		.MASK(16'b0));*/

endmodule

