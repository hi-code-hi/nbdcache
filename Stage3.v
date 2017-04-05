`include "../util/common.vh"

module mprcStage3(
  input clk,
  input reset,
  
  input s2_nack_hit,
  input s2_valid,
  input s2_replay,
  input s2_killed,
  input s2_recycle_next,
  
  input [39:0] s2_req_addr,
  input [4:0] s2_req_cmd,
  input [2:0] s2_req_typ,
  input [8:0] s2_req_tag,
  input s2_req_kill,
  input s2_req_phys,
  input [63:0] s2_req_data,
  
  input [3:0] s2_tag_match_way,
  input [3:0] s2_replaced_way_en,
  
  input [1:0] meta_io_resp_0_coh,
  input [19:0] meta_io_resp_0_tag,
  input [1:0] meta_io_resp_1_coh,
  input [19:0] meta_io_resp_1_tag,
  input [1:0] meta_io_resp_2_coh,
  input [19:0] meta_io_resp_2_tag,
  input [1:0] meta_io_resp_3_coh,
  input [19:0] meta_io_resp_3_tag,
  
  input [127:0] s2_data_0,
  input [127:0] s2_data_1,
  input [127:0] s2_data_2,
  input [127:0] s2_data_3,
  
  input s2_store_bypass,
  input [63:0] s2_store_bypass_data,
  
  input io_cpu_invalidate_lr,
  
  output reg [3:0] s3_way,
  output reg s3_valid,
  
  output reg [39:0] s3_req_addr,
  output reg [4:0] s3_req_cmd,
  output reg [2:0] s3_req_typ,
  output reg [8:0] s3_req_tag,
  output reg s3_req_kill,
  output reg s3_req_phys,
  output reg [63:0] s3_req_data,
  
  input mshr_req_ready,
  input mshr_secondary_miss,
  
  output mshr_req_valid,
  output [39:0] mshr_req_bits_addr,
  output [8:0] mshr_req_bits_tag,
  output [4:0] mshr_req_bits_cmd,
  output [2:0] mshr_req_bits_typ,
  output  mshr_req_bits_kill,
  output  mshr_req_bits_phys,
  output [63:0] mshr_req_bits_data,
  output  mshr_req_bits_tag_match,
  output [19:0] mshr_req_bits_old_meta_tag,
  output [1:0] mshr_req_bits_old_meta_coh_state,
  output [3:0] mshr_req_bits_way_en,
  
  output cache_resp_valid,
  output[39:0] cache_resp_bits_addr,
  output[8:0] cache_resp_bits_tag,
  output[4:0] cache_resp_bits_cmd,
  output[2:0] cache_resp_bits_typ,
  output[63:0] cache_resp_bits_data,
  output cache_resp_bits_nack,
  output cache_resp_bits_replay,
  output cache_resp_bits_has_data,
  output[63:0] cache_resp_bits_store_data,
  
  output [3:0] prober_way_en,
  output [1:0] prober_block_state,
  
  output [127:0] decode_corrected_data,
  output [63:0] amoalu_out_data,
  output s2_recycle_ecc,
  output s2_recycle,
  output reg block_miss,
  output lrsc_valid,
  output cache_pass,
  
  output [63:0] io_cpu_resp_bits_data_word_bypass,
  
  output s2_valid_masked,
  output s2_sc_fail
);

  wire s2_hit;
  wire s2_nack;
  wire s2_nack_victim;
  wire s2_nack_miss;
  //wire s2_valid_masked;
  wire s2_valid_replay;
  wire s2_masked_hit;
  wire s2_masked_hit_replay;
  wire next_block_miss;
  wire is_write;
  wire is_read;
  wire is_prefetch;
  wire s2_readwrite;
  wire s2_tag_match;
  wire [1:0] s2_repl_meta_coh;
  wire [19:0] s2_repl_meta_tag;
  wire [3:0] mshr_way_en;
  //wire s2_sc_fail;
  wire s2_correctable;
  wire [127:0] decode_in_data;
  wire [127:0] decode_uncorrected_data;
  wire [127:0] s2_data_0_mask;
  wire [127:0] s2_data_1_mask;
  wire [127:0] s2_data_2_mask;
  wire [127:0] s2_data_3_mask;
  wire s3_clk_en;
  wire [127:0] s2_data_word;
  wire [63:0] loadgen_data_out;
  wire [1:0] s2_hit_state;
  wire s2_req_sc;
  
  assign s2_nack_victim = s2_hit & mshr_secondary_miss;
  assign s2_nack_miss = ~s2_hit & ~mshr_req_ready;
  assign s2_valid_masked = ~s2_nack & s2_valid;
  assign s2_valid_replay = s2_valid | s2_replay;
  assign cache_pass = s2_valid_replay | s2_killed;
  assign s2_nack = s2_nack_victim | s2_nack_miss | s2_nack_hit;
  assign s2_masked_hit = s2_hit & s2_valid_masked;
  assign s2_recycle_ecc = s2_valid_replay & s2_hit & s2_correctable;
  assign s2_recycle = s2_recycle_ecc | s2_recycle_next;
  assign s2_masked_hit_replay = s2_masked_hit | s2_replay;
  assign next_block_miss = s2_nack_miss & (block_miss | s2_valid);
  assign is_write = (s2_req_cmd == `M_XWR) |
                    (s2_req_cmd[2'h3] == 1'h1) |
                    (s2_req_cmd == `M_XA_SWAP) |
                    (s2_req_cmd == `M_XSC);
  assign is_read =  (s2_req_cmd[2'h3] == 1'h1) |
                    (s2_req_cmd == `M_XA_SWAP) |
                    (s2_req_cmd == `M_XRD) |
                    (s2_req_cmd == `M_XLR) |
                    (s2_req_cmd == `M_XSC);
  assign is_prefetch = (s2_req_cmd == `M_PFR) | (s2_req_cmd == `M_PFW);
  assign s2_readwrite = is_read | is_write | is_prefetch;
  assign mshr_way_en = s2_tag_match ? s2_tag_match_way : s2_replaced_way_en;
  assign s2_data_0_mask = 128'h0 - s2_tag_match_way[0];
  assign s2_data_1_mask = 128'h0 - s2_tag_match_way[1];
  assign s2_data_2_mask = 128'h0 - s2_tag_match_way[2];
  assign s2_data_3_mask = 128'h0 - s2_tag_match_way[3];
  assign decode_in_data = (s2_data_0 & s2_data_0_mask) |
                        (s2_data_1 & s2_data_1_mask) |
                        (s2_data_2 & s2_data_2_mask) |
                        (s2_data_3 & s2_data_3_mask);
  assign s3_clk_en = s2_valid_replay & (is_write | s2_correctable);
  
  assign mshr_req_valid = s2_valid_masked & ~s2_hit & s2_readwrite;
  assign mshr_req_bits_addr = s2_req_addr;
  assign mshr_req_bits_tag = s2_req_tag;
  assign mshr_req_bits_cmd = s2_req_cmd;
  assign mshr_req_bits_typ = s2_req_typ;
  assign mshr_req_bits_kill = s2_req_kill;
  assign mshr_req_bits_phys = s2_req_phys;
  assign mshr_req_bits_data = s2_req_data;
  assign mshr_req_bits_tag_match = s2_tag_match;
  assign mshr_req_bits_old_meta_tag = s2_repl_meta_tag;
  assign mshr_req_bits_old_meta_coh_state = s2_repl_meta_coh;
  assign mshr_req_bits_way_en = mshr_way_en;
  
  assign s2_data_word = s2_store_bypass ? {64'h0, s2_store_bypass_data} : decode_uncorrected_data;
  
  assign cache_resp_valid = s2_masked_hit_replay & ~s2_correctable;
  assign cache_resp_bits_addr = s2_req_addr;
  assign cache_resp_bits_tag = s2_req_tag;
  assign cache_resp_bits_cmd = s2_req_cmd;
  assign cache_resp_bits_typ = s2_req_typ;
  assign cache_resp_bits_data = loadgen_data_out | s2_sc_fail;
  assign cache_resp_bits_nack = s2_valid & s2_nack;
  assign cache_resp_bits_replay = s2_replay;
  assign cache_resp_bits_has_data = is_read;
  assign cache_resp_bits_store_data = s2_req_data;
  
  assign prober_way_en = s2_tag_match_way;
  assign prober_block_state = s2_hit_state;
  assign s2_req_sc = s2_req_cmd == `M_XSC;
  
  mprcGen_s2_hit gen_s2_hit(
    .s2_req_cmd(s2_req_cmd),
    .s2_tag_match_way(s2_tag_match_way),
    .s2_replaced_way_en(s2_replaced_way_en),
  
    .meta_io_resp_0_coh(meta_io_resp_0_coh),
    .meta_io_resp_0_tag(meta_io_resp_0_tag),
    .meta_io_resp_1_coh(meta_io_resp_1_coh),
    .meta_io_resp_1_tag(meta_io_resp_1_tag),
    .meta_io_resp_2_coh(meta_io_resp_2_coh),
    .meta_io_resp_2_tag(meta_io_resp_2_tag),
    .meta_io_resp_3_coh(meta_io_resp_3_coh),
    .meta_io_resp_3_tag(meta_io_resp_3_tag),
  
    .s2_tag_match(s2_tag_match),
    .s2_hit(s2_hit),
    .s2_repl_meta_coh(s2_repl_meta_coh),
    .s2_repl_meta_tag(s2_repl_meta_tag),
    .s2_hit_state(s2_hit_state)
  );
  
  mprcLrsc lrsc(
    .clk(clk),
    .reset(reset),
  
    .invalidate(io_cpu_invalidate_lr),
    .s2_req_cmd(s2_req_cmd),
    .s2_req_addr(s2_req_addr),
    .s2_masked_hit_replay(s2_masked_hit_replay),
    .lrsc_valid(lrsc_valid),
    .s2_sc_fail(s2_sc_fail)
  );
  
  mprcDecode decode(
    .decode_in_data(decode_in_data),
    .decode_corrected_data(decode_corrected_data),
    .decode_uncorrected_data(decode_uncorrected_data),
    .s2_correctable(s2_correctable)
  );
  
  mprcAMOALU amoalu(
    .io_addr(s2_req_addr[5:0]),
    .io_cmd(s2_req_cmd),
    .io_typ(s2_req_typ),
    .io_rhs(s2_req_data),
    .io_lhs(s2_data_word[6'h3f:1'h0]),
    .io_out(amoalu_out_data)
  );
  
  mprcLoadGen loadgen(
    .addr(s2_req_addr),
    .typ(s2_req_typ),
    .zero(s2_req_sc),
    .data_in(s2_data_word),
    .data_out(loadgen_data_out),
    .data_word(io_cpu_resp_bits_data_word_bypass)
  );
  
  always @(posedge clk) begin
    if (reset) begin
      block_miss <= 1'h0;
      s3_valid <= 1'h0;
    end
    else begin
      block_miss <= next_block_miss;
      s3_valid <= s2_masked_hit_replay & is_write & ~s2_sc_fail;
    end
    
    if(reset)begin
      s3_way <= 4'h0;
      s3_req_addr <= 40'h0;
      s3_req_cmd <= 5'h0;
      s3_req_typ <= 3'h0;
      s3_req_tag <= 9'h0;
      s3_req_kill <= 1'h0;
      s3_req_phys <= 1'h1;
      s3_req_data <= 64'h0;
    end else
    if (s3_clk_en) begin
      s3_way <= s2_tag_match_way;
      s3_req_addr <= s2_req_addr;
      s3_req_cmd <= s2_req_cmd;
      s3_req_typ <= s2_req_typ;
      s3_req_tag <= s2_req_tag;
      s3_req_kill <= s2_req_kill;
      s3_req_phys <= s2_req_phys;
      s3_req_data <= s2_correctable ? decode_corrected_data[6'h3f:1'h0] : amoalu_out_data;
    end
  end
  
endmodule
