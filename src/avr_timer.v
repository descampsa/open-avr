module avr_timer
	#(parameter IO_ADDR = 0)
	(input clk,
	input rst,
	input [5:0] io_addr,
	inout [7:0] io_data,
	input io_write,
	input io_read,
	input T0);
	
	reg [2:0] TCCR;
	reg [7:0] TCNT;
	
	reg [9:0] prescaler;
	wire prescaled_clk;
	reg prescaled_clk_prev;
	
	assign prescaled_clk = 
		TCCR == 3'b000 ? 1'b0 :
		TCCR == 3'b001 ? clk :
		TCCR == 3'b010 ? prescaler[2] :
		TCCR == 3'b011 ? prescaler[5] :
		TCCR == 3'b100 ? prescaler[7] :
		TCCR == 3'b101 ? prescaler[9] :
		TCCR == 3'b110 ? T0 :
		~T0;
	
	reg [7:0] io_data_out;
	assign io_data = io_read ? io_data_out : 8'bZ;
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			prescaler <= 0;
			TCCR <= 0;
			TCNT <= 0;
		end
		else
		begin
			if(io_write)
			begin
				if(io_addr == IO_ADDR)
					TCNT <= io_data;
				if(io_addr == (IO_ADDR+1))
					TCCR <= io_data[2:0];
			end
			if(io_read)
			begin
				if(io_addr == IO_ADDR)
					io_data_out <= TCNT;
				if(io_addr == (IO_ADDR+1))
					io_data_out <= {5'b0,TCCR};
			end
			
			prescaler <= prescaler+1;
			
			prescaled_clk_prev <= prescaled_clk;
			
			if(TCCR == 3'b001 || (prescaled_clk && !prescaled_clk_prev))
			begin
				TCNT <= TCNT+1;
			end
		end
	end
	
endmodule

