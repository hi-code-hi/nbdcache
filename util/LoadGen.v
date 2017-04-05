module mprcLoadGen(
  input [2:0] typ,
  input [39:0] addr,
  input [127:0] data_in,
  input zero,
  output [63:0] data_word,
  output [63:0] data_out
);

wire [63:0] data_64;
wire [31:0] data_32;
wire [15:0] data_16;
wire [7:0] data_8;
reg [63:0] data;

assign sign = ~typ[2];
assign data_64 = data_in[6'h3f:1'h0];
assign data_32 = addr[2] ? data_64[6'h3f:6'h20] : data_64[5'h1f:1'h0];
assign data_16 = addr[1] ? data_32[5'h1f:5'h10] : data_32[4'hf:1'h0];
assign data_8 = addr[0] ? data_16[4'hf:4'h8] : data_16[3'h7:1'h0];

assign data_word = typ[1:0] == 2'b10 ? {32'h0 - (sign&data_32[31]),data_32}: {data_64[6'h3f:6'h20],data_32}; //data_word = typ[1:0] == 2'b10 ? {32'h0 - (sign&data_32[31]),data_32}: {data_32,data_32};

assign data_out = zero ? 64'h0 : data;

always @(*) begin
  case(typ[1:0])
    2'b00: data = {56'h0 - (sign&data_8[7]), data_8};
    2'b01: data = {48'h0 - (sign&data_16[15]),data_16};
    2'b10: data = {32'h0 - (sign&data_32[31]),data_32};
    2'b11: data = data_64;
  endcase  
end

endmodule