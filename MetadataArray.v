module mprcMetadataArray_RAM(
  input clk,
  //input flush_flag,
  input init,
  input [5:0] write_idx,//2^6è¡¨ç¤ºset?•°ï?Œè¦?†™?š„set
  input write_en,//?†™ä½¿èƒ½ä¿¡??
  input [87:0] write_bits_meta,//?†™?…¥ä¿¡??
  input [87:0] write_bits_mask,//ä½¿èƒ½ä¿¡??
  input [5:0] read_idx,//2^6è¡¨ç¤ºset?•°ï?Œè¦è¯»çš„set
  input read_en,//è¯»ä½¿¨¨ƒ½ä¿¡??
  output [87:0] resp//è¯»å‡ºä¿¡??
);

  reg [5:0] reg_read_idx;
  reg [87:0] ram [63:0];//cacheï¼Œ64ä¸?set?•¡ã
  
  integer i;
  always @(posedge clk) begin//?†™meta
    if (read_en) reg_read_idx <= read_idx;//è¯?
	else reg_read_idx <= reg_read_idx;
    for (i = 0; i < 88; i=i+1) begin
      if (write_en && write_bits_mask[i]) ram[write_idx][i] <= write_bits_meta[i];
	  else ram[write_idx][i] <= ram[write_idx][i];
    end
  end
  assign resp = ram[reg_read_idx];//è¯»ä?€ä¸?set?š„meta

endmodule


module mprcMetadataArray(
	input clk, 
	input reset,
    input  io_read_valid,
    input [5:0] io_read_bits_idx,//2^6=64ä¸?sets
    input [3:0] io_read_bits_way_en,//4ä¸?ways

    input  io_write_valid,
    input [5:0] io_write_bits_idx,//2^6=64ä¸?sets
    input [3:0] io_write_bits_way_en,//4ä¸?ways
    input [19:0] io_write_bits_data_tag,//è¦?†™?š„tag
    input [1:0] io_write_bits_data_coh_state,//ä¸€¨¨‡´æ€§çŠ¶æ€ä½
	
	output io_write_ready,
	output io_read_ready,
    output[19:0] io_resp_3_tag,//ç¬?3way?š„tag
    output[1:0] io_resp_3_coh_state,//ç¬?3way?š„?Š¶æ€
    output[19:0] io_resp_2_tag,//ç¬?2way?š„tag
    output[1:0] io_resp_2_coh_state,//ç¬?2way?š„?Š¶æ€
    output[19:0] io_resp_1_tag,//ç¬?1way?š„tag
    output[1:0] io_resp_1_coh_state,//ç¬?1way?š„?Š¶æ€
    output[19:0] io_resp_0_tag,//ç¬?0way?š„tag
    output[1:0] io_resp_0_coh_state,//ç¬?0way?š„?Š¶æ€
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

//1?€”?€”è®¡æ•°å™¡§  
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
 
//2?€”?€”è¯»å†™ä¿¡å·äº§?”Ÿ?•?…ƒ
  //?ˆå§‹?Œ–?˜???å®Œæ¯•ä¿¡å?
  assign flush_flag = cur_rst_cnt < 7'h40;
  
  //?†™?•°æ?
  assign rstVal_coh_state = 2'h0;
  assign write_data_coh_state = flush_flag ? rstVal_coh_state : io_write_bits_data_coh_state;//state
  assign rstVal_tag = 20'h0;
  assign write_data_tag = flush_flag ? rstVal_tag : io_write_bits_data_tag;//tag
  assign wdata = {write_data_tag, write_data_coh_state};//?‹¼æ?tag?’Œstate
  assign write_bits_meta_fill = {wdata , wdata, wdata, wdata};
  
  //?†™?œ°å€
  assign waddr_l = flush_flag ? cur_rst_cnt : {1'h0, io_write_bits_idx};
  assign waddr = waddr_l[3'h5:1'h0];
  
  //?†™ä½¿èƒ?
  assign wen = flush_flag | io_write_valid;//wen
  
  //?†™?©ç?
  assign wmask = flush_flag ? 4'hf : io_write_bits_way_en;
  assign write_bits_mask_0 = 22'h0 - {21'h0, wmask[1'h0]};
  assign write_bits_mask_1 = 22'h0 - {21'h0, wmask[1'h1]};
  assign write_bits_mask_2 = 22'h0 - {21'h0, wmask[2'h2]};
  assign write_bits_mask_3 = 22'h0 - {21'h0, wmask[2'h3]};
  assign write_bits_mask_fill = {{write_bits_mask_3, write_bits_mask_2}, {write_bits_mask_1, write_bits_mask_0}};
  
  
  
//3?€”?€”è°ƒ?”¡§  MetadataArray_wrapperæ¨¡å—
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
  
//4?€”?€”?•°æ?äº§ç”Ÿ?•?…ƒ  
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
