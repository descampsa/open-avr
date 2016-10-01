module fetch_tb;
	reg clk = 0;
	reg [15:0] pc_update = 0;
	reg read_stack = 0;
	reg write_stack = 0;
	reg hold = 0;
	reg rst = 1;
	
	wire [15:0] opcode;
	wire [1:0] cycle;

	avr_cpu_fetch fetch(.clk(clk), .rst(rst), .pc_update(pc_update), .read_stack(read_stack), .write_stack(write_stack), .hold(hold), .opcode(opcode), .cycle(cycle));

	always
		#1 clk <= ~clk;


	initial
	begin
		$dumpfile("fetch_tb.vcd");
		$dumpvars(0, fetch_tb);
		
		#6 rst = 0;
		
		// testing pc_update
		#10 pc_update = -1;
		#2 pc_update = 0;
		
		#4 pc_update = 5;
		#2 pc_update = 0;
		
		//testing hold
		#4 hold = 1;
		#2 hold = 0;
		
		#4 hold = 1;
		#4 hold = 0;
		
		//testing stack
		#4 write_stack = 1;
		#2 write_stack = 0;
		
		#8 read_stack = 1;
		#2 read_stack = 0;
		
		//test rjmp
		#4 pc_update = 5;
		hold = 1;
		#2 pc_update = 0;
		hold = 0;
		
		//test rcall, then ret
		#4 pc_update = 5;
		hold = 1;
		write_stack = 1;
		#2 pc_update = 0;
		hold = 0;
		write_stack = 0;
		
		#8 read_stack = 1;
		hold = 1;
		#2 read_stack = 0;
		hold = 0;
		
		#10 $finish;
	end

endmodule
