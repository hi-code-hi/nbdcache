
module mprcHellaCache(input clk, input reset,
//cpu req  ok
    output io_cpu_req_ready,
    input  io_cpu_req_valid,
    input [39:0] io_cpu_req_bits_addr,
    input [8:0] io_cpu_req_bits_tag,
    input [4:0] io_cpu_req_bits_cmd,
    input [2:0] io_cpu_req_bits_typ,
    input  io_cpu_req_bits_kill,
    input  io_cpu_req_bits_phys,
    input [63:0] io_cpu_req_bits_data,

//cache resp to cpu
    output io_cpu_resp_valid, //ok
    output[39:0] io_cpu_resp_bits_addr,//ok
    output[8:0] io_cpu_resp_bits_tag,//ok
    output[4:0] io_cpu_resp_bits_cmd,//ok
    output[2:0] io_cpu_resp_bits_typ,//ok
    output[63:0] io_cpu_resp_bits_data,//ok
    output io_cpu_resp_bits_nack,//ok
    output io_cpu_resp_bits_replay,//ok
    output io_cpu_resp_bits_has_data,//ok
    output[63:0] io_cpu_resp_bits_data_word_bypass,//ok
    output[63:0] io_cpu_resp_bits_store_data,//ok

    output io_cpu_replay_next_valid,//ok
    output[8:0] io_cpu_replay_next_bits,//ok

    output io_cpu_xcpt_ma_ld,//ok
    output io_cpu_xcpt_ma_st,//ok
    output io_cpu_xcpt_pf_ld,//ok
    output io_cpu_xcpt_pf_st,//ok
    input  io_cpu_invalidate_lr,//ok
    output io_cpu_ordered,//ok


// cache to ptw   ok
    input   io_ptw_req_ready,
    output  io_ptw_req_valid,
    output [1:0] io_ptw_req_bits_prv,
    output [26:0] io_ptw_req_bits_addr,
    output  io_ptw_req_bits_store,
    output  io_ptw_req_bits_fetch,
    
    input   io_ptw_resp_valid,
    input  io_ptw_resp_bits_error,
    input  [37:0] io_ptw_resp_bits_pte_ppn,
    input  [1:0] io_ptw_resp_bits_pte_reserved_for_software,
    input   io_ptw_resp_bits_pte_d,
    input   io_ptw_resp_bits_pte_r,
    input   io_ptw_resp_bits_pte_v,
    input  [3:0] io_ptw_resp_bits_pte_typ,

    input   io_ptw_status_sd,
    input  [1:0] io_ptw_status_zero2,
    input   io_ptw_status_sd_rv32,
    input  [3:0] io_ptw_status_zero1,
    input  [4:0] io_ptw_status_vm,
    input   io_ptw_status_mprv,
    input  [1:0] io_ptw_status_xs,
    input  [1:0] io_ptw_status_fs,
 
    
    input [1:0] io_ptw_status_prv3,
    input  io_ptw_status_ie3,
    input [1:0] io_ptw_status_prv2,
    input  io_ptw_status_ie2,
    input [1:0] io_ptw_status_prv1,
    input  io_ptw_status_ie1,
    input [1:0] io_ptw_status_prv,
    input  io_ptw_status_ie,
    input  io_ptw_invalidate,


// to next level memory  ok
    input  io_mem_acquire_ready,
    output io_mem_acquire_valid,
    output[25:0] io_mem_acquire_bits_addr_block,
    output[1:0] io_mem_acquire_bits_client_xact_id,
    output[1:0] io_mem_acquire_bits_addr_beat,
    output io_mem_acquire_bits_is_builtin_type,
    output[2:0] io_mem_acquire_bits_a_type,
    output[16:0] io_mem_acquire_bits_union,
    output[127:0] io_mem_acquire_bits_data,

//next level memory to cache  ok
    output io_mem_grant_ready,
    input  io_mem_grant_valid,
    input [1:0] io_mem_grant_bits_addr_beat,
    input [1:0] io_mem_grant_bits_client_xact_id,
    input [3:0] io_mem_grant_bits_manager_xact_id,
    input  io_mem_grant_bits_is_builtin_type,
    input [3:0] io_mem_grant_bits_g_type,
    input [127:0] io_mem_grant_bits_data,

    output io_mem_probe_ready,
    input  io_mem_probe_valid,
    input [25:0] io_mem_probe_bits_addr_block,
    input [1:0] io_mem_probe_bits_p_type,

    // from releaseArb   ok
    input  io_mem_release_ready,
    output io_mem_release_valid,
    output[1:0] io_mem_release_bits_addr_beat,
    output[25:0] io_mem_release_bits_addr_block,
    output[1:0] io_mem_release_bits_client_xact_id,
    output io_mem_release_bits_voluntary,
    output[2:0] io_mem_release_bits_r_type,
    output[127:0] io_mem_release_bits_data,
    
    //input [3:0] s2_replaced_way_en,
    input  init
);



// mshr and stage3
wire mshrs_io_req_ready;
wire mshrs_io_req_valid;
wire mshrs_io_secondary_miss;
wire[39:0] mshrs_io_req_bits_addr;
wire [8:0] mshrs_io_req_bits_tag;
wire [4:0] mshrs_io_req_bits_cmd;
wire [2:0] mshrs_io_req_bits_typ;
wire  mshrs_io_req_bits_kill;
wire  mshrs_io_req_bits_phys;
wire [63:0] mshrs_io_req_bits_data;
wire  mshrs_io_req_bits_tag_match;
wire [19:0] mshrs_io_req_bits_old_meta_tag;
wire [1:0] mshrs_io_req_bits_old_meta_coh_state;
wire [3:0] mshrs_io_req_bits_way_en;


//mshr and wbArbiter
wire wbArb_io_in_1_ready;
wire mshrs_io_wb_req_valid;
wire[1:0] mshrs_io_wb_req_bits_addr_beat;
wire[25:0] mshrs_io_wb_req_bits_addr_block;
wire[1:0] mshrs_io_wb_req_bits_client_xact_id;
wire mshrs_io_wb_req_bits_voluntary;
wire[2:0] mshrs_io_wb_req_bits_r_type;
wire[127:0] mshrs_io_wb_req_bits_data;
wire[3:0] mshrs_io_wb_req_bits_way_en;
wire[3:0] mshrs_io_wb_req_bicache_resp_bits_store_datats_way_en;

//flowThroughSerizlizer to mshr
wire io_mem_grant_valid_to_mshr;
wire FlowThroughSerializer_io_out_ready;
wire FlowThroughSerializer_io_out_valid;
wire[1:0] FlowThroughSerializer_io_out_bits_addr_beat;
wire[1:0] FlowThroughSerializer_io_out_bits_client_xact_id;
wire[3:0] FlowThroughSerializer_io_out_bits_manager_xact_id;
wire FlowThroughSerializer_io_out_bits_is_builtin_type;
wire[3:0] FlowThroughSerializer_io_out_bits_g_type;
wire[127:0] FlowThroughSerializer_io_out_bits_data;

wire writeArb_io_in_1_ready;//from stage4
wire narrow_grant_ready;//T8 in generaged by Chisel tool chain


//mshr to stage1 replay
wire readArb_io_in_1_ready;
wire mshrs_io_replay_valid;
wire[39:0] mshrs_io_replay_bits_addr;
wire[8:0] mshrs_io_replay_bits_tag;
wire[4:0] mshrs_io_replay_bits_cmd;
wire[2:0] mshrs_io_replay_bits_typ;
wire mshrs_io_replay_bits_kill;
wire mshrs_io_replay_bits_phys;
wire[63:0] mshrs_io_replay_bits_data;

