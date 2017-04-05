module mprcArbiter_0(
    output io_in_4_ready,
    input  io_in_4_valid,
    input [5:0] io_in_4_bits_idx,
    input [3:0] io_in_4_bits_way_en,
    output io_in_3_ready,
    input  io_in_3_valid,
    input [5:0] io_in_3_bits_idx,
    input [3:0] io_in_3_bits_way_en,
    output io_in_2_ready,
    input  io_in_2_valid,
    input [5:0] io_in_2_bits_idx,
    input [3:0] io_in_2_bits_way_en,
    output io_in_1_ready,
    input  io_in_1_valid,
    input [5:0] io_in_1_bits_idx,
    input [3:0] io_in_1_bits_way_en,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [5:0] io_in_0_bits_idx,
    input [3:0] io_in_0_bits_way_en,
    input  io_out_ready,
    output io_out_valid,
    output[5:0] io_out_bits_idx,
    output[3:0] io_out_bits_way_en,
    output[2:0] io_chosen
);

  wire[2:0] chosen;
  wire[2:0] choose;
  wire[2:0] T0;
  wire[2:0] T1;
  wire[2:0] T2;
  wire[3:0] T3;
  wire[3:0] T4;
  wire[3:0] T5;
  wire T6;
  wire[2:0] T7;
  wire[3:0] T8;
  wire T9;
  wire T10;
  wire T11;
  wire[5:0] T12;
  wire[5:0] T13;
  wire[5:0] T14;
  wire T15;
  wire[5:0] T16;
  wire T17;
  wire T18;
  wire T19;
  wire T20;
  wire T21;
  wire T22;
  wire T23;
  wire T24;
  wire T25;
  wire T26;
  wire T27;
  wire T28;
  wire T29;
  wire T30;
  wire T31;
  wire T32;
  wire T33;
  wire T34;
  wire T35;
  wire T36;
  wire T37;
  wire T38;
  wire T39;
  wire T40;
  wire T41;


  assign io_chosen = chosen;
  assign chosen = choose;
  assign choose = io_in_0_valid ? 3'h0 : T0;
  assign T0 = io_in_1_valid ? 3'h1 : T1;
  assign T1 = io_in_2_valid ? 3'h2 : T2;
  assign T2 = io_in_3_valid ? 3'h3 : 3'h4;
  assign io_out_bits_way_en = T3;
  assign T3 = T11 ? io_in_4_bits_way_en : T4;
  assign T4 = T10 ? T8 : T5;
  assign T5 = T6 ? io_in_1_bits_way_en : io_in_0_bits_way_en;
  assign T6 = T7[1'h0];
  assign T7 = chosen;
  assign T8 = T9 ? io_in_3_bits_way_en : io_in_2_bits_way_en;
  assign T9 = T7[1'h0];
  assign T10 = T7[1'h1];
  assign T11 = T7[2'h2];
  assign io_out_bits_idx = T12;
  assign T12 = T19 ? io_in_4_bits_idx : T13;
  assign T13 = T18 ? T16 : T14;
  assign T14 = T15 ? io_in_1_bits_idx : io_in_0_bits_idx;
  assign T15 = T7[1'h0];
  assign T16 = T17 ? io_in_3_bits_idx : io_in_2_bits_idx;
  assign T17 = T7[1'h0];
  assign T18 = T7[1'h1];
  assign T19 = T7[2'h2];
  assign io_out_valid = T20;
  assign T20 = T27 ? io_in_4_valid : T21;
  assign T21 = T26 ? T24 : T22;
  assign T22 = T23 ? io_in_1_valid : io_in_0_valid;
  assign T23 = T7[1'h0];
  assign T24 = T25 ? io_in_3_valid : io_in_2_valid;
  assign T25 = T7[1'h0];
  assign T26 = T7[1'h1];
  assign T27 = T7[2'h2];
  assign io_in_0_ready = io_out_ready;
  assign io_in_1_ready = T28;
  assign T28 = T29 & io_out_ready;
  assign T29 = io_in_0_valid ^ 1'h1;
  assign io_in_2_ready = T30;
  assign T30 = T31 & io_out_ready;
  assign T31 = T32 ^ 1'h1;
  assign T32 = io_in_0_valid | io_in_1_valid;
  assign io_in_3_ready = T33;
  assign T33 = T34 & io_out_ready;
  assign T34 = T35 ^ 1'h1;
  assign T35 = T36 | io_in_2_valid;
  assign T36 = io_in_0_valid | io_in_1_valid;
  assign io_in_4_ready = T37;
  assign T37 = T38 & io_out_ready;
  assign T38 = T39 ^ 1'h1;
  assign T39 = T40 | io_in_3_valid;
  assign T40 = T41 | io_in_2_valid;
  assign T41 = io_in_0_valid | io_in_1_valid;
endmodule

module mprcArbiter_1(
    output io_in_1_ready,
    input  io_in_1_valid,
    input [5:0] io_in_1_bits_idx,
    input [3:0] io_in_1_bits_way_en,
    input [19:0] io_in_1_bits_data_tag,
    input [1:0] io_in_1_bits_data_coh_state,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [5:0] io_in_0_bits_idx,
    input [3:0] io_in_0_bits_way_en,
    input [19:0] io_in_0_bits_data_tag,
    input [1:0] io_in_0_bits_data_coh_state,
    input  io_out_ready,
    output io_out_valid,
    output[5:0] io_out_bits_idx,
    output[3:0] io_out_bits_way_en,
    output[19:0] io_out_bits_data_tag,
    output[1:0] io_out_bits_data_coh_state,
    output io_chosen
);

  wire chosen;
  wire choose;
  wire[1:0] T0;
  wire T1;
  wire[19:0] T2;
  wire[3:0] T3;
  wire[5:0] T4;
  wire T5;
  wire T6;
  wire T7;

  assign io_chosen = chosen;
  assign chosen = choose;
  assign choose = io_in_0_valid == 1'h0;
  assign io_out_bits_data_coh_state = T0;
  assign T0 = T1 ? io_in_1_bits_data_coh_state : io_in_0_bits_data_coh_state;
  assign T1 = chosen;
  assign io_out_bits_data_tag = T2;
  assign T2 = T1 ? io_in_1_bits_data_tag : io_in_0_bits_data_tag;
  assign io_out_bits_way_en = T3;
  assign T3 = T1 ? io_in_1_bits_way_en : io_in_0_bits_way_en;
  assign io_out_bits_idx = T4;
  assign T4 = T1 ? io_in_1_bits_idx : io_in_0_bits_idx;
  assign io_out_valid = T5;
  assign T5 = T1 ? io_in_1_valid : io_in_0_valid;
  assign io_in_0_ready = io_out_ready;
  assign io_in_1_ready = T6;
  assign T6 = T7 & io_out_ready;
  assign T7 = io_in_0_valid ^ 1'h1;
endmodule

module mprcArbiter_2(
    output io_in_3_ready,
    input  io_in_3_valid,
    input [3:0] io_in_3_bits_way_en,
    input [11:0] io_in_3_bits_addr,
    output io_in_2_ready,
    input  io_in_2_valid,
    input [3:0] io_in_2_bits_way_en,
    input [11:0] io_in_2_bits_addr,
    output io_in_1_ready,
    input  io_in_1_valid,
    input [3:0] io_in_1_bits_way_en,
    input [11:0] io_in_1_bits_addr,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [3:0] io_in_0_bits_way_en,
    input [11:0] io_in_0_bits_addr,
    input  io_out_ready,
    output io_out_valid,
    output[3:0] io_out_bits_way_en,
    output[11:0] io_out_bits_addr,
    output[1:0] io_chosen
);

  wire[1:0] chosen;
  wire[1:0] choose;
  wire[1:0] T0;
  wire[1:0] T1;
  wire[11:0] T2;
  wire[11:0] T3;
  wire T4;
  wire[1:0] T5;
  wire[11:0] T6;
  wire T7;
  wire T8;
  wire[3:0] T9;
  wire[3:0] T10;
  wire T11;
  wire[3:0] T12;
  wire T13;
  wire T14;
  wire T15;
  wire T16;
  wire T17;
  wire T18;
  wire T19;
  wire T20;
  wire T21;
  wire T22;
  wire T23;
  wire T24;
  wire T25;
  wire T26;
  wire T27;
  wire T28;
  wire T29;


  assign io_chosen = chosen;
  assign chosen = choose;
  assign choose = io_in_0_valid ? 2'h0 : T0;
  assign T0 = io_in_1_valid ? 2'h1 : T1;
  assign T1 = io_in_2_valid ? 2'h2 : 2'h3;
  assign io_out_bits_addr = T2;
  assign T2 = T8 ? T6 : T3;
  assign T3 = T4 ? io_in_1_bits_addr : io_in_0_bits_addr;
  assign T4 = T5[1'h0];
  assign T5 = chosen;
  assign T6 = T7 ? io_in_3_bits_addr : io_in_2_bits_addr;
  assign T7 = T5[1'h0];
  assign T8 = T5[1'h1];
  assign io_out_bits_way_en = T9;
  assign T9 = T14 ? T12 : T10;
  assign T10 = T11 ? io_in_1_bits_way_en : io_in_0_bits_way_en;
  assign T11 = T5[1'h0];
  assign T12 = T13 ? io_in_3_bits_way_en : io_in_2_bits_way_en;
  assign T13 = T5[1'h0];
  assign T14 = T5[1'h1];
  assign io_out_valid = T15;
  assign T15 = T20 ? T18 : T16;
  assign T16 = T17 ? io_in_1_valid : io_in_0_valid;
  assign T17 = T5[1'h0];
  assign T18 = T19 ? io_in_3_valid : io_in_2_valid;
  assign T19 = T5[1'h0];
  assign T20 = T5[1'h1];
  assign io_in_0_ready = io_out_ready;
  assign io_in_1_ready = T21;
  assign T21 = T22 & io_out_ready;
  assign T22 = io_in_0_valid ^ 1'h1;
  assign io_in_2_ready = T23;
  assign T23 = T24 & io_out_ready;
  assign T24 = T25 ^ 1'h1;
  assign T25 = io_in_0_valid | io_in_1_valid;
  assign io_in_3_ready = T26;
  assign T26 = T27 & io_out_ready;
  assign T27 = T28 ^ 1'h1;
  assign T28 = T29 | io_in_2_valid;
  assign T29 = io_in_0_valid | io_in_1_valid;
endmodule


module mprcArbiter_3(
    output io_in_1_ready,
    input  io_in_1_valid,
    input [3:0] io_in_1_bits_way_en,
    input [11:0] io_in_1_bits_addr,
    input [1:0] io_in_1_bits_wmask,
    input [127:0] io_in_1_bits_data,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [3:0] io_in_0_bits_way_en,
    input [11:0] io_in_0_bits_addr,
    input [1:0] io_in_0_bits_wmask,
    input [127:0] io_in_0_bits_data,
    input  io_out_ready,
    output io_out_valid,
    output[3:0] io_out_bits_way_en,
    output[11:0] io_out_bits_addr,
    output[1:0] io_out_bits_wmask,
    output[127:0] io_out_bits_data,
    output io_chosen
);

  wire chosen;
  wire choose;
  wire[127:0] T0;
  wire T1;
  wire[1:0] T2;
  wire[11:0] T3;
  wire[3:0] T4;
  wire T5;
  wire T6;
  wire T7;


  assign io_chosen = chosen;
  assign chosen = choose;
  assign choose = io_in_0_valid == 1'h0;
  assign io_out_bits_data = T0;
  assign T0 = T1 ? io_in_1_bits_data : io_in_0_bits_data;
  assign T1 = chosen;
  assign io_out_bits_wmask = T2;
  assign T2 = T1 ? io_in_1_bits_wmask : io_in_0_bits_wmask;
  assign io_out_bits_addr = T3;
  assign T3 = T1 ? io_in_1_bits_addr : io_in_0_bits_addr;
  assign io_out_bits_way_en = T4;
  assign T4 = T1 ? io_in_1_bits_way_en : io_in_0_bits_way_en;
  assign io_out_valid = T5;
  assign T5 = T1 ? io_in_1_valid : io_in_0_valid;
  assign io_in_0_ready = io_out_ready;
  assign io_in_1_ready = T6;
  assign T6 = T7 & io_out_ready;
  assign T7 = io_in_0_valid ^ 1'h1;
endmodule

module mprcArbiter_4(
    output io_in_1_ready,
    input  io_in_1_valid,
    input [1:0] io_in_1_bits_addr_beat,
    input [25:0] io_in_1_bits_addr_block,
    input [1:0] io_in_1_bits_client_xact_id,
    input  io_in_1_bits_voluntary,
    input [2:0] io_in_1_bits_r_type,
    input [127:0] io_in_1_bits_data,
    input [3:0] io_in_1_bits_way_en,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [1:0] io_in_0_bits_addr_beat,
    input [25:0] io_in_0_bits_addr_block,
    input [1:0] io_in_0_bits_client_xact_id,
    input  io_in_0_bits_voluntary,
    input [2:0] io_in_0_bits_r_type,
    input [127:0] io_in_0_bits_data,
    input [3:0] io_in_0_bits_way_en,
    input  io_out_ready,
    output io_out_valid,
    output[1:0] io_out_bits_addr_beat,
    output[25:0] io_out_bits_addr_block,
    output[1:0] io_out_bits_client_xact_id,
    output io_out_bits_voluntary,
    output[2:0] io_out_bits_r_type,
    output[127:0] io_out_bits_data,
    output[3:0] io_out_bits_way_en,
    output io_chosen
);

  wire chosen;
  wire choose;
  wire[3:0] T0;
  wire T1;
  wire[127:0] T2;
  wire[2:0] T3;
  wire T4;
  wire[1:0] T5;
  wire[25:0] T6;
  wire[1:0] T7;
  wire T8;
  wire T9;
  wire T10;


  assign io_chosen = chosen;
  assign chosen = choose;
  assign choose = io_in_0_valid == 1'h0;
  assign io_out_bits_way_en = T0;
  assign T0 = T1 ? io_in_1_bits_way_en : io_in_0_bits_way_en;
  assign T1 = chosen;
  assign io_out_bits_data = T2;
  assign T2 = T1 ? io_in_1_bits_data : io_in_0_bits_data;
  assign io_out_bits_r_type = T3;
  assign T3 = T1 ? io_in_1_bits_r_type : io_in_0_bits_r_type;
  assign io_out_bits_voluntary = T4;
  assign T4 = T1 ? io_in_1_bits_voluntary : io_in_0_bits_voluntary;
  assign io_out_bits_client_xact_id = T5;
  assign T5 = T1 ? io_in_1_bits_client_xact_id : io_in_0_bits_client_xact_id;
  assign io_out_bits_addr_block = T6;
  assign T6 = T1 ? io_in_1_bits_addr_block : io_in_0_bits_addr_block;
  assign io_out_bits_addr_beat = T7;
  assign T7 = T1 ? io_in_1_bits_addr_beat : io_in_0_bits_addr_beat;
  assign io_out_valid = T8;
  assign T8 = T1 ? io_in_1_valid : io_in_0_valid;
  assign io_in_0_ready = io_out_ready;
  assign io_in_1_ready = T9;
  assign T9 = T10 & io_out_ready;
  assign T10 = io_in_0_valid ^ 1'h1;
endmodule


module mprcArbiter_5(
    output io_in_1_ready,
    input  io_in_1_valid,
    input [2:0] io_in_1_bits_addr_beat,
    input [3:0] io_in_1_bits_client_xact_id,
    input  io_in_1_bits_manager_xact_id,
    input  io_in_1_bits_is_builtin_type,
    input [3:0] io_in_1_bits_g_type,
    input [63:0] io_in_1_bits_data,
    input  io_in_1_bits_client_id,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [2:0] io_in_0_bits_addr_beat,
    input [3:0] io_in_0_bits_client_xact_id,
    input  io_in_0_bits_manager_xact_id,
    input  io_in_0_bits_is_builtin_type,
    input [3:0] io_in_0_bits_g_type,
    input [63:0] io_in_0_bits_data,
    input  io_in_0_bits_client_id,
    input  io_out_ready,
    output io_out_valid,
    output[2:0] io_out_bits_addr_beat,
    output[3:0] io_out_bits_client_xact_id,
    output io_out_bits_manager_xact_id,
    output io_out_bits_is_builtin_type,
    output[3:0] io_out_bits_g_type,
    output[63:0] io_out_bits_data,
    output io_out_bits_client_id,
    output io_chosen
);

  wire chosen;
  wire choose;
  wire T0;
  wire T1;
  wire[63:0] T2;
  wire[3:0] T3;
  wire T4;
  wire T5;
  wire[3:0] T6;
  wire[2:0] T7;
  wire T8;
  wire T9;
  wire T10;


  assign io_chosen = chosen;
  assign chosen = choose;
  assign choose = io_in_0_valid == 1'h0;
  assign io_out_bits_client_id = T0;
  assign T0 = T1 ? io_in_1_bits_client_id : io_in_0_bits_client_id;
  assign T1 = chosen;
  assign io_out_bits_data = T2;
  assign T2 = T1 ? io_in_1_bits_data : io_in_0_bits_data;
  assign io_out_bits_g_type = T3;
  assign T3 = T1 ? io_in_1_bits_g_type : io_in_0_bits_g_type;
  assign io_out_bits_is_builtin_type = T4;
  assign T4 = T1 ? io_in_1_bits_is_builtin_type : io_in_0_bits_is_builtin_type;
  assign io_out_bits_manager_xact_id = T5;
  assign T5 = T1 ? io_in_1_bits_manager_xact_id : io_in_0_bits_manager_xact_id;
  assign io_out_bits_client_xact_id = T6;
  assign T6 = T1 ? io_in_1_bits_client_xact_id : io_in_0_bits_client_xact_id;
  assign io_out_bits_addr_beat = T7;
  assign T7 = T1 ? io_in_1_bits_addr_beat : io_in_0_bits_addr_beat;
  assign io_out_valid = T8;
  assign T8 = T1 ? io_in_1_valid : io_in_0_valid;
  assign io_in_0_ready = io_out_ready;
  assign io_in_1_ready = T9;
  assign T9 = T10 & io_out_ready;
  assign T10 = io_in_0_valid ^ 1'h1;
endmodule

module mprcArbiter_6(
    output io_in_1_ready,
    input  io_in_1_valid,
    input [5:0] io_in_1_bits_idx,
    input [3:0] io_in_1_bits_way_en,
    input [19:0] io_in_1_bits_tag,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [5:0] io_in_0_bits_idx,
    input [3:0] io_in_0_bits_way_en,
    input [19:0] io_in_0_bits_tag,
    input  io_out_ready,
    output io_out_valid,
    output[5:0] io_out_bits_idx,
    output[3:0] io_out_bits_way_en,
    output[19:0] io_out_bits_tag,
    output io_chosen
);

  wire chosen;
  wire choose;
  wire[19:0] T0;
  wire T1;
  wire[3:0] T2;
  wire[5:0] T3;
  wire T4;
  wire T5;
  wire T6;


  assign io_chosen = chosen;
  assign chosen = choose;
  assign choose = io_in_0_valid == 1'h0;
  assign io_out_bits_tag = T0;
  assign T0 = T1 ? io_in_1_bits_tag : io_in_0_bits_tag;
  assign T1 = chosen;
  assign io_out_bits_way_en = T2;
  assign T2 = T1 ? io_in_1_bits_way_en : io_in_0_bits_way_en;
  assign io_out_bits_idx = T3;
  assign T3 = T1 ? io_in_1_bits_idx : io_in_0_bits_idx;
  assign io_out_valid = T4;
  assign T4 = T1 ? io_in_1_valid : io_in_0_valid;
  assign io_in_0_ready = io_out_ready;
  assign io_in_1_ready = T5;
  assign T5 = T6 & io_out_ready;
  assign T6 = io_in_0_valid ^ 1'h1;
endmodule

module mprcArbiter_7(
    output io_in_1_ready,
    input  io_in_1_valid,
    input [39:0] io_in_1_bits_addr,
    input [8:0] io_in_1_bits_tag,
    input [4:0] io_in_1_bits_cmd,
    input [2:0] io_in_1_bits_typ,
    input  io_in_1_bits_kill,
    input  io_in_1_bits_phys,
    input [4:0] io_in_1_bits_sdq_id,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [39:0] io_in_0_bits_addr,
    input [8:0] io_in_0_bits_tag,
    input [4:0] io_in_0_bits_cmd,
    input [2:0] io_in_0_bits_typ,
    input  io_in_0_bits_kill,
    input  io_in_0_bits_phys,
    input [4:0] io_in_0_bits_sdq_id,
    input  io_out_ready,
    output io_out_valid,
    output[39:0] io_out_bits_addr,
    output[8:0] io_out_bits_tag,
    output[4:0] io_out_bits_cmd,
    output[2:0] io_out_bits_typ,
    output io_out_bits_kill,
    output io_out_bits_phys,
    output[4:0] io_out_bits_sdq_id,
    output io_chosen
);

  wire chosen;
  wire choose;
  wire[4:0] T0;
  wire T1;
  wire T2;
  wire T3;
  wire[2:0] T4;
  wire[4:0] T5;
  wire[8:0] T6;
  wire[39:0] T7;
  wire T8;
  wire T9;
  wire T10;


  assign io_chosen = chosen;
  assign chosen = choose;
  assign choose = io_in_0_valid == 1'h0;
  assign io_out_bits_sdq_id = T0;
  assign T0 = T1 ? io_in_1_bits_sdq_id : io_in_0_bits_sdq_id;
  assign T1 = chosen;
  assign io_out_bits_phys = T2;
  assign T2 = T1 ? io_in_1_bits_phys : io_in_0_bits_phys;
  assign io_out_bits_kill = T3;
  assign T3 = T1 ? io_in_1_bits_kill : io_in_0_bits_kill;
  assign io_out_bits_typ = T4;
  assign T4 = T1 ? io_in_1_bits_typ : io_in_0_bits_typ;
  assign io_out_bits_cmd = T5;
  assign T5 = T1 ? io_in_1_bits_cmd : io_in_0_bits_cmd;
  assign io_out_bits_tag = T6;
  assign T6 = T1 ? io_in_1_bits_tag : io_in_0_bits_tag;
  assign io_out_bits_addr = T7;
  assign T7 = T1 ? io_in_1_bits_addr : io_in_0_bits_addr;
  assign io_out_valid = T8;
  assign T8 = T1 ? io_in_1_valid : io_in_0_valid;
  assign io_in_0_ready = io_out_ready;
  assign io_in_1_ready = T9;
  assign T9 = T10 & io_out_ready;
  assign T10 = io_in_0_valid ^ 1'h1;
endmodule

module mprcArbiter_8(
    output io_in_1_ready,
    input  io_in_1_valid,
    input  io_in_1_bits,
    output io_in_0_ready,
    input  io_in_0_valid,
    input  io_in_0_bits,
    input  io_out_ready,
    output io_out_valid,
    output io_out_bits,
    output io_chosen
);

  wire chosen;
  wire choose;
  wire T0;
  wire T1;
  wire T2;
  wire T3;
  wire T4;


  assign io_chosen = chosen;
  assign chosen = choose;
  assign choose = io_in_0_valid == 1'h0;
  assign io_out_bits = T0;
  assign T0 = T1 ? io_in_1_bits : io_in_0_bits;
  assign T1 = chosen;
  assign io_out_valid = T2;
  assign T2 = T1 ? io_in_1_valid : io_in_0_valid;
  assign io_in_0_ready = io_out_ready;
  assign io_in_1_ready = T3;
  assign T3 = T4 & io_out_ready;
  assign T4 = io_in_0_valid ^ 1'h1;
endmodule

module mprcArbiter_9(
    output io_in_0_ready,
    input  io_in_0_valid,
    input  io_in_0_bits,
    input  io_out_ready,
    output io_out_valid,
    output io_out_bits,
    output io_chosen
);

  wire chosen;


  assign io_chosen = chosen;
  assign chosen = 1'h0;
  assign io_out_bits = io_in_0_bits;
  assign io_out_valid = io_in_0_valid;
  assign io_in_0_ready = io_out_ready;
endmodule

module mprcArbiter_10(
    output io_in_0_ready,
    input  io_in_0_valid,
    input [39:0] io_in_0_bits_addr,
    input [8:0] io_in_0_bits_tag,
    input [4:0] io_in_0_bits_cmd,
    input [2:0] io_in_0_bits_typ,
    input [63:0] io_in_0_bits_data,
    input  io_in_0_bits_nack,
    input  io_in_0_bits_replay,
    input  io_in_0_bits_has_data,
    input [63:0] io_in_0_bits_data_word_bypass,
    input [63:0] io_in_0_bits_store_data,
    input  io_out_ready,
    output io_out_valid,
    output[39:0] io_out_bits_addr,
    output[8:0] io_out_bits_tag,
    output[4:0] io_out_bits_cmd,
    output[2:0] io_out_bits_typ,
    output[63:0] io_out_bits_data,
    output io_out_bits_nack,
    output io_out_bits_replay,
    output io_out_bits_has_data,
    output[63:0] io_out_bits_data_word_bypass,
    output[63:0] io_out_bits_store_data,
    output io_chosen
);

  wire chosen;


  assign io_chosen = chosen;
  assign chosen = 1'h0;
  assign io_out_bits_store_data = io_in_0_bits_store_data;
  assign io_out_bits_data_word_bypass = io_in_0_bits_data_word_bypass;
  assign io_out_bits_has_data = io_in_0_bits_has_data;
  assign io_out_bits_replay = io_in_0_bits_replay;
  assign io_out_bits_nack = io_in_0_bits_nack;
  assign io_out_bits_data = io_in_0_bits_data;
  assign io_out_bits_typ = io_in_0_bits_typ;
  assign io_out_bits_cmd = io_in_0_bits_cmd;
  assign io_out_bits_tag = io_in_0_bits_tag;
  assign io_out_bits_addr = io_in_0_bits_addr;
  assign io_out_valid = io_in_0_valid;
  assign io_in_0_ready = io_out_ready;
endmodule

