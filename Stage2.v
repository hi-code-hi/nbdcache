module mprcStage2(input clk, input reset,
    //cpu发出的请求信号:
    input [63:0] io_cpu_req_bits_data,
    input io_cpu_req_bits_kill,
    //mshr 
    input[63:0] mshrs_io_replay_bits_data,
     
     
    //to generate s1_nack 
    input prober_io_req_ready,
    input[5:0] prober_io_meta_write_bits_idx, 

 
    //tlb
    output dtlb_io_req_ready,
    output dtlb_io_resp_xcpt_ld,
    output dtlb_io_resp_xcpt_st,
    
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
    
  
    //meta tag and state input
    input[19:0] meta_io_resp_3_tag_in,
    input[19:0] meta_io_resp_2_tag_in,
    input[19:0] meta_io_resp_1_tag_in,
    input[19:0] meta_io_resp_0_tag_in,
    input[1:0] meta_io_resp_3_coh_state_in,
    input[1:0] meta_io_resp_2_coh_state_in,
    input[1:0] meta_io_resp_1_coh_state_in,
    input[1:0] meta_io_resp_0_coh_state_in,
    
    
    
    //data output
    input[127:0] data_io_resp_3_in,
    input[127:0] data_io_resp_2_in,
    input[127:0] data_io_resp_1_in,
    input[127:0] data_io_resp_0_in,
    

    // s1/s2 pipeline registers input
    input s1_valid,
    input s1_replay,
    input s1_recycled,
    input s1_clk_en,
    input [39:0] s1_req_addr,
    input [8:0] s1_req_tag,
    input [4:0] s1_req_cmd,
    input [2:0] s1_req_typ,
    input s1_req_kill,
    input s1_req_phys,
    input [63:0] s1_req_data,
  
  
      
    
    
    //stage3 stage4
    input s2_recycle_ecc,
    input s2_valid_masked,
    input s2_sc_fail,
    input s3_valid,
    input[39:0] s3_req_addr,
    input[63:0] s3_req_data,
    input[4:0] s3_req_cmd,
    
    input s4_valid,
    input[39:0] s4_req_addr,
    input[63:0] s4_req_data,
    input[4:0] s4_req_cmd,
    input[63:0] amoalu_out_data,
  
    
    
  
    output s1_read,
    output s1_write,
    
    
    //registers output
    output reg s2_valid,
    output reg s2_killed,
    output reg s2_replay,

    output reg s2_recycle_next,
    output reg[39:0] s2_req_addr,
		output reg[8:0] s2_req_tag,
		output reg[4:0] s2_req_cmd,
		output reg[2:0] s2_req_typ,
		output reg s2_req_kill,
		output reg s2_req_phys,
		output reg[63:0] s2_req_data,
		output reg s2_nack_hit,
		output reg[3:0] s2_tag_match_way,
		output reg[19:0] meta_io_resp_3_tag,
		output reg[19:0] meta_io_resp_2_tag,
		output reg[19:0] meta_io_resp_1_tag,
		output reg[19:0] meta_io_resp_0_tag,
		output reg[1:0] meta_io_resp_3_coh_state,
		output reg[1:0] meta_io_resp_2_coh_state,
		output reg[1:0] meta_io_resp_1_coh_state,
		output reg[1:0] meta_io_resp_0_coh_state,
		output reg[127:0] data_io_resp_3,
		output reg[127:0] data_io_resp_2,
		output reg[127:0] data_io_resp_1,
		output reg[127:0] data_io_resp_0,
		output reg[3:0] s2_replaced_way_en,
		output reg[63:0] s2_store_bypass_data,
		output reg s2_store_bypass

);


wire dtlb_req_valid_in;
wire [27:0] dtlb_req_vpn;
wire dtlb_io_resp_miss;
wire[19:0] dtlb_io_resp_ppn;


wire s1_valid_masked;
wire s1_readwrite;
wire s1_nack;
wire[31:0] s1_addr;
wire s2_req_addr_match;
wire s2_req_iswrite;
wire s3_req_addr_match;
wire s3_req_iswrite;
wire s4_req_addr_match;
wire s4_req_iswrite;
wire[3:0] s2_tag_match_way_t;
wire[3:0] s2_replaced_way_en_t;





