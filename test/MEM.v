//`timescale  1ns/1ns
`define mem_data_width 128
`define mem_addr_width 28
`define mem_size 1 << `mem_addr_width
`define mem_cycles 8
`define acquireShared 'b000
`define acquireExclusive 'b001
`define grantShared 'b000
`define grantExclusive 'b001
`define grantACK `b010

module ram(
	input clk,
	input reset,
	input read_en,
	input[`mem_addr_width-1:0] read_addr,
	output reg[`mem_data_width-1:0] data_out,
	output reg [`mem_addr_width-1:0] read_addr_out,

	input write_en,
	input[`mem_data_width-1:0] data_in,
	input[`mem_addr_width-1:0] write_addr
	);

	reg[`mem_data_width-1:0] memory[0:`mem_size-1];

/*
  integer i;
  initial begin
    for(i=0;i<`mem_size;i=i+1)begin
				memory[i] <= 128'heeee0000eeee;
	 end
  end
  */
  
	always @ (posedge clk) begin
		if(read_en && write_en) begin
			if(read_addr == write_addr)begin
				data_out <= data_in;
				memory[write_addr] <= data_in;
			end
			else begin
				data_out <= memory[read_addr];
				memory[write_addr] <= data_in;
			end
		end
		else if(read_en) begin
			data_out <= memory[read_addr];
		end
		else if(write_en) begin
			memory[write_addr] <= data_in;
			data_out <= `mem_data_width'bz;
		end
		else begin
			data_out <= `mem_data_width'bz;
		end
	end

	always @ (posedge clk)begin
		if(reset) begin
			read_addr_out <= 0;
		end
		else begin
			read_addr_out <= read_addr;
		end
	end

	initial begin
	  memory['h003d] <= 'hafd0ab000000ab00ffddaa00000ffdd0;
	  memory['h003e] <= 'hcd00ab0afb00aa00a007660bbb00aa00;
	  memory['h003f] <= 'hab00ab00ab00aa00ab00aa0bbb00aa00;
	  memory['h0040] <= 'haa00aa00aa00aa00aa00aa00aa00aa00;
		memory['h0041] <= 'hac02ac02ac02ac02ac02ac02ac02ac02;
		memory['h0042] <= 'haa00aa00aa00aa00aa00aa00aa00aa00;
		memory['h0043] <= 'h0a7c0a7c0a7c0a7c0a7c0a7caa7caa7c;
		memory['haafc] <= 'haafcaafcaafcaafcaafcaafcaafcaafc;
		memory['haa04] <= 'haa04aa04aa04aa04aa04aa04aa04aa04;
		memory['hab01] <= 'hab01ab01ab01ab01ab01ab01ab01ab01;
		memory['hac02] <= 'hac02ac02ac02ac02ac02ac02ac02ac02;
		memory['had03] <= 'had03ad03ad03ad03ad03ad03ad03ad03;
		memory['hba00] <= 'hba00ba00ba00ba00ba00ba00ba00ba00;
		memory['hab7d] <= 'hab7dab7dab7dab7dab7dab7dab7dab7d;
		memory['hac7e] <= 'hac7eac7eac7eac7eac7eac7eac7eac7e;
		memory['had7f] <= 'had7fad7fad7fad7fad7fad7fad7fad7f;
		memory['hbb7d] <= 'hbb7dbb7dbb7dbb7dbb7dbb7dbb7dbb7d;
		memory['habfd] <= 'habfdabfdabfdabfdabfdabfdabfdabfd;
		memory['hacfe] <= 'hacfeacfeacfeacfeacfeacfeacfeacfe;
		memory['hadff] <= 'hadffadffadffadffadffadffadffadff;
		memory['hbcfe] <= 'hbcfebcfebcfebcfebcfebcfebcfebcfe;
		memory['hab05] <= 'hab05ab05ab05ab05ab05ab05ab05ab05;
		memory['hac06] <= 'hac06ac06ac06ac06ac06ac06ac06ac06;
		memory['had07] <= 'had07ad07ad07ad07ad07ad07ad07ad07;
		memory['hbd07] <= 'hbd07bd07bd07bd07bd07bd07bd07bd07;
	end



endmodule // ram

module MEM(
	input clk,
	input reset,

	output reg io_mem_acquire_ready,
	input io_mem_acquire_valid,
	input[25:0] io_mem_acquire_bits_addr_block,
	input[1:0] io_mem_acquire_bits_client_xact_id,
	input[1:0] io_mem_acquire_bits_addr_beat,
	input io_mem_acquire_bits_is_builtin_type,
	input[2:0] io_mem_acquire_bits_a_type,
	input[16:0] io_mem_acquire_bits_union,
	input[127:0] io_mem_acquire_bits_data,

	input io_mem_grant_ready,
	output io_mem_grant_valid,
	output[1:0] io_mem_grant_bits_addr_beat,
	output[1:0] io_mem_grant_bits_client_xact_id,
	output[3:0] io_mem_grant_bits_manager_xact_id,
	output io_mem_grant_bits_is_builtin_type,
	output[3:0] io_mem_grant_bits_g_type,
	output[127:0] io_mem_grant_bits_data,

	input io_mem_probe_ready,
	output io_mem_probe_valid,

	output reg io_mem_release_ready,
	input io_mem_release_valid,
	input[1:0] io_mem_release_bits_addr_beat,
	input[25:0] io_mem_release_bits_addr_block,
	input[1:0] io_mem_release_bits_client_xact_id,
	input io_mem_release_bits_voluntary,
	input[2:0] io_mem_release_bits_r_type,
	input[127:0] io_mem_release_bits_data
	);
	
	reg[1:0] read_count;
	reg memory_read_en_r;
	reg memory_read_en_r1;
	reg[`mem_addr_width-1:0] memory_read_addr_r;
	reg[1:0] io_mem_acquire_bits_client_xact_id_r0;
	reg[1:0] io_mem_acquire_bits_client_xact_id_r1;
	reg io_mem_acquire_bits_is_builtin_type_r0;
	reg io_mem_acquire_bits_is_builtin_type_r1;
	reg[2:0] io_mem_acquire_bits_a_type_r0;
	reg[2:0] io_mem_acquire_bits_a_type_r1;

	reg memory_write_en_r;
	reg[`mem_addr_width-1:0] memory_write_addr_r;
	reg[`mem_data_width-1:0] memory_data_in_r;

	reg io_mem_grant_valid_r[0:`mem_cycles-1];
	reg[1:0] io_mem_grant_bits_addr_beat_r[0:`mem_cycles-1];
	reg[1:0] io_mem_grant_bits_client_xact_id_r[0:`mem_cycles-1];
	reg[3:0] io_mem_grant_bits_manager_xact_id_r[0:`mem_cycles-1];
	reg io_mem_grant_bits_is_builtin_type_r[0:`mem_cycles-1];
	reg[3:0] io_mem_grant_bits_g_type_r[0:`mem_cycles-1];
	reg[127:0] io_mem_grant_bits_data_r[0:`mem_cycles-1];
	
	wire[`mem_addr_width-1:0] memory_read_addr_r1;
	wire[127:0] memory_data_out;

	reg io_mem_grant_valid_gtype_ack;
	reg[25:0] io_mem_acquire_bits_addr_block_r;

	always @(posedge clk ) begin
		if(reset) begin
			io_mem_grant_valid_r[0] <= 0;
			io_mem_grant_bits_addr_beat_r[0] <= 0;
			io_mem_grant_bits_client_xact_id_r[0] <= 0;
			io_mem_grant_bits_manager_xact_id_r[0] <= 0;
			io_mem_grant_bits_is_builtin_type_r[0] <= 0;
			io_mem_grant_bits_g_type_r[0] <= 0;
			io_mem_grant_bits_data_r[0] <= 0;
		end 
		else begin
			io_mem_grant_valid_r[0] <= memory_read_en_r1;
			io_mem_grant_bits_addr_beat_r[0] <= memory_read_addr_r1[1:0];
			io_mem_grant_bits_client_xact_id_r[0] <= io_mem_acquire_bits_client_xact_id_r1;
			io_mem_grant_bits_manager_xact_id_r[0] <= $random;
			io_mem_grant_bits_is_builtin_type_r[0] <= io_mem_acquire_bits_is_builtin_type_r1;
			if(io_mem_acquire_bits_a_type_r1 == `acquireShared)
				io_mem_grant_bits_g_type_r[0] <= `grantShared;
			else if(io_mem_acquire_bits_a_type_r1 == `acquireExclusive)
				io_mem_grant_bits_g_type_r[0] <= `grantExclusive;
			else io_mem_grant_bits_g_type_r[0] <= 0;
			io_mem_grant_bits_data_r[0] <= memory_data_out;
		end
	end



	always @ (posedge clk) begin
		if(reset)begin
			io_mem_acquire_bits_client_xact_id_r0 <= 0;
			io_mem_acquire_bits_client_xact_id_r1 <= 0;
			io_mem_acquire_bits_is_builtin_type_r0 <= 0;
			io_mem_acquire_bits_is_builtin_type_r1 <= 0;
			io_mem_acquire_bits_a_type_r0 <= 0;
			io_mem_acquire_bits_a_type_r1 <= 0;
			memory_read_en_r1 <= 0;
		end
		else begin
			io_mem_acquire_bits_client_xact_id_r1 <= io_mem_acquire_bits_client_xact_id_r0;
			io_mem_acquire_bits_is_builtin_type_r1 <= io_mem_acquire_bits_is_builtin_type_r0;
			io_mem_acquire_bits_a_type_r1 <= io_mem_acquire_bits_a_type_r0;
			memory_read_en_r1 <= memory_read_en_r;
			if(io_mem_acquire_valid & io_mem_acquire_ready)begin
				io_mem_acquire_bits_client_xact_id_r0 <= io_mem_acquire_bits_client_xact_id;
				io_mem_acquire_bits_is_builtin_type_r0 <= io_mem_acquire_bits_is_builtin_type;
				io_mem_acquire_bits_a_type_r0 <= io_mem_acquire_bits_a_type;
			end
		end
	end


	always @ (posedge clk) begin
		if(reset)begin
			read_count <= 0;
		end
		else if(io_mem_acquire_valid & io_mem_acquire_ready) begin
			read_count <= 1;
		end
		else if(read_count == 1) begin
			read_count <= read_count + 1;
		end
		else if(read_count == 2) begin
			read_count <= read_count + 1;
		end
		else begin
			read_count <= 0;
		end
	end 

	always @ (posedge clk) begin
		if(reset)begin
			memory_read_en_r <= 0;
		end
		else if(io_mem_acquire_valid & io_mem_acquire_ready) begin
			memory_read_en_r <= 1;
		end
		else if(read_count == 1 || read_count == 2 || read_count == 3) begin
			memory_read_en_r <= 1;
		end
		else
			memory_read_en_r <= 0;
	end

	always @ (posedge clk) begin
		if(reset)begin
			memory_read_addr_r <= 0;
		end
		else if(io_mem_acquire_valid & io_mem_acquire_ready) begin
			memory_read_addr_r <= {io_mem_acquire_bits_addr_block,read_count};
		end
		else if(read_count == 1 || read_count == 2 || read_count == 3)begin
			memory_read_addr_r <= {io_mem_acquire_bits_addr_block_r,read_count};
		end
		else begin
			memory_read_addr_r <= 0;
		end
	end

	always @ (posedge clk) begin
		if(reset)begin
			memory_write_en_r <= 0;
			memory_data_in_r <= 0;
			memory_write_addr_r <= 0;
		end
		else if(io_mem_release_valid)begin
			memory_write_en_r <= 1;
			memory_data_in_r <= io_mem_release_bits_data;
			memory_write_addr_r <= {io_mem_release_bits_addr_block,io_mem_release_bits_addr_beat};
		end
		else begin
			memory_write_en_r <= 0;
			memory_data_in_r <= 0;
			memory_write_addr_r <= 0;
		end

	end

	always @ (posedge clk) begin
		if(reset)begin
			io_mem_release_ready <= 1;
		end
	end

	always @ (posedge clk) begin
		if(reset) begin
			io_mem_acquire_bits_addr_block_r <= 0;
		end
		else if(io_mem_acquire_valid & io_mem_acquire_ready)begin
			io_mem_acquire_bits_addr_block_r <= io_mem_acquire_bits_addr_block;
		end
	end

	/*always @(posedge clk) begin
		if(reset)begin
			io_mem_grant_valid_gtype_ack <= 0;
		end
		else if(io_mem_release_valid && io_mem_release_bits_addr_beat == 2'b11)begin
			io_mem_grant_valid_gtype_ack <= 1;
			io_mem_grant_bits_g_type_r[`mem_cycles-1] <= `grantACK;
		end
		else begin
			io_mem_grant_valid_gtype_ack <= 0;
		end
	end*/

integer i;
	always @ (posedge clk) begin
		if(reset)begin
			for(i=1;i<`mem_cycles;i=i+1)begin
				io_mem_grant_valid_r[i] <= 0;
				io_mem_grant_bits_addr_beat_r[i] <= 0;
				io_mem_grant_bits_client_xact_id_r[i] <= 0;
				io_mem_grant_bits_manager_xact_id_r[i] <= 0;
				io_mem_grant_bits_is_builtin_type_r[i] <= 0;
				io_mem_grant_bits_g_type_r[i] <= 0;
				io_mem_grant_bits_data_r[i] <= 0;
			end
		end
		else if ((io_mem_grant_ready !== 1) && io_mem_grant_valid_r[`mem_cycles-1])begin
			for(i=1;i<`mem_cycles;i=i+1)begin
				io_mem_grant_valid_r[i] <= io_mem_grant_valid_r[i];
				io_mem_grant_bits_addr_beat_r[i] <= io_mem_grant_bits_addr_beat_r[i];
				io_mem_grant_bits_client_xact_id_r[i] <= io_mem_grant_bits_client_xact_id_r[i];
				io_mem_grant_bits_manager_xact_id_r[i] <= io_mem_grant_bits_manager_xact_id_r[i];
				io_mem_grant_bits_is_builtin_type_r[i] <= io_mem_grant_bits_is_builtin_type_r[i];
				io_mem_grant_bits_g_type_r[i] <= io_mem_grant_bits_g_type_r[i];
				io_mem_grant_bits_data_r[i] <= io_mem_grant_bits_data_r[i];
			end
		end
		else begin
			for(i=1;i<`mem_cycles;i=i+1)begin
				io_mem_grant_valid_r[i] <= io_mem_grant_valid_r[i-1];
				io_mem_grant_bits_addr_beat_r[i] <= io_mem_grant_bits_addr_beat_r[i-1];
				io_mem_grant_bits_client_xact_id_r[i] <= io_mem_grant_bits_client_xact_id_r[i-1];
				io_mem_grant_bits_manager_xact_id_r[i] <= io_mem_grant_bits_manager_xact_id_r[i-1];
				io_mem_grant_bits_is_builtin_type_r[i] <= io_mem_grant_bits_is_builtin_type_r[i-1];
				io_mem_grant_bits_g_type_r[i] <= io_mem_grant_bits_g_type_r[i-1];
				io_mem_grant_bits_data_r[i] <= io_mem_grant_bits_data_r[i-1];
			end
		end
	end
	always @ (posedge clk) begin
		if(reset) begin
			io_mem_acquire_ready <= 1;
		end
		else if(io_mem_acquire_valid & io_mem_acquire_ready)
			io_mem_acquire_ready <= 0;
		else if(io_mem_grant_valid_r[`mem_cycles-1] && io_mem_grant_ready && io_mem_grant_bits_addr_beat_r[`mem_cycles-1]==2'b11)
			io_mem_acquire_ready <= 1;
    end

	assign io_mem_grant_valid = io_mem_grant_valid_r[`mem_cycles-1] ;//& io_mem_grant_ready) ;
	assign io_mem_grant_bits_addr_beat = io_mem_grant_bits_addr_beat_r[`mem_cycles-1];
	assign io_mem_grant_bits_client_xact_id = io_mem_grant_bits_client_xact_id_r[`mem_cycles-1];
	assign io_mem_grant_bits_manager_xact_id = io_mem_grant_bits_manager_xact_id_r[`mem_cycles-1];
	assign io_mem_grant_bits_is_builtin_type = io_mem_grant_bits_is_builtin_type_r[`mem_cycles-1];
	assign io_mem_grant_bits_g_type = io_mem_grant_bits_g_type_r[`mem_cycles-1];
	assign io_mem_grant_bits_data = io_mem_grant_bits_data_r[`mem_cycles-1];
	assign io_mem_probe_valid = 0;


	ram ram1(
		.clk(clk),
		.reset(reset),
		.read_en (memory_read_en_r),
		.read_addr (memory_read_addr_r),
		.data_out (memory_data_out),
		.read_addr_out(memory_read_addr_r1),

		.write_en (memory_write_en_r),
		.data_in (memory_data_in_r),
		.write_addr (memory_write_addr_r)
	);


	

endmodule

module MEMTest;
	reg clk;
	reg reset;
	reg[31:0] counter;

	wire io_mem_acquire_ready;
	reg io_mem_acquire_valid;
	reg[25:0] io_mem_acquire_bits_addr_block;
	reg[1:0] io_mem_acquire_bits_client_xact_id;
	reg[1:0] io_mem_acquire_bits_addr_beat;
	reg io_mem_acquire_bits_is_builtin_type;
	reg[2:0] io_mem_acquire_bits_a_type;
	reg[16:0]  io_mem_acquire_bits_union;
	reg[127:0]io_mem_acquire_bits_data;

	reg io_mem_grant_ready;
	wire io_mem_grant_valid;
	wire[1:0] io_mem_grant_bits_addr_beat;
	wire[1:0] io_mem_grant_bits_client_xact_id;
	wire[3:0]  io_mem_grant_bits_manager_xact_id;
	wire io_mem_grant_bits_is_builtin_type;
	wire[3:0] io_mem_grant_bits_g_type;
	wire[127:0] io_mem_grant_bits_data;

	reg io_mem_probe_ready;
	wire io_mem_probe_valid;

	wire  io_mem_release_ready;
	reg io_mem_release_valid;
	reg[1:0] io_mem_release_bits_addr_beat;
	reg[25:0]  io_mem_release_bits_addr_block;
	reg[1:0] io_mem_release_bits_client_xact_id;
	reg io_mem_release_bits_voluntary;
	reg[2:0] io_mem_release_bits_r_type;
	reg[127:0] io_mem_release_bits_data;

	initial begin
		clk = 0;
		reset=1;
		#100 reset=0; 
	end
	always 
	#(10/2) clk = ~clk;


	always @ (posedge clk)begin
		if(reset)begin
			counter <= 0;
		end
		else begin
			counter<= counter+1;
		end
	end

	MEM memory(
		.clk (clk),
		.reset (reset),

		.io_mem_acquire_ready (io_mem_acquire_ready),
		.io_mem_acquire_valid (io_mem_acquire_valid),
		.io_mem_acquire_bits_addr_block (io_mem_acquire_bits_addr_block),
		.io_mem_acquire_bits_client_xact_id (io_mem_acquire_bits_client_xact_id),
		.io_mem_acquire_bits_addr_beat (io_mem_acquire_bits_addr_beat),
		.io_mem_acquire_bits_is_builtin_type (io_mem_acquire_bits_is_builtin_type),
		.io_mem_acquire_bits_a_type (io_mem_acquire_bits_a_type),
		.io_mem_acquire_bits_union (io_mem_acquire_bits_union),
		.io_mem_acquire_bits_data (io_mem_acquire_bits_data),

		.io_mem_grant_ready (io_mem_grant_ready),
		.io_mem_grant_valid (io_mem_grant_valid),
		.io_mem_grant_bits_addr_beat (io_mem_grant_bits_addr_beat),
		.io_mem_grant_bits_client_xact_id (io_mem_grant_bits_client_xact_id),
		.io_mem_grant_bits_manager_xact_id (io_mem_grant_bits_manager_xact_id),
		.io_mem_grant_bits_is_builtin_type (io_mem_grant_bits_is_builtin_type),
		.io_mem_grant_bits_g_type (io_mem_grant_bits_g_type),
		.io_mem_grant_bits_data (io_mem_grant_bits_data),

		.io_mem_probe_ready (io_mem_probe_ready),
		.io_mem_probe_valid (io_mem_probe_valid),

		.io_mem_release_ready (io_mem_release_ready),
		.io_mem_release_valid (io_mem_release_valid),
		.io_mem_release_bits_addr_beat (io_mem_release_bits_addr_beat),
		.io_mem_release_bits_addr_block (io_mem_release_bits_addr_block),
		.io_mem_release_bits_client_xact_id (io_mem_release_bits_client_xact_id),
		.io_mem_release_bits_voluntary (io_mem_release_bits_voluntary),
		.io_mem_release_bits_r_type (io_mem_release_bits_r_type),
		.io_mem_release_bits_data (io_mem_release_bits_data)
		);

	always @ (posedge clk) begin
		if(reset) begin
			io_mem_grant_ready <= 1;
		end
	end

	always @ (posedge clk)begin

		// single release test
		if(counter == 2) begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 0;
			io_mem_release_bits_addr_block <= 26'h1234567;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h12345678123456781234567812345678;
		end
		else if(counter == 3)begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 1;
			io_mem_release_bits_addr_block <= 26'h1234567;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h87654321876543218765432187654321;
		end
		else if(counter == 4)begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 2;
			io_mem_release_bits_addr_block <= 26'h1234567;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h88888888777777776666666655555555;
		end
		else if(counter == 5) begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 3;
			io_mem_release_bits_addr_block <= 26'h1234567;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h44444444333333332222222211111111;
		end
		else if(counter ==6) begin
			io_mem_release_valid <= 0;
			io_mem_release_bits_addr_beat <= 0;
			io_mem_release_bits_addr_block <= 0;
			io_mem_release_bits_client_xact_id <= 0;
			io_mem_release_bits_voluntary <= 0;
			io_mem_release_bits_r_type <= 0;
			io_mem_release_bits_data <= 0;
		end

		//single acqurie with acquireShared
		else if(counter == 7) begin
			io_mem_acquire_valid <= 1;
			io_mem_acquire_bits_addr_block <= 26'h1234567;
			io_mem_acquire_bits_addr_beat <= 3;
			io_mem_acquire_bits_a_type <= `acquireShared;
			io_mem_acquire_bits_is_builtin_type <= 0;
			io_mem_acquire_bits_client_xact_id <= 2;
			io_mem_acquire_bits_union <= 6;
		end
		else if(counter == 8) begin
			io_mem_acquire_valid <= 0;
		end
		//single acquire with acquireExclusive
		/*else if(counter == 12) begin
			io_mem_acquire_valid <= 1;
			io_mem_acquire_bits_addr_block <= 26'h1234567;
			io_mem_acquire_bits_addr_beat <= 3;
			io_mem_acquire_bits_a_type <= `acquireExclusive;
			io_mem_acquire_bits_is_builtin_type <= 0;
			io_mem_acquire_bits_client_xact_id <= 1;
			io_mem_acquire_bits_union <= 6;
		end
		else if(counter == 13)begin
			io_mem_acquire_valid <= 0;
		end*/
		// acquire and release at the same time at the same addr
		else if(counter == 113)begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 0;
			io_mem_release_bits_addr_block <= 26'h1234567;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h87654321876543218765432187654321;

			io_mem_acquire_valid <= 1;
			io_mem_acquire_bits_addr_block <= 26'h1234567;
			io_mem_acquire_bits_addr_beat <= 3;
			io_mem_acquire_bits_a_type <= `acquireExclusive;
			io_mem_acquire_bits_is_builtin_type <= 0;
			io_mem_acquire_bits_client_xact_id <= 0;
			io_mem_acquire_bits_union <= 6;

		end
		else if(counter == 114)begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 1;
			io_mem_release_bits_addr_block <= 26'h1234567;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h12345678123456781234567812345678;

			io_mem_acquire_valid <= 0;
		end
		else if(counter == 115)begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 2;
			io_mem_release_bits_addr_block <= 26'h1234567;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h11111111222222223333333344444444;
		end
		else if(counter == 116)begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 3;
			io_mem_release_bits_addr_block <= 26'h1234567;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h55555555666666667777777788888888;
		end
		else if(counter == 117)begin
			io_mem_release_valid <= 0;
		end

		//acquire and release at the same time and different addr
		else if(counter == 219) begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 0;
			io_mem_release_bits_addr_block <= 26'h7654321;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h12345678123456781234567812345678;

			io_mem_acquire_valid <= 1;
			io_mem_acquire_bits_addr_block <= 26'h1234567;
			io_mem_acquire_bits_addr_beat <= 3;
			io_mem_acquire_bits_a_type <= `acquireExclusive;
			io_mem_acquire_bits_is_builtin_type <= 0;
			io_mem_acquire_bits_client_xact_id <= 1;
			io_mem_acquire_bits_union <= 6;

		end
		else if(counter == 220)begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 1;
			io_mem_release_bits_addr_block <= 26'h7654321;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h87654321876543218765432187654321;

			io_mem_acquire_valid <= 0;
		end
		else if(counter == 221) begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 2;
			io_mem_release_bits_addr_block <= 26'h7654321;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h55555555666666667777777788888888;

		end
		else if(counter == 222)begin
			io_mem_release_valid <= 1;
			io_mem_release_bits_addr_beat <= 3;
			io_mem_release_bits_addr_block <= 26'h7654321;
			io_mem_release_bits_client_xact_id <= $random;
			io_mem_release_bits_voluntary <= 1;
			io_mem_release_bits_r_type <= $random;
			io_mem_release_bits_data <= 128'h11111111222222223333333344444444;

		end
		else if(counter == 223)begin
			io_mem_release_valid <= 0;
		end
		else if(counter == 321)begin
			io_mem_grant_ready <= 0;
		end
		else if(counter == 399)begin
			io_mem_grant_ready <= 1;
		end
		if(!io_mem_acquire_ready)begin
			$display("at counter %d, ready is invalid",counter);
		end
		//test read memory
		if(io_mem_grant_valid) begin
			$display("-----------------------io_mem_grant_valid----------------------");
			$display("at counter %d",counter);
			if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 0 && io_mem_grant_bits_data == 128'h12345678123456781234567812345678 && io_mem_grant_bits_client_xact_id == 2 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantShared ) begin
				$display("acuqire1 test 1st beat OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 1 && io_mem_grant_bits_data == 128'h87654321876543218765432187654321 && io_mem_grant_bits_client_xact_id == 2 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantShared ) begin
				$display("acuqire1 test 2nd beat OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 2 && io_mem_grant_bits_data == 128'h88888888777777776666666655555555 && io_mem_grant_bits_client_xact_id == 2 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantShared ) begin
				$display("acuqire1 test 3rd beat OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 3 && io_mem_grant_bits_data == 128'h44444444333333332222222211111111 && io_mem_grant_bits_client_xact_id == 2 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantShared ) begin
				$display("acuqire1 test 4th beat OK");
			end

			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 0 && io_mem_grant_bits_data == 128'h87654321876543218765432187654321 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("acquire2 at same addr at same time 1st beat OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 1 && io_mem_grant_bits_data == 128'h12345678123456781234567812345678 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("acquire2 at same addr at same time 2nd beat OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 2 && io_mem_grant_bits_data == 128'h11111111222222223333333344444444 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("acquire2 at same addr at same time 3rd beat OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 3 && io_mem_grant_bits_data == 128'h55555555666666667777777788888888 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("acquire2 at same addr at same time 4th beat OK");
			end

			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 0 && io_mem_grant_bits_data == 128'h87654321876543218765432187654321 && io_mem_grant_bits_client_xact_id == 1 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("acquire2 at diff addr at same time 1st beat OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 1 && io_mem_grant_bits_data == 128'h12345678123456781234567812345678 && io_mem_grant_bits_client_xact_id == 1 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("acquire2 at diff addr at same time 2nd beat OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 2 && io_mem_grant_bits_data == 128'h11111111222222223333333344444444 && io_mem_grant_bits_client_xact_id == 1 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("acquire2 at diff addr at same time 3rd beat OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 3 && io_mem_grant_bits_data == 128'h55555555666666667777777788888888 && io_mem_grant_bits_client_xact_id == 1 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("acquire2 at diff addr at same time 4th beat OK");
			end

			/*if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 0 && io_mem_grant_bits_data == 128'h12345678123456781234567812345678 && io_mem_grant_bits_client_xact_id == 1 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("55555 OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 1 && io_mem_grant_bits_data == 128'h87654321876543218765432187654321 && io_mem_grant_bits_client_xact_id == 1 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("66666 OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 2 && io_mem_grant_bits_data == 128'h88888888777777776666666655555555 && io_mem_grant_bits_client_xact_id == 1 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("77777 OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 3 && io_mem_grant_bits_data == 128'h44444444333333332222222211111111 && io_mem_grant_bits_client_xact_id == 1 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("88888 OK");
			end

			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 0 && io_mem_grant_bits_data == 128'h87654321876543218765432187654321 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("AAAAA OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 1 && io_mem_grant_bits_data == 128'h12345678123456781234567812345678 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("BBBBB OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 2 && io_mem_grant_bits_data == 128'h11111111222222223333333344444444 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("CCCCC OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 3 && io_mem_grant_bits_data == 128'h55555555666666667777777788888888 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("DDDDD OK");
			end
			if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 0 && io_mem_grant_bits_data == 128'h12345678123456781234567812345678 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("EEEEE OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 1 && io_mem_grant_bits_data == 128'h87654321876543218765432187654321 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("FFFFF OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 2 && io_mem_grant_bits_data == 128'h88888888777777776666666655555555 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("GGGGG OK");
			end
			else if(io_mem_grant_valid && io_mem_grant_bits_addr_beat == 3 && io_mem_grant_bits_data == 128'h44444444333333332222222211111111 && io_mem_grant_bits_client_xact_id == 0 && io_mem_grant_bits_is_builtin_type == 0 && io_mem_grant_bits_g_type==`grantExclusive ) begin
				$display("HHHHH OK");
			end*/
		end
		else if(counter == 1000)begin
			$stop;
		end
	end

endmodule

/*module RAMTest;


	reg clk;
	reg read_en;
	reg[`mem_addr_width-1:0] read_addr;
	wire[`mem_data_width-1:0] data_out;

	reg write_en;
	reg[`mem_data_width-1:0] data_in;
	reg[`mem_addr_width-1:0] write_addr;

	initial begin
		clk = 0;
	end
	always 
	#(10/2) clk = ~clk;

	initial begin
		#100 read_en = 1;
		read_addr = 28'h1234567;
		#10 write_en = 1;
		write_addr =  28'h1234567;
		data_in = 128'h1234567;
		#10 read_en =  1;
		read_addr = 28'h1234567;
		#10 read_en = 1;
		read_addr = 28'h1234567;
		write_en = 1;
		write_addr =  28'h1234567;
		data_in = 128'h7654321;
		#100 $stop;

	end

	always @(posedge clk) begin 
		if(data_out == 128'h1234567)
			$display("OKAAAAAA");
		if(data_out == 128'h7654321)
			$display("OKBBBBBB");
	end

	ram ram1(
		.read_en (read_en),
		.read_addr (read_addr),
		.data_out (data_out),

		.write_en (write_en),
		.data_in (data_in),
		.write_addr (write_addr)
	);

endmodule*/