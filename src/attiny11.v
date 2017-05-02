module attiny11
	(input clk,
	input rst,
	inout [5:0] portb,
	input T0);
	
	wire [5:0] io_addr;
	wire [7:0] io_data;
	wire io_read;
	wire io_write;
	
	wire rst_inv;
	
	avr_cpu cpu(.clk(clk), .rst(~rst_inv), .io_addr(io_addr), .io_data(io_data), .io_read(io_read), .io_write(io_write));
	avr_gpio#(.IO_ADDR(22), .PORT_WIDTH(6)) 
		portb_gpio(.clk(clk), .rst(~rst_inv), .io_addr(io_addr), .io_data(io_data), .io_read(io_read), .io_write(io_write), .gpio(portb));
	avr_timer#(.IO_ADDR(50))
		timer0(.clk(clk), .rst(~rst_inv), .io_addr(io_addr), .io_data(io_data), .io_read(io_read), .io_write(io_write), .T0(T0));
	
`ifdef ICE40_SYNTHESIS
	SB_IO #(.PIN_TYPE(6'b000000), .PULLUP(1'b1)) 
		rst_pin(.PACKAGE_PIN(rst), .D_IN_0(rst_inv), .INPUT_CLK(clk));
`endif
endmodule
