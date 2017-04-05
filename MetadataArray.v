module mprcMetadataArray_RAM(
  input clk,
  //input flush_flag,
  input init,
  input [5:0] write_idx,//2^6表示set?���?�要?��?��set
  input write_en,//?��使能信?�?
  input [87:0] write_bits_meta,//?��?��信?�?
  input [87:0] write_bits_mask,//使能信?�?
  input [5:0] read_idx,//2^6表示set?���?�要读的set
  input read_en,//读使����信?�?
  output [87:0] resp//读出信?�?
);

  reg [5:0] reg_read_idx;
  reg [87:0] ram [63:0];//cache，64�?set?���
  
  integer i;
  always @(posedge clk) begin//?��meta
    if (read_en) reg_read_idx <= read_idx;//�?
	else reg_read_idx <= reg_read_idx;
    for (i = 0; i < 88; i=i+1) begin
      if (write_en && write_bits_mask[i]) ram[write_idx][i] <= write_bits_meta[i];
	  else ram[write_idx][i] <= ram[write_idx][i];
    end
  end
  assign resp = ram[reg_read_idx];//读�?��?set?��meta

endmodule


module mprcMetadataArray(
	input clk, 
	input reset,
    input  io_read_valid,
    input [5:0] io_read_bits_idx,//2^6=64�?sets
    input [3:0] io_read_bits_way_en,//4�?ways

    input  io_write_valid,
    input [5:0] io_write_bits_idx,//2^6=64�?sets
    input [3:0] io_write_bits_way_en,//4�?ways
    input [19:0] io_write_bits_data_tag,//要?��?��tag
    input [1:0] io_write_bits_data_coh_state,//一����性状态位
	
	output io_write_ready,
	output io_read_ready,
    output[19:0] io_resp_3_tag,//�?3way?��tag
    output[1:0] io_resp_3_coh_state,//�?3way?��?��态
    output[19:0] io_resp_2_tag,//�?2way?��tag
    output[1:0] io_resp_2_coh_state,//�?2way?��?��态
    output[19:0] io_resp_1_tag,//�?1way?��tag
    output[1:0] io_resp_1_coh_state,//�?1way?��?��态
    output[19:0] io_resp_0_tag,//�?0way?��tag
    output[1:0] io_resp_0_coh_state,//�?0way?��?��态
    input  init
);

  
  wire[87:0] meta_resp;
  wire[87:0] write_bits_mask_fill;
  wire[21:0] write_bits_mask_0;
  wire[3:0] wmask;
  wire flush_flag;
  wire cnt_en;
  reg [6:0] cur_rst_cnt;
  wire[6:0] next_rst_cnt;
  wire[21:0] write_bits_mask_1;
  wire[21:0] write_bits_mask_2;
  wire[21:0] write_bits_mask_3;
  wire[87:0] write_bits_meta_fill;
  wire[21:0] wdata;
  wire[1:0] write_data_coh_state;
  wire[1:0] rstVal_coh_state;
  wire[19:0] write_data_tag;
  wire[19:0] rstVal_tag;
  wire wen;
  wire[5:0] waddr;
  wire[6:0] waddr_l;
  reg [5:0] read_bits_idx;

//1?��?��计数噡�  
  always @(posedge clk) begin
    if(reset) begin
      cur_rst_cnt <= 7'h0;
    end 
	else if(cnt_en) begin
      cur_rst_cnt <= next_rst_cnt;
    end
  end
  
  assign next_rst_cnt = cur_rst_cnt + 7'h1;
  assign cnt_en = cur_rst_cnt < 7'h40;
 
//2?��?��读写信号产?��?��?��
  //?��始?��?�??�?完毕信�?
  assign flush_flag = cur_rst_cnt < 7'h40;
  
  //?��?���?
  assign rstVal_coh_state = 2'h0;
  assign write_data_coh_state = flush_flag ? rstVal_coh_state : io_write_bits_data_coh_state;//state
  assign rstVal_tag = 20'h0;
  assign write_data_tag = flush_flag ? rstVal_tag : io_write_bits_data_tag;//tag
  assign wdata = {write_data_tag, write_data_coh_state};//?���?tag?��state
  assign write_bits_meta_fill = {wdata , wdata, wdata, wdata};
  
  //?��?��址
  assign waddr_l = flush_flag ? cur_rst_cnt : {1'h0, io_write_bits_idx};
  assign waddr = waddr_l[3'h5:1'h0];
  
  //?��使�?
  assign wen = flush_flag | io_write_valid;//wen
  
  //?��?���?�
  assign wmask = flush_flag ? 4'hf : io_write_bits_way_en;
  assign write_bits_mask_0 = 22'h0 - {21'h0, wmask[1'h0]};
  assign write_bits_mask_1 = 22'h0 - {21'h0, wmask[1'h1]};
  assign write_bits_mask_2 = 22'h0 - {21'h0, wmask[2'h2]};
  assign write_bits_mask_3 = 22'h0 - {21'h0, wmask[2'h3]};
  assign write_bits_mask_fill = {{write_bits_mask_3, write_bits_mask_2}, {write_bits_mask_1, write_bits_mask_0}};
  
  
  
//3?��?��调?���  MetadataArray_wrapper模块
  mprcMetadataArray_RAM Ram (
    .clk(clk),
    .init(init),
    .write_idx(waddr),
    .write_en(wen),
    .write_bits_meta(write_bits_meta_fill),
    .write_bits_mask(write_bits_mask_fill),
    .read_idx(io_read_bits_idx),
    .read_en(io_read_valid),
    .resp(meta_resp)
  );
  
//4?��?��?���?产生?��?��  
  assign io_resp_0_coh_state = meta_resp[1'h1:1'h0];
  assign io_resp_0_tag = meta_resp[5'h15:2'h2];
  assign io_resp_1_coh_state = meta_resp[5'h17:5'h16];
  assign io_resp_1_tag = meta_resp[6'h2b:5'h18];
  assign io_resp_2_coh_state = meta_resp[6'h2d:6'h2c];
  assign io_resp_2_tag = meta_resp[7'h41:6'h2e];
  assign io_resp_3_coh_state = meta_resp[7'h43:7'h42];
  assign io_resp_3_tag = meta_resp[7'h57:7'h44];
  assign io_write_ready = flush_flag ^ 1'h1;
  assign io_read_ready = flush_flag ^ 1'h1 & io_write_valid ^ 1'h1;
  
endmodule
