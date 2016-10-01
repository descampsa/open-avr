module stack_tb;
	reg clk = 0;
	wire [8:0] data;
	reg write = 0;
	reg read = 0;

	avr_cpu_stack stack(.clk(clk), .data(data), .write(write), .read(read));

	reg [8:0] input_data = 0;
	wire [8:0] output_data;
	reg enable_input_data = 0;
	assign output_data = data;
	assign data = enable_input_data ? input_data : 9'bz;

	always
		#1 clk <= ~clk;

	initial
	begin
		$dumpfile("stack_tb.vcd");
		$dumpvars(0, stack_tb);

		#1 input_data = 9'd1;
		enable_input_data = 1;
		write = 1;
		
		#2 enable_input_data = 0; 
		write = 0;
		
		#2 input_data = 9'd2;
		enable_input_data = 1;
		write = 1;

		#2 enable_input_data = 0; 
		write = 0;

		#2 input_data = 9'd3;
		enable_input_data = 1;
		write = 1;

		#2 enable_input_data = 0; 
		write = 0;

		#2 input_data = 9'd4;
		enable_input_data = 1;
		write = 1;

		#2 enable_input_data = 0; 
		write = 0;


		#2 read = 1;
		#2 read = 0;
	
		#2 read = 1;
		#2 read = 0;

		#2 read = 1;
		#2 read = 0;

		#2 read = 1;
		#2 read = 0;

		#10 $finish;
	end
endmodule
