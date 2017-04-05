
module mprcMSHRFile(input clk, input reset,
    output io_req_ready,
    input  io_req_valid,
    input [39:0] io_req_bits_addr,
    input [8:0] io_req_bits_tag,
    input [4:0] io_req_bits_cmd,
    input [2:0] io_req_bits_typ,
    input  io_req_bits_kill,
    input  io_req_bits_phys,
    input [63:0] io_req_bits_data,
    input  io_req_bits_tag_match,
    input [19:0] io_req_bits_old_meta_tag,
    input [1:0] io_req_bits_old_meta_coh_state,
    input [3:0] io_req_bits_way_en,
    input  io_resp_ready,
    output io_resp_valid,
    output[39:0] io_resp_bits_addr,
    output[8:0] io_resp_bits_tag,
    output[4:0] io_resp_bits_cmd,
    output[2:0] io_resp_bits_typ,
    output[63:0] io_resp_bits_data,
    output io_resp_bits_nack,
    output io_resp_bits_replay,
    output io_resp_bits_has_data,
    output[63:0] io_resp_bits_data_word_bypass,
    output[63:0] io_resp_bits_store_data,
    output io_secondary_miss,
    input  io_mem_req_ready,
    output io_mem_req_valid,
    output[25:0] io_mem_req_bits_addr_block,
    output[1:0] io_mem_req_bits_client_xact_id,
    output[1:0] io_mem_req_bits_addr_beat,
    output io_mem_req_bits_is_builtin_type,
    output[2:0] io_mem_req_bits_a_type,
    output[16:0] io_mem_req_bits_union,
    output[127:0] io_mem_req_bits_data,
    output[3:0] io_refill_way_en,
    output[11:0] io_refill_addr,
    input  io_meta_read_ready,
    output io_meta_read_valid,
    output[5:0] io_meta_read_bits_idx,
    output[3:0] io_meta_read_bits_way_en,
    output[19:0] io_meta_read_bits_tag,
    input  io_meta_write_ready,
    output io_meta_write_valid,
    output[5:0] io_meta_write_bits_idx,
    output[3:0] io_meta_write_bits_way_en,
    output[19:0] io_meta_write_bits_data_tag,
    output[1:0] io_meta_write_bits_data_coh_state,
    input  io_replay_ready,
    output io_replay_valid,
    output[39:0] io_replay_bits_addr,
    output[8:0] io_replay_bits_tag,
    output[4:0] io_replay_bits_cmd,
    output[2:0] io_replay_bits_typ,
    output io_replay_bits_kill,
    output io_replay_bits_phys,
    output[63:0] io_replay_bits_data,
    input  io_mem_grant_valid,
    input [1:0] io_mem_grant_bits_addr_beat,
    input [1:0] io_mem_grant_bits_client_xact_id,
    input [3:0] io_mem_grant_bits_manager_xact_id,
    input  io_mem_grant_bits_is_builtin_type,
    input [3:0] io_mem_grant_bits_g_type,
    input [127:0] io_mem_grant_bits_data,
    input  io_wb_req_ready,
    output io_wb_req_valid,
    output[1:0] io_wb_req_bits_addr_beat,
    output[25:0] io_wb_req_bits_addr_block,
    output[1:0] io_wb_req_bits_client_xact_id,
    output io_wb_req_bits_voluntary,
    output[2:0] io_wb_req_bits_r_type,
    output[127:0] io_wb_req_bits_data,
    output[3:0] io_wb_req_bits_way_en,
    output io_probe_rdy,
    output io_fence_rdy,
    
    input io_mem_release_valid,
    input[1:0] io_mem_release_bits_addr_beat
);

  wire T0;
  wire T1;
  wire T2;
  wire T3;
  wire cacheable;
  wire T4;
  wire T5;
  wire[4:0] T111;
  wire[4:0] T112;
  wire[4:0] T113;
  wire[4:0] T114;
  wire[4:0] T115;
  wire[4:0] T116;
  wire[4:0] T117;
  wire[4:0] T118;
  wire[4:0] T119;
  wire[4:0] T120;
  wire[4:0] T121;
  wire[4:0] T122;
  wire[4:0] T123;
  wire[4:0] T124;
  wire[4:0] T125;
  wire[4:0] T126;
  wire T127;
  wire[16:0] T6;
  wire[16:0] T7;
  reg [16:0] sdq_val;
  wire[16:0] T128;
  wire[31:0] T129;
  wire[31:0] T8;
  wire[31:0] T130;
  wire[31:0] T9;
  wire[31:0] T131;
  wire[16:0] T10;
  wire[16:0] T11;
  wire[16:0] T132;
  wire sdq_enq;
  wire T12;
  wire T13;
  wire T14;
  wire T15;
  wire T16;
  wire T17;
  wire T18;
  wire T19;
  wire T20;
  wire[16:0] T21;
  wire[16:0] T22;
  wire[16:0] T23;
  wire[16:0] T24;
  wire[16:0] T25;
  wire[16:0] T26;
  wire[16:0] T27;
  wire[16:0] T28;
  wire[16:0] T29;
  wire[16:0] T30;
  wire[16:0] T31;
  wire[16:0] T32;
  wire[16:0] T33;
  wire[16:0] T34;
  wire[16:0] T35;
  wire[16:0] T36;
  wire[16:0] T37;
  wire T38;
  wire[16:0] T39;
  wire[16:0] T40;
  wire T41;
  wire T42;
  wire T43;
  wire T44;
  wire T45;
  wire T46;
  wire T47;
  wire T48;
  wire T49;
  wire T50;
  wire T51;
  wire T52;
  wire T53;
  wire T54;
  wire T55;
  wire T56;
  wire[31:0] T57;
  wire[31:0] T58;
  wire[31:0] T59;
  wire[31:0] T133;
  wire[16:0] T60;
  wire[16:0] T134;
  wire free_sdq;
  wire T61;
  wire T62;
  wire T63;
  wire T64;
  wire T65;
  wire T66;
  wire T67;
  wire T68;
  wire[31:0] T69;
  wire[31:0] T135;
  wire T70;
  wire T136;
  wire T137;
  wire T138;
  wire T139;
  wire T140;
  wire T141;
  wire T142;
  wire T143;
  wire T144;
  wire T145;
  wire T146;
  wire T147;
  wire T148;
  wire T149;
  wire T150;
  wire T71;
  wire tag_match;
  wire[27:0] T72;
  wire[27:0] T151;
  wire[19:0] T73;
  wire[19:0] T74;
  wire[19:0] tagList_1;
  wire idxMatch_1;
  wire[19:0] T75;
  wire[19:0] tagList_0;
  wire idxMatch_0;
  wire T76;
  wire sdq_rdy;
  wire T77;
  wire T78;
  wire T79;
  wire T80;
  wire T81;
  wire T82;
  wire T83;
  wire idx_match;
  wire T84;
  wire T85;
  wire T86;
  wire T87;
  wire T88;
  wire T89;
  wire T90;
  wire T91;
  wire T92;
  wire T93;
  wire T94;
  wire T95;
  wire[63:0] T96;
  reg [63:0] sdq [16:0];
  wire[63:0] T97;
  wire T98;
  wire T99;
  wire[4:0] T100;
  reg [4:0] R101;
  wire[4:0] T102;
  wire[11:0] T103;
  wire[11:0] refillMux_0_addr;
  wire[11:0] refillMux_1_addr;
  wire T104;
  wire T152;
  wire[3:0] T105;
  wire[3:0] refillMux_0_way_en;
  wire[3:0] refillMux_1_way_en;
  wire T106;
  wire T107;
  wire T108;
  wire pri_rdy;
  wire T109;
  wire sec_rdy;
  wire T110;
  wire meta_read_arb_io_in_1_ready;
  wire meta_read_arb_io_in_0_ready;
  wire meta_read_arb_io_out_valid;
  wire[5:0] meta_read_arb_io_out_bits_idx;
  wire[3:0] meta_read_arb_io_out_bits_way_en;
  wire[19:0] meta_read_arb_io_out_bits_tag;
  wire meta_write_arb_io_in_1_ready;
  wire meta_write_arb_io_in_0_ready;
  wire meta_write_arb_io_out_valid;
  wire[5:0] meta_write_arb_io_out_bits_idx;
  wire[3:0] meta_write_arb_io_out_bits_way_en;
  wire[19:0] meta_write_arb_io_out_bits_data_tag;
  wire[1:0] meta_write_arb_io_out_bits_data_coh_state;
  wire mem_req_arb_io_in_2_ready;
  wire mem_req_arb_io_in_1_ready;
  wire mem_req_arb_io_in_0_ready;
  wire mem_req_arb_io_out_valid;
  wire[25:0] mem_req_arb_io_out_bits_addr_block;
  wire[1:0] mem_req_arb_io_out_bits_client_xact_id;
  wire[1:0] mem_req_arb_io_out_bits_addr_beat;
  wire mem_req_arb_io_out_bits_is_builtin_type;
  wire[2:0] mem_req_arb_io_out_bits_a_type;
  wire[16:0] mem_req_arb_io_out_bits_union;
  wire[127:0] mem_req_arb_io_out_bits_data;
  wire wb_req_arb_io_in_1_ready;
  wire wb_req_arb_io_in_0_ready;
  wire wb_req_arb_io_out_valid;
  wire[1:0] wb_req_arb_io_out_bits_addr_beat;
  wire[25:0] wb_req_arb_io_out_bits_addr_block;
  wire[1:0] wb_req_arb_io_out_bits_client_xact_id;
  wire wb_req_arb_io_out_bits_voluntary;
  wire[2:0] wb_req_arb_io_out_bits_r_type;
  wire[127:0] wb_req_arb_io_out_bits_data;
  wire[3:0] wb_req_arb_io_out_bits_way_en;
  wire replay_arb_io_in_1_ready;
  wire replay_arb_io_in_0_ready;
  wire replay_arb_io_out_valid;
  wire[39:0] replay_arb_io_out_bits_addr;
  wire[8:0] replay_arb_io_out_bits_tag;
  wire[4:0] replay_arb_io_out_bits_cmd;
  wire[2:0] replay_arb_io_out_bits_typ;
  wire replay_arb_io_out_bits_kill;
  wire replay_arb_io_out_bits_phys;
  wire[4:0] replay_arb_io_out_bits_sdq_id;
  wire alloc_arb_io_in_1_ready;
  wire alloc_arb_io_in_0_ready;
  wire mmio_alloc_arb_io_in_0_ready;
  wire resp_arb_io_in_0_ready;
  wire resp_arb_io_out_valid;
  wire[39:0] resp_arb_io_out_bits_addr;
  wire[8:0] resp_arb_io_out_bits_tag;
  wire[4:0] resp_arb_io_out_bits_cmd;
  wire[2:0] resp_arb_io_out_bits_typ;
  wire[63:0] resp_arb_io_out_bits_data;
  wire resp_arb_io_out_bits_nack;
  wire resp_arb_io_out_bits_replay;
  wire resp_arb_io_out_bits_has_data;
  wire[63:0] resp_arb_io_out_bits_data_word_bypass;
  wire[63:0] resp_arb_io_out_bits_store_data;
  wire IOMSHR_io_req_ready;
  wire IOMSHR_io_acquire_valid;
  wire[25:0] IOMSHR_io_acquire_bits_addr_block;
  wire[1:0] IOMSHR_io_acquire_bits_client_xact_id;
  wire[1:0] IOMSHR_io_acquire_bits_addr_beat;
  wire IOMSHR_io_acquire_bits_is_builtin_type;
  wire[2:0] IOMSHR_io_acquire_bits_a_type;
  wire[16:0] IOMSHR_io_acquire_bits_union;
  wire[127:0] IOMSHR_io_acquire_bits_data;
  wire IOMSHR_io_resp_valid;
  wire[39:0] IOMSHR_io_resp_bits_addr;
  wire[8:0] IOMSHR_io_resp_bits_tag;
  wire[4:0] IOMSHR_io_resp_bits_cmd;
  wire[2:0] IOMSHR_io_resp_bits_typ;
  wire[63:0] IOMSHR_io_resp_bits_data;
  wire IOMSHR_io_resp_bits_nack;
  wire IOMSHR_io_resp_bits_replay;
  wire IOMSHR_io_resp_bits_has_data;
  wire[63:0] IOMSHR_io_resp_bits_store_data;
  wire MSHR_io_req_pri_rdy;
  wire MSHR_io_req_sec_rdy;
  wire MSHR_io_idx_match;
  wire[19:0] MSHR_io_tag;
  wire MSHR_io_mem_req_valid;
  wire[25:0] MSHR_io_mem_req_bits_addr_block;
  wire[1:0] MSHR_io_mem_req_bits_client_xact_id;
  wire[1:0] MSHR_io_mem_req_bits_addr_beat;
  wire MSHR_io_mem_req_bits_is_builtin_type;
  wire[2:0] MSHR_io_mem_req_bits_a_type;
  wire[16:0] MSHR_io_mem_req_bits_union;
  wire[127:0] MSHR_io_mem_req_bits_data;
  wire[3:0] MSHR_io_refill_way_en;
  wire[11:0] MSHR_io_refill_addr;
  wire MSHR_io_meta_read_valid;
  wire[5:0] MSHR_io_meta_read_bits_idx;
  wire[19:0] MSHR_io_meta_read_bits_tag;
  wire MSHR_io_meta_write_valid;
  wire[5:0] MSHR_io_meta_write_bits_idx;
  wire[3:0] MSHR_io_meta_write_bits_way_en;
  wire[19:0] MSHR_io_meta_write_bits_data_tag;
  wire[1:0] MSHR_io_meta_write_bits_data_coh_state;
  wire MSHR_io_replay_valid;
  wire[39:0] MSHR_io_replay_bits_addr;
  wire[8:0] MSHR_io_replay_bits_tag;
  wire[4:0] MSHR_io_replay_bits_cmd;
  wire[2:0] MSHR_io_replay_bits_typ;
  wire MSHR_io_replay_bits_kill;
  wire MSHR_io_replay_bits_phys;
  wire[4:0] MSHR_io_replay_bits_sdq_id;
  wire MSHR_io_wb_req_valid;
  wire[1:0] MSHR_io_wb_req_bits_addr_beat;
  wire[25:0] MSHR_io_wb_req_bits_addr_block;
  wire[1:0] MSHR_io_wb_req_bits_client_xact_id;
  wire MSHR_io_wb_req_bits_voluntary;
  wire[2:0] MSHR_io_wb_req_bits_r_type;
  wire[127:0] MSHR_io_wb_req_bits_data;
  wire[3:0] MSHR_io_wb_req_bits_way_en;
  wire MSHR_io_probe_rdy;
  wire MSHR_1_io_req_pri_rdy;
  wire MSHR_1_io_req_sec_rdy;
  wire MSHR_1_io_idx_match;
  wire[19:0] MSHR_1_io_tag;
  wire MSHR_1_io_mem_req_valid;
  wire[25:0] MSHR_1_io_mem_req_bits_addr_block;
  wire[1:0] MSHR_1_io_mem_req_bits_client_xact_id;
  wire[1:0] MSHR_1_io_mem_req_bits_addr_beat;
  wire MSHR_1_io_mem_req_bits_is_builtin_type;
  wire[2:0] MSHR_1_io_mem_req_bits_a_type;
  wire[16:0] MSHR_1_io_mem_req_bits_union;
  wire[127:0] MSHR_1_io_mem_req_bits_data;
  wire[3:0] MSHR_1_io_refill_way_en;
  wire[11:0] MSHR_1_io_refill_addr;
  wire MSHR_1_io_meta_read_valid;
  wire[5:0] MSHR_1_io_meta_read_bits_idx;
  wire[19:0] MSHR_1_io_meta_read_bits_tag;
  wire MSHR_1_io_meta_write_valid;
  wire[5:0] MSHR_1_io_meta_write_bits_idx;
  wire[3:0] MSHR_1_io_meta_write_bits_way_en;
  wire[19:0] MSHR_1_io_meta_write_bits_data_tag;
  wire[1:0] MSHR_1_io_meta_write_bits_data_coh_state;
  wire MSHR_1_io_replay_valid;
  wire[39:0] MSHR_1_io_replay_bits_addr;
  wire[8:0] MSHR_1_io_replay_bits_tag;
  wire[4:0] MSHR_1_io_replay_bits_cmd;
  wire[2:0] MSHR_1_io_replay_bits_typ;
  wire MSHR_1_io_replay_bits_kill;
  wire MSHR_1_io_replay_bits_phys;
  wire[4:0] MSHR_1_io_replay_bits_sdq_id;
  wire MSHR_1_io_wb_req_valid;
  wire[1:0] MSHR_1_io_wb_req_bits_addr_beat;
  wire[25:0] MSHR_1_io_wb_req_bits_addr_block;
  wire[1:0] MSHR_1_io_wb_req_bits_client_xact_id;
  wire MSHR_1_io_wb_req_bits_voluntary;
  wire[2:0] MSHR_1_io_wb_req_bits_r_type;
  wire[127:0] MSHR_1_io_wb_req_bits_data;
  wire[3:0] MSHR_1_io_wb_req_bits_way_en;
  wire MSHR_1_io_probe_rdy;

  assign T0 = io_mem_grant_valid & T1;
  assign T1 = io_mem_grant_bits_client_xact_id == 2'h2;
  assign T2 = io_req_valid & T3;
  assign T3 = cacheable ^ 1'h1;
  assign cacheable = io_req_bits_addr < 40'h100000000;
  assign T4 = io_mem_grant_valid & T5;
  assign T5 = io_mem_grant_bits_client_xact_id == 2'h1;
  assign T111 = T150 ? 1'h0 : T112;
  assign T112 = T149 ? 1'h1 : T113;
  assign T113 = T148 ? 2'h2 : T114;
  assign T114 = T147 ? 2'h3 : T115;
  assign T115 = T146 ? 3'h4 : T116;
  assign T116 = T145 ? 3'h5 : T117;
  assign T117 = T144 ? 3'h6 : T118;
  assign T118 = T143 ? 3'h7 : T119;
  assign T119 = T142 ? 4'h8 : T120;
  assign T120 = T141 ? 4'h9 : T121;
  assign T121 = T140 ? 4'ha : T122;
  assign T122 = T139 ? 4'hb : T123;
  assign T123 = T138 ? 4'hc : T124;
  assign T124 = T137 ? 4'hd : T125;
  assign T125 = T136 ? 4'he : T126;
  assign T126 = T127 ? 4'hf : 5'h10;
  assign T127 = T6[4'hf];
  assign T6 = ~ T7;
  assign T7 = sdq_val;
  assign T128 = T129[5'h10:1'h0];
  assign T129 = reset ? 32'h0 : T8;
  assign T8 = T70 ? T9 : T130;
  assign T130 = {15'h0, sdq_val};
  assign T9 = T57 | T131;
  assign T131 = {15'h0, T10};
  assign T10 = T21 & T11;
  assign T11 = 17'h0 - T132;
  assign T132 = {16'h0, sdq_enq};
  assign sdq_enq = T19 & T12;
  assign T12 = T16 | T13;
  assign T13 = T15 | T14;
  assign T14 = io_req_bits_cmd == 5'h4;
  assign T15 = io_req_bits_cmd[2'h3];
  assign T16 = T18 | T17;
  assign T17 = io_req_bits_cmd == 5'h7;
  assign T18 = io_req_bits_cmd == 5'h1;
  assign T19 = T20 & cacheable;
  assign T20 = io_req_valid & io_req_ready;
  assign T21 = T56 ? 17'h1 : T22;
  assign T22 = T55 ? 17'h2 : T23;
  assign T23 = T54 ? 17'h4 : T24;
  assign T24 = T53 ? 17'h8 : T25;
  assign T25 = T52 ? 17'h10 : T26;
  assign T26 = T51 ? 17'h20 : T27;
  assign T27 = T50 ? 17'h40 : T28;
  assign T28 = T49 ? 17'h80 : T29;
  assign T29 = T48 ? 17'h100 : T30;
  assign T30 = T47 ? 17'h200 : T31;
  assign T31 = T46 ? 17'h400 : T32;
  assign T32 = T45 ? 17'h800 : T33;
  assign T33 = T44 ? 17'h1000 : T34;
  assign T34 = T43 ? 17'h2000 : T35;
  assign T35 = T42 ? 17'h4000 : T36;
  assign T36 = T41 ? 17'h8000 : T37;
  assign T37 = T38 ? 17'h10000 : 17'h0;
  assign T38 = T39[5'h10];
  assign T39 = ~ T40;
  assign T40 = sdq_val;
  assign T41 = T39[4'hf];
  assign T42 = T39[4'he];
  assign T43 = T39[4'hd];
  assign T44 = T39[4'hc];
  assign T45 = T39[4'hb];
  assign T46 = T39[4'ha];
  assign T47 = T39[4'h9];
  assign T48 = T39[4'h8];
  assign T49 = T39[3'h7];
  assign T50 = T39[3'h6];
  assign T51 = T39[3'h5];
  assign T52 = T39[3'h4];
  assign T53 = T39[2'h3];
  assign T54 = T39[2'h2];
  assign T55 = T39[1'h1];
  assign T56 = T39[1'h0];
  assign T57 = T135 & T58;
  assign T58 = ~ T59;
  assign T59 = T69 & T133;
  assign T133 = {15'h0, T60};
  assign T60 = 17'h0 - T134;
  assign T134 = {16'h0, free_sdq};
  assign free_sdq = T68 & T61;
  assign T61 = T65 | T62;
  assign T62 = T64 | T63;
  assign T63 = io_replay_bits_cmd == 5'h4;
  assign T64 = io_replay_bits_cmd[2'h3];
  assign T65 = T67 | T66;
  assign T66 = io_replay_bits_cmd == 5'h7;
  assign T67 = io_replay_bits_cmd == 5'h1;
  assign T68 = io_replay_ready & io_replay_valid;
  assign T69 = 1'h1 << replay_arb_io_out_bits_sdq_id;
  assign T135 = {15'h0, sdq_val};
  assign T70 = io_replay_valid | sdq_enq;
  assign T136 = T6[4'he];
  assign T137 = T6[4'hd];
  assign T138 = T6[4'hc];
  assign T139 = T6[4'hb];
  assign T140 = T6[4'ha];
  assign T141 = T6[4'h9];
  assign T142 = T6[4'h8];
  assign T143 = T6[3'h7];
  assign T144 = T6[3'h6];
  assign T145 = T6[3'h5];
  assign T146 = T6[3'h4];
  assign T147 = T6[2'h3];
  assign T148 = T6[2'h2];
  assign T149 = T6[1'h1];
  assign T150 = T6[1'h0];
  assign T71 = T76 & tag_match;
  assign tag_match = T151 == T72;
  assign T72 = io_req_bits_addr >> 4'hc;
  assign T151 = {8'h0, T73};
  assign T73 = T75 | T74;
  assign T74 = idxMatch_1 ? tagList_1 : 20'h0;
  assign tagList_1 = MSHR_1_io_tag;
  assign idxMatch_1 = MSHR_1_io_idx_match;
  assign T75 = idxMatch_0 ? tagList_0 : 20'h0;
  assign tagList_0 = MSHR_io_tag;
  assign idxMatch_0 = MSHR_io_idx_match;
  assign T76 = io_req_valid & sdq_rdy;
  assign sdq_rdy = T77 ^ 1'h1;
  assign T77 = sdq_val == 17'h1ffff;
  assign T78 = io_mem_grant_valid & T79;
  assign T79 = io_mem_grant_bits_client_xact_id == 2'h0;
  assign T80 = T81 & tag_match;
  assign T81 = io_req_valid & sdq_rdy;
  assign T82 = T84 & T83;
  assign T83 = idx_match ^ 1'h1;
  assign idx_match = MSHR_io_idx_match | MSHR_1_io_idx_match;
  assign T84 = T85 & cacheable;
  assign T85 = io_req_valid & sdq_rdy;
  assign io_fence_rdy = T86;
  assign T86 = T91 ? 1'h0 : T87;
  assign T87 = T90 ? 1'h0 : T88;
  assign T88 = T89 == 1'h0;
  assign T89 = MSHR_io_req_pri_rdy ^ 1'h1;
  assign T90 = MSHR_1_io_req_pri_rdy ^ 1'h1;
  assign T91 = IOMSHR_io_req_ready ^ 1'h1;
  assign io_probe_rdy = T92;
  assign T92 = T95 ? 1'h0 : T93;
  assign T93 = T94 == 1'h0;
  assign T94 = MSHR_io_probe_rdy ^ 1'h1;
  assign T95 = MSHR_1_io_probe_rdy ^ 1'h1;
  assign io_wb_req_bits_way_en = wb_req_arb_io_out_bits_way_en;
  assign io_wb_req_bits_data = wb_req_arb_io_out_bits_data;
  assign io_wb_req_bits_r_type = wb_req_arb_io_out_bits_r_type;
  assign io_wb_req_bits_voluntary = wb_req_arb_io_out_bits_voluntary;
  assign io_wb_req_bits_client_xact_id = wb_req_arb_io_out_bits_client_xact_id;
  assign io_wb_req_bits_addr_block = wb_req_arb_io_out_bits_addr_block;
  assign io_wb_req_bits_addr_beat = wb_req_arb_io_out_bits_addr_beat;
  assign io_wb_req_valid = wb_req_arb_io_out_valid;
  assign io_replay_bits_data = T96;
  assign T96 = sdq[R101];
  assign T98 = sdq_enq & T99;
  assign T99 = T100 < 5'h11;
  assign T100 = T111;
  assign T102 = free_sdq ? replay_arb_io_out_bits_sdq_id : R101;
  assign io_replay_bits_phys = replay_arb_io_out_bits_phys;
  assign io_replay_bits_kill = replay_arb_io_out_bits_kill;
  assign io_replay_bits_typ = replay_arb_io_out_bits_typ;
  assign io_replay_bits_cmd = replay_arb_io_out_bits_cmd;
  assign io_replay_bits_tag = replay_arb_io_out_bits_tag;
  assign io_replay_bits_addr = replay_arb_io_out_bits_addr;
  assign io_replay_valid = replay_arb_io_out_valid;
  assign io_meta_write_bits_data_coh_state = meta_write_arb_io_out_bits_data_coh_state;
  assign io_meta_write_bits_data_tag = meta_write_arb_io_out_bits_data_tag;
  assign io_meta_write_bits_way_en = meta_write_arb_io_out_bits_way_en;
  assign io_meta_write_bits_idx = meta_write_arb_io_out_bits_idx;
  assign io_meta_write_valid = meta_write_arb_io_out_valid;
  assign io_meta_read_bits_tag = meta_read_arb_io_out_bits_tag;
  assign io_meta_read_bits_way_en = meta_read_arb_io_out_bits_way_en;
  assign io_meta_read_bits_idx = meta_read_arb_io_out_bits_idx;
  assign io_meta_read_valid = meta_read_arb_io_out_valid;
  assign io_refill_addr = T103;
  assign T103 = T104 ? refillMux_1_addr : refillMux_0_addr;
  assign refillMux_0_addr = MSHR_io_refill_addr;
  assign refillMux_1_addr = MSHR_1_io_refill_addr;
  assign T104 = T152;
  assign T152 = io_mem_grant_bits_client_xact_id[1'h0];
  assign io_refill_way_en = T105;
  assign T105 = T104 ? refillMux_1_way_en : refillMux_0_way_en;
  assign refillMux_0_way_en = MSHR_io_refill_way_en;
  assign refillMux_1_way_en = MSHR_1_io_refill_way_en;
  assign io_mem_req_bits_data = mem_req_arb_io_out_bits_data;
  assign io_mem_req_bits_union = mem_req_arb_io_out_bits_union;
  assign io_mem_req_bits_a_type = mem_req_arb_io_out_bits_a_type;
  assign io_mem_req_bits_is_builtin_type = mem_req_arb_io_out_bits_is_builtin_type;
  assign io_mem_req_bits_addr_beat = mem_req_arb_io_out_bits_addr_beat;
  assign io_mem_req_bits_client_xact_id = mem_req_arb_io_out_bits_client_xact_id;
  assign io_mem_req_bits_addr_block = mem_req_arb_io_out_bits_addr_block;
  assign io_mem_req_valid = mem_req_arb_io_out_valid;
  assign io_secondary_miss = idx_match;
  assign io_resp_bits_store_data = resp_arb_io_out_bits_store_data;
  assign io_resp_bits_data_word_bypass = resp_arb_io_out_bits_data_word_bypass;
  assign io_resp_bits_has_data = resp_arb_io_out_bits_has_data;
  assign io_resp_bits_replay = resp_arb_io_out_bits_replay;
  assign io_resp_bits_nack = resp_arb_io_out_bits_nack;
  assign io_resp_bits_data = resp_arb_io_out_bits_data;
  assign io_resp_bits_typ = resp_arb_io_out_bits_typ;
  assign io_resp_bits_cmd = resp_arb_io_out_bits_cmd;
  assign io_resp_bits_tag = resp_arb_io_out_bits_tag;
  assign io_resp_bits_addr = resp_arb_io_out_bits_addr;
  assign io_resp_valid = resp_arb_io_out_valid;
  assign io_req_ready = T106;
  assign T106 = T110 ? IOMSHR_io_req_ready : T107;
  assign T107 = T108 & sdq_rdy;
  assign T108 = idx_match ? T109 : pri_rdy;
  assign pri_rdy = MSHR_io_req_pri_rdy | MSHR_1_io_req_pri_rdy;
  assign T109 = tag_match & sec_rdy;
  assign sec_rdy = MSHR_io_req_sec_rdy | MSHR_1_io_req_sec_rdy;
  assign T110 = cacheable ^ 1'h1;
  Arbiter_6 meta_read_arb(
       .io_in_1_ready( meta_read_arb_io_in_1_ready ),
       .io_in_1_valid( MSHR_1_io_meta_read_valid ),
       .io_in_1_bits_idx( MSHR_1_io_meta_read_bits_idx ),
       .io_in_1_bits_way_en(  ),
       .io_in_1_bits_tag( MSHR_1_io_meta_read_bits_tag ),
       .io_in_0_ready( meta_read_arb_io_in_0_ready ),
       .io_in_0_valid( MSHR_io_meta_read_valid ),
       .io_in_0_bits_idx( MSHR_io_meta_read_bits_idx ),
       .io_in_0_bits_way_en(  ),
       .io_in_0_bits_tag( MSHR_io_meta_read_bits_tag ),
       .io_out_ready( io_meta_read_ready ),
       .io_out_valid( meta_read_arb_io_out_valid ),
       .io_out_bits_idx( meta_read_arb_io_out_bits_idx ),
       .io_out_bits_way_en( meta_read_arb_io_out_bits_way_en ),
       .io_out_bits_tag( meta_read_arb_io_out_bits_tag),
       .io_chosen(  )
  );

  mprcArbiter_1 meta_write_arb(
       .io_in_1_ready( meta_write_arb_io_in_1_ready ),
       .io_in_1_valid( MSHR_1_io_meta_write_valid ),
       .io_in_1_bits_idx( MSHR_1_io_meta_write_bits_idx ),
       .io_in_1_bits_way_en( MSHR_1_io_meta_write_bits_way_en ),
       .io_in_1_bits_data_tag( MSHR_1_io_meta_write_bits_data_tag ),
       .io_in_1_bits_data_coh_state( MSHR_1_io_meta_write_bits_data_coh_state ),
       .io_in_0_ready( meta_write_arb_io_in_0_ready ),
       .io_in_0_valid( MSHR_io_meta_write_valid ),
       .io_in_0_bits_idx( MSHR_io_meta_write_bits_idx ),
       .io_in_0_bits_way_en( MSHR_io_meta_write_bits_way_en ),
       .io_in_0_bits_data_tag( MSHR_io_meta_write_bits_data_tag ),
       .io_in_0_bits_data_coh_state( MSHR_io_meta_write_bits_data_coh_state ),
       .io_out_ready( io_meta_write_ready ),
       .io_out_valid( meta_write_arb_io_out_valid ),
       .io_out_bits_idx( meta_write_arb_io_out_bits_idx ),
       .io_out_bits_way_en( meta_write_arb_io_out_bits_way_en ),
       .io_out_bits_data_tag( meta_write_arb_io_out_bits_data_tag ),
       .io_out_bits_data_coh_state( meta_write_arb_io_out_bits_data_coh_state ),
       .io_chosen(  )
  );
  mprcLockingArbiter_1 mem_req_arb(.clk(clk), .reset(reset),
       .io_in_2_ready( mem_req_arb_io_in_2_ready ),
       .io_in_2_valid( IOMSHR_io_acquire_valid ),
       .io_in_2_bits_addr_block( IOMSHR_io_acquire_bits_addr_block ),
       .io_in_2_bits_client_xact_id( IOMSHR_io_acquire_bits_client_xact_id ),
       .io_in_2_bits_addr_beat( IOMSHR_io_acquire_bits_addr_beat ),
       .io_in_2_bits_is_builtin_type( IOMSHR_io_acquire_bits_is_builtin_type ),
       .io_in_2_bits_a_type( IOMSHR_io_acquire_bits_a_type ),
       .io_in_2_bits_union( IOMSHR_io_acquire_bits_union ),
       .io_in_2_bits_data( IOMSHR_io_acquire_bits_data ),
       .io_in_1_ready( mem_req_arb_io_in_1_ready ),
       .io_in_1_valid( MSHR_1_io_mem_req_valid ),
       .io_in_1_bits_addr_block( MSHR_1_io_mem_req_bits_addr_block ),
       .io_in_1_bits_client_xact_id( MSHR_1_io_mem_req_bits_client_xact_id ),
       .io_in_1_bits_addr_beat( MSHR_1_io_mem_req_bits_addr_beat ),
       .io_in_1_bits_is_builtin_type( MSHR_1_io_mem_req_bits_is_builtin_type ),
       .io_in_1_bits_a_type( MSHR_1_io_mem_req_bits_a_type ),
       .io_in_1_bits_union( MSHR_1_io_mem_req_bits_union ),
       .io_in_1_bits_data( MSHR_1_io_mem_req_bits_data ),
       .io_in_0_ready( mem_req_arb_io_in_0_ready ),
       .io_in_0_valid( MSHR_io_mem_req_valid ),
       .io_in_0_bits_addr_block( MSHR_io_mem_req_bits_addr_block ),
       .io_in_0_bits_client_xact_id( MSHR_io_mem_req_bits_client_xact_id ),
       .io_in_0_bits_addr_beat( MSHR_io_mem_req_bits_addr_beat ),
       .io_in_0_bits_is_builtin_type( MSHR_io_mem_req_bits_is_builtin_type ),
       .io_in_0_bits_a_type( MSHR_io_mem_req_bits_a_type ),
       .io_in_0_bits_union( MSHR_io_mem_req_bits_union ),
       .io_in_0_bits_data( MSHR_io_mem_req_bits_data ),
       .io_out_ready( io_mem_req_ready ),
       .io_out_valid( mem_req_arb_io_out_valid ),
       .io_out_bits_addr_block( mem_req_arb_io_out_bits_addr_block ),
       .io_out_bits_client_xact_id( mem_req_arb_io_out_bits_client_xact_id ),
       .io_out_bits_addr_beat( mem_req_arb_io_out_bits_addr_beat ),
       .io_out_bits_is_builtin_type( mem_req_arb_io_out_bits_is_builtin_type ),
       .io_out_bits_a_type( mem_req_arb_io_out_bits_a_type ),
       .io_out_bits_union( mem_req_arb_io_out_bits_union ),
       .io_out_bits_data( mem_req_arb_io_out_bits_data ),
       .io_chosen(  )
  );
  mprcArbiter_4 wb_req_arb(
       .io_in_1_ready( wb_req_arb_io_in_1_ready ),
       .io_in_1_valid( MSHR_1_io_wb_req_valid ),
       .io_in_1_bits_addr_beat( MSHR_1_io_wb_req_bits_addr_beat ),
       .io_in_1_bits_addr_block( MSHR_1_io_wb_req_bits_addr_block ),
       .io_in_1_bits_client_xact_id( MSHR_1_io_wb_req_bits_client_xact_id ),
       .io_in_1_bits_voluntary( MSHR_1_io_wb_req_bits_voluntary ),
       .io_in_1_bits_r_type( MSHR_1_io_wb_req_bits_r_type ),
       .io_in_1_bits_data( MSHR_1_io_wb_req_bits_data ),
       .io_in_1_bits_way_en( MSHR_1_io_wb_req_bits_way_en ),
       .io_in_0_ready( wb_req_arb_io_in_0_ready ),
       .io_in_0_valid( MSHR_io_wb_req_valid ),
       .io_in_0_bits_addr_beat( MSHR_io_wb_req_bits_addr_beat ),
       .io_in_0_bits_addr_block( MSHR_io_wb_req_bits_addr_block ),
       .io_in_0_bits_client_xact_id( MSHR_io_wb_req_bits_client_xact_id ),
       .io_in_0_bits_voluntary( MSHR_io_wb_req_bits_voluntary ),
       .io_in_0_bits_r_type( MSHR_io_wb_req_bits_r_type ),
       .io_in_0_bits_data( MSHR_io_wb_req_bits_data ),
       .io_in_0_bits_way_en( MSHR_io_wb_req_bits_way_en ),
       .io_out_ready( io_wb_req_ready ),
       .io_out_valid( wb_req_arb_io_out_valid ),
       .io_out_bits_addr_beat( wb_req_arb_io_out_bits_addr_beat ),
       .io_out_bits_addr_block( wb_req_arb_io_out_bits_addr_block ),
       .io_out_bits_client_xact_id( wb_req_arb_io_out_bits_client_xact_id ),
       .io_out_bits_voluntary( wb_req_arb_io_out_bits_voluntary ),
       .io_out_bits_r_type( wb_req_arb_io_out_bits_r_type ),
       .io_out_bits_data( wb_req_arb_io_out_bits_data ),
       .io_out_bits_way_en( wb_req_arb_io_out_bits_way_en ),
       .io_chosen(  )
  );
  mprcArbiter_7 replay_arb(
       .io_in_1_ready( replay_arb_io_in_1_ready ),
       .io_in_1_valid( MSHR_1_io_replay_valid ),
       .io_in_1_bits_addr( MSHR_1_io_replay_bits_addr ),
       .io_in_1_bits_tag( MSHR_1_io_replay_bits_tag ),
       .io_in_1_bits_cmd( MSHR_1_io_replay_bits_cmd ),
       .io_in_1_bits_typ( MSHR_1_io_replay_bits_typ ),
       .io_in_1_bits_kill( MSHR_1_io_replay_bits_kill ),
       .io_in_1_bits_phys( MSHR_1_io_replay_bits_phys ),
       .io_in_1_bits_sdq_id( MSHR_1_io_replay_bits_sdq_id ),
       .io_in_0_ready( replay_arb_io_in_0_ready ),
       .io_in_0_valid( MSHR_io_replay_valid ),
       .io_in_0_bits_addr( MSHR_io_replay_bits_addr ),
       .io_in_0_bits_tag( MSHR_io_replay_bits_tag ),
       .io_in_0_bits_cmd( MSHR_io_replay_bits_cmd ),
       .io_in_0_bits_typ( MSHR_io_replay_bits_typ ),
       .io_in_0_bits_kill( MSHR_io_replay_bits_kill ),
       .io_in_0_bits_phys( MSHR_io_replay_bits_phys ),
       .io_in_0_bits_sdq_id( MSHR_io_replay_bits_sdq_id ),
       .io_out_ready( io_replay_ready ),
       .io_out_valid( replay_arb_io_out_valid ),
       .io_out_bits_addr( replay_arb_io_out_bits_addr ),
       .io_out_bits_tag( replay_arb_io_out_bits_tag ),
       .io_out_bits_cmd( replay_arb_io_out_bits_cmd ),
       .io_out_bits_typ( replay_arb_io_out_bits_typ ),
       .io_out_bits_kill( replay_arb_io_out_bits_kill ),
       .io_out_bits_phys( replay_arb_io_out_bits_phys ),
       .io_out_bits_sdq_id( replay_arb_io_out_bits_sdq_id ),
       .io_chosen(  )
  );
  mprcArbiter_8 alloc_arb(
       .io_in_1_ready( alloc_arb_io_in_1_ready ),
       .io_in_1_valid( MSHR_1_io_req_pri_rdy ),
       .io_in_1_bits(  ),
       .io_in_0_ready( alloc_arb_io_in_0_ready ),
       .io_in_0_valid( MSHR_io_req_pri_rdy ),
       .io_in_0_bits(  ),
       .io_out_ready( T82 ),
       .io_out_valid(  ),
       .io_out_bits(  ),
       .io_chosen(  )
  );

  mprcMSHR #(.client_xact_id(0)) MSHR_0(.clk(clk), .reset(reset),
       .io_req_pri_val( alloc_arb_io_in_0_ready ),
       .io_req_pri_rdy( MSHR_io_req_pri_rdy ),
       .io_req_sec_val( T80 ),
       .io_req_sec_rdy( MSHR_io_req_sec_rdy ),
       .io_req_bits_addr( io_req_bits_addr ),
       .io_req_bits_tag( io_req_bits_tag ),
       .io_req_bits_cmd( io_req_bits_cmd ),
       .io_req_bits_typ( io_req_bits_typ ),
       .io_req_bits_kill( io_req_bits_kill ),
       .io_req_bits_phys( io_req_bits_phys ),
       .io_req_bits_sdq_id( T111 ),
       .io_req_bits_tag_match( io_req_bits_tag_match ),
       .io_req_bits_old_meta_tag( io_req_bits_old_meta_tag ),
       .io_req_bits_old_meta_coh_state( io_req_bits_old_meta_coh_state ),
       .io_req_bits_way_en( io_req_bits_way_en ),
       .io_idx_match( MSHR_io_idx_match ),
       .io_tag( MSHR_io_tag ),
       .io_mem_req_ready( mem_req_arb_io_in_0_ready ),
       .io_mem_req_valid( MSHR_io_mem_req_valid ),
       .io_mem_req_bits_addr_block( MSHR_io_mem_req_bits_addr_block ),
       .io_mem_req_bits_client_xact_id( MSHR_io_mem_req_bits_client_xact_id ),
       .io_mem_req_bits_addr_beat( MSHR_io_mem_req_bits_addr_beat ),
       .io_mem_req_bits_is_builtin_type( MSHR_io_mem_req_bits_is_builtin_type ),
       .io_mem_req_bits_a_type( MSHR_io_mem_req_bits_a_type ),
       .io_mem_req_bits_union( MSHR_io_mem_req_bits_union ),
       .io_mem_req_bits_data( MSHR_io_mem_req_bits_data ),
       .io_refill_way_en( MSHR_io_refill_way_en ),
       .io_refill_addr( MSHR_io_refill_addr ),
       .io_meta_read_ready( meta_read_arb_io_in_0_ready ),
       .io_meta_read_valid( MSHR_io_meta_read_valid ),
       .io_meta_read_bits_idx( MSHR_io_meta_read_bits_idx ),
       .io_meta_read_bits_tag( MSHR_io_meta_read_bits_tag ),
       .io_meta_write_ready( meta_write_arb_io_in_0_ready ),
       .io_meta_write_valid( MSHR_io_meta_write_valid ),
       .io_meta_write_bits_idx( MSHR_io_meta_write_bits_idx ),
       .io_meta_write_bits_way_en( MSHR_io_meta_write_bits_way_en ),
       .io_meta_write_bits_data_tag( MSHR_io_meta_write_bits_data_tag ),
       .io_meta_write_bits_data_coh_state( MSHR_io_meta_write_bits_data_coh_state ),
       .io_replay_ready( replay_arb_io_in_0_ready ),
       .io_replay_valid( MSHR_io_replay_valid ),
       .io_replay_bits_addr( MSHR_io_replay_bits_addr ),
       .io_replay_bits_tag( MSHR_io_replay_bits_tag ),
       .io_replay_bits_cmd( MSHR_io_replay_bits_cmd ),
       .io_replay_bits_typ( MSHR_io_replay_bits_typ ),
       .io_replay_bits_kill( MSHR_io_replay_bits_kill ),
       .io_replay_bits_phys( MSHR_io_replay_bits_phys ),
       .io_replay_bits_sdq_id( MSHR_io_replay_bits_sdq_id ),
       .io_mem_grant_valid( T78 ),
       .io_mem_grant_bits_addr_beat( io_mem_grant_bits_addr_beat ),
       .io_mem_grant_bits_client_xact_id( io_mem_grant_bits_client_xact_id ),
       .io_mem_grant_bits_manager_xact_id( io_mem_grant_bits_manager_xact_id ),
       .io_mem_grant_bits_is_builtin_type( io_mem_grant_bits_is_builtin_type ),
       .io_mem_grant_bits_g_type( io_mem_grant_bits_g_type ),
       .io_mem_grant_bits_data( io_mem_grant_bits_data ),
       .io_wb_req_ready( wb_req_arb_io_in_0_ready ),
       .io_wb_req_valid( MSHR_io_wb_req_valid ),
       .io_wb_req_bits_addr_beat( MSHR_io_wb_req_bits_addr_beat ),
       .io_wb_req_bits_addr_block( MSHR_io_wb_req_bits_addr_block ),
       .io_wb_req_bits_client_xact_id( MSHR_io_wb_req_bits_client_xact_id ),
       .io_wb_req_bits_voluntary( MSHR_io_wb_req_bits_voluntary ),
       .io_wb_req_bits_r_type( MSHR_io_wb_req_bits_r_type ),
       .io_wb_req_bits_data( MSHR_io_wb_req_bits_data ),
       .io_wb_req_bits_way_en( MSHR_io_wb_req_bits_way_en ),
       .io_probe_rdy( MSHR_io_probe_rdy ),
       
       
       .io_mem_release_valid(io_mem_release_valid),
       .io_mem_release_bits_addr_beat(io_mem_release_bits_addr_beat)
  );
   mprcMSHR #(.client_xact_id(1)) MSHR_1(.clk(clk), .reset(reset),
       .io_req_pri_val( alloc_arb_io_in_1_ready ),
       .io_req_pri_rdy( MSHR_1_io_req_pri_rdy ),
       .io_req_sec_val( T71 ),
       .io_req_sec_rdy( MSHR_1_io_req_sec_rdy ),
       .io_req_bits_addr( io_req_bits_addr ),
       .io_req_bits_tag( io_req_bits_tag ),
       .io_req_bits_cmd( io_req_bits_cmd ),
       .io_req_bits_typ( io_req_bits_typ ),
       .io_req_bits_kill( io_req_bits_kill ),
       .io_req_bits_phys( io_req_bits_phys ),
       .io_req_bits_sdq_id( T111 ),
       .io_req_bits_tag_match( io_req_bits_tag_match ),
       .io_req_bits_old_meta_tag( io_req_bits_old_meta_tag ),
       .io_req_bits_old_meta_coh_state( io_req_bits_old_meta_coh_state ),
       .io_req_bits_way_en( io_req_bits_way_en ),
       .io_idx_match( MSHR_1_io_idx_match ),
       .io_tag( MSHR_1_io_tag ),
       .io_mem_req_ready( mem_req_arb_io_in_1_ready ),
       .io_mem_req_valid( MSHR_1_io_mem_req_valid ),
       .io_mem_req_bits_addr_block( MSHR_1_io_mem_req_bits_addr_block ),
       .io_mem_req_bits_client_xact_id( MSHR_1_io_mem_req_bits_client_xact_id ),
       .io_mem_req_bits_addr_beat( MSHR_1_io_mem_req_bits_addr_beat ),
       .io_mem_req_bits_is_builtin_type( MSHR_1_io_mem_req_bits_is_builtin_type ),
       .io_mem_req_bits_a_type( MSHR_1_io_mem_req_bits_a_type ),
       .io_mem_req_bits_union( MSHR_1_io_mem_req_bits_union ),
       .io_mem_req_bits_data( MSHR_1_io_mem_req_bits_data ),
       .io_refill_way_en( MSHR_1_io_refill_way_en ),
       .io_refill_addr( MSHR_1_io_refill_addr ),
       .io_meta_read_ready( meta_read_arb_io_in_1_ready ),
       .io_meta_read_valid( MSHR_1_io_meta_read_valid ),
       .io_meta_read_bits_idx( MSHR_1_io_meta_read_bits_idx ),
       .io_meta_read_bits_tag( MSHR_1_io_meta_read_bits_tag ),
       .io_meta_write_ready( meta_write_arb_io_in_1_ready ),
       .io_meta_write_valid( MSHR_1_io_meta_write_valid ),
       .io_meta_write_bits_idx( MSHR_1_io_meta_write_bits_idx ),
       .io_meta_write_bits_way_en( MSHR_1_io_meta_write_bits_way_en ),
       .io_meta_write_bits_data_tag( MSHR_1_io_meta_write_bits_data_tag ),
       .io_meta_write_bits_data_coh_state( MSHR_1_io_meta_write_bits_data_coh_state ),
       .io_replay_ready( replay_arb_io_in_1_ready ),
       .io_replay_valid( MSHR_1_io_replay_valid ),
       .io_replay_bits_addr( MSHR_1_io_replay_bits_addr ),
       .io_replay_bits_tag( MSHR_1_io_replay_bits_tag ),
       .io_replay_bits_cmd( MSHR_1_io_replay_bits_cmd ),
       .io_replay_bits_typ( MSHR_1_io_replay_bits_typ ),
       .io_replay_bits_kill( MSHR_1_io_replay_bits_kill ),
       .io_replay_bits_phys( MSHR_1_io_replay_bits_phys ),
       .io_replay_bits_sdq_id( MSHR_1_io_replay_bits_sdq_id ),
       .io_mem_grant_valid( T4 ),
       .io_mem_grant_bits_addr_beat( io_mem_grant_bits_addr_beat ),
       .io_mem_grant_bits_client_xact_id( io_mem_grant_bits_client_xact_id ),
       .io_mem_grant_bits_manager_xact_id( io_mem_grant_bits_manager_xact_id ),
       .io_mem_grant_bits_is_builtin_type( io_mem_grant_bits_is_builtin_type ),
       .io_mem_grant_bits_g_type( io_mem_grant_bits_g_type ),
       .io_mem_grant_bits_data( io_mem_grant_bits_data ),
       .io_wb_req_ready( wb_req_arb_io_in_1_ready ),
       .io_wb_req_valid( MSHR_1_io_wb_req_valid ),
       .io_wb_req_bits_addr_beat( MSHR_1_io_wb_req_bits_addr_beat ),
       .io_wb_req_bits_addr_block( MSHR_1_io_wb_req_bits_addr_block ),
       .io_wb_req_bits_client_xact_id( MSHR_1_io_wb_req_bits_client_xact_id ),
       .io_wb_req_bits_voluntary( MSHR_1_io_wb_req_bits_voluntary ),
       .io_wb_req_bits_r_type( MSHR_1_io_wb_req_bits_r_type ),
       .io_wb_req_bits_data( MSHR_1_io_wb_req_bits_data ),
       .io_wb_req_bits_way_en( MSHR_1_io_wb_req_bits_way_en ),
       .io_probe_rdy( MSHR_1_io_probe_rdy ),
       
       
       .io_mem_release_valid(io_mem_release_valid),
       .io_mem_release_bits_addr_beat(io_mem_release_bits_addr_beat)
  );
  mprcArbiter_9 mmio_alloc_arb(
       .io_in_0_ready( mmio_alloc_arb_io_in_0_ready ),
       .io_in_0_valid( IOMSHR_io_req_ready ),
       .io_in_0_bits(  ),
       .io_out_ready( T2 ),
       .io_out_valid(  ),
       .io_out_bits(  ),
       .io_chosen(  )
  );

  mprcArbiter_10 resp_arb(
       .io_in_0_ready( resp_arb_io_in_0_ready ),
       .io_in_0_valid( IOMSHR_io_resp_valid ),
       .io_in_0_bits_addr( IOMSHR_io_resp_bits_addr ),
       .io_in_0_bits_tag( IOMSHR_io_resp_bits_tag ),
       .io_in_0_bits_cmd( IOMSHR_io_resp_bits_cmd ),
       .io_in_0_bits_typ( IOMSHR_io_resp_bits_typ ),
       .io_in_0_bits_data( IOMSHR_io_resp_bits_data ),
       .io_in_0_bits_nack( IOMSHR_io_resp_bits_nack ),
       .io_in_0_bits_replay( IOMSHR_io_resp_bits_replay ),
       .io_in_0_bits_has_data( IOMSHR_io_resp_bits_has_data ),
       .io_in_0_bits_data_word_bypass(  ),
       .io_in_0_bits_store_data( IOMSHR_io_resp_bits_store_data ),
       .io_out_ready( io_resp_ready ),
       .io_out_valid( resp_arb_io_out_valid ),
       .io_out_bits_addr( resp_arb_io_out_bits_addr ),
       .io_out_bits_tag( resp_arb_io_out_bits_tag ),
       .io_out_bits_cmd( resp_arb_io_out_bits_cmd ),
       .io_out_bits_typ( resp_arb_io_out_bits_typ ),
       .io_out_bits_data( resp_arb_io_out_bits_data ),
       .io_out_bits_nack( resp_arb_io_out_bits_nack ),
       .io_out_bits_replay( resp_arb_io_out_bits_replay ),
       .io_out_bits_has_data( resp_arb_io_out_bits_has_data ),
       .io_out_bits_data_word_bypass( resp_arb_io_out_bits_data_word_bypass ),
       .io_out_bits_store_data( resp_arb_io_out_bits_store_data ),
       .io_chosen(  )
  );

  mprcIOMSHR IOMSHR(.clk(clk), .reset(reset),
       .io_req_ready( IOMSHR_io_req_ready ),
       .io_req_valid( mmio_alloc_arb_io_in_0_ready ),
       .io_req_bits_addr( io_req_bits_addr ),
       .io_req_bits_tag( io_req_bits_tag ),
       .io_req_bits_cmd( io_req_bits_cmd ),
       .io_req_bits_typ( io_req_bits_typ ),
       .io_req_bits_kill( io_req_bits_kill ),
       .io_req_bits_phys( io_req_bits_phys ),
       .io_req_bits_data( io_req_bits_data ),
       .io_acquire_ready( mem_req_arb_io_in_2_ready ),
       .io_acquire_valid( IOMSHR_io_acquire_valid ),
       .io_acquire_bits_addr_block( IOMSHR_io_acquire_bits_addr_block ),
       .io_acquire_bits_client_xact_id( IOMSHR_io_acquire_bits_client_xact_id ),
       .io_acquire_bits_addr_beat( IOMSHR_io_acquire_bits_addr_beat ),
       .io_acquire_bits_is_builtin_type( IOMSHR_io_acquire_bits_is_builtin_type ),
       .io_acquire_bits_a_type( IOMSHR_io_acquire_bits_a_type ),
       .io_acquire_bits_union( IOMSHR_io_acquire_bits_union ),
       .io_acquire_bits_data( IOMSHR_io_acquire_bits_data ),
       .io_grant_valid( T0 ),
       .io_grant_bits_addr_beat( io_mem_grant_bits_addr_beat ),
       .io_grant_bits_client_xact_id( io_mem_grant_bits_client_xact_id ),
       .io_grant_bits_manager_xact_id( io_mem_grant_bits_manager_xact_id ),
       .io_grant_bits_is_builtin_type( io_mem_grant_bits_is_builtin_type ),
       .io_grant_bits_g_type( io_mem_grant_bits_g_type ),
       .io_grant_bits_data( io_mem_grant_bits_data ),
       .io_resp_ready( resp_arb_io_in_0_ready ),
       .io_resp_valid( IOMSHR_io_resp_valid ),
       .io_resp_bits_addr( IOMSHR_io_resp_bits_addr ),
       .io_resp_bits_tag( IOMSHR_io_resp_bits_tag ),
       .io_resp_bits_cmd( IOMSHR_io_resp_bits_cmd ),
       .io_resp_bits_typ( IOMSHR_io_resp_bits_typ ),
       .io_resp_bits_data( IOMSHR_io_resp_bits_data ),
       .io_resp_bits_nack( IOMSHR_io_resp_bits_nack ),
       .io_resp_bits_replay( IOMSHR_io_resp_bits_replay ),
       .io_resp_bits_has_data( IOMSHR_io_resp_bits_has_data ),
       .io_resp_bits_store_data( IOMSHR_io_resp_bits_store_data )
  );

  always @(posedge clk) begin
    sdq_val <= T128;
    if (T98)
      sdq[T111] <= io_req_bits_data;
    if(free_sdq) begin
      R101 <= replay_arb_io_out_bits_sdq_id;
    end
  end
endmodule