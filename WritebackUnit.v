
module mprcWritebackUnit(input clk, input reset,
    output io_req_ready,
    input  io_req_valid,
    input [1:0] io_req_bits_addr_beat,
    input [25:0] io_req_bits_addr_block,
    input [1:0] io_req_bits_client_xact_id,
    input  io_req_bits_voluntary,
    input [2:0] io_req_bits_r_type,
    input [127:0] io_req_bits_data,
    input [3:0] io_req_bits_way_en,
    input  io_meta_read_ready,
    output io_meta_read_valid,
    output[5:0] io_meta_read_bits_idx,
    output[19:0] io_meta_read_bits_tag,
    input  io_data_req_ready,
    output io_data_req_valid,
    output[3:0] io_data_req_bits_way_en,
    output[11:0] io_data_req_bits_addr,
    input [127:0] io_data_resp,
    input  io_release_ready,
    output io_release_valid,
    output[1:0] io_release_bits_addr_beat,
    output[25:0] io_release_bits_addr_block,
    output[1:0] io_release_bits_client_xact_id,
    output io_release_bits_voluntary,
    output[2:0] io_release_bits_r_type,
    output[127:0] io_release_bits_data
);

  reg [2:0] req_r_type;
  reg  req_voluntary;
  reg [1:0] req_client_xact_id;
  reg [25:0] req_addr_block;
  reg [1:0] beat_cnt;

  reg  r2_data_req_fired;
  reg  r1_data_req_fired;
  wire data_req_fire;
  wire data_req_and_not_release;
  reg  active;
  reg [2:0] data_req_cnt;
  wire[5:0] req_idx;
  reg [3:0] req_way_en;
  wire fire;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    req_r_type = {1{$random}};
    req_voluntary = {1{$random}};
    req_client_xact_id = {1{$random}};
    req_addr_block = {1{$random}};
    beat_cnt = {1{$random}};
    r2_data_req_fired = {1{$random}};
    r1_data_req_fired = {1{$random}};
    active = {1{$random}};
    data_req_cnt = {1{$random}};
    req_way_en = {1{$random}};
  end
// synthesis translate_on
`endif


  assign io_release_bits_data = io_data_resp;
  assign io_release_bits_r_type = req_r_type;
  assign io_release_bits_voluntary = req_voluntary;
  assign io_release_bits_client_xact_id = req_client_xact_id;
  assign io_release_bits_addr_block = req_addr_block;
  assign io_release_bits_addr_beat = beat_cnt;
  assign io_release_valid = active & r2_data_req_fired;
  assign data_req_fire = active & ((io_data_req_ready & io_data_req_valid) & (io_meta_read_ready & io_meta_read_valid));
  assign data_req_and_not_release = (active & r2_data_req_fired) & (io_release_ready ^ 1'h1);
  assign io_data_req_bits_addr = {req_idx, data_req_cnt[1'h1:1'h0]} << 3'h4;
  assign req_idx = req_addr_block[3'h5:1'h0];
  assign io_data_req_bits_way_en = req_way_en;
  assign io_data_req_valid = fire;
  assign fire = active & (data_req_cnt < 3'h4);
  assign io_meta_read_bits_tag = req_addr_block >> 3'h6;
  assign io_meta_read_bits_idx = req_idx;
  assign io_meta_read_valid = fire;
  assign io_req_ready = active ^ 1'h1;

  always @(posedge clk) begin
    if(io_req_ready & io_req_valid) begin
      req_r_type <= io_req_bits_r_type;
    end
    if(io_req_ready & io_req_valid) begin
      req_voluntary <= io_req_bits_voluntary;
    end
    if(io_req_ready & io_req_valid) begin
      req_client_xact_id <= io_req_bits_client_xact_id;
    end
    if(io_req_ready & io_req_valid) begin
      req_addr_block <= io_req_bits_addr_block;
    end
    if(reset) begin
      beat_cnt <= 2'h0;
    end else if(io_release_ready & io_release_valid) begin
      beat_cnt <= beat_cnt + 2'h1;
    end
    if(reset) begin
      r2_data_req_fired <= 1'h0;
    end else if(data_req_and_not_release) begin
      r2_data_req_fired <= 1'h0;
    end else if(active) begin
      r2_data_req_fired <= r1_data_req_fired;
    end
    if(reset) begin
      r1_data_req_fired <= 1'h0;
    end else if(data_req_and_not_release) begin
      r1_data_req_fired <= 1'h0;
    end else if(data_req_fire) begin
      r1_data_req_fired <= 1'h1;
    end else if(active) begin
      r1_data_req_fired <= 1'h0;
    end
    if(reset) begin
      active <= 1'h0;
    end else if(io_req_ready & io_req_valid) begin
      active <= 1'h1;
    end else if((active & r2_data_req_fired) & (r1_data_req_fired ^ 1'h1)) begin
      active <= (data_req_cnt < 3'h4) | (io_release_ready ^ 1'h1);
    end
    if(reset) begin //?§åˆ¶è??data?š„æ¬¡æ•°ï?Œä¸€?…±å››æ¬?
      data_req_cnt <= 3'h0;
    end else if(io_req_ready & io_req_valid) begin
      data_req_cnt <= 3'h0;
    end else if(data_req_and_not_release) begin
      data_req_cnt <= data_req_cnt - {1'h0, r1_data_req_fired ? 2'h2 : 2'h1};
    end else if(data_req_fire) begin
      data_req_cnt <= data_req_cnt + 3'h1;
    end
    if(io_req_ready & io_req_valid) begin
      req_way_en <= io_req_bits_way_en;
    end
  end
endmodule

