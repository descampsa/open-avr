module cpu_tb;
	reg clk = 0;
	reg rst = 1;

	avr_cpu cpu(.clk(clk),.rst(rst));

	always
		#5 clk <= ~clk;

	initial
	begin
		$dumpfile("cpu_tb.vcd");
		$dumpvars(0, cpu_tb);
		
		#10 rst = 0;
		
		#200 $finish;
	end

endmodule
