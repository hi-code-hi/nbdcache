//`timescale 1ns/1ns
`define num_insts 200000
`define insts_width 112 //40bit addr+ 5 bit cmd+ 3bit type + 64bit data
`define insts_file_name "D:/modeltech_10.0a/examples/work/MPRC_HellaCache/3.15.2246Version/mprcHellaCacheTestBench/cpu_input.data"
`define output_insts_file "D:/modeltech_10.0a/examples/work/MPRC_HellaCache/3.15.2246Version/mprcHellaCacheTestBench/cpu_ints_output.data"
`define pys_addr_width 40
`define halt_inst 'h11111111

module CPU(
	input clk,
	input  reset,
	input io_cpu_req_ready,
	output wire io_cpu_req_valid,
	output wire[`pys_addr_width-1:0] io_cpu_req_bits_addr,
	output wire[8:0] io_cpu_req_bits_tag,
	output wire[4:0] io_cpu_req_bits_cmd,
	output wire[2:0] io_cpu_req_bits_typ,
	output wire io_cpu_req_bits_kill,
	output wire io_cpu_req_bits_phys,
	output wire io_cpu_invalidate_lr,
	output wire [63:0] io_cpu_req_bits_data
	);

	integer fp_r,cnt,temp,fp_w;

	reg io_cpu_req_valid_r;
	reg[`pys_addr_width-1:0] io_cpu_req_bits_addr_r;
	reg[8:0] io_cpu_req_bits_tag_r;
	reg[4:0] io_cpu_req_bits_cmd_r;
	reg[2:0] io_cpu_req_bits_typ_r;
	reg io_cpu_req_bits_kill_r;
	reg io_cpu_req_bits_phys_r;
	reg io_cpu_invalidate_lr_r;
	reg[63:0] io_cpu_req_bits_data_r;
	reg[63:0] io_cpu_req_bits_data_r1;

	//reg io_cpu_req_ready_r;

	reg[7:0] stall_cycles;
	reg[7:0] stall_counter;

	reg[31:0] insts_mem_p;
	reg[`insts_width-1:0] insts_mem[0:`num_insts-1];

	reg[255:0] string;

	/*initial begin
		$readmemh (`insts_file_name,insts_mem);
		//$readmemh ("cpu_input.data",insts_mem);
		$display("read cpu input OK !!");
	end*/
	initial begin
		fp_r = $fopen(`insts_file_name,"r");
		fp_w = $fopen(`output_insts_file,"w");
		if(!fp_w)begin
			$display("could not open output file");
			$stop;
		end
		temp = 0;
		while(!$feof(fp_r)) begin
       	//#10;
       	cnt = $fscanf(fp_r, "%h %h %h %h", insts_mem[temp][`insts_width-1:72],insts_mem[temp][71:67],insts_mem[temp][66:64],insts_mem[temp][63:0]);
       	cnt = $fgets(string,fp_r);
       	//$display("%h", insts_mem[temp][`insts_width-1:72]);
       //	$display("%h", insts_mem[temp][71:67]);
       //	$display("%h", insts_mem[temp][66:64]);
       //	$display("%h", insts_mem[temp][63:0]);
       //	$display("------------------------------------");

		//$fdisplay(fp_w,"%h %h %h %h", insts_mem[temp][`insts_width-1:72],insts_mem[temp][71:67],insts_mem[temp][66:64],insts_mem[temp][63:0]);

        temp =temp+1;
		

		end
		$fclose(fp_r);
		$fclose(fp_w);
		$display("finishing reading cpu input data ---------------");
	end

	/*always @(posedge clk) begin
		if(reset) begin
			io_cpu_req_ready_r <= 0;
		end
		else begin
			io_cpu_req_ready_r <= io_cpu_req_ready;
		end
	end*/

	always @(posedge clk ) begin
		if (reset) begin
			io_cpu_req_valid_r <= 0;
			io_cpu_req_bits_addr_r <= 0;
			io_cpu_req_bits_tag_r <= 0;
			io_cpu_req_bits_cmd_r <= 0;
			io_cpu_req_bits_typ_r <= 0;
			io_cpu_req_bits_kill_r <= 0;
			io_cpu_req_bits_phys_r <= 1;
			io_cpu_invalidate_lr_r <= 0;
			io_cpu_req_bits_data_r <= 0;

			stall_cycles <= 0;
			stall_counter <= 0;
			insts_mem_p <= 0;
		end
		else if(insts_mem[insts_mem_p][`insts_width-1:`insts_width-`pys_addr_width] == `halt_inst)
			io_cpu_req_valid_r <= 0;
		else if(insts_mem_p >= `num_insts)
			io_cpu_req_valid_r <= 0;
		else if (stall_counter == 0 || stall_counter == stall_cycles) begin
			if(io_cpu_req_valid_r && !io_cpu_req_ready)begin
				stall_counter <= 0;
				io_cpu_req_bits_addr_r <= io_cpu_req_bits_addr_r;
				io_cpu_req_bits_tag_r <= io_cpu_req_bits_tag_r;
				io_cpu_req_bits_cmd_r <= io_cpu_req_bits_cmd_r;
				io_cpu_req_bits_typ_r <= io_cpu_req_bits_typ_r;
				io_cpu_req_bits_data_r <= io_cpu_req_bits_data_r;
			end
			else if (insts_mem[insts_mem_p][`insts_width-1:`insts_width-`pys_addr_width] == 0) begin				
				stall_counter <= 1;
				stall_cycles <= insts_mem[insts_mem_p][63:0];
				io_cpu_req_valid_r <= 0;
				io_cpu_req_bits_addr_r <= 0;
				io_cpu_req_bits_tag_r <= 0;
				io_cpu_req_bits_cmd_r <= 0;
				io_cpu_req_bits_typ_r <= 0;
				io_cpu_req_bits_data_r <= 0;
				insts_mem_p <= insts_mem_p + 1;
			end
			else begin
				stall_counter <= 0;
				{io_cpu_req_bits_addr_r,io_cpu_req_bits_cmd_r,io_cpu_req_bits_typ_r,io_cpu_req_bits_data_r} <= insts_mem[insts_mem_p];
					//$display("%h",insts_mem[0]);
				io_cpu_req_valid_r <= 1;
				io_cpu_req_bits_tag_r <= $random;
				insts_mem_p <= insts_mem_p + 1;
			end
		end				
		else begin
			io_cpu_req_valid_r <= 0;
			io_cpu_req_bits_addr_r <= 0;
			io_cpu_req_bits_tag_r <= 0;
			io_cpu_req_bits_cmd_r <= 0;
			io_cpu_req_bits_typ_r <= 0;
			io_cpu_req_bits_data_r <= 0;
			stall_counter <= stall_counter + 1;
		end
	end

	always @ (posedge clk)begin
		if(reset)begin
			io_cpu_req_bits_data_r1 <= 0;
		end
		else begin
			io_cpu_req_bits_data_r1 <= io_cpu_req_bits_data_r;
		end
	end

	//assign io_cpu_req_valid = io_cpu_req_valid_r & io_cpu_req_ready;
	assign io_cpu_req_valid = io_cpu_req_valid_r;
	assign io_cpu_req_bits_addr =  io_cpu_req_bits_addr_r;
	assign io_cpu_req_bits_cmd =  io_cpu_req_bits_cmd_r;
	assign io_cpu_req_bits_typ = io_cpu_req_bits_typ_r;
	assign io_cpu_req_bits_tag = io_cpu_req_bits_tag_r;
	assign io_cpu_req_bits_phys = io_cpu_req_bits_phys_r;
	assign io_cpu_req_bits_kill = io_cpu_req_bits_kill_r;
	assign io_cpu_invalidate_lr = io_cpu_invalidate_lr_r;
	assign io_cpu_req_bits_data = io_cpu_req_bits_data_r1;

endmodule

module CPUTest;
	reg clk;
	reg reset;
	parameter period = 10;

	reg io_cpu_req_ready;
	wire io_cpu_req_valid;
	wire[`pys_addr_width-1:0] io_cpu_req_bits_addr;
	wire[8:0] io_cpu_req_bits_tag;
	wire[4:0] io_cpu_req_bits_cmd;
	wire[2:0] io_cpu_req_bits_typ;
	wire io_cpu_invalidate_lr;
	wire io_cpu_req_bits_kill;
	wire io_cpu_req_bits_phys;
	wire [63:0] io_cpu_req_bits_data;

	reg[7:0] counter;

	initial begin
		clk <= 0 ;
		reset <= 1;
		io_cpu_req_ready <= 0;
		reset <= #80 0;
		//$monitor($time, "io_cpu_req_bits_data is",io_cpu_req_bits_data);
		//io_cpu_req_ready <= #130 0; 
		//io_cpu_req_ready <= #200 1;
		#10000000 $stop;		
		
	end

	always 
	#(period/2) clk = ~clk;

	CPU cpu(
		.clk (clk),
		.reset (reset),
		.io_cpu_req_ready (io_cpu_req_ready),
		.io_cpu_req_valid (io_cpu_req_valid),
		.io_cpu_req_bits_addr (io_cpu_req_bits_addr),
		.io_cpu_req_bits_tag (io_cpu_req_bits_tag),
		.io_cpu_req_bits_cmd (io_cpu_req_bits_cmd),
		.io_cpu_req_bits_typ (io_cpu_req_bits_typ),
		.io_cpu_req_bits_kill (io_cpu_req_bits_kill),
		.io_cpu_req_bits_phys (io_cpu_req_bits_phys),
		.io_cpu_invalidate_lr (io_cpu_invalidate_lr),
		.io_cpu_req_bits_data (io_cpu_req_bits_data)
		);
	always @ (posedge clk) begin
		$display("at counter %d, io_cpu_req_bits_data is %h",counter,io_cpu_req_bits_data);
		if(io_cpu_req_valid)begin
			$display("-------------------------------------");
			$display("tims is %t",$time);
			$display("at counter %d",counter);
			$display("io_cpu_req_bits_addr is %h",io_cpu_req_bits_addr);
			$display("io_cpu_req_bits_tag is %h",io_cpu_req_bits_tag);
			$display("io_cpu_req_bits_cmd is %h",io_cpu_req_bits_cmd);
			$display("io_cpu_req_bits_typ is %h",io_cpu_req_bits_typ);
			$display("io_cpu_req_bits_kill is %h",io_cpu_req_bits_kill);
			$display("io_cpu_req_bits_phys is %h",io_cpu_req_bits_phys);
			$display("io_cpu_invalidate_lr is %h",io_cpu_invalidate_lr);
			//$display("io_cpu_req_bits_data is %h",io_cpu_req_bits_data);
		end
		if(counter == 8)
			io_cpu_req_ready <= 0;
		if(counter == 13)
			io_cpu_req_ready <= 1;
	end

	always @ (posedge clk)begin
		if(reset)
			counter <= 0;
		else 
			counter <= counter +1;
	end


endmodule
