module attiny11_tb;
	reg clk = 0;
	reg rst = 1;
	wire [5:0] portb;

	attiny11 uc(.clk(clk),.rst(rst), .portb(portb));

	always
		#5 clk <= ~clk;

	initial
	begin
		$dumpfile("attiny_tb.vcd");
		$dumpvars(0, attiny11_tb);
		//$dumpvars(0, uc.cpu.exec.register.register_bank[16]);
		
		#10 rst = 0;
		
		#500 $finish;
	end

endmodule
