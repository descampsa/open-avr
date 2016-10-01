module avr_cpu_stack(
	input clk,
	inout [8:0] data,
	input write,
	input read);

	reg [8:0] stack [0:2];

	assign data = read ? stack[0] : 9'bZ;

	always @ (posedge clk)
	begin
		if(write)
		begin
			stack[2] <= stack[1];
			stack[1] <= stack[0];
			stack[0] <= data;
		end
		else if(read)
		begin
			stack[0] <= stack[1];
			stack[1] <= stack[2];
		end
	end
endmodule
