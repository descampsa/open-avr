module timer_tb;
	reg clk = 0;
	reg rst = 1;
	reg [5:0] io_addr = 0;
	reg [7:0] io_data_reg =0;
	wire [7:0] io_data;
	reg io_read = 0;
	reg io_write = 0;
	reg T0 = 0;
	
	assign io_data = io_write ? io_data_reg : 8'bZ;

	avr_timer timer(.clk(clk),.rst(rst), .io_addr(io_addr), .io_data(io_data), .io_read(io_read), .io_write(io_write), .T0(T0));

	always
		#5 clk <= ~clk;
	
	always
		#30 T0 <= ~T0;

	initial
	begin
		$dumpfile("timer_tb.vcd");
		$dumpvars(0, timer_tb);
		//$dumpvars(0, uc.cpu.exec.register.register_bank[16]);
		
		#10 rst = 0;
		
		#25 io_write = 1;
		io_addr = 1;
		io_data_reg = 1;
		#10 io_write = 0;
		io_data_reg = 0;
		
		#10000 io_write = 1;
		io_addr = 1;
		io_data_reg = 2;
		#10 io_write = 0;
		io_data_reg = 0;
		
		#10000 io_write = 1;
		io_addr = 1;
		io_data_reg = 3;
		#10 io_write = 0;
		io_data_reg = 0;
		
		#10000 io_write = 1;
		io_addr = 1;
		io_data_reg = 4;
		#10 io_write = 0;
		io_data_reg = 0;
		
		#10000 io_write = 1;
		io_addr = 1;
		io_data_reg = 5;
		#10 io_write = 0;
		io_data_reg = 0;
		
		#10000 io_write = 1;
		io_addr = 1;
		io_data_reg = 6;
		#10 io_write = 0;
		io_data_reg = 0;
		
		#10000 io_write = 1;
		io_addr = 1;
		io_data_reg = 7;
		#10 io_write = 0;
		io_data_reg = 0;
		
		#10000 $finish;
	end

endmodule
