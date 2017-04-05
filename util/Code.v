module mprcDecode(
  input [127:0] decode_in_data,
  output [127:0] decode_corrected_data,
  output [127:0] decode_uncorrected_data,
  output s2_correctable
);

  assign s2_correctable = 1'h0;
  assign decode_corrected_data = decode_in_data;
  assign decode_uncorrected_data = decode_in_data;
endmodule

module mprcEncode(
  input [127:0] encode_data_in,
  output [127:0] encode_data_out
);
  assign encode_data_out = encode_data_in;
endmodule