//mshr to stage1 meta_read
wire metaReadArb_io_in_1_ready;
wire mshrs_io_meta_read_valid;
wire[5:0] mshrs_io_meta_read_bits_idx;
wire[3:0] mshrs_io_meta_read_bits_way_en;

//mshr to stage4 meta_write
wire mshrs_meta_write_ready;
wire mshrs_io_meta_write_valid;
wire[5:0] mshrs_io_meta_write_bits_idx;
wire[3:0] mshrs_io_meta_write_bits_way_en;
wire[19:0] mshrs_io_meta_write_bits_data_tag;
wire[1:0] mshrs_io_meta_write_bits_data_coh_state;

//mshr to stage4 refill
wire[3:0] mshrs_refill_way_en;
wire[11:0] mshrs_refill_addr;

//mshr to probe
wire mshrs_io_probe_rdy;

//to generate io_resp_ordered   not ok
wire mshrs_io_fence_rdy;




wire prober_io_req_ready;
wire lrsc_valid;//ok


// probe and releaseArb ok
//wire prober_io_req_ready;
wire prober_io_rep_valid;
wire[1:0] prober_io_rep_bits_addr_beat;
wire[25:0] prober_io_rep_bits_addr_block;
wire[1:0] prober_io_rep_bits_client_xact_id;
wire prober_io_rep_bits_voluntary;
wire[2:0] prober_io_rep_bits_r_type;
wire[127:0] prober_io_rep_bits_data;

//probe and stage1 meta_read  ok
wire metaReadArb_io_in_2_ready;
wire prober_io_meta_read_valid;
wire[5:0] prober_io_meta_read_bits_idx;
wire[19:0] prober_io_meta_read_bits_tag;

//porbe and stage4 meta_write ok
wire metaWriteArb_io_in_1_ready;
wire prober_io_meta_write_valid;
wire[5:0] prober_io_meta_write_bits_idx;
wire[3:0] prober_io_meta_write_bits_way_en;
wire[19:0] prober_io_meta_write_bits_data_tag;
wire[1:0] prober_io_meta_write_bits_data_coh_state;


//probe and wbArb  ok
wire wbArb_io_in_0_ready;
wire prober_io_wb_req_valid;
wire[1:0] prober_io_wb_req_bits_addr_beat;
wire[25:0] prober_io_wb_req_bits_addr_block;
wire[1:0] prober_io_wb_req_bits_client_xact_id;
wire prober_io_wb_req_bits_voluntary;
wire[2:0] prober_io_wb_req_bits_r_type;
wire[127:0] prober_io_wb_req_bits_data;
wire[3:0] prober_io_wb_req_bits_way_en;


//probe and stage3  ok
wire[3:0] prober_way_en;
wire[1:0] prober_block_state;


//wbArb and wb    ok
wire wb_io_req_ready;
wire wbArb_io_out_valid;
wire[1:0] wbArb_io_out_bits_addr_beat;
wire[25:0] wbArb_io_out_bits_addr_block;
wire[1:0] wbArb_io_out_bits_client_xact_id;
wire wbArb_io_out_bits_voluntary;
wire[2:0] wbArb_io_out_bits_r_type;
wire[127:0] wbArb_io_out_bits_data;
wire[3:0] wbArb_io_out_bits_way_en;


//wb and stage1 read_meta  ok
wire metaReadArb_io_in_3_ready;
wire wb_io_meta_read_valid;
wire[5:0] wb_io_meta_read_bits_idx;
wire[19:0] wb_io_meta_read_bits_tag;

//wb and stage1 read_data  ok
wire readArb_io_in_2_ready;
wire wb_io_data_req_valid;
wire[3:0] wb_io_data_req_bits_way_en;
wire[11:0] wb_io_data_req_bits_addr;

//wb and stage3 ok
wire[127:0] s2_data_corrected;

//wb and release ok
wire releaseArb_io_in_0_ready;
wire wb_io_release_valid;
wire[1:0] wb_io_release_bits_addr_beat;
wire[25:0] wb_io_release_bits_addr_block;
wire[1:0] wb_io_release_bits_client_xact_id;
wire wb_io_release_bits_voluntary;
wire[2:0] wb_io_release_bits_r_type;
wire[127:0] wb_io_release_bits_data;



//stage1 and stage 4
wire meta_io_write_ready;
wire meta_io_write_valid;
wire [5:0] meta_io_write_idx;
wire [3:0] meta_io_write_way_en;
wire [19:0] meta_io_write_data_tag;
wire [1:0] meta_io_write_data_coh_state;

wire data_io_write_ready;
wire data_io_write_valid;
wire [3:0] data_io_write_way_en;
wire [11:0] data_io_write_addr;
wire [1:0] data_io_write_wmask;
wire [127:0] data_io_write_data;



//stage1 and stage2
wire [19:0] meta_io_resp_3_tag_1to2;
wire [19:0] meta_io_resp_2_tag_1to2;
wire [19:0] meta_io_resp_1_tag_1to2;
wire [19:0] meta_io_resp_0_tag_1to2;
wire [1:0] meta_io_resp_3_coh_state_1to2;
wire [1:0] meta_io_resp_2_coh_state_1to2;
wire [1:0] meta_io_resp_1_coh_state_1to2;
wire [1:0] meta_io_resp_0_coh_state_1to2;
wire [127:0] data_io_resp_3_1to2;
wire [127:0] data_io_resp_2_1to2;
wire [127:0] data_io_resp_1_1to2;
wire [127:0] data_io_resp_0_1to2;
wire s1_valid;
wire s1_replay;
wire s1_recycled;
wire s1_clk_en;
wire [39:0] s1_req_addr;
wire [8:0] s1_req_tag;
wire [4:0] s1_req_cmd;
wire [2:0] s1_req_typ;
wire s1_req_kill;
wire s1_req_phys;
wire [63:0] s1_req_data;


//stage1 ans stage3 ok
wire s2_recycle;

//stage2 and stage3 
wire s2_recycle_ecc;
wire s2_valid_masked;

wire s2_sc_fail;
wire[63:0] amoalu_out_data;

//stage2 to stage3 registers out
wire  s2_valid;
wire  s2_killed;
wire  s2_replay;
wire  s2_recycle_next;
wire [39:0] s2_req_addr;
wire [8:0] s2_req_tag;
wire [4:0] s2_req_cmd;
wire [2:0] s2_req_typ;
wire  s2_req_kill;
wire  s2_req_phys;
wire [63:0] s2_req_data;
wire  s2_nack_hit;
wire [3:0] s2_tag_match_way;
wire [19:0] meta_io_resp_3_tag;
wire [19:0] meta_io_resp_2_tag;
wire [19:0] meta_io_resp_1_tag;
wire [19:0] meta_io_resp_0_tag;
wire [1:0] meta_io_resp_3_coh_state;
wire [1:0] meta_io_resp_2_coh_state;
wire [1:0] meta_io_resp_1_coh_state;
wire [1:0] meta_io_resp_0_coh_state;
wire [127:0] data_io_resp_3;
wire [127:0] data_io_resp_2;
wire [127:0] data_io_resp_1;
wire [127:0] data_io_resp_0;
wire [3:0] s2_replaced_way_en;
wire [63:0] s2_store_bypass_data;
wire  s2_store_bypass;




