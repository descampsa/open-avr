module avr_cpu_register
	(input clk,
	input rst,
	input [4:0] r_addr,
	input [4:0] d_addr,
	output [7:0] r_out,
	output [7:0] d_out,
	input [7:0] d_in);

	reg [7:0] register_bank [0:31];

	assign r_out = register_bank[r_addr];
	assign d_out = register_bank[d_addr];

	integer i;
	always @ (posedge clk)
	begin
		if(rst)
			for(i=0; i<32; i=i+1)
				register_bank[i] <= 8'b0;
		else
			register_bank[d_addr] <= d_in;
	end
endmodule
