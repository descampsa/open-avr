module cpu_tb;
	reg clk = 0;
	reg rst = 0;
	
	wire [5:0] io_addr;
	wire io_read;
	wire io_write;
	wire [7:0] io_data;

	avr_cpu cpu(.clk(clk),.rst(rst), .io_addr(io_addr), .io_read(io_read), .io_write(io_write), .io_data(io_data));

	always
		#1 clk <= ~clk;

	initial
	begin
		$dumpfile("cpu_tb.vcd");
		$dumpvars(0, cpu_tb);
		
		rst = 1;
		#6 rst = 0;
		
		#100 $finish;
	end

endmodule
