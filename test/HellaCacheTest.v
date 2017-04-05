`timescale 1ns/1ns
`define pys_addr_width 40
`define output_file "D:/modeltech_10.0a/examples/work/MPRC_HellaCache/3.15.2246Version/mprcHellaCacheTestBench/HellaCacheTestOutput.txt"
`define output_file_ignore_x "D:/modeltech_10.0a/examples/work/MPRC_HellaCache/3.15.2246Version/mprcHellaCacheTestBench/HellaCacheTestOutput_ignore_x.txt"
module HellaCacheTest;

	reg clk;
	reg reset;
	parameter period = 10;

	//signals about cpu
	wire io_cpu_req_ready_mprc;
	wire io_cpu_req_valid;
	wire[`pys_addr_width-1:0] io_cpu_req_bits_addr;
	wire[8:0] io_cpu_req_bits_tag;
	wire[4:0] io_cpu_req_bits_cmd;
	wire[2:0] io_cpu_req_bits_typ;
	wire io_cpu_invalidate_lr;
	wire io_cpu_req_bits_kill;
	wire io_cpu_req_bits_phys;
	wire [63:0] io_cpu_req_bits_data;

	wire io_cpu_resp_valid_mprc;//ok
    wire[39:0] io_cpu_resp_bits_addr_mprc;//ok
    wire[8:0] io_cpu_resp_bits_tag_mprc;//ok
    wire[4:0] io_cpu_resp_bits_cmd_mprc;//ok
    wire[2:0] io_cpu_resp_bits_typ_mprc;//ok
    wire[63:0] io_cpu_resp_bits_data_mprc;//ok
    wire io_cpu_resp_bits_nack_mprc;//ok
    wire io_cpu_resp_bits_replay_mprc;//ok
    wire io_cpu_resp_bits_has_data_mprc;//ok
    wire[63:0] io_cpu_resp_bits_data_word_bypass_mprc;//ok
    wire[63:0] io_cpu_resp_bits_store_data_mprc;//ok

    wire io_cpu_replay_next_valid_mprc;//ok
    wire[8:0] io_cpu_replay_next_bits_mprc;//ok

    wire io_cpu_xcpt_ma_ld_mprc;//ok
    wire io_cpu_xcpt_ma_st_mprc;//ok
    wire io_cpu_xcpt_pf_ld_mprc;//ok
    wire io_cpu_xcpt_pf_st_mprc;//ok
    wire io_cpu_ordered_mprc;//

	//signals about memory for mprc_hellacache
	wire io_mem_acquire_ready_mprc;
	wire io_mem_acquire_valid_mprc;
	wire[25:0] io_mem_acquire_bits_addr_block_mprc;
	wire[1:0] io_mem_acquire_bits_client_xact_id_mprc;
	wire[1:0] io_mem_acquire_bits_addr_beat_mprc;
	wire io_mem_acquire_bits_is_builtin_type_mprc;
	wire[2:0] io_mem_acquire_bits_a_type_mprc;
	wire[16:0]  io_mem_acquire_bits_union_mprc;
	wire[127:0]io_mem_acquire_bits_data_mprc;

	wire io_mem_grant_ready_mprc;
	wire io_mem_grant_valid_mprc;
	wire[1:0] io_mem_grant_bits_addr_beat_mprc;
	wire[1:0] io_mem_grant_bits_client_xact_id_mprc;
	wire[3:0]  io_mem_grant_bits_manager_xact_id_mprc;
	wire io_mem_grant_bits_is_builtin_type_mprc;
	wire[3:0] io_mem_grant_bits_g_type_mprc;
	wire[127:0] io_mem_grant_bits_data_mprc;

	wire io_mem_probe_ready_mprc;
	wire io_mem_probe_valid_mprc;

	wire  io_mem_release_ready_mprc;
	wire io_mem_release_valid_mprc;
	wire[1:0] io_mem_release_bits_addr_beat_mprc;
	wire[25:0]  io_mem_release_bits_addr_block_mprc;
	wire[1:0] io_mem_release_bits_client_xact_id_mprc;
	wire io_mem_release_bits_voluntary_mprc;
	wire[2:0] io_mem_release_bits_r_type_mprc;
	wire[127:0] io_mem_release_bits_data_mprc;

	wire   io_ptw_req_ready;
    assign io_ptw_req_ready = 1;

    reg  io_ptw_resp_valid;
    reg  io_ptw_resp_bits_error;
    reg [19:0] io_ptw_resp_bits_pte_ppn;
    reg [2:0] io_ptw_resp_bits_pte_reserved_for_software;
    reg  io_ptw_resp_bits_pte_d;
    reg  io_ptw_resp_bits_pte_r;
    reg [3:0] io_ptw_resp_bits_pte_typ;
    reg  io_ptw_resp_bits_pte_v;
    reg  io_ptw_status_sd;
    reg [30:0] io_ptw_status_zero2;
    reg  io_ptw_status_sd_rv32;
    reg [8:0] io_ptw_status_zero1;
    reg [4:0] io_ptw_status_vm;
    reg  io_ptw_status_mprv;
    reg [1:0] io_ptw_status_xs;
    reg [1:0] io_ptw_status_fs;
    reg [1:0] io_ptw_status_prv3;
    reg  io_ptw_status_ie3;
    reg [1:0] io_ptw_status_prv2;
    reg  io_ptw_status_ie2;
    reg [1:0] io_ptw_status_prv1;
    reg  io_ptw_status_ie1;
    reg [1:0] io_ptw_status_prv;
    reg  io_ptw_status_ie;
    reg  io_ptw_invalidate;

    //wire   io_ptw_req_ready_mprc;
    wire  io_ptw_req_valid_mprc;
    wire [1:0] io_ptw_req_bits_prv_mprc;
    wire [26:0] io_ptw_req_bits_addr_mprc;
    wire  io_ptw_req_bits_store_mprc;
    wire  io_ptw_req_bits_fetch_mprc;
    /*wire   io_ptw_resp_valid_mprc;
    wire  [15:0] io_ptw_resp_bits_pte_reserved_for_hardware_mprc;
    wire  [37:0] io_ptw_resp_bits_pte_ppn_mprc;
    wire  [1:0] io_ptw_resp_bits_pte_reserved_for_software_mprc;
    wire   io_ptw_resp_bits_pte_d_mprc;
    wire   io_ptw_resp_bits_pte_a_mprc;
    wire   io_ptw_resp_bits_pte_g_mprc;
    wire   io_ptw_resp_bits_pte_u_mprc;
    wire   io_ptw_resp_bits_pte_x_mprc;
    wire   io_ptw_resp_bits_pte_w_mprc;
    wire   io_ptw_resp_bits_pte_r_mprc;
    wire   io_ptw_resp_bits_pte_v_mprc;
    wire  [6:0] io_ptw_ptbr_asid_mprc;
    wire  [37:0] io_ptw_ptbr_ppn_mprc;
    wire   io_ptw_invalidate_mprc;
    wire   io_ptw_status_debug_mprc;
    wire  [31:0] io_ptw_status_isa_mprc;
    wire  [1:0] io_ptw_status_prv_mprc;
    wire   io_ptw_status_sd_mprc;
    wire  [30:0] io_ptw_status_zero3_mprc;
    wire   io_ptw_status_sd_rv32_mprc;
    wire  [1:0] io_ptw_status_zero2_mprc;
    wire  [4:0] io_ptw_status_vm_mprc;
    wire  [3:0] io_ptw_status_zero1_mprc;
    wire   io_ptw_status_mxr_mprc;
    wire   io_ptw_status_pum_mprc;
    wire   io_ptw_status_mprv_mprc;
    wire  [1:0] io_ptw_status_xs_mprc;
    wire  [1:0] io_ptw_status_fs_mprc;
    wire  [1:0] io_ptw_status_mpp_mprc;
    wire  [1:0] io_ptw_status_hpp_mprc;
    wire   io_ptw_status_spp_mprc;
    wire   io_ptw_status_mpie_mprc;
    wire   io_ptw_status_hpie_mprc;
    wire   io_ptw_status_spie_mprc;
    wire   io_ptw_status_upie_mprc;
    wire   io_ptw_status_mie_mprc;
    wire   io_ptw_status_hie_mprc;
    wire   io_ptw_status_sie_mprc;
    wire   io_ptw_status_uie_mprc;*/
    wire init;
    
    //wire [3:0] s2_replaced_way_en;

	initial begin
		clk = 0 ;
		reset = 1;
		#80 reset = 0;
		#1700000 $stop;				
	end

	always 
	#(period/2) clk = ~clk;

	CPU cpu(
		.clk (clk),
		.reset (reset),
		.io_cpu_req_ready (io_cpu_req_ready_mprc),
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

	MEM memory_mprc(
		.clk (clk),
		.reset (reset),

		.io_mem_acquire_ready (io_mem_acquire_ready_mprc),
		.io_mem_acquire_valid (io_mem_acquire_valid_mprc),
		.io_mem_acquire_bits_addr_block (io_mem_acquire_bits_addr_block_mprc),
		.io_mem_acquire_bits_client_xact_id (io_mem_acquire_bits_client_xact_id_mprc),
		.io_mem_acquire_bits_addr_beat (io_mem_acquire_bits_addr_beat_mprc),
		.io_mem_acquire_bits_is_builtin_type (io_mem_acquire_bits_is_builtin_type_mprc),
		.io_mem_acquire_bits_a_type (io_mem_acquire_bits_a_type_mprc),
		.io_mem_acquire_bits_union (io_mem_acquire_bits_union_mprc),
		.io_mem_acquire_bits_data (io_mem_acquire_bits_data_mprc),

		.io_mem_grant_ready (io_mem_grant_ready_mprc),
		.io_mem_grant_valid (io_mem_grant_valid_mprc),
		.io_mem_grant_bits_addr_beat (io_mem_grant_bits_addr_beat_mprc),
		.io_mem_grant_bits_client_xact_id (io_mem_grant_bits_client_xact_id_mprc),
		.io_mem_grant_bits_manager_xact_id (io_mem_grant_bits_manager_xact_id_mprc),
		.io_mem_grant_bits_is_builtin_type (io_mem_grant_bits_is_builtin_type_mprc),
		.io_mem_grant_bits_g_type (io_mem_grant_bits_g_type_mprc),
		.io_mem_grant_bits_data (io_mem_grant_bits_data_mprc),

		.io_mem_probe_ready (io_mem_probe_ready_mprc),
		.io_mem_probe_valid (io_mem_probe_valid_mprc),

		.io_mem_release_ready (io_mem_release_ready_mprc),
		.io_mem_release_valid (io_mem_release_valid_mprc),
		.io_mem_release_bits_addr_beat (io_mem_release_bits_addr_beat_mprc),
		.io_mem_release_bits_addr_block (io_mem_release_bits_addr_block_mprc),
		.io_mem_release_bits_client_xact_id (io_mem_release_bits_client_xact_id_mprc),
		.io_mem_release_bits_voluntary (io_mem_release_bits_voluntary_mprc),
		.io_mem_release_bits_r_type (io_mem_release_bits_r_type_mprc),
		.io_mem_release_bits_data (io_mem_release_bits_data_mprc)
		);

	mprcHellaCache mprchellacache(
	  .clk(clk),
	  .reset(reset),
	  .io_cpu_req_ready (io_cpu_req_ready_mprc),
    .io_cpu_req_valid (io_cpu_req_valid),
    .io_cpu_req_bits_addr (io_cpu_req_bits_addr),
    .io_cpu_req_bits_tag (io_cpu_req_bits_tag),
    .io_cpu_req_bits_cmd (io_cpu_req_bits_cmd),
    .io_cpu_req_bits_typ (io_cpu_req_bits_typ),
    .io_cpu_req_bits_kill (io_cpu_req_bits_kill),
    .io_cpu_req_bits_phys (io_cpu_req_bits_phys),
    .io_cpu_req_bits_data (io_cpu_req_bits_data),

//cache resp to cpu
    .io_cpu_resp_valid (io_cpu_resp_valid_mprc), //ok
    .io_cpu_resp_bits_addr (io_cpu_resp_bits_addr_mprc),//ok
    .io_cpu_resp_bits_tag (io_cpu_resp_bits_tag_mprc),//ok
    .io_cpu_resp_bits_cmd (io_cpu_resp_bits_cmd_mprc),//ok
    .io_cpu_resp_bits_typ (io_cpu_resp_bits_typ_mprc),//ok
    .io_cpu_resp_bits_data (io_cpu_resp_bits_data_mprc),//ok
    .io_cpu_resp_bits_nack (io_cpu_resp_bits_nack_mprc),//ok
    .io_cpu_resp_bits_replay (io_cpu_resp_bits_replay_mprc),//ok
    .io_cpu_resp_bits_has_data (io_cpu_resp_bits_has_data_mprc),//ok
    .io_cpu_resp_bits_data_word_bypass (io_cpu_resp_bits_data_word_bypass_mprc),//ok
    .io_cpu_resp_bits_store_data (io_cpu_resp_bits_store_data_mprc),//ok

    .io_cpu_replay_next_valid (io_cpu_replay_next_valid_mprc),//ok
    .io_cpu_replay_next_bits (io_cpu_replay_next_bits_mprc),//ok

    .io_cpu_xcpt_ma_ld (io_cpu_xcpt_ma_ld_mprc),//ok
    .io_cpu_xcpt_ma_st (io_cpu_xcpt_ma_st_mprc),//ok
    .io_cpu_xcpt_pf_ld (io_cpu_xcpt_pf_ld_mprc),//ok
    .io_cpu_xcpt_pf_st (io_cpu_xcpt_pf_st_mprc),//ok
    .io_cpu_invalidate_lr (io_cpu_invalidate_lr),//ok
    .io_cpu_ordered (io_cpu_ordered_mprc),//ok


// cache to ptw   ok
    .io_ptw_req_ready (io_ptw_req_ready),
    .io_ptw_req_valid (io_ptw_req_valid_mprc),
    .io_ptw_req_bits_prv (io_ptw_req_bits_prv_mprc),
    .io_ptw_req_bits_addr (io_ptw_req_bits_addr_mprc),
    .io_ptw_req_bits_store (io_ptw_req_bits_store_mprc),
    .io_ptw_req_bits_fetch (io_ptw_req_bits_fetch_mprc),

    .io_ptw_resp_valid(io_ptw_resp_valid),
    .io_ptw_resp_bits_error(io_ptw_resp_bits_error),
    .io_ptw_resp_bits_pte_ppn(io_ptw_resp_bits_pte_ppn),
    .io_ptw_resp_bits_pte_reserved_for_software(io_ptw_resp_bits_pte_reserved_for_software),
    .io_ptw_resp_bits_pte_d(io_ptw_resp_bits_pte_d),
    .io_ptw_resp_bits_pte_r(io_ptw_resp_bits_pte_r),
    .io_ptw_resp_bits_pte_typ(io_ptw_resp_bits_pte_typ),
    .io_ptw_resp_bits_pte_v(io_ptw_resp_bits_pte_v),
    .io_ptw_status_sd(io_ptw_status_sd),
    .io_ptw_status_zero2(io_ptw_status_zero2),
    .io_ptw_status_sd_rv32(io_ptw_status_sd_rv32),
    .io_ptw_status_zero1(io_ptw_status_zero1),
    .io_ptw_status_vm(io_ptw_status_vm),
    .io_ptw_status_mprv(io_ptw_status_mprv),
    .io_ptw_status_xs(io_ptw_status_xs),
    .io_ptw_status_fs(io_ptw_status_fs),
    .io_ptw_status_prv3(io_ptw_status_prv3),
    .io_ptw_status_ie3(io_ptw_status_ie3),
    .io_ptw_status_prv2(io_ptw_status_prv2),
    .io_ptw_status_ie2(io_ptw_status_ie2),
    .io_ptw_status_prv1(io_ptw_status_prv1),
    .io_ptw_status_ie1(io_ptw_status_ie1),
    .io_ptw_status_prv(io_ptw_status_prv),
    .io_ptw_status_ie(io_ptw_status_ie),
    .io_ptw_invalidate(io_ptw_invalidate),

// to next level memory  ok
    .io_mem_acquire_ready (io_mem_acquire_ready_mprc),
    .io_mem_acquire_valid (io_mem_acquire_valid_mprc),
    .io_mem_acquire_bits_addr_block (io_mem_acquire_bits_addr_block_mprc),
    .io_mem_acquire_bits_client_xact_id (io_mem_acquire_bits_client_xact_id_mprc),
    .io_mem_acquire_bits_addr_beat (io_mem_acquire_bits_addr_beat_mprc),
    .io_mem_acquire_bits_is_builtin_type (io_mem_acquire_bits_is_builtin_type_mprc),
    .io_mem_acquire_bits_a_type (io_mem_acquire_bits_a_type_mprc),
    .io_mem_acquire_bits_union (io_mem_acquire_bits_union_mprc),
    .io_mem_acquire_bits_data (io_mem_acquire_bits_data_mprc),

//next level memory to cache  ok
    .io_mem_grant_ready (io_mem_grant_ready_mprc),
    .io_mem_grant_valid (io_mem_grant_valid_mprc),
    .io_mem_grant_bits_addr_beat (io_mem_grant_bits_addr_beat_mprc),
    .io_mem_grant_bits_client_xact_id (io_mem_grant_bits_client_xact_id_mprc),
    .io_mem_grant_bits_manager_xact_id (io_mem_grant_bits_manager_xact_id_mprc),
    .io_mem_grant_bits_is_builtin_type (io_mem_grant_bits_is_builtin_type_mprc),
    .io_mem_grant_bits_g_type (io_mem_grant_bits_g_type_mprc),
    .io_mem_grant_bits_data (io_mem_grant_bits_data_mprc),

    .io_mem_probe_ready (io_mem_probe_ready_mprc),
    .io_mem_probe_valid (io_mem_probe_valid_mprc),
    .io_mem_probe_bits_addr_block (io_mem_probe_bits_addr_block_mprc),
    .io_mem_probe_bits_p_type (io_mem_probe_bits_p_type_mprc),

    // from releaseArb   ok
    .io_mem_release_ready (io_mem_release_ready_mprc),
    .io_mem_release_valid (io_mem_release_valid_mprc),
    .io_mem_release_bits_addr_beat (io_mem_release_bits_addr_beat_mprc),
    .io_mem_release_bits_addr_block (io_mem_release_bits_addr_block_mprc),
    .io_mem_release_bits_client_xact_id (io_mem_release_bits_client_xact_id_mprc),
    .io_mem_release_bits_voluntary (io_mem_release_bits_voluntary_mprc),
    .io_mem_release_bits_r_type (io_mem_release_bits_r_type_mprc),
    .io_mem_release_bits_data (io_mem_release_bits_data_mprc),
    
    //.s2_replaced_way_en (s2_replaced_way_en),
    
    .init (init)
	);
	
	
	assign init = 0;
	integer fp_w,fp_w_ignore_x;
	initial begin
		fp_w = $fopen(`output_file,"w");
        fp_w_ignore_x = $fopen(`output_file_ignore_x,"w");
		if(!fp_w)begin
			$display("could not open output file");
			$stop;
		end
        if(!fp_w_ignore_x)begin
            $display("could not open output ingore x file");
            $stop;
        end  

	end
    
	reg[31:0] counter;
	always @ (posedge clk)begin
		if(reset)begin
			counter <= 0;
		end
		else begin
			counter <= counter + 1;
		end
	end

    always @ (posedge clk) begin
        io_ptw_resp_valid <= io_ptw_req_valid_mprc;
        io_ptw_resp_bits_error <= 0;
        io_ptw_resp_bits_pte_ppn <= $random;
        io_ptw_resp_bits_pte_reserved_for_software <= $random;
        io_ptw_resp_bits_pte_d <= $random;
        io_ptw_resp_bits_pte_r <= $random;
        io_ptw_resp_bits_pte_typ <= $random;
        io_ptw_resp_bits_pte_v <= 1;
        io_ptw_status_sd <= $random;
        io_ptw_status_zero2 <= $random;
        io_ptw_status_sd_rv32 <= $random;
        io_ptw_status_zero1 <= $random;
        io_ptw_status_vm <= 'b11111;
        io_ptw_status_mprv <= 1;
        io_ptw_status_xs <= $random;
        io_ptw_status_fs <= $random;
        io_ptw_status_prv3 <= $random;
        io_ptw_status_ie3 <= $random;
        io_ptw_status_prv2 <= $random;
        io_ptw_status_ie2 <= $random;
        io_ptw_status_prv1 <= 0;
        io_ptw_status_ie1 <= $random;
        io_ptw_status_prv <= $random;
        io_ptw_status_ie <= $random;
        io_ptw_invalidate <= 0;
    end

endmodule // HellaCacheTest