//stage4 to stage2
wire s4_valid;
wire[39:0] s4_req_addr;
wire[63:0] s4_req_data;
wire[4:0] s4_req_cmd;


//stage3 to stage4 registers out
wire [3:0] s3_way;
wire s3_valid;
wire [39:0] s3_req_addr;
wire [4:0] s3_req_cmd;
wire [2:0] s3_req_typ;
wire [8:0] s3_req_tag;
wire s3_req_kill;
wire s3_req_phys;
wire [63:0] s3_req_data;



//resp from stage3
wire cache_resp_valid;
wire [39:0] cache_resp_bits_addr;
wire [8:0] cache_resp_bits_tag;
wire [4:0] cache_resp_bits_cmd;
wire [2:0] cache_resp_bits_typ;
wire [63:0] cache_resp_bits_data;
wire cache_resp_bits_nack;
wire cache_resp_bits_replay;
wire cache_resp_bits_has_data;
wire [63:0] cache_resp_bits_store_data;


//resp from mshr(io)
wire mshrs_io_resp_valid;
wire[39:0] mshrs_io_resp_bits_addr;
wire[8:0] mshrs_io_resp_bits_tag;
wire[4:0] mshrs_io_resp_bits_cmd;
wire[2:0] mshrs_io_resp_bits_typ;
wire[63:0] mshrs_io_resp_bits_data;
wire mshrs_io_resp_bits_nack;
wire mshrs_io_resp_bits_replay;
wire mshrs_io_resp_bits_has_data;
wire[63:0] mshrs_io_resp_bits_store_data;



// others
wire block_miss;
wire readArb_io_in_3_ready;
wire metaReadArb_io_in_4_ready;
wire dtlb_io_req_ready;
wire cache_pass;
wire s1_read;
wire s1_write;
wire dtlb_io_resp_xcpt_st;
wire dtlb_io_resp_xcpt_ld;
wire misaligned;
wire[3:0] shift;
wire metaReadArb_io_out_valid;


wire t2;
wire t3;
wire t4;

assign narrow_grant_ready = FlowThroughSerializer_io_out_ready;
assign io_mem_grant_valid_to_mshr = FlowThroughSerializer_io_out_valid & narrow_grant_ready;



