`include "../util/common.vh"

module mprcGen_s2_hit(
  input [4:0] s2_req_cmd,
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
  
  output s2_tag_match,
  output s2_hit,
  output [1:0] s2_repl_meta_coh,
  output [19:0] s2_repl_meta_tag,
  
  output [1:0] s2_hit_state
);

  wire [1:0] repl_coh_mask_0;
  wire [1:0] repl_coh_mask_1;
  wire [1:0] repl_coh_mask_2;
  wire [1:0] repl_coh_mask_3;
  wire [19:0] repl_tag_mask_0;
  wire [19:0] repl_tag_mask_1;
  wire [19:0] repl_tag_mask_2;
  wire [19:0] repl_tag_mask_3;
  
  wire [1:0] match_coh_mask_0;
  wire [1:0] match_coh_mask_1;
  wire [1:0] match_coh_mask_2;
  wire [1:0] match_coh_mask_3;
  
  wire is_readable;
  wire is_writeable;
  wire is_dirty;
  
  wire is_writeintent;
  wire is_write;
  
  wire is_hit;
  wire on_hit;
  
  assign repl_coh_mask_0 = 2'h0 - s2_replaced_way_en[1'h0];
  assign repl_coh_mask_1 = 2'h0 - s2_replaced_way_en[1'h1];
  assign repl_coh_mask_2 = 2'h0 - s2_replaced_way_en[2'h2];
  assign repl_coh_mask_3 = 2'h0 - s2_replaced_way_en[2'h3];
  assign repl_tag_mask_0 = 20'h0 - s2_replaced_way_en[1'h0];
  assign repl_tag_mask_1 = 20'h0 - s2_replaced_way_en[1'h1];
  assign repl_tag_mask_2 = 20'h0 - s2_replaced_way_en[2'h2];
  assign repl_tag_mask_3 = 20'h0 - s2_replaced_way_en[2'h3];
  
  assign match_coh_mask_0 = 2'h0 - s2_tag_match_way[1'h0];
  assign match_coh_mask_1 = 2'h0 - s2_tag_match_way[1'h1];
  assign match_coh_mask_2 = 2'h0 - s2_tag_match_way[2'h2];
  assign match_coh_mask_3 = 2'h0 - s2_tag_match_way[2'h3];
  
  assign s2_repl_meta_coh = (meta_io_resp_0_coh & repl_coh_mask_0) |
                            (meta_io_resp_1_coh & repl_coh_mask_1) |
                            (meta_io_resp_2_coh & repl_coh_mask_2) |
                            (meta_io_resp_3_coh & repl_coh_mask_3);
  assign s2_repl_meta_tag = (meta_io_resp_0_tag & repl_tag_mask_0) |
                            (meta_io_resp_1_tag & repl_tag_mask_1) |
                            (meta_io_resp_2_tag & repl_tag_mask_2) |
                            (meta_io_resp_3_tag & repl_tag_mask_3);
  assign s2_hit_state = (meta_io_resp_0_coh & match_coh_mask_0) |
                        (meta_io_resp_1_coh & match_coh_mask_1) |
                        (meta_io_resp_2_coh & match_coh_mask_2) |
                        (meta_io_resp_3_coh & match_coh_mask_3);
  
  assign is_readable = (s2_hit_state == `clientShared) | 
                       (s2_hit_state == `clientExclusiveClean) | 
                       (s2_hit_state == `clientExclusiveDirty);
  assign is_writeable = (s2_hit_state == `clientExclusiveClean) | 
                        (s2_hit_state == `clientExclusiveDirty);
  assign is_dirty = s2_hit_state == `clientExclusiveDirty;
  
  assign is_writeintent = (s2_req_cmd == `M_XWR) |
                          (s2_req_cmd == `M_XSC) |
                          (s2_req_cmd[2'h3] == 1'h1) |
                          (s2_req_cmd == `M_XA_SWAP) |
                          (s2_req_cmd == `M_PFW) |
                          (s2_req_cmd == `M_XLR);
  
  assign is_write = (s2_req_cmd == `M_XWR) |
                    (s2_req_cmd[2'h3] == 1'h1) |
                    (s2_req_cmd == `M_XA_SWAP) |
                    (s2_req_cmd == `M_XSC);
                    
  assign is_hit = is_writeintent ? is_writeable : is_readable;
  assign on_hit = is_write ? is_dirty : 1'h1;
  
  assign s2_tag_match = s2_tag_match_way != 4'h0;
  assign s2_hit = s2_tag_match & is_hit & on_hit;
  
endmodule
