module avr_cpu_progmem(
	input clk,
	input [8:0] addr,
	output reg [15:0] data);
	
	reg [15:0] mem [0:511];
	
	
	reg[15:0] k;
	initial
	begin
		for(k=0; k<511; k=k+1)
		begin
			mem[k] = k;
		end
	end
	
	always @ (posedge clk)
	begin
		data <= mem[addr];
	end
	
endmodule
