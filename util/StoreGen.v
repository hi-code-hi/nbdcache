module mprcStoreGen(
  input [2:0] typ,
  input [39:0] addr,
  input [127:0] data_in,
  output [63:0] data_out,
  output [63:0] data_word,
  output [7:0] mask
);

  wire lower0;
  wire upper0;
  wire [1:0] res0;
  wire [1:0] lower1;
  wire [1:0] upper1_tpy;
  wire [1:0] upper1;
  wire [3:0] res1;
  wire [3:0] lower2;
  wire [3:0] upper2_typ;
  wire [3:0] upper2;
  wire [63:0] align_w;
  wire [63:0] align_h;
  wire [63:0] align_B;
  wire [63:0] align_32;
  wire [63:0] align_16;

  assign lower0 = addr[1'h0] == 1'h0;
  assign upper0 = addr[1'h0] | (2'h1 <= typ[1'h1:1'h0]);
  assign res0 = {upper0, lower0};
  
  assign lower1 = addr[1'h1] ? 2'h0 : res0;
  assign upper1_tpy = (2'h2 <= typ[1'h1:1'h0]) ? 2'h3 : 2'h0;
  assign upper1 = addr[1'h1] ? res0 : 2'h0;
  assign res1 = {upper1 | upper1_tpy, lower1};
 
  assign lower2 = addr[2'h2] ? 4'h0 : res1; 
  assign upper2_typ = (2'h3 <= typ[1'h1:1'h0]) ? 4'hf : 4'h0;
  assign upper2 = addr[2'h2] ? res1 : 4'h0;
  assign mask = {upper2 | upper2_typ, lower2};

  assign align_w = {data_in[5'h1f:1'h0], data_in[5'h1f:1'h0]};
  assign align_h = {data_in[4'hf:1'h0], data_in[4'hf:1'h0], data_in[4'hf:1'h0], data_in[4'hf:1'h0]};
  assign align_B = {align_B[3'h7:1'h0], align_B[3'h7:1'h0], align_B[3'h7:1'h0], align_B[3'h7:1'h0], 
                    align_B[3'h7:1'h0], align_B[3'h7:1'h0], align_B[3'h7:1'h0], align_B[3'h7:1'h0]};
  assign align_32 = typ[1'h1:1'h0] == 2'h2 ? align_w : data_in; 
  assign align_16 = typ[1'h1:1'h0] == 2'h1 ? align_h : align_32;
  assign data_out = typ[1'h1:1'h0] == 2'h0 ? align_B : align_16;
  
  assign data_word = align_32; 
endmodule