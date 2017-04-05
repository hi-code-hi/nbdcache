module mprcLockingArbiter_0(input clk, input reset,
    output io_in_1_ready,
    input  io_in_1_valid,
    input [1:0] io_in_1_bits_addr_beat,
    input [25:0] io_in_1_bits_addr_block,
    input [1:0] io_in_1_bits_client_xact_id,
    input  io_in_1_bits_voluntary,
    input [2:0] io_in_1_bits_r_type,
    input [127:0] io_in_1_bits_data,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [1:0] io_in_0_bits_addr_beat,
    input [25:0] io_in_0_bits_addr_block,
    input [1:0] io_in_0_bits_client_xact_id,
    input  io_in_0_bits_voluntary,
    input [2:0] io_in_0_bits_r_type,
    input [127:0] io_in_0_bits_data,
    input  io_out_ready,
    output io_out_valid,
    output[1:0] io_out_bits_addr_beat,
    output[25:0] io_out_bits_addr_block,
    output[1:0] io_out_bits_client_xact_id,
    output io_out_bits_voluntary,
    output[2:0] io_out_bits_r_type,
    output[127:0] io_out_bits_data,
    output io_chosen
);

  wire chosen;
  wire T0;
  wire choose;
  reg  lockIdx;
  wire T37;
  wire T1;
  wire T2;
  wire T3;
  wire T4;
  wire T5;
  wire T6;
  wire T7;
  wire T8;
  wire T9;
  wire T10;
  wire T11;
  wire T12;
  reg  locked;
  wire T38;
  wire T13;
  wire T14;
  wire T15;
  wire T16;
  wire[1:0] T17;
  reg [1:0] R18;
  wire[1:0] T39;
  wire[1:0] T19;
  wire T20;
  wire T21;
  wire[127:0] T22;
  wire T23;
  wire[2:0] T24;
  wire T25;
  wire[1:0] T26;
  wire[25:0] T27;
  wire[1:0] T28;
  wire T29;
  wire T30;
  wire T31;
  wire T32;
  wire T33;
  wire T34;
  wire T35;
  wire T36;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    lockIdx = {1{$random}};
    locked = {1{$random}};
    R18 = {1{$random}};
  end
