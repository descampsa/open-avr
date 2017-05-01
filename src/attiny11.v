module attiny11
	(input clk,
	input rst,
	inout [5:0] portb);
	
	wire [5:0] io_addr;
	wire [7:0] io_data;
	wire io_read;
	wire io_write;
	
	avr_cpu cpu(.clk(clk), .rst(rst), .io_addr(io_addr), .io_data(io_data), .io_read(io_read), .io_write(io_write));
	avr_gpio#(.IO_ADDR(22), .PORT_WIDTH(6)) 
		portb_gpio(.clk(clk), .rst(rst), .io_addr(io_addr), .io_data(io_data), .io_read(io_read), .io_write(io_write), .gpio(portb));
	
endmodule