assign dtlb_req_vpn = s1_req_addr >> 12;
assign s1_valid_masked = s1_valid & (io_cpu_req_bits_kill ^ 1'h1);
assign s1_readwrite = (s1_req_cmd == 5'h3) | (s1_req_cmd ==5'h2) | s1_read | s1_write;
assign s1_read = (s1_req_cmd == 5'h0) | (s1_req_cmd == 5'h4) | (s1_req_cmd == 5'h6) | (s1_req_cmd == 5'h7) | s1_req_cmd[3];
assign s1_write = (s1_req_cmd == 5'h1) | (s1_req_cmd == 5'h4) | (s1_req_cmd == 5'h7) | s1_req_cmd[3];
assign s1_nack = (~s1_req_phys & s1_valid_masked & s1_readwrite & dtlb_io_resp_miss) |
 ((s1_req_addr[4'hb:3'h6]===prober_io_meta_write_bits_idx) & (~prober_io_req_ready));//????
assign s1_addr = {dtlb_io_resp_ppn, s1_req_addr[4'hb:1'h0]};

assign s2_req_addr_match = s2_req_addr>>3 == {8'h0,s1_addr}>>3;
assign s2_req_iswrite = (s2_req_cmd == 5'h1) | (s2_req_cmd == 5'h4) | (s2_req_cmd == 5'h7) | s2_req_cmd[3];
assign s3_req_addr_match = s3_req_addr>>3 == {8'h0,s1_addr}>>3;
assign s3_req_iswrite = (s3_req_cmd == 5'h1) | (s3_req_cmd == 5'h4) | (s3_req_cmd == 5'h7) | s3_req_cmd[3];
assign s4_req_addr_match = s4_req_addr>>3 == {8'h0,s1_addr}>>3;
assign s4_req_iswrite = (s4_req_cmd == 5'h1) | (s4_req_cmd == 5'h4) | (s4_req_cmd == 5'h7) | s4_req_cmd[3];
assign dtlb_req_valid_in =  (s1_req_phys ^ 1'h1) & s1_valid_masked & s1_readwrite;
assign s2_tag_match_way_t[0] = (dtlb_io_resp_ppn == meta_io_resp_0_tag_in) & (meta_io_resp_0_coh_state_in != 2'h0);
assign s2_tag_match_way_t[1] = (dtlb_io_resp_ppn == meta_io_resp_1_tag_in) & (meta_io_resp_1_coh_state_in != 2'h0);
assign s2_tag_match_way_t[2] = (dtlb_io_resp_ppn == meta_io_resp_2_tag_in) & (meta_io_resp_2_coh_state_in != 2'h0);
assign s2_tag_match_way_t[3] = (dtlb_io_resp_ppn == meta_io_resp_3_tag_in) & (meta_io_resp_3_coh_state_in != 2'h0);


//TLB instantiation
TLB dtlb(
    .clk(clk), 
    .reset(reset),
    .io_req_ready(dtlb_io_req_ready),
    .io_req_valid(dtlb_req_valid_in),
    .io_req_bits_asid(7'h0),
    .io_req_bits_vpn(dtlb_req_vpn),
    .io_req_bits_passthrough(s1_req_phys),
    .io_req_bits_instruction(1'h0),
    .io_req_bits_store(s1_write),
    
    .io_resp_miss(dtlb_io_resp_miss),
    .io_resp_ppn(dtlb_io_resp_ppn),
    .io_resp_xcpt_ld(dtlb_io_resp_xcpt_ld),
    .io_resp_xcpt_st( dtlb_io_resp_xcpt_st ),
    //.io_resp_xcpt_if,
    //.io_resp_hit_idx,
    
  
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
    .io_ptw_invalidate(io_ptw_invalidate)
);

mprcPLRU replacer(
  .clk(clk),
  .reset(reset),
  .set(s1_req_addr[11:6]),
  .valid(s1_clk_en),
  .hit(s2_tag_match_way_t[0] | s2_tag_match_way_t[1] | s2_tag_match_way_t[2] | s2_tag_match_way_t[3]),
  .way_in(s2_tag_match_way_t),
  
  .way_out(s2_replaced_way_en_t)
);

always @(posedge clk)
begin
 // s2/s3 pipeline registers
  if(reset) begin
    s2_valid <= 1'h0;
  end else begin
    s2_valid <= s1_valid_masked; 
  end
  if(reset)begin
    s2_killed <= 1'h0;
  end else begin
    s2_killed <= s1_valid & io_cpu_req_bits_kill;
  end
  
  if(reset)begin
    s2_replay <= 1'h0;
  end else begin
    s2_replay <= s1_replay & (s1_req_cmd != 5'h5);
  end
  
  if(reset) begin
    s2_recycle_next <= 1'h0;
  end else if(s1_valid | s1_replay) begin
    s2_recycle_next <= s2_recycle_ecc;
  end
  
  if(reset)begin
    s2_req_addr <= 40'h0;
  end  else
  if(s1_clk_en) begin
      s2_req_addr <= {8'h0,{dtlb_io_resp_ppn, s1_req_addr[4'hb:1'h0]}};
  end
  
  if(reset)begin
    s2_req_tag <= 9'h0;
  end  else
  if(s1_clk_en) begin
    s2_req_tag <= s1_req_tag;
  end
  
  if(reset)begin
    s2_req_cmd <= 5'h0;
  end  else
  if(s1_clk_en) begin
    s2_req_cmd <= s1_req_cmd;
  end
  
  if(reset)begin
    s2_req_typ <= 3'h0;
  end  else
  if(s1_clk_en) begin
    s2_req_typ <= s1_req_typ;
  end
  
  
  if(reset)begin
    s2_req_kill <= 1'h0;
  end  else
  if(s1_clk_en) begin
    s2_req_kill <= s1_req_kill;
  end
  
  if(reset)begin
    s2_req_phys <= 1'h1;
  end  else
  if(s1_clk_en) begin
    s2_req_phys <= s1_req_phys;
  end
  
  if(reset)begin
    s2_req_data <= 64'h0;
  end  else
  if(s1_clk_en & s1_recycled) begin
    s2_req_data <= s1_req_data;
  end else if(s1_clk_en & s1_write) begin
    s2_req_data <= s1_replay ? mshrs_io_replay_bits_data : io_cpu_req_bits_data;
  end
  
  if(reset)begin
    s2_nack_hit <= 1'h0;
  end  else
  if(s1_valid | s1_replay) begin
    s2_nack_hit <= s1_nack;
  end
  
  if(reset)begin
    s2_tag_match_way <= 4'h0;
    s2_replaced_way_en <= 4'h0;
  
    meta_io_resp_3_tag <= 20'h0;
    meta_io_resp_2_tag <= 20'h0;
    meta_io_resp_1_tag <= 20'h0;
    meta_io_resp_0_tag <= 20'h0;
    meta_io_resp_3_coh_state <= 2'h0;
    meta_io_resp_2_coh_state <= 2'h0;
    meta_io_resp_1_coh_state <= 2'h0;
    meta_io_resp_0_coh_state <= 2'h0;
  
    data_io_resp_3 <= 128'h0;
    data_io_resp_2 <= 128'h0;
    data_io_resp_1 <= 128'h0;
    data_io_resp_0 <= 128'h0;
  end else begin
    s2_tag_match_way <= s2_tag_match_way_t;
    s2_replaced_way_en <= s2_replaced_way_en_t;
  
    meta_io_resp_3_tag <= meta_io_resp_3_tag_in;
    meta_io_resp_2_tag <= meta_io_resp_2_tag_in;
    meta_io_resp_1_tag <= meta_io_resp_1_tag_in;
    meta_io_resp_0_tag <= meta_io_resp_0_tag_in;
    meta_io_resp_3_coh_state <= meta_io_resp_3_coh_state_in;
    meta_io_resp_2_coh_state <= meta_io_resp_2_coh_state_in;
    meta_io_resp_1_coh_state <= meta_io_resp_1_coh_state_in;
    meta_io_resp_0_coh_state <= meta_io_resp_0_coh_state_in;
  
    data_io_resp_3 <= data_io_resp_3_in;
    data_io_resp_2 <= data_io_resp_2_in;
    data_io_resp_1 <= data_io_resp_1_in;
    data_io_resp_0 <= data_io_resp_0_in;
  end
  
  if(reset)begin
    s2_store_bypass_data <= 64'h0;
  end else
  if(s1_clk_en & s2_req_iswrite & s2_req_addr_match & (s2_valid_masked | s2_replay) & ~s2_sc_fail)begin
    s2_store_bypass_data <= amoalu_out_data;
  end else if(s1_clk_en & s3_req_iswrite & s3_req_addr_match & s3_valid)begin
    s2_store_bypass_data <= s3_req_data;
  end else if(s1_clk_en & s4_req_iswrite & s4_req_addr_match & s4_valid)begin 
    s2_store_bypass_data <= s4_req_data;
  end
  
  if(reset)begin
    s2_store_bypass = 1'h0;
  end else if(s1_clk_en & (
    (s2_req_iswrite & s2_req_addr_match & (s2_valid_masked | s2_replay) & ~s2_sc_fail) |
    (s3_req_iswrite & s3_req_addr_match & s3_valid) |
    (s4_req_iswrite & s4_req_addr_match & s4_valid)  )) begin
    s2_store_bypass <= 1'h1;
  end else if(s1_clk_en) begin
   s2_store_bypass <= 1'h0; 
  end
  
end

endmodule