// synthesis translate_on
`endif

  assign io_chosen = chosen;
  assign chosen = T0;
  assign T0 = locked ? lockIdx : choose;
  assign choose = io_in_0_valid == 1'h0;
  assign T37 = reset ? 1'h1 : T1;
  assign T1 = T4 ? T2 : lockIdx;
  assign T2 = T3 == 1'h0;
  assign T3 = io_in_0_ready & io_in_0_valid;
  assign T4 = T6 & T5;
  assign T5 = locked ^ 1'h1;
  assign T6 = T12 & T7;
  assign T7 = T9 | T8;
  assign T8 = 3'h2 == io_out_bits_r_type;
  assign T9 = T11 | T10;
  assign T10 = 3'h1 == io_out_bits_r_type;
  assign T11 = 3'h0 == io_out_bits_r_type;
  assign T12 = io_out_valid & io_out_ready;
  assign T38 = reset ? 1'h0 : T13;
  assign T13 = T20 ? 1'h0 : T14;
  assign T14 = T6 ? T15 : locked;
  assign T15 = T16 ^ 1'h1;
  assign T16 = T17 == 2'h0;
  assign T17 = R18 + 2'h1;
  assign T39 = reset ? 2'h0 : T19;
  assign T19 = T6 ? T17 : R18;
  assign T20 = T12 & T21;
  assign T21 = T7 ^ 1'h1;
  assign io_out_bits_data = T22;
  assign T22 = T23 ? io_in_1_bits_data : io_in_0_bits_data;
  assign T23 = chosen;
  assign io_out_bits_r_type = T24;
  assign T24 = T23 ? io_in_1_bits_r_type : io_in_0_bits_r_type;
  assign io_out_bits_voluntary = T25;
  assign T25 = T23 ? io_in_1_bits_voluntary : io_in_0_bits_voluntary;
  assign io_out_bits_client_xact_id = T26;
  assign T26 = T23 ? io_in_1_bits_client_xact_id : io_in_0_bits_client_xact_id;
  assign io_out_bits_addr_block = T27;
  assign T27 = T23 ? io_in_1_bits_addr_block : io_in_0_bits_addr_block;
  assign io_out_bits_addr_beat = T28;
  assign T28 = T23 ? io_in_1_bits_addr_beat : io_in_0_bits_addr_beat;
  assign io_out_valid = T29;
  assign T29 = T23 ? io_in_1_valid : io_in_0_valid;
  assign io_in_0_ready = T30;
  assign T30 = T31 & io_out_ready;
  assign T31 = locked ? T32 : 1'h1;
  assign T32 = lockIdx == 1'h0;
  assign io_in_1_ready = T33;
  assign T33 = T34 & io_out_ready;
  assign T34 = locked ? T36 : T35;
  assign T35 = io_in_0_valid ^ 1'h1;
  assign T36 = lockIdx == 1'h1;

  always @(posedge clk) begin
    if(reset) begin
      lockIdx <= 1'h1;
    end else if(T4) begin
      lockIdx <= T2;
    end
    if(reset) begin
      locked <= 1'h0;
    end else if(T20) begin
      locked <= 1'h0;
    end else if(T6) begin
      locked <= T15;
    end
    if(reset) begin
      R18 <= 2'h0;
    end else if(T6) begin
      R18 <= T17;
    end
  end
endmodule
module mprcLockingArbiter_1(input clk, input reset,
    output io_in_2_ready,
    input  io_in_2_valid,
    input [25:0] io_in_2_bits_addr_block,
    input [1:0] io_in_2_bits_client_xact_id,
    input [1:0] io_in_2_bits_addr_beat,
    input  io_in_2_bits_is_builtin_type,
    input [2:0] io_in_2_bits_a_type,
    input [16:0] io_in_2_bits_union,
    input [127:0] io_in_2_bits_data,
    output io_in_1_ready,
    input  io_in_1_valid,
    input [25:0] io_in_1_bits_addr_block,
    input [1:0] io_in_1_bits_client_xact_id,
    input [1:0] io_in_1_bits_addr_beat,
    input  io_in_1_bits_is_builtin_type,
    input [2:0] io_in_1_bits_a_type,
    input [16:0] io_in_1_bits_union,
    input [127:0] io_in_1_bits_data,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [25:0] io_in_0_bits_addr_block,
    input [1:0] io_in_0_bits_client_xact_id,
    input [1:0] io_in_0_bits_addr_beat,
    input  io_in_0_bits_is_builtin_type,
    input [2:0] io_in_0_bits_a_type,
    input [16:0] io_in_0_bits_union,
    input [127:0] io_in_0_bits_data,
    input  io_out_ready,
    output io_out_valid,
    output[25:0] io_out_bits_addr_block,
    output[1:0] io_out_bits_client_xact_id,
    output[1:0] io_out_bits_addr_beat,
    output io_out_bits_is_builtin_type,
    output[2:0] io_out_bits_a_type,
    output[16:0] io_out_bits_union,
    output[127:0] io_out_bits_data,
    output[1:0] io_chosen
);

  wire[1:0] chosen;
  wire[1:0] T0;
  wire[1:0] choose;
  wire[1:0] T1;
  reg [1:0] lockIdx;
  wire[1:0] T67;
  wire[1:0] T2;
  wire[1:0] T3;
  wire[1:0] T4;
  wire T5;
  wire T6;
  wire T7;
  wire T8;
  wire T9;
  wire T10;
  wire T11;
  wire T12;
  reg  locked;
  wire T68;
  wire T13;
  wire T14;
  wire T15;
  wire T16;
  wire[1:0] T17;
  reg [1:0] R18;
  wire[1:0] T69;
  wire[1:0] T19;
  wire T20;
  wire T21;
  wire[127:0] T22;
  wire[127:0] T23;
  wire T24;
  wire[1:0] T25;
  wire T26;
  wire[16:0] T27;
  wire[16:0] T28;
  wire T29;
  wire T30;
  wire[2:0] T31;
  wire[2:0] T32;
  wire T33;
  wire T34;
  wire T35;
  wire T36;
  wire T37;
  wire T38;
  wire[1:0] T39;
  wire[1:0] T40;
  wire T41;
  wire T42;
  wire[1:0] T43;
  wire[1:0] T44;
  wire T45;
  wire T46;
  wire[25:0] T47;
  wire[25:0] T48;
  wire T49;
  wire T50;
  wire T51;
  wire T52;
  wire T53;
  wire T54;
  wire T55;
  wire T56;
  wire T57;
  wire T58;
  wire T59;
  wire T60;
  wire T61;
  wire T62;
  wire T63;
  wire T64;
  wire T65;
  wire T66;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    lockIdx = {1{$random}};
    locked = {1{$random}};
    R18 = {1{$random}};
  end
// synthesis translate_on
`endif

  assign io_chosen = chosen;
  assign chosen = T0;
  assign T0 = locked ? lockIdx : choose;
  assign choose = io_in_0_valid ? 2'h0 : T1;
  assign T1 = io_in_1_valid ? 2'h1 : 2'h2;
  assign T67 = reset ? 2'h2 : T2;
  assign T2 = T7 ? T3 : lockIdx;
  assign T3 = T6 ? 2'h0 : T4;
  assign T4 = T5 ? 2'h1 : 2'h2;
  assign T5 = io_in_1_ready & io_in_1_valid;
  assign T6 = io_in_0_ready & io_in_0_valid;
  assign T7 = T9 & T8;
  assign T8 = locked ^ 1'h1;
  assign T9 = T12 & T10;
  assign T10 = io_out_bits_is_builtin_type & T11;
  assign T11 = 3'h3 == io_out_bits_a_type;
  assign T12 = io_out_valid & io_out_ready;
  assign T68 = reset ? 1'h0 : T13;
  assign T13 = T20 ? 1'h0 : T14;
  assign T14 = T9 ? T15 : locked;
  assign T15 = T16 ^ 1'h1;
  assign T16 = T17 == 2'h0;
  assign T17 = R18 + 2'h1;
  assign T69 = reset ? 2'h0 : T19;
  assign T19 = T9 ? T17 : R18;
  assign T20 = T12 & T21;
  assign T21 = T10 ^ 1'h1;
  assign io_out_bits_data = T22;
  assign T22 = T26 ? io_in_2_bits_data : T23;
  assign T23 = T24 ? io_in_1_bits_data : io_in_0_bits_data;
  assign T24 = T25[1'h0];
  assign T25 = chosen;
  assign T26 = T25[1'h1];
  assign io_out_bits_union = T27;
  assign T27 = T30 ? io_in_2_bits_union : T28;
  assign T28 = T29 ? io_in_1_bits_union : io_in_0_bits_union;
  assign T29 = T25[1'h0];
  assign T30 = T25[1'h1];
  assign io_out_bits_a_type = T31;
  assign T31 = T34 ? io_in_2_bits_a_type : T32;
  assign T32 = T33 ? io_in_1_bits_a_type : io_in_0_bits_a_type;
  assign T33 = T25[1'h0];
  assign T34 = T25[1'h1];
  assign io_out_bits_is_builtin_type = T35;
  assign T35 = T38 ? io_in_2_bits_is_builtin_type : T36;
  assign T36 = T37 ? io_in_1_bits_is_builtin_type : io_in_0_bits_is_builtin_type;
  assign T37 = T25[1'h0];
  assign T38 = T25[1'h1];
  assign io_out_bits_addr_beat = T39;
  assign T39 = T42 ? io_in_2_bits_addr_beat : T40;
  assign T40 = T41 ? io_in_1_bits_addr_beat : io_in_0_bits_addr_beat;
  assign T41 = T25[1'h0];
  assign T42 = T25[1'h1];
  assign io_out_bits_client_xact_id = T43;
  assign T43 = T46 ? io_in_2_bits_client_xact_id : T44;
  assign T44 = T45 ? io_in_1_bits_client_xact_id : io_in_0_bits_client_xact_id;
  assign T45 = T25[1'h0];
  assign T46 = T25[1'h1];
  assign io_out_bits_addr_block = T47;
  assign T47 = T50 ? io_in_2_bits_addr_block : T48;
  assign T48 = T49 ? io_in_1_bits_addr_block : io_in_0_bits_addr_block;
  assign T49 = T25[1'h0];
  assign T50 = T25[1'h1];
  assign io_out_valid = T51;
  assign T51 = T54 ? io_in_2_valid : T52;
  assign T52 = T53 ? io_in_1_valid : io_in_0_valid;
  assign T53 = T25[1'h0];
  assign T54 = T25[1'h1];
  assign io_in_0_ready = T55;
  assign T55 = T56 & io_out_ready;
  assign T56 = locked ? T57 : 1'h1;
  assign T57 = lockIdx == 2'h0;
  assign io_in_1_ready = T58;
  assign T58 = T59 & io_out_ready;
  assign T59 = locked ? T61 : T60;
  assign T60 = io_in_0_valid ^ 1'h1;
  assign T61 = lockIdx == 2'h1;
  assign io_in_2_ready = T62;
  assign T62 = T63 & io_out_ready;
  assign T63 = locked ? T66 : T64;
  assign T64 = T65 ^ 1'h1;
  assign T65 = io_in_0_valid | io_in_1_valid;
  assign T66 = lockIdx == 2'h2;

  always @(posedge clk) begin
    if(reset) begin
      lockIdx <= 2'h2;
    end else if(T7) begin
      lockIdx <= T3;
    end
    if(reset) begin
      locked <= 1'h0;
    end else if(T20) begin
      locked <= 1'h0;
    end else if(T9) begin
      locked <= T15;
    end
    if(reset) begin
      R18 <= 2'h0;
    end else if(T9) begin
      R18 <= T17;
    end
  end
endmodule
