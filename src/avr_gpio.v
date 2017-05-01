module avr_gpio
	#(parameter IO_ADDR = 0,
	parameter PORT_WIDTH = 8)
	(input clk,
	input rst,
	input [5:0] io_addr,
	inout [7:0] io_data,
	input io_write,
	input io_read,
	inout [PORT_WIDTH-1:0] gpio);
	
	reg [PORT_WIDTH-1:0] DDR;
	reg [PORT_WIDTH-1:0] PORT;
	
	wire [PORT_WIDTH-1:0] PIN;
	
	reg io_data_out;
	assign io_data = io_read ? io_data_out : 8'bZ;
	
`ifdef SIMULATION
	genvar i;
	for(i=0; i<PORT_WIDTH; i=i+1)
	begin
		assign gpio[i] = DDR[i] ? PORT[i] : 1'bZ;
	end
	assign PIN = gpio;
`endif

`ifdef ICE40_SYNTHESIS
	genvar i;
	for(i=0; i<PORT_WIDTH; i=i+1)
	begin
		SB_IO #(.PIN_TYPE(6'b101001))//{PIN_OUTPUT_TRISTATE, PIN_INPUT}
			portb0_pin(
				.PACKAGE_PIN(gpio[i]),
				.OUTPUT_ENABLE(DDR[i]),
				.D_OUT_0(PORT[i]),
				.D_IN_0(PIN[i]));
	end
`endif

	always @(posedge clk)
	begin
		if(rst)
		begin
			DDR <= {PORT_WIDTH{1'b0}};
			PORT <= {PORT_WIDTH{1'b0}};
		end
		
		if(io_write)
		begin
			if(io_addr == (IO_ADDR+1))
				DDR <= io_data[PORT_WIDTH-1:0];
			if(io_addr == (IO_ADDR+2))
				PORT <= io_data[PORT_WIDTH-1:0];
		end
		
		if(io_read)
		begin
			if(io_addr == IO_ADDR)
				io_data_out <= {{8-PORT_WIDTH{1'b0}}, PIN};
			if(io_addr == (IO_ADDR+1))
				io_data_out <= {{8-PORT_WIDTH{1'b0}}, DDR};
			if(io_addr == (IO_ADDR+2))
				io_data_out <= {{8-PORT_WIDTH{1'b0}}, PORT};
		end
		
	end
endmodule
