`include "../util/common.vh"     

module mprcMSHR(
    input clk, 
    input reset,

    input  io_req_pri_val,
    output io_req_pri_rdy,
    input  io_req_sec_val,
    output io_req_sec_rdy,

    input [39:0] io_req_bits_addr,
    input [8:0] io_req_bits_tag,
    input [4:0] io_req_bits_cmd,
    input [2:0] io_req_bits_typ,
    input  io_req_bits_kill,
    input  io_req_bits_phys,
    input [4:0] io_req_bits_sdq_id,
    input  io_req_bits_tag_match,
    input [19:0] io_req_bits_old_meta_tag,
    input [1:0] io_req_bits_old_meta_coh_state,
    input [3:0] io_req_bits_way_en,

    output io_idx_match,
    output[19:0] io_tag,
 
    input  io_mem_req_ready,
    output io_mem_req_valid,
    output[25:0] io_mem_req_bits_addr_block,
    output[1:0] io_mem_req_bits_client_xact_id,
    output[1:0] io_mem_req_bits_addr_beat,
    output io_mem_req_bits_is_builtin_type,
    output[2:0] io_mem_req_bits_a_type,
    output[16:0] io_mem_req_bits_union,
    output[127:0] io_mem_req_bits_data,

    output[3:0] io_refill_way_en,
    output[11:0] io_refill_addr,

    input  io_meta_read_ready,
    output io_meta_read_valid,
    output[5:0] io_meta_read_bits_idx,
    output[19:0] io_meta_read_bits_tag,

    input  io_meta_write_ready,
    output io_meta_write_valid,
    output[5:0] io_meta_write_bits_idx,
    output[3:0] io_meta_write_bits_way_en,
    output[19:0] io_meta_write_bits_data_tag,
    output[1:0] io_meta_write_bits_data_coh_state,

    input  io_replay_ready,
    output io_replay_valid,
    output[39:0] io_replay_bits_addr,
    output[8:0] io_replay_bits_tag,
    output[4:0] io_replay_bits_cmd,
    output[2:0] io_replay_bits_typ,
    output io_replay_bits_kill,
    output io_replay_bits_phys,
    output[4:0] io_replay_bits_sdq_id,

    input  io_mem_grant_valid,
    input [1:0] io_mem_grant_bits_addr_beat,
    input [1:0] io_mem_grant_bits_client_xact_id,
    input [3:0] io_mem_grant_bits_manager_xact_id,
    input  io_mem_grant_bits_is_builtin_type,
    input [3:0] io_mem_grant_bits_g_type,
    input [127:0] io_mem_grant_bits_data,

    input  io_wb_req_ready,
    output io_wb_req_valid,
    output[1:0] io_wb_req_bits_addr_beat,
    output[25:0] io_wb_req_bits_addr_block,
    output[1:0] io_wb_req_bits_client_xact_id,
    output io_wb_req_bits_voluntary,
    output[2:0] io_wb_req_bits_r_type,
    output[127:0] io_wb_req_bits_data,
    output[3:0] io_wb_req_bits_way_en,

    output io_probe_rdy,
    
    
    
    input io_mem_release_valid,
    input[1:0] io_mem_release_bits_addr_beat
);

    parameter client_xact_id = 2'h0;
    parameter refillCycles = 2'h4;

    reg [39:0] req_addr;
    reg [8:0] req_tag;
    reg [4:0] req_cmd;
    reg [2:0] req_typ;
    reg req_kill;
    reg req_phys;
    reg [4:0] req_sdq_id;
    reg req_tag_match;
    reg [19:0] req_old_meta_tag;
    reg [1:0] req_old_meta_coh_state;
    reg [3:0] req_way_en;

    reg [1:0] meta_hazard;

    wire [5:0]  req_idx;

    wire gnt_multi_data;
    wire [1:0] refill_cnt;
    wire refill_count_done;

    wire rpq_enq_valid;
    wire rpq_enq_ready;
    wire rpq_deq_valid;
    wire rpq_deq_ready;
    wire s_rpq_deq_ready;
    wire sec_rdy;

    wire idx_match;
    wire cmd_requires_second_acquire;
    wire coh_isHit;
    wire coh_require_wb;
    wire wb_req_fire;
    wire wb_req_requireAck;
    wire mem_req_fire;
    wire refill_done;
    wire [1:0] new_coh_state;

    wire T1;
    wire T2;
    wire [1:0] T3;
    wire [1:0] T4;
    wire [1:0] T5;
    wire [1:0] T6;
    wire T7;
    wire T8;
    wire T9;
    wire req_received;
    wire isnt_Prefetch;
    wire io_req_cmd_isWriteIntent;
    wire req_cmd_isWriteIntent;
    wire allow_read_states;
    wire allow_write_states;

    wire [63:0] replay_bits;
    wire [3:0] state;
    
    wire [1:0] coh_on_grant;
    wire [1:0] coh_on_hit;
    
	
	
	wire[39:0] rpq_io_deq_bits_addr;
    wire[8:0] rpq_io_deq_bits_tag;
    wire[4:0] rpq_io_deq_bits_cmd;
    wire[2:0] rpq_io_deq_bits_typ;
    wire rpq_io_deq_bits_kill;
    wire rpq_io_deq_bits_phys;
    wire[4:0] rpq_io_deq_bits_sdq_id;
    

    assign req_idx          = req_addr[4'hb:3'h6];

    assign gnt_multi_data   = io_mem_grant_bits_is_builtin_type ? T2 : T1;
    assign T1               = (4'h0 == io_mem_grant_bits_g_type) | (4'h1 == io_mem_grant_bits_g_type);
    assign T2               = 4'h5 == io_mem_grant_bits_g_type;   

    assign rpq_enq_valid    = req_received & isnt_Prefetch;
    assign req_received     = (io_req_pri_val & io_req_pri_rdy) | (io_req_sec_val & sec_rdy);
    assign isnt_Prefetch    = (io_req_bits_cmd == `M_PFR | io_req_bits_cmd == `M_PFW) ^ 'h1;

    assign rpq_deq_ready    = (io_meta_read_ready ^ 1'h1) ? 1'h0 : s_rpq_deq_ready;

    assign idx_match        = io_req_bits_addr[4'hb:3'h6] == req_idx;

    assign cmd_requires_second_acquire  = io_req_cmd_isWriteIntent & !req_cmd_isWriteIntent;
    assign io_req_cmd_isWriteIntent     = (
                                            io_req_bits_cmd == `M_XWR || 
                                            io_req_bits_cmd == `M_XSC ||  
                                            io_req_bits_cmd[3] == 1'b1 || 
                                            io_req_bits_cmd == `M_XA_SWAP || 
                                            io_req_bits_cmd == `M_PFW || 
                                            io_req_bits_cmd == `M_XLR);
    assign req_cmd_isWriteIntent        = (
                                            req_cmd == `M_XWR || 
                                            req_cmd == `M_XSC ||  
                                            req_cmd[3] == 1'b1 || 
                                            req_cmd == `M_XA_SWAP || 
                                            req_cmd == `M_PFW || 
                                            req_cmd == `M_XLR);
                    
    assign coh_isHit            = io_req_cmd_isWriteIntent ? allow_write_states : allow_read_states;
    assign allow_read_states    = 
                                  (`clientExclusiveDirty == io_req_bits_old_meta_coh_state) |
                                  (`clientExclusiveClean == io_req_bits_old_meta_coh_state) |
                                  (`clientShared == io_req_bits_old_meta_coh_state);
    assign allow_write_states   = 
                                  (`clientExclusiveDirty == io_req_bits_old_meta_coh_state) |
                                  (`clientExclusiveClean == io_req_bits_old_meta_coh_state);

    assign coh_require_wb       = io_req_bits_old_meta_coh_state == `clientExclusiveDirty;
    assign wb_req_fire          = io_wb_req_ready & io_wb_req_valid;
    assign wb_req_requireAck    = 1'b1;
    assign mem_req_fire         = io_mem_req_valid & io_mem_req_ready;
    assign refill_done          = io_mem_grant_valid & (!gnt_multi_data | refill_count_done);

    assign coh_on_grant         = io_mem_grant_bits_is_builtin_type ? 2'h0 : T3;
    assign T3                   = (io_mem_grant_bits_g_type == 4'h0) ? 2'h1 : T4;
    assign T4                   = (io_mem_grant_bits_g_type == 4'h1) ? T6 : T5;
    assign T5                   = (io_mem_grant_bits_g_type == 4'h2) ? 2'h3 : 2'h0;
    assign T6                   = T7 ? 2'h3 : 2'h2;
    assign T7                   = 
                                  (req_cmd == `M_XA_SWAP) | 
                                  (req_cmd[2'h3]) | 
                                  (req_cmd == `M_XSC) | 
                                  (req_cmd == `M_XWR);

    assign coh_on_hit           = T8 ? 2'h3 : io_req_bits_old_meta_coh_state;
    assign T8                   = 
                                  (io_req_bits_cmd == 5'h4) |
                                  (io_req_bits_cmd[2'h3]) |
                                  (io_req_bits_cmd == 5'h7) |
                                  (io_req_bits_cmd == 5'h1);

    assign io_refill_way_en     = req_way_en;
    assign io_refill_addr       = {req_idx, refill_cnt} << 3'h4;

    assign io_tag               = req_addr[5'h1f:4'hc];
    assign io_req_sec_rdy       = sec_rdy & rpq_enq_ready;

    assign io_meta_write_bits_idx            = req_idx;
    assign io_meta_write_bits_way_en         = req_way_en;
    assign io_meta_write_bits_data_tag       = io_tag;
    assign io_meta_write_bits_data_coh_state = new_coh_state;

    assign io_wb_req_bits_way_en             = req_way_en;
    assign io_wb_req_bits_addr_beat          = 2'h0;
    assign io_wb_req_bits_addr_block         = {req_old_meta_tag, req_idx};
    assign io_wb_req_bits_client_xact_id     = client_xact_id;
    assign io_wb_req_bits_voluntary          = 1'h1;
    assign io_wb_req_bits_r_type             = (2'h3 == req_old_meta_coh_state) ? 3'h0 : 3'h3;
    assign io_wb_req_bits_data               = 128'h0;

    assign io_mem_req_bits_addr_block        = {io_tag, req_idx};
    assign io_mem_req_bits_client_xact_id    = client_xact_id;
    assign io_mem_req_bits_addr_beat         = 2'h0;
    assign io_mem_req_bits_is_builtin_type   = 1'h0;
    assign io_mem_req_bits_a_type            = {2'h0, req_cmd_isWriteIntent};
    assign io_mem_req_bits_union             = {11'h0, req_cmd, 1'h1};
    assign io_mem_req_bits_data              = 128'h0;

    assign io_meta_read_bits_idx             = req_idx;
    assign io_meta_read_bits_tag             = io_tag;

    assign io_replay_bits_addr               = rpq_io_deq_bits_addr;
    assign io_replay_bits_tag                = rpq_io_deq_bits_tag;
    assign io_replay_bits_cmd                = (io_meta_read_ready ^ 1'h1) ? 5'h5 : rpq_io_deq_bits_cmd;
    assign io_replay_bits_typ                = rpq_io_deq_bits_typ;
    assign io_replay_bits_kill               = rpq_io_deq_bits_kill;
    assign io_replay_bits_phys               = 1'h1;
    assign io_replay_bits_sdq_id             = rpq_io_deq_bits_sdq_id;
	
    assign io_secondary_miss                 = idx_match;

    assign io_probe_rdy                      = (idx_match ^ 1'h1) | (T9 & (meta_hazard == 2'h0));
    assign T9                                = ((4'h3 == state) | (4'h2 == state) | (4'h1 == state)) ^ 1'h1;

    mprccounter #(.depth(2)) cnt(
        clk, 
        reset,
        io_mem_grant_valid & gnt_multi_data,
        refillCycles,
        refill_cnt,
        refill_count_done
    );

    mprcQueue rpq(  
	   .clk(clk), 
	   .reset(reset),
       .io_enq_ready( rpq_enq_ready ),
       .io_enq_valid( rpq_enq_valid ),
       .io_enq_bits_addr( io_req_bits_addr ),
       .io_enq_bits_tag( io_req_bits_tag ),
       .io_enq_bits_cmd( io_req_bits_cmd ),
       .io_enq_bits_typ( io_req_bits_typ ),
       .io_enq_bits_kill( io_req_bits_kill ),
       .io_enq_bits_phys( io_req_bits_phys ),
       .io_enq_bits_sdq_id( io_req_bits_sdq_id ),
       .io_deq_ready( rpq_deq_ready ),
       .io_deq_valid( rpq_deq_valid),
       .io_deq_bits_addr( rpq_io_deq_bits_addr ),
       .io_deq_bits_tag( rpq_io_deq_bits_tag ),
       .io_deq_bits_cmd( rpq_io_deq_bits_cmd ),
       .io_deq_bits_typ( rpq_io_deq_bits_typ ),
       .io_deq_bits_kill( rpq_io_deq_bits_kill ),
       .io_deq_bits_phys( rpq_io_deq_bits_phys ),
       .io_deq_bits_sdq_id( rpq_io_deq_bits_sdq_id )
    );

    mprcMSHR_State state1(  
        clk, 
        reset,

        io_req_pri_val,
        io_req_bits_tag_match,        
        io_mem_grant_valid,
        io_meta_write_ready,
        io_replay_ready,
        idx_match,
        cmd_requires_second_acquire,
        coh_isHit,
        coh_require_wb,
        wb_req_fire,
        wb_req_requireAck,
        mem_req_fire,
        rpq_deq_valid,
        refill_done,
        coh_on_grant,
        coh_on_hit,

        io_wb_req_valid,
        io_meta_write_valid,
        io_mem_req_valid,
        io_meta_read_valid,
        io_replay_valid,
        io_idx_match,
        io_req_pri_rdy,
        s_rpq_deq_ready,
        new_coh_state,
        sec_rdy, 
        state,
        
        io_mem_release_valid,
        io_mem_release_bits_addr_beat
    );

always @(posedge clk)
begin
    if (reset)
    begin
        req_addr <= 40'h0;
        req_tag  <= 9'h0;
        req_cmd  <= 5'h0;
        req_typ  <= 3'h0;
        req_kill <= 1'h0;
        req_phys <= 1'h0;
        req_sdq_id <= 5'h0;
        req_tag_match <= 1'h0;
        req_old_meta_tag <= 20'h0;
        req_old_meta_coh_state <= 2'h0;
        req_way_en <= 4'h0;
    end
    else if (io_req_pri_val && io_req_pri_rdy)
    begin
        req_addr <= io_req_bits_addr;
        req_tag  <= io_req_bits_tag;
        req_cmd  <= io_req_bits_cmd;
        req_typ  <= io_req_bits_typ;
        req_kill <= io_req_bits_kill;
        req_phys <= io_req_bits_phys;
        req_sdq_id <= io_req_bits_sdq_id;
        req_tag_match <= io_req_bits_tag_match;
        req_old_meta_tag <= io_req_bits_old_meta_tag;
        req_old_meta_coh_state <= io_req_bits_old_meta_coh_state;
        req_way_en <= io_req_bits_way_en;
    end    
    else if (io_req_sec_val && io_req_sec_rdy && cmd_requires_second_acquire)
        req_cmd = io_req_bits_cmd;
    else
        req_cmd = req_cmd;

    if(reset) begin
      meta_hazard <= 2'h0;
    end else if(io_meta_write_ready & io_meta_write_valid) begin
      meta_hazard <= 2'h1;
    end else if(meta_hazard != 2'h0) begin
      meta_hazard <= meta_hazard + 2'h1;
    end

end
endmodule