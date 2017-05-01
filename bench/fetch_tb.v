module fetch_tb;
	reg clk = 0;
	reg rst = 1;
	wire [15:0] opcode;

	avr_cpu_fetch #(.PROG_MEM_SIZE(512))
		fetch (.clk(clk), .rst(rst), .opcode(opcode));

	always
		#5 clk <= ~clk;


	initial
	begin
		$dumpfile("fetch_tb.vcd");
		$dumpvars(0, fetch_tb);
		
		#10 rst = 0;
		
		#1000 $finish;
	end

endmodule