assign io_mem_probe_ready = prober_io_req_ready & (lrsc_valid ^ 1'h1);



assign io_cpu_req_ready = block_miss ? 1'h0 : t2;
                          /*block_miss ? 1'h0 :
                              (~readArb_io_in_3_ready ? 1'h0 :
                                  (~metaReadArb_io_in_4_ready ? 1'h0 : 
                                    (((~io_cpu_req_bits_phys) & (~dtlb_io_req_ready)) == 0)));*/
assign t4 = ((~io_cpu_req_bits_phys) & (~dtlb_io_req_ready)) == 1'b0;
assign t3 = (~metaReadArb_io_in_4_ready) ? 1'h0 : t4;
assign t2 = (~readArb_io_in_3_ready) ? 1'h0 : t3;

assign io_cpu_resp_valid = cache_pass ? cache_resp_valid : mshrs_io_resp_valid;
assign io_cpu_resp_bits_addr = cache_pass ? cache_resp_bits_addr : mshrs_io_resp_bits_addr;
assign io_cpu_resp_bits_tag = cache_pass ? cache_resp_bits_tag : mshrs_io_resp_bits_tag;
assign io_cpu_resp_bits_cmd = cache_pass ? cache_resp_bits_cmd : mshrs_io_resp_bits_cmd;
assign io_cpu_resp_bits_typ = cache_pass ? cache_resp_bits_typ : mshrs_io_resp_bits_typ;
assign io_cpu_resp_bits_nack = cache_pass ? cache_resp_bits_nack : mshrs_io_resp_bits_nack;
assign io_cpu_resp_bits_replay = cache_pass ? cache_resp_bits_replay : mshrs_io_resp_bits_replay;
assign io_cpu_resp_bits_has_data = cache_pass ? cache_resp_bits_has_data : mshrs_io_resp_bits_has_data;
assign io_cpu_resp_bits_store_data = cache_pass ? cache_resp_bits_store_data : mshrs_io_resp_bits_store_data;
assign io_cpu_resp_bits_data = cache_pass ? cache_resp_bits_data : mshrs_io_resp_bits_data;


assign io_cpu_replay_next_valid = s1_replay & s1_read;
assign io_cpu_replay_next_bits = s1_req_tag;

assign io_cpu_xcpt_pf_ld = s1_read & dtlb_io_resp_xcpt_ld;
assign io_cpu_xcpt_pf_st = s1_write & dtlb_io_resp_xcpt_st;
assign io_cpu_ordered = mshrs_io_fence_rdy & (s1_valid ^ 1'h1) & (s2_valid ^ 1'h1);//不懂

assign io_cpu_xcpt_ma_st = s1_write & misaligned;
assign io_cpu_xcpt_ma_ld = s1_read & misaligned;
assign misaligned = (s1_req_addr[2:0] & (shift[2:0] - 4'b1)) != 3'b0;
assign shift = 4'h1 << s1_req_typ[1:0];






 mprcMSHRFile mshrs(.clk(clk), .reset(reset),
        //with stage3  ok
       .io_req_ready( mshrs_io_req_ready ),
       .io_req_valid( mshrs_io_req_valid ),
       .io_req_bits_addr( mshrs_io_req_bits_addr ),
       .io_req_bits_tag( mshrs_io_req_bits_tag ),
       .io_req_bits_cmd( mshrs_io_req_bits_cmd ),
       .io_req_bits_typ( mshrs_io_req_bits_typ ),
       .io_req_bits_kill( mshrs_io_req_bits_kill ),
       .io_req_bits_phys( mshrs_io_req_bits_phys ),
       .io_req_bits_data( mshrs_io_req_bits_data ),
       .io_req_bits_tag_match( mshrs_io_req_bits_tag_match ),
       .io_req_bits_old_meta_tag( mshrs_io_req_bits_old_meta_tag ),
       .io_req_bits_old_meta_coh_state( mshrs_io_req_bits_old_meta_coh_state ),
       .io_req_bits_way_en( mshrs_io_req_bits_way_en ),
       .io_secondary_miss( mshrs_io_secondary_miss ),
       
      
       .io_resp_ready( !cache_pass ),
       .io_resp_valid( mshrs_io_resp_valid ),
       .io_resp_bits_addr( mshrs_io_resp_bits_addr ),
       .io_resp_bits_tag( mshrs_io_resp_bits_tag ),
       .io_resp_bits_cmd( mshrs_io_resp_bits_cmd ),
       .io_resp_bits_typ( mshrs_io_resp_bits_typ ),
       .io_resp_bits_data( mshrs_io_resp_bits_data ),
       .io_resp_bits_nack( mshrs_io_resp_bits_nack ),
       .io_resp_bits_replay( mshrs_io_resp_bits_replay ),
       .io_resp_bits_has_data( mshrs_io_resp_bits_has_data ),
       .io_resp_bits_store_data( mshrs_io_resp_bits_store_data ),
       
       
       //req to next memory   ok
       .io_mem_req_ready( io_mem_acquire_ready ),
       .io_mem_req_valid( io_mem_acquire_valid ),
       .io_mem_req_bits_addr_block( io_mem_acquire_bits_addr_block ),
       .io_mem_req_bits_client_xact_id( io_mem_acquire_bits_client_xact_id ),
       .io_mem_req_bits_addr_beat( io_mem_acquire_bits_addr_beat ),
       .io_mem_req_bits_is_builtin_type( io_mem_acquire_bits_is_builtin_type ),
       .io_mem_req_bits_a_type( io_mem_acquire_bits_a_type ),
       .io_mem_req_bits_union( io_mem_acquire_bits_union ),
       .io_mem_req_bits_data( io_mem_acquire_bits_data ),
       
       //to stage4 refill  ok
       .io_refill_way_en( mshrs_refill_way_en ),
       .io_refill_addr( mshrs_refill_addr ),
       
       //to stage1 meta_read   ok
       .io_meta_read_ready( metaReadArb_io_in_1_ready ),
       .io_meta_read_valid( mshrs_io_meta_read_valid ),
       .io_meta_read_bits_idx( mshrs_io_meta_read_bits_idx ),
       .io_meta_read_bits_way_en( mshrs_io_meta_read_bits_way_en ),

      // to stage4 meta_write
       .io_meta_write_ready( mshrs_meta_write_ready ),
       .io_meta_write_valid( mshrs_io_meta_write_valid ),
       .io_meta_write_bits_idx( mshrs_io_meta_write_bits_idx ),
       .io_meta_write_bits_way_en( mshrs_io_meta_write_bits_way_en ),
       .io_meta_write_bits_data_tag( mshrs_io_meta_write_bits_data_tag ),
       .io_meta_write_bits_data_coh_state( mshrs_io_meta_write_bits_data_coh_state ),
       
       
       //to stage1 replay  ok
       .io_replay_ready( readArb_io_in_1_ready ),
       .io_replay_valid( mshrs_io_replay_valid ),
       .io_replay_bits_addr( mshrs_io_replay_bits_addr ),
       .io_replay_bits_tag( mshrs_io_replay_bits_tag ),
       .io_replay_bits_cmd( mshrs_io_replay_bits_cmd ),
       .io_replay_bits_typ( mshrs_io_replay_bits_typ ),
       .io_replay_bits_kill( mshrs_io_replay_bits_kill ),
       .io_replay_bits_phys( mshrs_io_replay_bits_phys ),
       .io_replay_bits_data( mshrs_io_replay_bits_data ),
       
       
       //next memory to mshr
       .io_mem_grant_valid( io_mem_grant_valid_to_mshr),//ok in connection wire,not ok in acknowledgement
       .io_mem_grant_bits_addr_beat( FlowThroughSerializer_io_out_bits_addr_beat ),
       .io_mem_grant_bits_client_xact_id( FlowThroughSerializer_io_out_bits_client_xact_id ),
       .io_mem_grant_bits_manager_xact_id( FlowThroughSerializer_io_out_bits_manager_xact_id ),
       .io_mem_grant_bits_is_builtin_type( FlowThroughSerializer_io_out_bits_is_builtin_type ),
       .io_mem_grant_bits_g_type( FlowThroughSerializer_io_out_bits_g_type ),
       .io_mem_grant_bits_data( FlowThroughSerializer_io_out_bits_data ),
       
       
       //with wbArbiter  ok
       .io_wb_req_ready( wbArb_io_in_1_ready ),
       .io_wb_req_valid( mshrs_io_wb_req_valid ),
       .io_wb_req_bits_addr_beat( mshrs_io_wb_req_bits_addr_beat ),
       .io_wb_req_bits_addr_block( mshrs_io_wb_req_bits_addr_block ),
       .io_wb_req_bits_client_xact_id( mshrs_io_wb_req_bits_client_xact_id ),
       .io_wb_req_bits_voluntary( mshrs_io_wb_req_bits_voluntary ),
       .io_wb_req_bits_r_type( mshrs_io_wb_req_bits_r_type ),
       .io_wb_req_bits_data( mshrs_io_wb_req_bits_data ),
       .io_wb_req_bits_way_en( mshrs_io_wb_req_bits_way_en ),
       
       // with prober ok
       .io_probe_rdy( mshrs_io_probe_rdy ),
       // to generate io_cpu_ordered  no ok now
       .io_fence_rdy( mshrs_io_fence_rdy ),
       
       
       .io_mem_release_valid(io_mem_release_valid),
       .io_mem_release_bits_addr_beat(io_mem_release_bits_addr_beat)
  );




  mprcProbeUnit prober(.clk(clk), .reset(reset),
  
        // next memory to porber   ok
       .io_req_ready( prober_io_req_ready ),
       .io_req_valid( io_mem_probe_valid & (lrsc_valid ^ 1'h1) ),
       .io_req_bits_addr_block( io_mem_probe_bits_addr_block ),
       .io_req_bits_p_type( io_mem_probe_bits_p_type ),
       
       //with realeaseArb  ok
       .io_rep_ready( releaseArb_io_in_1_ready ),
       .io_rep_valid( prober_io_rep_valid ),
       .io_rep_bits_addr_beat( prober_io_rep_bits_addr_beat ),
       .io_rep_bits_addr_block( prober_io_rep_bits_addr_block ),
       .io_rep_bits_client_xact_id( prober_io_rep_bits_client_xact_id ),
       .io_rep_bits_voluntary( prober_io_rep_bits_voluntary ),
       .io_rep_bits_r_type( prober_io_rep_bits_r_type ),
       .io_rep_bits_data( prober_io_rep_bits_data ),
       
       // with stage1 meta_read  ok
       .io_meta_read_ready( metaReadArb_io_in_2_ready ),
       .io_meta_read_valid( prober_io_meta_read_valid ),
       .io_meta_read_bits_idx( prober_io_meta_read_bits_idx ),
       .io_meta_read_bits_tag( prober_io_meta_read_bits_tag ),
       
       //with stage4 meta_write  ok
       .io_meta_write_ready( metaWriteArb_io_in_1_ready ),
       .io_meta_write_valid( prober_io_meta_write_valid ),
       .io_meta_write_bits_idx( prober_io_meta_write_bits_idx ),//both stage2 and stage4
       .io_meta_write_bits_way_en( prober_io_meta_write_bits_way_en ),
       .io_meta_write_bits_data_tag( prober_io_meta_write_bits_data_tag ),
       .io_meta_write_bits_data_coh_state( prober_io_meta_write_bits_data_coh_state ),
       
       //with wbArb   ok
       .io_wb_req_ready( wbArb_io_in_0_ready ),
       .io_wb_req_valid( prober_io_wb_req_valid ),
       .io_wb_req_bits_addr_beat( prober_io_wb_req_bits_addr_beat ),
       .io_wb_req_bits_addr_block( prober_io_wb_req_bits_addr_block ),
       .io_wb_req_bits_client_xact_id( prober_io_wb_req_bits_client_xact_id ),
       .io_wb_req_bits_voluntary( prober_io_wb_req_bits_voluntary ),
       .io_wb_req_bits_r_type( prober_io_wb_req_bits_r_type ),
       .io_wb_req_bits_data( prober_io_wb_req_bits_data ),
       .io_wb_req_bits_way_en( prober_io_wb_req_bits_way_en ),
       
       //with stage3  ok
       .io_way_en( prober_way_en ),
       .io_block_state_state( prober_block_state ),
       
       //with mshr  ok
       .io_mshr_rdy( mshrs_io_probe_rdy )
  );




//wbArb instantation
/* 2 input
**   1:mshr wb req
**   0:probe wb req
*/
mprcArbiter_4 wbArb(
  //with mshrs   ok
  .io_in_1_ready( wbArb_io_in_1_ready ),
  .io_in_1_valid( mshrs_io_wb_req_valid ),
  .io_in_1_bits_addr_beat( mshrs_io_wb_req_bits_addr_beat ),
  .io_in_1_bits_addr_block( mshrs_io_wb_req_bits_addr_block ),
  .io_in_1_bits_client_xact_id( mshrs_io_wb_req_bits_client_xact_id ),
  .io_in_1_bits_voluntary( mshrs_io_wb_req_bits_voluntary ),
  .io_in_1_bits_r_type( mshrs_io_wb_req_bits_r_type ),
  .io_in_1_bits_data( mshrs_io_wb_req_bits_data ),
  .io_in_1_bits_way_en( mshrs_io_wb_req_bits_way_en ),
  
  
  //with prober   ok
  .io_in_0_ready( wbArb_io_in_0_ready ),
  .io_in_0_valid( prober_io_wb_req_valid ),
  .io_in_0_bits_addr_beat( prober_io_wb_req_bits_addr_beat ),
  .io_in_0_bits_addr_block( prober_io_wb_req_bits_addr_block ),
  .io_in_0_bits_client_xact_id( prober_io_wb_req_bits_client_xact_id ),
  .io_in_0_bits_voluntary( prober_io_wb_req_bits_voluntary ),
  .io_in_0_bits_r_type( prober_io_wb_req_bits_r_type ),
  .io_in_0_bits_data( prober_io_wb_req_bits_data ),
  .io_in_0_bits_way_en( prober_io_wb_req_bits_way_en ),
  
  
  //with wb       ok
  .io_out_ready( wb_io_req_ready ),
  .io_out_valid( wbArb_io_out_valid ),
  .io_out_bits_addr_beat( wbArb_io_out_bits_addr_beat ),
  .io_out_bits_addr_block( wbArb_io_out_bits_addr_block ),
  .io_out_bits_client_xact_id( wbArb_io_out_bits_client_xact_id ),
  .io_out_bits_voluntary( wbArb_io_out_bits_voluntary ),
  .io_out_bits_r_type( wbArb_io_out_bits_r_type ),
  .io_out_bits_data( wbArb_io_out_bits_data ),
  .io_out_bits_way_en( wbArb_io_out_bits_way_en )
  );  
 




//wb instantation
mprcWritebackUnit wb(.clk(clk), .reset(reset),
// with wbArb    ok
  .io_req_ready( wb_io_req_ready ),
  .io_req_valid( wbArb_io_out_valid ),
  .io_req_bits_addr_beat( wbArb_io_out_bits_addr_beat ),
  .io_req_bits_addr_block( wbArb_io_out_bits_addr_block ),
  .io_req_bits_client_xact_id( wbArb_io_out_bits_client_xact_id ),
  .io_req_bits_voluntary( wbArb_io_out_bits_voluntary ),
  .io_req_bits_r_type( wbArb_io_out_bits_r_type ),
  .io_req_bits_data( wbArb_io_out_bits_data ),
  .io_req_bits_way_en( wbArb_io_out_bits_way_en ),
  
  //with stage1  meta_read   ok
  .io_meta_read_ready( metaReadArb_io_in_3_ready ),
  .io_meta_read_valid( wb_io_meta_read_valid ),
  .io_meta_read_bits_idx( wb_io_meta_read_bits_idx ),
  .io_meta_read_bits_tag( wb_io_meta_read_bits_tag ),
  
  //with stage1 data_read  ok
  .io_data_req_ready( readArb_io_in_2_ready ),
  .io_data_req_valid( wb_io_data_req_valid ),
  .io_data_req_bits_way_en( wb_io_data_req_bits_way_en ),
  .io_data_req_bits_addr( wb_io_data_req_bits_addr ),
  
  //from stage3  ok
  .io_data_resp( s2_data_corrected ),
    
    
   // to releaseArb ok
  .io_release_ready( releaseArb_io_in_0_ready ),
  .io_release_valid( wb_io_release_valid ),
  .io_release_bits_addr_beat( wb_io_release_bits_addr_beat ),
  .io_release_bits_addr_block( wb_io_release_bits_addr_block ),
  .io_release_bits_client_xact_id( wb_io_release_bits_client_xact_id ),
  .io_release_bits_voluntary( wb_io_release_bits_voluntary ),
  .io_release_bits_r_type( wb_io_release_bits_r_type ),
  .io_release_bits_data( wb_io_release_bits_data )
  
);



  mprcFlowThroughSerializer mprcFlowThroughSerializer(
        //ok
       .io_in_ready( io_mem_grant_ready ),
       .io_in_valid( io_mem_grant_valid ),
       .io_in_bits_addr_beat( io_mem_grant_bits_addr_beat ),
       .io_in_bits_client_xact_id( io_mem_grant_bits_client_xact_id ),
       .io_in_bits_manager_xact_id( io_mem_grant_bits_manager_xact_id ),
       .io_in_bits_is_builtin_type( io_mem_grant_bits_is_builtin_type ),
       .io_in_bits_g_type( io_mem_grant_bits_g_type ),
       .io_in_bits_data( io_mem_grant_bits_data ),
       
       //ok
       .io_out_ready( narrow_grant_ready ),
       .io_out_valid( FlowThroughSerializer_io_out_valid ),
       .io_out_bits_addr_beat( FlowThroughSerializer_io_out_bits_addr_beat ),
       .io_out_bits_client_xact_id( FlowThroughSerializer_io_out_bits_client_xact_id ),
       .io_out_bits_manager_xact_id( FlowThroughSerializer_io_out_bits_manager_xact_id ),
       .io_out_bits_is_builtin_type( FlowThroughSerializer_io_out_bits_is_builtin_type ),
       .io_out_bits_g_type( FlowThroughSerializer_io_out_bits_g_type ),
       .io_out_bits_data( FlowThroughSerializer_io_out_bits_data )
  );




// releaseArb instantation
/* 2 input
**   1:probe
**   0:wb
*/
mprcLockingArbiter_0 releaseArb(.clk(clk), .reset(reset),
    //with prober   ok
    .io_in_1_ready( releaseArb_io_in_1_ready ),
    .io_in_1_valid( prober_io_rep_valid ),
    .io_in_1_bits_addr_beat( prober_io_rep_bits_addr_beat ),
    .io_in_1_bits_addr_block( prober_io_rep_bits_addr_block ),
    .io_in_1_bits_client_xact_id( prober_io_rep_bits_client_xact_id ),
    .io_in_1_bits_voluntary( prober_io_rep_bits_voluntary ),
    .io_in_1_bits_r_type( prober_io_rep_bits_r_type ),
    .io_in_1_bits_data( prober_io_rep_bits_data ),
    
    //with wb  ok
    .io_in_0_ready( releaseArb_io_in_0_ready ),
    .io_in_0_valid( wb_io_release_valid ),
    .io_in_0_bits_addr_beat( wb_io_release_bits_addr_beat ),
    .io_in_0_bits_addr_block( wb_io_release_bits_addr_block ),
    .io_in_0_bits_client_xact_id( wb_io_release_bits_client_xact_id ),
    .io_in_0_bits_voluntary( wb_io_release_bits_voluntary ),
    .io_in_0_bits_r_type( wb_io_release_bits_r_type ),
    .io_in_0_bits_data( wb_io_release_bits_data ),
    
    .io_out_ready( io_mem_release_ready ),
    .io_out_valid( io_mem_release_valid ),
    .io_out_bits_addr_beat( io_mem_release_bits_addr_beat ),
    .io_out_bits_addr_block( io_mem_release_bits_addr_block ),
    .io_out_bits_client_xact_id( io_mem_release_bits_client_xact_id ),
    .io_out_bits_voluntary( io_mem_release_bits_voluntary ),
    .io_out_bits_r_type( io_mem_release_bits_r_type ),
    .io_out_bits_data( io_mem_release_bits_data )
    
 ); 


mprcStage1 stage1(
    //cpu发出的请求信号:
    .clk(clk),
    .reset(reset),
    .init(init),
  //cpu发出的请求信号:
    //ok
    .io_cpu_req_bits_tag(io_cpu_req_bits_tag),
    .io_cpu_req_bits_cmd(io_cpu_req_bits_cmd),
    .io_cpu_req_bits_typ(io_cpu_req_bits_typ),
    .io_cpu_req_bits_kill(io_cpu_req_bits_kill),
    .io_cpu_req_bits_phys(io_cpu_req_bits_phys),
    .io_cpu_req_bits_data(io_cpu_req_bits_data),
    .io_cpu_req_ready(io_cpu_req_ready),
    
    
    //mshr ok
    .mshrs_io_replay_bits_tag(mshrs_io_replay_bits_tag),
    .mshrs_io_replay_bits_cmd(mshrs_io_replay_bits_cmd),
    .mshrs_io_replay_bits_typ(mshrs_io_replay_bits_typ),
    .mshrs_io_replay_bits_kill(mshrs_io_replay_bits_kill),
    .mshrs_io_replay_bits_phys(mshrs_io_replay_bits_phys),
    .mshrs_io_replay_bits_data(mshrs_io_replay_bits_data),
     
    
    
    //s2_req
    .s2_req_addr(s2_req_addr),
    .s2_req_tag(s2_req_tag),
    .s2_req_cmd(s2_req_cmd),
    .s2_req_typ(s2_req_typ),
    .s2_req_kill(s2_req_kill),
    .s2_req_phys(s2_req_phys),
    .s2_req_data(s2_req_data),
    
    
    
    //readmetaArb 
    .metaReadArb_io_in_4_ready(metaReadArb_io_in_4_ready),// will generate io_cpu_req_ready   not ok now

    .io_cpu_req_valid(io_cpu_req_valid),
    .io_cpu_req_bits_addr(io_cpu_req_bits_addr),
      //from wb    ok
    .metaReadArb_io_in_3_ready(metaReadArb_io_in_3_ready),
    .wb_io_meta_read_valid(wb_io_meta_read_valid),
    .wb_io_meta_read_bits_tag(wb_io_meta_read_bits_tag),
    .wb_io_meta_read_bits_idx(wb_io_meta_read_bits_idx),
      // from prober  ok
    .metaReadArb_io_in_2_ready(metaReadArb_io_in_2_ready),
    .prober_io_meta_read_valid(prober_io_meta_read_valid),
    .prober_io_meta_read_bits_tag(prober_io_meta_read_bits_tag),
    .prober_io_meta_read_bits_idx(prober_io_meta_read_bits_idx),
    
        //ok
    .metaReadArb_io_in_1_ready(metaReadArb_io_in_1_ready),
    .mshrs_io_meta_read_valid(mshrs_io_meta_read_valid),
    .mshrs_io_meta_read_bits_idx(mshrs_io_meta_read_bits_idx),
    .mshrs_io_meta_read_bits_way_en(mshrs_io_meta_read_bits_way_en),
    
    // from stage3  ok
    .s2_recycle(s2_recycle),
    

    
    
    //readdataArb
    .readArb_io_in_3_ready(readArb_io_in_3_ready), // will generate io_cpu_req_ready   not ok now
      //from wb ok
    .readArb_io_in_2_ready(readArb_io_in_2_ready),
    .wb_io_data_req_valid(wb_io_data_req_valid),
    .wb_io_data_req_bits_way_en(wb_io_data_req_bits_way_en),
    .wb_io_data_req_bits_addr(wb_io_data_req_bits_addr),
      //from mshr ok
    .readArb_io_in_1_ready(readArb_io_in_1_ready),
    .mshrs_io_replay_valid(mshrs_io_replay_valid),
    .mshrs_io_replay_bits_addr(mshrs_io_replay_bits_addr),
    
    
    //ok
    .narrow_grant_valid(FlowThroughSerializer_io_out_valid),
    .narrow_grant_ready(narrow_grant_ready),

    
    
    //meta write wire
    // from stage4  ok
    .meta_io_write_ready(meta_io_write_ready),
    .metaWriteArb_io_out_valid(meta_io_write_valid),
    .metaWriteArb_io_out_bits_idx(meta_io_write_idx),
    .metaWriteArb_io_out_bits_way_en(meta_io_write_way_en),
    .metaWriteArb_io_out_bits_data_tag(meta_io_write_data_tag),
    .metaWriteArb_io_out_bits_data_coh_state(meta_io_write_data_coh_state),
    
      
    
    //data write wire
    // from stage4  ok
    .data_io_write_ready(data_io_write_ready),
    .writeArb_io_out_valid(data_io_write_valid),
    .writeArb_io_out_bits_way_en(data_io_write_way_en),
    .writeArb_io_out_bits_addr(data_io_write_addr),
    .writeArb_io_out_bits_wmask(data_io_write_wmask),
    .writeArb_io_out_bits_data(data_io_write_data),
    
    
    
    
    //meta output  ok
    .meta_io_resp_3_tag(meta_io_resp_3_tag_1to2),
    .meta_io_resp_2_tag(meta_io_resp_2_tag_1to2),
    .meta_io_resp_1_tag(meta_io_resp_1_tag_1to2),
    .meta_io_resp_0_tag(meta_io_resp_0_tag_1to2),
    .meta_io_resp_3_coh_state(meta_io_resp_3_coh_state_1to2),
    .meta_io_resp_2_coh_state(meta_io_resp_2_coh_state_1to2),
    .meta_io_resp_1_coh_state(meta_io_resp_1_coh_state_1to2),
    .meta_io_resp_0_coh_state(meta_io_resp_0_coh_state_1to2),
    
    
    
    //data output  ok
    .data_io_resp_3(data_io_resp_3_1to2),
    .data_io_resp_2(data_io_resp_2_1to2),
    .data_io_resp_1(data_io_resp_1_1to2),
    .data_io_resp_0(data_io_resp_0_1to2),
    

    //s1/s2 pipeline registers output  ok
    .s1_valid(s1_valid),
    .s1_replay(s1_replay),
    .s1_recycled(s1_recycled),
    .s1_clk_en(s1_clk_en),
    .s1_req_addr(s1_req_addr),
    .s1_req_tag(s1_req_tag),
    .s1_req_cmd(s1_req_cmd),
    .s1_req_typ(s1_req_typ),
    .s1_req_kill(s1_req_kill),
    .s1_req_phys(s1_req_phys),
    .s1_req_data(s1_req_data),
  
    .metaReadArb_io_out_valid(metaReadArb_io_out_valid)
);



mprcStage2 stage2(
    .clk(clk),
    .reset(reset),
    
  //cpu发出的请求信号: ok
    .io_cpu_req_bits_data(io_cpu_req_bits_data),
    .io_cpu_req_bits_kill(io_cpu_req_bits_kill),
    //mshr  ok
    .mshrs_io_replay_bits_data(mshrs_io_replay_bits_data),
     
     
    //to generate s1_nack  ok 
    .prober_io_req_ready(prober_io_req_ready),
    //from prober
    .prober_io_meta_write_bits_idx(prober_io_meta_write_bits_idx), 

 
    //tlb
    .dtlb_io_req_ready(dtlb_io_req_ready),  //to generate io_cpu_req_ready
    .dtlb_io_resp_xcpt_ld(dtlb_io_resp_xcpt_ld),
    .dtlb_io_resp_xcpt_st(dtlb_io_resp_xcpt_st),
    
     //oks
    .io_ptw_req_ready(io_ptw_req_ready),
    .io_ptw_req_valid(io_ptw_req_valid),
    .io_ptw_req_bits_addr(io_ptw_req_bits_addr),
    .io_ptw_req_bits_prv(io_ptw_req_bits_prv),
    .io_ptw_req_bits_store(io_ptw_req_bits_store),
    .io_ptw_req_bits_fetch(io_ptw_req_bits_fetch),
    
    .io_ptw_resp_valid(io_ptw_resp_valid),
    .io_ptw_resp_bits_error(io_ptw_resp_bits_error),
    .io_ptw_resp_bits_pte_ppn(io_ptw_resp_bits_pte_ppn),
    .io_ptw_resp_bits_pte_reserved_for_software(io_ptw_resp_bits_pte_reserved_for_software),
    .io_ptw_resp_bits_pte_d(io_ptw_resp_bits_pte_d),
    .io_ptw_resp_bits_pte_r(io_ptw_resp_bits_pte_r),
    .io_ptw_resp_bits_pte_typ( io_ptw_resp_bits_pte_typ ),
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
    
    //ok
    .s1_read(s1_read),
    .s1_write(s1_write),

    
    
    // from stage3
    .s2_recycle_ecc(s2_recycle_ecc),
    .s2_valid_masked(s2_valid_masked),
    
    .s2_sc_fail(s2_sc_fail),
    .s3_valid(s3_valid),
    .s3_req_addr(s3_req_addr),
    .s3_req_data(s3_req_data),
    .s3_req_cmd(s3_req_cmd),
    .amoalu_out_data(amoalu_out_data),
    
    // from stage4  ok
    .s4_valid(s4_valid),
    .s4_req_addr(s4_req_addr),
    .s4_req_data(s4_req_data),
    .s4_req_cmd(s4_req_cmd),
    
  
    
    
    
    
    // from stage1   ok
	  .meta_io_resp_3_tag_in(meta_io_resp_3_tag_1to2),
	  .meta_io_resp_2_tag_in(meta_io_resp_2_tag_1to2),
	  .meta_io_resp_1_tag_in(meta_io_resp_1_tag_1to2),
	  .meta_io_resp_0_tag_in(meta_io_resp_0_tag_1to2),
	  .meta_io_resp_3_coh_state_in(meta_io_resp_3_coh_state_1to2),
	  .meta_io_resp_2_coh_state_in(meta_io_resp_2_coh_state_1to2),
	  .meta_io_resp_1_coh_state_in(meta_io_resp_1_coh_state_1to2),
   	.meta_io_resp_0_coh_state_in(meta_io_resp_0_coh_state_1to2),
  	 .data_io_resp_3_in(data_io_resp_3_1to2),
  	 .data_io_resp_2_in(data_io_resp_2_1to2),
	  .data_io_resp_1_in(data_io_resp_1_1to2),
	  .data_io_resp_0_in(data_io_resp_0_1to2),
	  .s1_valid(s1_valid),
	  .s1_replay(s1_replay),
	  .s1_recycled(s1_recycled),
	  .s1_clk_en(s1_clk_en),
	  .s1_req_addr(s1_req_addr),
	  .s1_req_tag(s1_req_tag),
	  .s1_req_cmd(s1_req_cmd),
	  .s1_req_typ(s1_req_typ),
	  .s1_req_kill(s1_req_kill),
	  .s1_req_phys(s1_req_phys),
	  .s1_req_data(s1_req_data),
    
    
    
    
    //registers output to stage 3 ok
		.s2_valid(s2_valid),
		.s2_killed(s2_killed),
		.s2_replay(s2_replay),
		.s2_recycle_next(s2_recycle_next),
		.s2_req_addr(s2_req_addr),
		.s2_req_tag(s2_req_tag),
		.s2_req_cmd(s2_req_cmd),
		.s2_req_typ(s2_req_typ),
		.s2_req_kill(s2_req_kill),
		.s2_req_phys(s2_req_phys),
		.s2_req_data(s2_req_data),
		.s2_nack_hit(s2_nack_hit),
		.s2_tag_match_way(s2_tag_match_way),
		.meta_io_resp_3_tag(meta_io_resp_3_tag),
		.meta_io_resp_2_tag(meta_io_resp_2_tag),
		.meta_io_resp_1_tag(meta_io_resp_1_tag),
		.meta_io_resp_0_tag(meta_io_resp_0_tag),
		.meta_io_resp_3_coh_state(meta_io_resp_3_coh_state),
		.meta_io_resp_2_coh_state(meta_io_resp_2_coh_state),
		.meta_io_resp_1_coh_state(meta_io_resp_1_coh_state),
		.meta_io_resp_0_coh_state(meta_io_resp_0_coh_state),
		.data_io_resp_3(data_io_resp_3),
		.data_io_resp_2(data_io_resp_2),
		.data_io_resp_1(data_io_resp_1),
		.data_io_resp_0(data_io_resp_0),
		.s2_replaced_way_en(s2_replaced_way_en),
		.s2_store_bypass_data(s2_store_bypass_data),
		.s2_store_bypass(s2_store_bypass)

);


//ok
mprcStage3 stage3(
  .clk(clk),
  .reset(reset),
  //from stage2  ok
  .s2_nack_hit(s2_nack_hit),
  .s2_valid(s2_valid),
  .s2_replay(s2_replay),
  .s2_killed(s2_killed),
  .s2_recycle_next(s2_recycle_next),
  .s2_req_addr(s2_req_addr),
  .s2_req_cmd(s2_req_cmd),
  .s2_req_typ(s2_req_typ),
  .s2_req_tag(s2_req_tag),
  .s2_req_kill(s2_req_kill),
  .s2_req_phys(s2_req_phys),
  .s2_req_data(s2_req_data),
  .s2_tag_match_way(s2_tag_match_way),
  //.s2_replaced_way_en(s2_replaced_way_en),
  .s2_replaced_way_en(s2_replaced_way_en),
  .meta_io_resp_0_coh(meta_io_resp_0_coh_state),
  .meta_io_resp_0_tag(meta_io_resp_0_tag),
  .meta_io_resp_1_coh(meta_io_resp_1_coh_state),
  .meta_io_resp_1_tag(meta_io_resp_1_tag),
  .meta_io_resp_2_coh(meta_io_resp_2_coh_state),
  .meta_io_resp_2_tag(meta_io_resp_2_tag),
  .meta_io_resp_3_coh(meta_io_resp_3_coh_state),
  .meta_io_resp_3_tag(meta_io_resp_3_tag), 
  .s2_data_0(data_io_resp_0),
  .s2_data_1(data_io_resp_1),
  .s2_data_2(data_io_resp_2),
  .s2_data_3(data_io_resp_3),
  .s2_store_bypass(s2_store_bypass),
  .s2_store_bypass_data(s2_store_bypass_data),
  .io_cpu_resp_bits_data_word_bypass(io_cpu_resp_bits_data_word_bypass),//需要在stage3给出，目前尚未给出
  
  
  .lrsc_valid(lrsc_valid),//stage3模块中尚未引出
  .io_cpu_invalidate_lr(io_cpu_invalidate_lr),//stage3模块中尚未引入
  
  
  //to stage4 ok
  .s3_way(s3_way),
  .s3_valid(s3_valid),
  .s3_req_addr(s3_req_addr),
  .s3_req_cmd(s3_req_cmd),
  .s3_req_typ(s3_req_typ),
  .s3_req_tag(s3_req_tag),
  .s3_req_kill(s3_req_kill),
  .s3_req_phys(s3_req_phys),
  .s3_req_data(s3_req_data),
  
  
  //with mshr
  .mshr_req_ready(mshrs_io_req_ready),
  .mshr_secondary_miss(mshrs_io_secondary_miss),
  .mshr_req_valid(mshrs_io_req_valid),
  .mshr_req_bits_addr(mshrs_io_req_bits_addr),
  .mshr_req_bits_tag(mshrs_io_req_bits_tag),
  .mshr_req_bits_cmd(mshrs_io_req_bits_cmd),
  .mshr_req_bits_typ(mshrs_io_req_bits_typ),
  .mshr_req_bits_kill(mshrs_io_req_bits_kill),
  .mshr_req_bits_phys(mshrs_io_req_bits_phys),
  .mshr_req_bits_data(mshrs_io_req_bits_data),
  .mshr_req_bits_tag_match(mshrs_io_req_bits_tag_match),
  .mshr_req_bits_old_meta_tag(mshrs_io_req_bits_old_meta_tag),
  .mshr_req_bits_old_meta_coh_state(mshrs_io_req_bits_old_meta_coh_state),
  .mshr_req_bits_way_en(mshrs_io_req_bits_way_en),
  
  .cache_resp_valid(cache_resp_valid),
  .cache_resp_bits_addr(cache_resp_bits_addr),
  .cache_resp_bits_tag(cache_resp_bits_tag),
  .cache_resp_bits_cmd(cache_resp_bits_cmd),
  .cache_resp_bits_typ(cache_resp_bits_typ),
  .cache_resp_bits_data(cache_resp_bits_data),
  .cache_resp_bits_nack(cache_resp_bits_nack),
  .cache_resp_bits_replay(cache_resp_bits_replay),
  .cache_resp_bits_has_data(cache_resp_bits_has_data),
  .cache_resp_bits_store_data(cache_resp_bits_store_data),
  
  .prober_way_en(prober_way_en),
  .prober_block_state(prober_block_state),
  
  //to wb  ok
  .decode_corrected_data(s2_data_corrected),
  
  //ok
  .amoalu_out_data(amoalu_out_data),
  .s2_recycle_ecc(s2_recycle_ecc),
  //to stage1  ok
  .s2_recycle(s2_recycle),
  .block_miss(block_miss),
  .cache_pass(cache_pass),
  
  .s2_valid_masked(s2_valid_masked),
  .s2_sc_fail(s2_sc_fail)
);


//缺少writeArb_io_in_1_ready
mprcStage4 stage4(
  .clk(clk),
  .reset(reset),
  
  // from stage3 ok
  .s3_valid(s3_valid),
  .s3_way(s3_way),
  .s3_req_addr(s3_req_addr),
  .s3_req_cmd(s3_req_cmd),
  .s3_req_typ(s3_req_typ),
  .s3_req_tag(s3_req_tag),
  .s3_req_kill(s3_req_kill),
  .s3_req_phys(s3_req_phys),
  .s3_req_data(s3_req_data), 
  
  // from prober meta_write   ok
  .prober_meta_write_ready(metaWriteArb_io_in_1_ready),
	.prober_meta_write_valid(prober_io_meta_write_valid),
  .prober_meta_write_bits_idx(prober_io_meta_write_bits_idx),
  .prober_meta_write_bits_way_en(prober_io_meta_write_bits_way_en),
  .prober_meta_write_bits_data_tag(prober_io_meta_write_bits_data_tag),
  .prober_meta_write_bits_data_coh_state(prober_io_meta_write_bits_data_coh_state),
  
  //from mshr meta_write  ok
  .mshr_meta_write_ready(mshrs_meta_write_ready),
  .mshr_meta_write_valid(mshrs_io_meta_write_valid),
  .mshr_meta_write_bits_idx(mshrs_io_meta_write_bits_idx),
  .mshr_meta_write_bits_way_en(mshrs_io_meta_write_bits_way_en),
  .mshr_meta_write_bits_data_tag(mshrs_io_meta_write_bits_data_tag),
  .mshr_meta_write_bits_data_coh_state(mshrs_io_meta_write_bits_data_coh_state),
  
  //from mshr refill  ok
  .mshr_refill_way_en(mshrs_refill_way_en),
  .mshr_refill_addr(mshrs_refill_addr),
  
  
  /*
  output  io_mem_grant_ready,
  input  io_mem_grant_valid,
  input [1:0] io_mem_grant_bits_client_xact_id,
  input  io_mem_grant_bits_is_builtin_type,
  input [3:0] io_mem_grant_bits_g_type,
  input [127:0] io_mem_grant_bits_data,
  */
  .FlowThroughSerializer_io_out_ready(FlowThroughSerializer_io_out_ready),
  .FlowThroughSerializer_io_out_valid(FlowThroughSerializer_io_out_valid),
  .FlowThroughSerializer_io_out_bits_client_xact_id(FlowThroughSerializer_io_out_bits_client_xact_id),
  .FlowThroughSerializer_io_out_bits_is_builtin_type(FlowThroughSerializer_io_out_bits_is_builtin_type),
  .FlowThroughSerializer_io_out_bits_g_type(FlowThroughSerializer_io_out_bits_g_type),
  .FlowThroughSerializer_io_out_bits_data(FlowThroughSerializer_io_out_bits_data),
  
  
  
  
  //to stage2 ok
  .s4_valid(s4_valid),
  .s4_req_addr(s4_req_addr),
  .s4_req_cmd(s4_req_cmd),
  .s4_req_data(s4_req_data), 
  //不需要下面的
  //output reg [2:0] s4_req_typ,
  //output reg [8:0] s4_req_tag,
  //output reg s4_req_kill,
  //output reg s4_req_phys,
  
  
  
  // to stage1 ok
  .meta_io_write_ready(meta_io_write_ready),
  .meta_io_write_valid(meta_io_write_valid),
  .meta_io_write_idx(meta_io_write_idx),
  .meta_io_write_way_en(meta_io_write_way_en),
  .meta_io_write_data_tag(meta_io_write_data_tag),
  .meta_io_write_data_coh_state(meta_io_write_data_coh_state),
  // to stage1 ok
  .data_io_write_ready(data_io_write_ready),
  .data_io_write_valid(data_io_write_valid),
  .data_io_write_way_en(data_io_write_way_en),
  .data_io_write_addr(data_io_write_addr),
  .data_io_write_wmask(data_io_write_wmask),
  .data_io_write_data(data_io_write_data),
  
  .metaReadArb_io_out_valid(metaReadArb_io_out_valid)
);


endmodule