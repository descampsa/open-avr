module avr_cpu_register(
	input clk,
	input [4:0] r_addr,
	input [4:0] d_addr,
	output [7:0] r_out,
	output [7:0] d_out,
	input [7:0] in,
	input write,
	output [15:0] z,
	input z_r_addr,
	input z_d_addr);

	reg [7:0] register_bank [0:31];
	
	assign z = {register_bank[30],register_bank[31]};
	
	wire [4:0] int_r_addr;
	wire [4:0] int_d_addr;
	assign int_r_addr = z_r_addr ? z[4:0] : r_addr;
	assign int_d_addr = z_d_addr ? z[4:0] : d_addr;
	
	assign r_out = register_bank[int_r_addr];
	assign d_out = register_bank[int_d_addr];
	
	always @ (posedge clk)
	begin
		if(write)
			register_bank[d_addr] <= in;
	end

endmodule
