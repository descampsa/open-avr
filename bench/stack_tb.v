module stack_tb;
	reg clk, rst, read, write;
	wire [8:0] data;
	reg [8:0] data_reg;
	
	assign data = data_reg;

	avr_cpu_stack stack(.clk(clk), .rst(rst), .read(read), .write(write), .data(data));

	always
		#5 clk = !clk; 

	initial
	begin
		$dumpfile("stack_tb.vcd");
		$dumpvars(0,stack_tb);
		$dumpvars(0, stack.buffer[0], stack.buffer[1], stack.buffer[2]);

		clk=0;
		rst=1;
		read=0;
		write=0;
		data_reg='bz;

		#15;
		rst=0;

		#20;
		write=1;
		data_reg=1;

		#10;
		data_reg=2;

		#10;
		data_reg=3;

		#10
		write=0;
		read=1;
		data_reg='bz;

		#30;
		read=0;

		#50;
		$finish;
	end
endmodule
