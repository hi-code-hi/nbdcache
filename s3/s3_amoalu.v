`include "../util/common.vh"

module mprcAMOALU(
    input [5:0] io_addr,
    input [4:0] io_cmd,
    input [2:0] io_typ,
    input [63:0] io_lhs,
    input [63:0] io_rhs,
    output[63:0] io_out
);

  //align_rhs
  wire[63:0] align_rhs;
  wire[63:0] align_rhs_16;
  wire[63:0] align_rhs_32;
  wire[63:0] align_rhs_w;
  wire[63:0] align_rhs_h;
  wire[63:0] align_rhs_B;
  //add
  wire[63:0] adder_out;
  wire[63:0] mask;
  //max&min
  wire max;
  wire min;
  wire less;
  wire cmp_rhs;
  wire[63:0] rhs;
  wire word;
  wire cmp_lhs;
  wire sgned;
  wire lt;
  wire lt_lo;
  wire eq_hi;
  wire lt_hi;
  wire is_m;
  //out
  wire[63:0] out;
  wire[63:0] amo_out;
  wire[63:0] cmd_and;
  wire[63:0] cmd_or;
  wire[63:0] cmd_xor;
  wire[63:0] cmd_m;
  //wmask
  wire[63:0] wmask;
  wire[7:0] lower19;
  wire[7:0] res;
  wire[3:0] lower2;
  wire[3:0] res1;
  wire[1:0] lower1;
  wire[1:0] res0;
  wire lower0;
  wire upper0;
  wire[1:0] upper1_tpy;
  wire[1:0] upper1;
  wire[3:0] upper2_typ;
  wire[3:0] upper2;
  
  wire is_amo;
  //?ò??ê?‰∏∫ÂéüÂ≠ê?ìç‰Ωú‰ø°Âè?
  assign is_amo = io_cmd == `M_XA_XOR | io_cmd == `M_XA_OR | io_cmd == `M_XA_AND | io_cmd == `M_XA_ADD | io_cmd == `M_XA_MIN | io_cmd == `M_XA_MINU | io_cmd == `M_XA_MAX | io_cmd == `M_XA_MAXU; //io_cmd == `M_XA_SWAP 
  
  //?éüÂ≠ê?ìç‰Ωú 
  //cache?ìç‰Ωú?ï°„
  assign rhs = io_typ[1'h1:1'h0] == `MT_W ? ({io_rhs[5'h1f:1'h0], io_rhs[5'h1f:1'h0]}) : io_rhs;//32‰Ωç?àñ®®ÄÖ64‰Ωç?ìç‰Ωú
  //add
  assign mask = (~64'h0) ^ ({32'h0, io_addr[2'h2] << 5'h1f});//®¶ò≤Ê?¢Ë?õ‰Ωç
  assign adder_out = (io_lhs & mask) + (rhs & mask);
  
  //min&max_signal
  assign word = (io_typ == `MT_W) | (io_typ == `MT_WU) | (io_typ == `MT_B) | (io_typ == `MT_BU);
  assign cmp_rhs = (word & (io_addr[2'h2] ^ 1'h1)) ? rhs[5'h1f] : rhs[6'h3f];
  assign cmp_lhs = (word & (io_addr[2'h2] ^ 1'h1)) ? io_lhs[5'h1f] : io_lhs[6'h3f];
  assign sgned = (io_cmd == `M_XA_MIN) | (io_cmd == `M_XA_MAX);
  
  assign lt = word ? (io_addr[2'h2]? lt_hi : lt_lo) : (lt_hi | (eq_hi & lt_lo));
  assign lt_lo = io_lhs[5'h1f:1'h0] < rhs[5'h1f:1'h0];
  assign eq_hi = io_lhs[6'h3f:6'h20] == rhs[6'h3f:6'h20];
  assign lt_hi = io_lhs[6'h3f:6'h20] < rhs[6'h3f:6'h20];
  
  assign is_m = sgned ? cmp_lhs : cmp_rhs;
  assign less = cmp_lhs == cmp_rhs ? lt : is_m; //io_lhs<rhs

  assign max = (io_cmd == `M_XA_MAX) | (io_cmd == `M_XA_MAXU);
  assign min = (io_cmd == `M_XA_MIN) | (io_cmd == `M_XA_MINU);  
  //?éüÂ≠ê?ìç‰ΩúÁªì?ûúamo_out
  assign cmd_m = (less ? min : max) ? io_lhs : align_rhs;
  assign cmd_xor = io_cmd == `M_XA_XOR ? io_lhs ^ rhs : cmd_m;
  assign cmd_or = io_cmd == `M_XA_OR ? io_lhs | rhs : cmd_xor;
  assign cmd_and = io_cmd == `M_XA_AND ? io_lhs & rhs : cmd_or;
  assign amo_out = io_cmd == `M_XA_ADD ? adder_out : cmd_and;
  //®¶ùû?éüÂ≠ê?ìç‰ΩúÁªì?ûú
  //align_rhs
  assign align_rhs_w = {io_rhs[5'h1f:1'h0], io_rhs[5'h1f:1'h0]};
  assign align_rhs_h = {io_rhs[4'hf:1'h0], io_rhs[4'hf:1'h0], io_rhs[4'hf:1'h0], io_rhs[4'hf:1'h0]};
  assign align_rhs_B = {io_rhs[3'h7:1'h0], io_rhs[3'h7:1'h0], io_rhs[3'h7:1'h0], io_rhs[3'h7:1'h0], io_rhs[3'h7:1'h0], io_rhs[3'h7:1'h0], io_rhs[3'h7:1'h0], io_rhs[3'h7:1'h0]};
  assign align_rhs_32 = io_typ[1'h1:1'h0] == `MT_W ? align_rhs_w : io_rhs; 
  assign align_rhs_16 = io_typ[1'h1:1'h0] == `MT_H ? align_rhs_h : align_rhs_32;
  assign align_rhs = (io_typ[1'h1:1'h0] == `MT_B) ? align_rhs_B : align_rhs_16;
  
  //®¶Äâ?ã©ÂéüÂ≠ê?ìç‰ΩúËæì?á∫Êàñ®¶ùû?éüÂ≠ê?ìç‰ΩúËæì?á?
  assign out = is_amo ? amo_out : align_rhs; //?èêÈ´ò?ïà?éá
  
  //mask 
  assign lower0 = io_addr[1'h0] == 1'h0;
  assign upper0 = io_addr[1'h0] | (2'h1 <= io_typ[1'h1:1'h0]);
  assign res0 = {upper0, lower0};
  
  assign lower1 = io_addr[1'h1] ? 2'h0 : res0;
  assign upper1_tpy = (2'h2 <= io_typ[1'h1:1'h0]) ? 2'h3 : 2'h0;
  assign upper1 = io_addr[1'h1] ? res0 : 2'h0;
  assign res1 = {upper1 | upper1_tpy, lower1};
 
  assign lower2 = io_addr[2'h2] ? 4'h0 : res1; 
  assign upper2_typ = (2'h3 <= io_typ[1'h1:1'h0]) ? 4'hf : 4'h0;
  assign upper2 = io_addr[2'h2] ? res1 : 4'h0;
  assign res = {upper2 | upper2_typ, lower2};

  assign wmask = {8'h0 - {7'h0, res[3'h7]}, 8'h0 - {7'h0, res[3'h6]}, 8'h0 - {7'h0, res[3'h5]}, 8'h0 - {7'h0, res[3'h4]}, 8'h0 - {7'h0, res[2'h3]}, 8'h0 - {7'h0, res[2'h2]}, 8'h0 - {7'h0, res[1'h1]}, 8'h0 - {7'h0, res[1'h0]}};
  
  //io_out
  assign io_out = (wmask & out) | ((~ wmask) & io_lhs);
  
endmodule
