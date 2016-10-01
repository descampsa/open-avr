module avr_cpu_exec(
	input clk,
	input rst,
	input [15:0] opcode,
	input cycle,
	output [5:0] io_addr,
	output io_read,
	output io_write,
	input [7:0] io_in,
	output [7:0] io_out,
	output [15:0] pc_update,
	output hold,
	output stack_read,
	output stack_write,
	output lpm_read,
	output [15:0] lpm_addr,
	input [7:0] lpm_data);
	
	wire [3:0] alu_opcode;
	wire alu_use_carry;
	wire [3:0] alu_bits;
	
	wire register_write;
	wire status_write;
	
	wire [4:0] d_addr;
	wire [4:0] r_addr;
	wire [7:0] d_reg;
	wire [7:0] r_reg;
	
	wire [7:0] immediate;
	wire use_immediate;
	
	wire [5:0] io_addr;
	wire io_read;
	wire io_write;
	
	wire [7:0] alu_out;
	
	wire z_r_addr;
	wire z_d_addr;
	
	wire lpm_in;
	
	wire uncond_hold;
	wire z_hold;
	wire t_hold;
	assign hold = uncond_hold | (z_hold & new_status[1]) | (t_hold & new_status[6]);
	
	reg [7:0] status;
	wire [7:0] current_status;
	wire [7:0] new_status;
	assign current_status=status;
	
	wire [7:0] alu_r_in;
	assign alu_r_in = use_immediate ? immediate : (io_read ? io_in : (lpm_in ? lpm_data : r_reg));
	
	assign io_out = alu_out;
	
	avr_cpu_decode decode(.opcode(opcode), .cycle(cycle),
		.alu_opcode(alu_opcode), .alu_use_carry(alu_use_carry), .alu_bits(alu_bits),
		.register_write(register_write), .status_write(status_write),
		.r_addr(r_addr), .d_addr(d_addr), .immediate(immediate), .use_immediate(use_immediate),
		.z_r_addr(z_r_addr), .z_d_addr(z_d_addr), .hold(uncond_hold), .z_hold(z_hold), .t_hold(t_hold),
		.stack_read(stack_read), .stack_write(stack_write), .lpm_access(lpm_read), .lpm_read(lpm_in),
		.io_read(io_read), .io_write(io_write), .io_addr(io_addr), .pc_update(pc_update));
	
	avr_cpu_alu alu(.opcode(alu_opcode), .use_carry(alu_use_carry), .bits(alu_bits),
		.status_in(current_status), .status_out(new_status),
		.d_in(d_reg), .r_in(alu_r_in),.out(alu_out));
	
	avr_cpu_register register(.clk(clk), .r_addr(r_addr), .d_addr(d_addr),
		.r_out(r_reg), .d_out(d_reg), .in(alu_out), .write(register_write),
		.z_r_addr(z_r_addr), .z_d_addr(z_d_addr), .z(lpm_addr));
	
	always @ (posedge clk)
	begin
		if(status_write)
			status = new_status;
	end
	
endmodule
