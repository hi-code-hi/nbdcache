`include "common.vh"

module mprcLrsc(
  input clk,
  input reset,
  
  input invalidate,
  input [4:0] s2_req_cmd,
  input [39:0] s2_req_addr,
  input s2_masked_hit_replay,
  
  output lrsc_valid,
  output s2_sc_fail
);

wire is_lr;
wire is_sc;
wire lr_en;
wire sc_en;
wire s2_lrsc_addr_match;

reg [4:0] lrsc_count_next;
reg [4:0] lrsc_count;
reg [33:0] lrsc_addr;

assign is_lr = s2_req_cmd == `M_XLR;
assign is_sc = s2_req_cmd == `M_XSC;
assign lr_en = is_lr & s2_masked_hit_replay;
assign sc_en = is_sc & s2_masked_hit_replay;
assign lrsc_valid = lrsc_count != 5'h0;
assign s2_lrsc_addr_match = lrsc_valid & (s2_req_addr[39:6] == lrsc_addr);
assign s2_sc_fail = is_sc & ~s2_lrsc_addr_match;

always @(*) begin
  if (lrsc_valid)
    lrsc_count_next = lrsc_count-1;
  else if (!lrsc_valid && lr_en)
    lrsc_count_next = `lrscCycles-1;
  else
    lrsc_count_next = 5'h0;
end

always @(posedge clk) begin
  if (reset | invalidate)
    lrsc_count <= 5'h0;
  else if (sc_en)
    lrsc_count <= 5'h0;
  else
    lrsc_count <= lrsc_count_next;
  
  if (lr_en)
    lrsc_addr <= s2_req_addr[39:6];
end

endmodule
