module mprcFlowThroughSerializer(
    output io_in_ready,
    input  io_in_valid,
    input [1:0] io_in_bits_addr_beat,
    input [1:0] io_in_bits_client_xact_id,
    input [3:0] io_in_bits_manager_xact_id,
    input  io_in_bits_is_builtin_type,
    input [3:0] io_in_bits_g_type,
    input [127:0] io_in_bits_data,
    input  io_out_ready,
    output io_out_valid,
    output[1:0] io_out_bits_addr_beat,
    output[1:0] io_out_bits_client_xact_id,
    output[3:0] io_out_bits_manager_xact_id,
    output io_out_bits_is_builtin_type,
    output[3:0] io_out_bits_g_type,
    output[127:0] io_out_bits_data,
    output io_cnt,
    output io_done
);



  assign io_done = 1'h1;
  assign io_cnt = 1'h0;
  assign io_out_bits_data = io_in_bits_data;
  assign io_out_bits_g_type = io_in_bits_g_type;
  assign io_out_bits_is_builtin_type = io_in_bits_is_builtin_type;
  assign io_out_bits_manager_xact_id = io_in_bits_manager_xact_id;
  assign io_out_bits_client_xact_id = io_in_bits_client_xact_id;
  assign io_out_bits_addr_beat = io_in_bits_addr_beat;
  assign io_out_valid = io_in_valid;
  assign io_in_ready = io_out_ready;
endmodule
