module RocketCAM(input clk, input reset,
    input  io_clear,
    input [7:0] io_clear_mask,
    input [33:0] io_tag,
    output io_hit,
    output[7:0] io_hits,
    output[7:0] io_valid_bits,
    input  io_write,
    input [33:0] io_write_tag,
    input [2:0] io_write_addr
);

  reg [7:0] vb_array;
  wire[7:0] T44;
  wire[7:0] T0;
  wire[7:0] T1;
  wire[7:0] T2;
  wire[7:0] T3;
  wire[7:0] T4;
  wire[7:0] T45;
  wire T5;
  wire[7:0] T6;
  wire[7:0] T7;
  wire[7:0] T8;
  wire[7:0] T9;
  wire[7:0] T10;
  wire[7:0] T11;
  wire[3:0] T12;
  wire[1:0] T13;
  wire hits_0;
  wire T14;
  wire[33:0] T15;
  reg [33:0] cam_tags [7:0];
  wire[33:0] T16;
  wire T17;
  wire hits_1;
  wire T18;
  wire[33:0] T19;
  wire T20;
  wire[1:0] T21;
  wire hits_2;
  wire T22;
  wire[33:0] T23;
  wire T24;
  wire hits_3;
  wire T25;
  wire[33:0] T26;
  wire T27;
  wire[3:0] T28;
  wire[1:0] T29;
  wire hits_4;
  wire T30;
  wire[33:0] T31;
  wire T32;
  wire hits_5;
  wire T33;
  wire[33:0] T34;
  wire T35;
  wire[1:0] T36;
  wire hits_6;
  wire T37;
  wire[33:0] T38;
  wire T39;
  wire hits_7;
  wire T40;
  wire[33:0] T41;
  wire T42;
  wire T43;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    vb_array = {1{$random}};
    for (initvar = 0; initvar < 8; initvar = initvar+1)
      cam_tags[initvar] = {2{$random}};
  end
// synthesis translate_on
`endif

  assign io_valid_bits = vb_array;
  assign T44 = reset ? 8'h0 : T0;
  assign T0 = io_clear ? T8 : T1;
  assign T1 = io_write ? T2 : vb_array;
  assign T2 = T6 | T3;
  assign T3 = T45 & T4;
  assign T4 = 1'h1 << io_write_addr;
  assign T45 = T5 ? 8'hff : 8'h0;
  assign T5 = 1'h1;
  assign T6 = vb_array & T7;
  assign T7 = ~ T4;
  assign T8 = vb_array & T9;
  assign T9 = ~ io_clear_mask;
  assign io_hits = T10;
  assign T10 = T11;
  assign T11 = {T28, T12};
  assign T12 = {T21, T13};
  assign T13 = {hits_1, hits_0};
  assign hits_0 = T17 & T14;
  assign T14 = T15 == io_tag;
  assign T15 = cam_tags[3'h0];
  assign T17 = vb_array[1'h0];
  assign hits_1 = T20 & T18;
  assign T18 = T19 == io_tag;
  assign T19 = cam_tags[3'h1];
  assign T20 = vb_array[1'h1];
  assign T21 = {hits_3, hits_2};
  assign hits_2 = T24 & T22;
  assign T22 = T23 == io_tag;
  assign T23 = cam_tags[3'h2];
  assign T24 = vb_array[2'h2];
  assign hits_3 = T27 & T25;
  assign T25 = T26 == io_tag;
  assign T26 = cam_tags[3'h3];
  assign T27 = vb_array[2'h3];
  assign T28 = {T36, T29};
  assign T29 = {hits_5, hits_4};
  assign hits_4 = T32 & T30;
  assign T30 = T31 == io_tag;
  assign T31 = cam_tags[3'h4];
  assign T32 = vb_array[3'h4];
  assign hits_5 = T35 & T33;
  assign T33 = T34 == io_tag;
  assign T34 = cam_tags[3'h5];
  assign T35 = vb_array[3'h5];
  assign T36 = {hits_7, hits_6};
  assign hits_6 = T39 & T37;
  assign T37 = T38 == io_tag;
  assign T38 = cam_tags[3'h6];
  assign T39 = vb_array[3'h6];
  assign hits_7 = T42 & T40;
  assign T40 = T41 == io_tag;
  assign T41 = cam_tags[3'h7];
  assign T42 = vb_array[3'h7];
  assign io_hit = T43;
  assign T43 = io_hits != 8'h0;

  always @(posedge clk) begin
    if(reset) begin
      vb_array <= 8'h0;
    end else if(io_clear) begin
      vb_array <= T8;
    end else if(io_write) begin
      vb_array <= T2;
    end
    if (io_write)
      cam_tags[io_write_addr] <= io_write_tag;
  end
endmodule

module TLB(
    input clk, 
    input reset,
    output io_req_ready,
    input  io_req_valid,
    input [6:0] io_req_bits_asid,
    input [27:0] io_req_bits_vpn,
    input  io_req_bits_passthrough,
    input  io_req_bits_instruction,
    input  io_req_bits_store,
    output io_resp_miss,
    output[19:0] io_resp_ppn,
    output io_resp_xcpt_ld,
    output io_resp_xcpt_st,
    output io_resp_xcpt_if,
    output[7:0] io_resp_hit_idx,
    input  io_ptw_req_ready,
    output io_ptw_req_valid,
    output[26:0] io_ptw_req_bits_addr,
    output[1:0] io_ptw_req_bits_prv,
    output io_ptw_req_bits_store,
    output io_ptw_req_bits_fetch,
    input  io_ptw_resp_valid,
    input  io_ptw_resp_bits_error,
    input [19:0] io_ptw_resp_bits_pte_ppn,
    input [2:0] io_ptw_resp_bits_pte_reserved_for_software,
    input  io_ptw_resp_bits_pte_d,
    input  io_ptw_resp_bits_pte_r,
    input [3:0] io_ptw_resp_bits_pte_typ,
    input  io_ptw_resp_bits_pte_v,
    input  io_ptw_status_sd,
    input [30:0] io_ptw_status_zero2,
    input  io_ptw_status_sd_rv32,
    input [8:0] io_ptw_status_zero1,
    input [4:0] io_ptw_status_vm,
    input  io_ptw_status_mprv,
    input [1:0] io_ptw_status_xs,
    input [1:0] io_ptw_status_fs,
    input [1:0] io_ptw_status_prv3,
    input  io_ptw_status_ie3,
    input [1:0] io_ptw_status_prv2,
    input  io_ptw_status_ie2,
    input [1:0] io_ptw_status_prv1,
    input  io_ptw_status_ie1,
    input [1:0] io_ptw_status_prv,
    input  io_ptw_status_ie,
    input  io_ptw_invalidate
);

  reg [2:0] r_refill_waddr;
  wire[2:0] T0;
  wire[2:0] repl_waddr;
  wire[2:0] T1;
  wire[3:0] T2;
  wire T3;
  reg [7:0] R4;
  wire[7:0] T5;
  wire[7:0] T6;
  wire[7:0] T7;
  wire[7:0] T8;
  wire[14:0] T9;
  wire[2:0] T10;
  wire T11;
  wire[2:0] T479;
  wire[1:0] T480;
  wire T481;
  wire[1:0] T482;
  wire[1:0] T483;
  wire[3:0] T484;
  wire[3:0] T485;
  wire[3:0] T486;
  wire[1:0] T487;
  wire T488;
  wire T489;
  wire[1:0] T13;
  wire T14;
  wire T15;
  wire[7:0] T16;
  wire[7:0] T17;
  wire[7:0] T18;
  wire[7:0] T19;
  wire[7:0] T20;
  wire[10:0] T21;
  wire[7:0] T22;
  wire[7:0] T23;
  wire[7:0] T24;
  wire[7:0] T25;
  wire[7:0] T26;
  wire T27;
  wire tlb_hit;
  wire tag_hit;
  wire[7:0] tag_hits;
  wire[7:0] T28;
  wire[7:0] T29;
  wire[7:0] T30;
  wire[7:0] w_array;
  wire[7:0] T31;
  wire[7:0] T32;
  wire[3:0] T33;
  wire[1:0] T34;
  reg  uw_array_0;
  wire T35;
  wire T36;
  wire T37;
  wire T38;
  wire T39;
  wire T40;
  wire T41;
  wire T42;
  wire T43;
  wire T44;
  wire T45;
  wire[7:0] T46;
  wire[2:0] T47;
  reg  uw_array_1;
  wire T48;
  wire T49;
  wire T50;
  wire[1:0] T51;
  reg  uw_array_2;
  wire T52;
  wire T53;
  wire T54;
  reg  uw_array_3;
  wire T55;
  wire T56;
  wire T57;
  wire[3:0] T58;
  wire[1:0] T59;
  reg  uw_array_4;
  wire T60;
  wire T61;
  wire T62;
  reg  uw_array_5;
  wire T63;
  wire T64;
  wire T65;
  wire[1:0] T66;
  reg  uw_array_6;
  wire T67;
  wire T68;
  wire T69;
  reg  uw_array_7;
  wire T70;
  wire T71;
  wire T72;
  wire[7:0] T73;
  wire[7:0] T74;
  wire[3:0] T75;
  wire[1:0] T76;
  reg  sw_array_0;
  wire T77;
  wire T78;
  wire T79;
  wire T80;
  wire T81;
  wire T82;
  wire T83;
  wire T84;
  wire T85;
  wire[7:0] T86;
  wire[2:0] T87;
  reg  sw_array_1;
  wire T88;
  wire T89;
  wire T90;
  wire[1:0] T91;
  reg  sw_array_2;
  wire T92;
  wire T93;
  wire T94;
  reg  sw_array_3;
  wire T95;
  wire T96;
  wire T97;
  wire[3:0] T98;
  wire[1:0] T99;
  reg  sw_array_4;
  wire T100;
  wire T101;
  wire T102;
  reg  sw_array_5;
  wire T103;
  wire T104;
  wire T105;
  wire[1:0] T106;
  reg  sw_array_6;
  wire T107;
  wire T108;
  wire T109;
  reg  sw_array_7;
  wire T110;
  wire T111;
  wire T112;
  wire priv_s;
  wire[1:0] priv;
  wire T113;
  wire T114;
  wire[7:0] T115;
  wire[7:0] T116;
  wire[3:0] T117;
  wire[1:0] T118;
  reg  dirty_array_0;
  wire T119;
  wire T120;
  wire T121;
  wire[7:0] T122;
  wire[2:0] T123;
  reg  dirty_array_1;
  wire T124;
  wire T125;
  wire T126;
  wire[1:0] T127;
  reg  dirty_array_2;
  wire T128;
  wire T129;
  wire T130;
  reg  dirty_array_3;
  wire T131;
  wire T132;
  wire T133;
  wire[3:0] T134;
  wire[1:0] T135;
  reg  dirty_array_4;
  wire T136;
  wire T137;
  wire T138;
  reg  dirty_array_5;
  wire T139;
  wire T140;
  wire T141;
  wire[1:0] T142;
  reg  dirty_array_6;
  wire T143;
  wire T144;
  wire T145;
  reg  dirty_array_7;
  wire T146;
  wire T147;
  wire T148;
  wire vm_enabled;
  wire T149;
  wire T150;
  wire priv_uses_vm;
  wire T151;
  wire[2:0] T152;
  wire T153;
  wire[1:0] T154;
  wire T155;
  wire[2:0] T490;
  wire[2:0] T491;
  wire[2:0] T492;
  wire[2:0] T493;
  wire[2:0] T494;
  wire[2:0] T495;
  wire[2:0] T496;
  wire T497;
  wire[7:0] T156;
  wire T498;
  wire T499;
  wire T500;
  wire T501;
  wire T502;
  wire T503;
  wire has_invalid_entry;
  wire T157;
  wire T158;
  wire tlb_miss;
  wire T159;
  wire bad_va;
  wire T160;
  wire T161;
  wire T162;
  wire T163;
  wire T164;
  wire[33:0] T504;
  reg [34:0] r_refill_tag;
  wire[34:0] T165;
  wire[34:0] lookup_tag;
  wire[34:0] T166;
  wire T167;
  wire T168;
  reg [1:0] state;
  wire[1:0] T505;
  wire[1:0] T169;
  wire[1:0] T170;
  wire[1:0] T171;
  wire[1:0] T172;
  wire[1:0] T173;
  wire[1:0] T174;
  wire T175;
  wire T176;
  wire T177;
  wire T178;
  wire T179;
  wire T180;
  wire[33:0] T506;
  wire[7:0] T181;
  wire[7:0] T182;
  wire[7:0] T183;
  wire[7:0] T184;
  wire[7:0] T185;
  wire[7:0] T186;
  wire[7:0] T187;
  wire[3:0] T188;
  wire[1:0] T189;
  reg  valid_array_0;
  wire T190;
  wire T191;
  wire T192;
  wire T193;
  wire[7:0] T194;
  wire[2:0] T195;
  reg  valid_array_1;
  wire T196;
  wire T197;
  wire T198;
  wire[1:0] T199;
  reg  valid_array_2;
  wire T200;
  wire T201;
  wire T202;
  reg  valid_array_3;
  wire T203;
  wire T204;
  wire T205;
  wire[3:0] T206;
  wire[1:0] T207;
  reg  valid_array_4;
  wire T208;
  wire T209;
  wire T210;
  reg  valid_array_5;
  wire T211;
  wire T212;
  wire T213;
  wire[1:0] T214;
  reg  valid_array_6;
  wire T215;
  wire T216;
  wire T217;
  reg  valid_array_7;
  wire T218;
  wire T219;
  wire T220;
  wire T221;
  wire T222;
  reg  r_req_instruction;
  wire T223;
  reg  r_req_store;
  wire T224;
  wire[26:0] T507;
  wire T225;
  wire T226;
  wire T227;
  wire T228;
  wire T229;
  wire[7:0] T230;
  wire[7:0] x_array;
  wire[7:0] T231;
  wire[7:0] T232;
  wire[3:0] T233;
  wire[1:0] T234;
  reg  ux_array_0;
  wire T235;
  wire T236;
  wire T237;
  wire T238;
  wire T239;
  wire T240;
  wire T241;
  wire T242;
  wire T243;
  wire T244;
  wire T245;
  wire[7:0] T246;
  wire[2:0] T247;
  reg  ux_array_1;
  wire T248;
  wire T249;
  wire T250;
  wire[1:0] T251;
  reg  ux_array_2;
  wire T252;
  wire T253;
  wire T254;
  reg  ux_array_3;
  wire T255;
  wire T256;
  wire T257;
  wire[3:0] T258;
  wire[1:0] T259;
  reg  ux_array_4;
  wire T260;
  wire T261;
  wire T262;
  reg  ux_array_5;
  wire T263;
  wire T264;
  wire T265;
  wire[1:0] T266;
  reg  ux_array_6;
  wire T267;
  wire T268;
  wire T269;
  reg  ux_array_7;
  wire T270;
  wire T271;
  wire T272;
  wire[7:0] T273;
  wire[7:0] T274;
  wire[3:0] T275;
  wire[1:0] T276;
  reg  sx_array_0;
  wire T277;
  wire T278;
  wire T279;
  wire T280;
  wire T281;
  wire T282;
  wire T283;
  wire T284;
  wire T285;
  wire[7:0] T286;
  wire[2:0] T287;
  reg  sx_array_1;
  wire T288;
  wire T289;
  wire T290;
  wire[1:0] T291;
  reg  sx_array_2;
  wire T292;
  wire T293;
  wire T294;
  reg  sx_array_3;
  wire T295;
  wire T296;
  wire T297;
  wire[3:0] T298;
  wire[1:0] T299;
  reg  sx_array_4;
  wire T300;
  wire T301;
  wire T302;
  reg  sx_array_5;
  wire T303;
  wire T304;
  wire T305;
  wire[1:0] T306;
  reg  sx_array_6;
  wire T307;
  wire T308;
  wire T309;
  reg  sx_array_7;
  wire T310;
  wire T311;
  wire T312;
  wire T313;
  wire T314;
  wire T315;
  wire T316;
  wire[2:0] T317;
  wire[2:0] T318;
  wire[2:0] T319;
  wire T320;
  wire T321;
  wire[31:0] paddr;
  wire T322;
  wire[2:0] T323;
  wire[2:0] T324;
  wire T325;
  wire T326;
  wire T327;
  wire[2:0] T328;
  wire T329;
  wire T330;
  wire T331;
  wire T332;
  wire T333;
  wire addr_ok;
  wire T334;
  wire T335;
  wire T336;
  wire T337;
  wire T338;
  wire T339;
  wire T340;
  wire T341;
  wire T342;
  wire T343;
  wire T344;
  wire T345;
  wire T346;
  wire T347;
  wire T348;
  wire T349;
  wire[7:0] T350;
  wire T351;
  wire T352;
  wire T353;
  wire T354;
  wire T355;
  wire T356;
  wire T357;
  wire T358;
  wire T359;
  wire[7:0] T360;
  wire[7:0] r_array;
  wire[7:0] T361;
  wire[7:0] T362;
  wire[3:0] T363;
  wire[1:0] T364;
  reg  ur_array_0;
  wire T365;
  wire T366;
  wire T367;
  wire T368;
  wire T369;
  wire T370;
  wire T371;
  wire T372;
  wire T373;
  wire[7:0] T374;
  wire[2:0] T375;
  reg  ur_array_1;
  wire T376;
  wire T377;
  wire T378;
  wire[1:0] T379;
  reg  ur_array_2;
  wire T380;
  wire T381;
  wire T382;
  reg  ur_array_3;
  wire T383;
  wire T384;
  wire T385;
  wire[3:0] T386;
  wire[1:0] T387;
  reg  ur_array_4;
  wire T388;
  wire T389;
  wire T390;
  reg  ur_array_5;
  wire T391;
  wire T392;
  wire T393;
  wire[1:0] T394;
  reg  ur_array_6;
  wire T395;
  wire T396;
  wire T397;
  reg  ur_array_7;
  wire T398;
  wire T399;
  wire T400;
  wire[7:0] T401;
  wire[7:0] T402;
  wire[3:0] T403;
  wire[1:0] T404;
  reg  sr_array_0;
  wire T405;
  wire T406;
  wire T407;
  wire T408;
  wire T409;
  wire T410;
  wire T411;
  wire[7:0] T412;
  wire[2:0] T413;
  reg  sr_array_1;
  wire T414;
  wire T415;
  wire T416;
  wire[1:0] T417;
  reg  sr_array_2;
  wire T418;
  wire T419;
  wire T420;
  reg  sr_array_3;
  wire T421;
  wire T422;
  wire T423;
  wire[3:0] T424;
  wire[1:0] T425;
  reg  sr_array_4;
  wire T426;
  wire T427;
  wire T428;
  reg  sr_array_5;
  wire T429;
  wire T430;
  wire T431;
  wire[1:0] T432;
  reg  sr_array_6;
  wire T433;
  wire T434;
  wire T435;
  reg  sr_array_7;
  wire T436;
  wire T437;
  wire T438;
  wire T439;
  wire T440;
  wire T441;
  wire T442;
  wire T443;
  wire[19:0] T444;
  wire[19:0] T445;
  wire[19:0] T446;
  wire[19:0] T447;
  wire[19:0] T448;
  reg [19:0] tag_ram [7:0];
  wire[19:0] T449;
  wire T450;
  wire[19:0] T451;
  wire[19:0] T452;
  wire[19:0] T453;
  wire T454;
  wire[19:0] T455;
  wire[19:0] T456;
  wire[19:0] T457;
  wire T458;
  wire[19:0] T459;
  wire[19:0] T460;
  wire[19:0] T461;
  wire T462;
  wire[19:0] T463;
  wire[19:0] T464;
  wire[19:0] T465;
  wire T466;
  wire[19:0] T467;
  wire[19:0] T468;
  wire[19:0] T469;
  wire T470;
  wire[19:0] T471;
  wire[19:0] T472;
  wire[19:0] T473;
  wire T474;
  wire[19:0] T475;
  wire[19:0] T476;
  wire T477;
  wire T478;
  wire[7:0] tag_cam_io_hits;
  wire[7:0] tag_cam_io_valid_bits;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    r_refill_waddr = {1{$random}};
    R4 = {1{$random}};
    uw_array_0 = {1{$random}};
    uw_array_1 = {1{$random}};
    uw_array_2 = {1{$random}};
    uw_array_3 = {1{$random}};
    uw_array_4 = {1{$random}};
    uw_array_5 = {1{$random}};
    uw_array_6 = {1{$random}};
    uw_array_7 = {1{$random}};
    sw_array_0 = {1{$random}};
    sw_array_1 = {1{$random}};
    sw_array_2 = {1{$random}};
    sw_array_3 = {1{$random}};
    sw_array_4 = {1{$random}};
    sw_array_5 = {1{$random}};
    sw_array_6 = {1{$random}};
    sw_array_7 = {1{$random}};
    dirty_array_0 = {1{$random}};
    dirty_array_1 = {1{$random}};
    dirty_array_2 = {1{$random}};
    dirty_array_3 = {1{$random}};
    dirty_array_4 = {1{$random}};
    dirty_array_5 = {1{$random}};
    dirty_array_6 = {1{$random}};
    dirty_array_7 = {1{$random}};
    r_refill_tag = {2{$random}};
    state = {1{$random}};
    valid_array_0 = {1{$random}};
    valid_array_1 = {1{$random}};
    valid_array_2 = {1{$random}};
    valid_array_3 = {1{$random}};
    valid_array_4 = {1{$random}};
    valid_array_5 = {1{$random}};
    valid_array_6 = {1{$random}};
    valid_array_7 = {1{$random}};
    r_req_instruction = {1{$random}};
    r_req_store = {1{$random}};
    ux_array_0 = {1{$random}};
    ux_array_1 = {1{$random}};
    ux_array_2 = {1{$random}};
    ux_array_3 = {1{$random}};
    ux_array_4 = {1{$random}};
    ux_array_5 = {1{$random}};
    ux_array_6 = {1{$random}};
    ux_array_7 = {1{$random}};
    sx_array_0 = {1{$random}};
    sx_array_1 = {1{$random}};
    sx_array_2 = {1{$random}};
    sx_array_3 = {1{$random}};
    sx_array_4 = {1{$random}};
    sx_array_5 = {1{$random}};
    sx_array_6 = {1{$random}};
    sx_array_7 = {1{$random}};
    ur_array_0 = {1{$random}};
    ur_array_1 = {1{$random}};
    ur_array_2 = {1{$random}};
    ur_array_3 = {1{$random}};
    ur_array_4 = {1{$random}};
    ur_array_5 = {1{$random}};
    ur_array_6 = {1{$random}};
    ur_array_7 = {1{$random}};
    sr_array_0 = {1{$random}};
    sr_array_1 = {1{$random}};
    sr_array_2 = {1{$random}};
    sr_array_3 = {1{$random}};
    sr_array_4 = {1{$random}};
    sr_array_5 = {1{$random}};
    sr_array_6 = {1{$random}};
    sr_array_7 = {1{$random}};
    for (initvar = 0; initvar < 8; initvar = initvar+1)
      tag_ram[initvar] = {1{$random}};
  end
// synthesis translate_on
`endif

  assign T0 = T158 ? repl_waddr : r_refill_waddr;
  assign repl_waddr = has_invalid_entry ? T490 : T1;
  assign T1 = T2[2'h2:1'h0];
  assign T2 = {T152, T3};
  assign T3 = R4[T152];
  assign T5 = T27 ? T6 : R4;
  assign T6 = T16 | T7;
  assign T7 = T15 ? 8'h0 : T8;
  assign T8 = T9[3'h7:1'h0];
  assign T9 = 8'h1 << T10;
  assign T10 = {T13, T11};
  assign T11 = T479[1'h1];
  assign T479 = {T489, T480};
  assign T480 = {T488, T481};
  assign T481 = T482[1'h1];
  assign T482 = T487 | T483;
  assign T483 = T484[1'h1:1'h0];
  assign T484 = T486 | T485;
  assign T485 = tag_cam_io_hits[2'h3:1'h0];
  assign T486 = tag_cam_io_hits[3'h7:3'h4];
  assign T487 = T484[2'h3:2'h2];
  assign T488 = T487 != 2'h0;
  assign T489 = T486 != 4'h0;
  assign T13 = {1'h1, T14};
  assign T14 = T479[2'h2];
  assign T15 = T479[1'h0];
  assign T16 = T18 & T17;
  assign T17 = ~ T8;
  assign T18 = T22 | T19;
  assign T19 = T11 ? 8'h0 : T20;
  assign T20 = T21[3'h7:1'h0];
  assign T21 = 8'h1 << T13;
  assign T22 = T24 & T23;
  assign T23 = ~ T20;
  assign T24 = T26 | T25;
  assign T25 = T14 ? 8'h0 : 8'h2;
  assign T26 = R4 & 8'hfd;
  assign T27 = io_req_valid & tlb_hit;
  assign tlb_hit = vm_enabled & tag_hit;
  assign tag_hit = tag_hits != 8'h0;
  assign tag_hits = tag_cam_io_hits & T28;
  assign T28 = T115 | T29;
  assign T29 = ~ T30;
  assign T30 = io_req_bits_store ? w_array : 8'h0;
  assign w_array = priv_s ? T73 : T31;
  assign T31 = T32;
  assign T32 = {T58, T33};
  assign T33 = {T51, T34};
  assign T34 = {uw_array_1, uw_array_0};
  assign T35 = T44 ? T36 : uw_array_0;
  assign T36 = T38 & T37;
  assign T37 = io_ptw_resp_bits_error ^ 1'h1;
  assign T38 = T40 & T39;
  assign T39 = io_ptw_resp_bits_pte_typ[1'h0];
  assign T40 = T42 & T41;
  assign T41 = io_ptw_resp_bits_pte_typ < 4'h8;
  assign T42 = io_ptw_resp_bits_pte_v & T43;
  assign T43 = 4'h2 <= io_ptw_resp_bits_pte_typ;
  assign T44 = io_ptw_resp_valid & T45;
  assign T45 = T46[1'h0];
  assign T46 = 1'h1 << T47;
  assign T47 = r_refill_waddr;
  assign T48 = T49 ? T36 : uw_array_1;
  assign T49 = io_ptw_resp_valid & T50;
  assign T50 = T46[1'h1];
  assign T51 = {uw_array_3, uw_array_2};
  assign T52 = T53 ? T36 : uw_array_2;
  assign T53 = io_ptw_resp_valid & T54;
  assign T54 = T46[2'h2];
  assign T55 = T56 ? T36 : uw_array_3;
  assign T56 = io_ptw_resp_valid & T57;
  assign T57 = T46[2'h3];
  assign T58 = {T66, T59};
  assign T59 = {uw_array_5, uw_array_4};
  assign T60 = T61 ? T36 : uw_array_4;
  assign T61 = io_ptw_resp_valid & T62;
  assign T62 = T46[3'h4];
  assign T63 = T64 ? T36 : uw_array_5;
  assign T64 = io_ptw_resp_valid & T65;
  assign T65 = T46[3'h5];
  assign T66 = {uw_array_7, uw_array_6};
  assign T67 = T68 ? T36 : uw_array_6;
  assign T68 = io_ptw_resp_valid & T69;
  assign T69 = T46[3'h6];
  assign T70 = T71 ? T36 : uw_array_7;
  assign T71 = io_ptw_resp_valid & T72;
  assign T72 = T46[3'h7];
  assign T73 = T74;
  assign T74 = {T98, T75};
  assign T75 = {T91, T76};
  assign T76 = {sw_array_1, sw_array_0};
  assign T77 = T84 ? T78 : sw_array_0;
  assign T78 = T80 & T79;
  assign T79 = io_ptw_resp_bits_error ^ 1'h1;
  assign T80 = T82 & T81;
  assign T81 = io_ptw_resp_bits_pte_typ[1'h0];
  assign T82 = io_ptw_resp_bits_pte_v & T83;
  assign T83 = 4'h2 <= io_ptw_resp_bits_pte_typ;
  assign T84 = io_ptw_resp_valid & T85;
  assign T85 = T86[1'h0];
  assign T86 = 1'h1 << T87;
  assign T87 = r_refill_waddr;
  assign T88 = T89 ? T78 : sw_array_1;
  assign T89 = io_ptw_resp_valid & T90;
  assign T90 = T86[1'h1];
  assign T91 = {sw_array_3, sw_array_2};
  assign T92 = T93 ? T78 : sw_array_2;
  assign T93 = io_ptw_resp_valid & T94;
  assign T94 = T86[2'h2];
  assign T95 = T96 ? T78 : sw_array_3;
  assign T96 = io_ptw_resp_valid & T97;
  assign T97 = T86[2'h3];
  assign T98 = {T106, T99};
  assign T99 = {sw_array_5, sw_array_4};
  assign T100 = T101 ? T78 : sw_array_4;
  assign T101 = io_ptw_resp_valid & T102;
  assign T102 = T86[3'h4];
  assign T103 = T104 ? T78 : sw_array_5;
  assign T104 = io_ptw_resp_valid & T105;
  assign T105 = T86[3'h5];
  assign T106 = {sw_array_7, sw_array_6};
  assign T107 = T108 ? T78 : sw_array_6;
  assign T108 = io_ptw_resp_valid & T109;
  assign T109 = T86[3'h6];
  assign T110 = T111 ? T78 : sw_array_7;
  assign T111 = io_ptw_resp_valid & T112;
  assign T112 = T86[3'h7];
  assign priv_s = priv == 2'h1;
  assign priv = T113 ? io_ptw_status_prv1 : io_ptw_status_prv;
  assign T113 = io_ptw_status_mprv & T114;
  assign T114 = io_req_bits_instruction ^ 1'h1;
  assign T115 = T116;
  assign T116 = {T134, T117};
  assign T117 = {T127, T118};
  assign T118 = {dirty_array_1, dirty_array_0};
  assign T119 = T120 ? io_ptw_resp_bits_pte_d : dirty_array_0;
  assign T120 = io_ptw_resp_valid & T121;
  assign T121 = T122[1'h0];
  assign T122 = 1'h1 << T123;
  assign T123 = r_refill_waddr;
  assign T124 = T125 ? io_ptw_resp_bits_pte_d : dirty_array_1;
  assign T125 = io_ptw_resp_valid & T126;
  assign T126 = T122[1'h1];
  assign T127 = {dirty_array_3, dirty_array_2};
  assign T128 = T129 ? io_ptw_resp_bits_pte_d : dirty_array_2;
  assign T129 = io_ptw_resp_valid & T130;
  assign T130 = T122[2'h2];
  assign T131 = T132 ? io_ptw_resp_bits_pte_d : dirty_array_3;
  assign T132 = io_ptw_resp_valid & T133;
  assign T133 = T122[2'h3];
  assign T134 = {T142, T135};
  assign T135 = {dirty_array_5, dirty_array_4};
  assign T136 = T137 ? io_ptw_resp_bits_pte_d : dirty_array_4;
  assign T137 = io_ptw_resp_valid & T138;
  assign T138 = T122[3'h4];
  assign T139 = T140 ? io_ptw_resp_bits_pte_d : dirty_array_5;
  assign T140 = io_ptw_resp_valid & T141;
  assign T141 = T122[3'h5];
  assign T142 = {dirty_array_7, dirty_array_6};
  assign T143 = T144 ? io_ptw_resp_bits_pte_d : dirty_array_6;
  assign T144 = io_ptw_resp_valid & T145;
  assign T145 = T122[3'h6];
  assign T146 = T147 ? io_ptw_resp_bits_pte_d : dirty_array_7;
  assign T147 = io_ptw_resp_valid & T148;
  assign T148 = T122[3'h7];
  assign vm_enabled = T150 & T149;
  assign T149 = io_req_bits_passthrough ^ 1'h1;
  assign T150 = T151 & priv_uses_vm;
  assign priv_uses_vm = priv <= 2'h1;
  assign T151 = io_ptw_status_vm[2'h3];
  assign T152 = {T154, T153};
  assign T153 = R4[T154];
  assign T154 = {1'h1, T155};
  assign T155 = R4[1'h1];
  assign T490 = T503 ? 1'h0 : T491;
  assign T491 = T502 ? 1'h1 : T492;
  assign T492 = T501 ? 2'h2 : T493;
  assign T493 = T500 ? 2'h3 : T494;
  assign T494 = T499 ? 3'h4 : T495;
  assign T495 = T498 ? 3'h5 : T496;
  assign T496 = T497 ? 3'h6 : 3'h7;
  assign T497 = T156[3'h6];
  assign T156 = ~ tag_cam_io_valid_bits;
  assign T498 = T156[3'h5];
  assign T499 = T156[3'h4];
  assign T500 = T156[2'h3];
  assign T501 = T156[2'h2];
  assign T502 = T156[1'h1];
  assign T503 = T156[1'h0];
  assign has_invalid_entry = T157 ^ 1'h1;
  assign T157 = tag_cam_io_valid_bits == 8'hff;
  assign T158 = T164 & tlb_miss;
  assign tlb_miss = T162 & T159;
  assign T159 = bad_va ^ 1'h1;
  assign bad_va = T161 != T160;
  assign T160 = io_req_bits_vpn[5'h1a];
  assign T161 = io_req_bits_vpn[5'h1b];
  assign T162 = vm_enabled & T163;
  assign T163 = tag_hit ^ 1'h1;
  assign T164 = io_req_ready & io_req_valid;
  assign T504 = r_refill_tag[6'h21:1'h0];
  assign T165 = T158 ? lookup_tag : r_refill_tag;
  assign lookup_tag = T166;
  assign T166 = {io_req_bits_asid, io_req_bits_vpn};
  assign T167 = T168 & io_ptw_resp_valid;
  assign T168 = state == 2'h2;
  assign T505 = reset ? 2'h0 : T169;
  assign T169 = io_ptw_resp_valid ? 2'h0 : T170;
  assign T170 = T179 ? 2'h3 : T171;
  assign T171 = T178 ? 2'h3 : T172;
  assign T172 = T177 ? 2'h2 : T173;
  assign T173 = T175 ? 2'h0 : T174;
  assign T174 = T158 ? 2'h1 : state;
  assign T175 = T176 & io_ptw_invalidate;
  assign T176 = state == 2'h1;
  assign T177 = T176 & io_ptw_req_ready;
  assign T178 = T177 & io_ptw_invalidate;
  assign T179 = T180 & io_ptw_invalidate;
  assign T180 = state == 2'h2;
  assign T506 = lookup_tag[6'h21:1'h0];
  assign T181 = io_ptw_invalidate ? 8'hff : T182;
  assign T182 = T185 | T183;
  assign T183 = tag_cam_io_hits & T184;
  assign T184 = ~ tag_hits;
  assign T185 = ~ T186;
  assign T186 = T187;
  assign T187 = {T206, T188};
  assign T188 = {T199, T189};
  assign T189 = {valid_array_1, valid_array_0};
  assign T190 = T192 ? T191 : valid_array_0;
  assign T191 = io_ptw_resp_bits_error ^ 1'h1;
  assign T192 = io_ptw_resp_valid & T193;
  assign T193 = T194[1'h0];
  assign T194 = 1'h1 << T195;
  assign T195 = r_refill_waddr;
  assign T196 = T197 ? T191 : valid_array_1;
  assign T197 = io_ptw_resp_valid & T198;
  assign T198 = T194[1'h1];
  assign T199 = {valid_array_3, valid_array_2};
  assign T200 = T201 ? T191 : valid_array_2;
  assign T201 = io_ptw_resp_valid & T202;
  assign T202 = T194[2'h2];
  assign T203 = T204 ? T191 : valid_array_3;
  assign T204 = io_ptw_resp_valid & T205;
  assign T205 = T194[2'h3];
  assign T206 = {T214, T207};
  assign T207 = {valid_array_5, valid_array_4};
  assign T208 = T209 ? T191 : valid_array_4;
  assign T209 = io_ptw_resp_valid & T210;
  assign T210 = T194[3'h4];
  assign T211 = T212 ? T191 : valid_array_5;
  assign T212 = io_ptw_resp_valid & T213;
  assign T213 = T194[3'h5];
  assign T214 = {valid_array_7, valid_array_6};
  assign T215 = T216 ? T191 : valid_array_6;
  assign T216 = io_ptw_resp_valid & T217;
  assign T217 = T194[3'h6];
  assign T218 = T219 ? T191 : valid_array_7;
  assign T219 = io_ptw_resp_valid & T220;
  assign T220 = T194[3'h7];
  assign T221 = io_ptw_invalidate | T222;
  assign T222 = io_req_ready & io_req_valid;
  assign io_ptw_req_bits_fetch = r_req_instruction;
  assign T223 = T158 ? io_req_bits_instruction : r_req_instruction;
  assign io_ptw_req_bits_store = r_req_store;
  assign T224 = T158 ? io_req_bits_store : r_req_store;
  assign io_ptw_req_bits_prv = io_ptw_status_prv;
  assign io_ptw_req_bits_addr = T507;
  assign T507 = r_refill_tag[5'h1a:1'h0];
  assign io_ptw_req_valid = T225;
  assign T225 = state == 2'h1;
  assign io_resp_hit_idx = tag_cam_io_hits;
  assign io_resp_xcpt_if = T226;
  assign T226 = T313 | T227;
  assign T227 = tlb_hit & T228;
  assign T228 = T229 ^ 1'h1;
  assign T229 = T230 != 8'h0;
  assign T230 = x_array & tag_cam_io_hits;
  assign x_array = priv_s ? T273 : T231;
  assign T231 = T232;
  assign T232 = {T258, T233};
  assign T233 = {T251, T234};
  assign T234 = {ux_array_1, ux_array_0};
  assign T235 = T244 ? T236 : ux_array_0;
  assign T236 = T238 & T237;
  assign T237 = io_ptw_resp_bits_error ^ 1'h1;
  assign T238 = T240 & T239;
  assign T239 = io_ptw_resp_bits_pte_typ[1'h1];
  assign T240 = T242 & T241;
  assign T241 = io_ptw_resp_bits_pte_typ < 4'h8;
  assign T242 = io_ptw_resp_bits_pte_v & T243;
  assign T243 = 4'h2 <= io_ptw_resp_bits_pte_typ;
  assign T244 = io_ptw_resp_valid & T245;
  assign T245 = T246[1'h0];
  assign T246 = 1'h1 << T247;
  assign T247 = r_refill_waddr;
  assign T248 = T249 ? T236 : ux_array_1;
  assign T249 = io_ptw_resp_valid & T250;
  assign T250 = T246[1'h1];
  assign T251 = {ux_array_3, ux_array_2};
  assign T252 = T253 ? T236 : ux_array_2;
  assign T253 = io_ptw_resp_valid & T254;
  assign T254 = T246[2'h2];
  assign T255 = T256 ? T236 : ux_array_3;
  assign T256 = io_ptw_resp_valid & T257;
  assign T257 = T246[2'h3];
  assign T258 = {T266, T259};
  assign T259 = {ux_array_5, ux_array_4};
  assign T260 = T261 ? T236 : ux_array_4;
  assign T261 = io_ptw_resp_valid & T262;
  assign T262 = T246[3'h4];
  assign T263 = T264 ? T236 : ux_array_5;
  assign T264 = io_ptw_resp_valid & T265;
  assign T265 = T246[3'h5];
  assign T266 = {ux_array_7, ux_array_6};
  assign T267 = T268 ? T236 : ux_array_6;
  assign T268 = io_ptw_resp_valid & T269;
  assign T269 = T246[3'h6];
  assign T270 = T271 ? T236 : ux_array_7;
  assign T271 = io_ptw_resp_valid & T272;
  assign T272 = T246[3'h7];
  assign T273 = T274;
  assign T274 = {T298, T275};
  assign T275 = {T291, T276};
  assign T276 = {sx_array_1, sx_array_0};
  assign T277 = T284 ? T278 : sx_array_0;
  assign T278 = T280 & T279;
  assign T279 = io_ptw_resp_bits_error ^ 1'h1;
  assign T280 = T282 & T281;
  assign T281 = io_ptw_resp_bits_pte_typ[1'h1];
  assign T282 = io_ptw_resp_bits_pte_v & T283;
  assign T283 = 4'h4 <= io_ptw_resp_bits_pte_typ;
  assign T284 = io_ptw_resp_valid & T285;
  assign T285 = T286[1'h0];
  assign T286 = 1'h1 << T287;
  assign T287 = r_refill_waddr;
  assign T288 = T289 ? T278 : sx_array_1;
  assign T289 = io_ptw_resp_valid & T290;
  assign T290 = T286[1'h1];
  assign T291 = {sx_array_3, sx_array_2};
  assign T292 = T293 ? T278 : sx_array_2;
  assign T293 = io_ptw_resp_valid & T294;
  assign T294 = T286[2'h2];
  assign T295 = T296 ? T278 : sx_array_3;
  assign T296 = io_ptw_resp_valid & T297;
  assign T297 = T286[2'h3];
  assign T298 = {T306, T299};
  assign T299 = {sx_array_5, sx_array_4};
  assign T300 = T301 ? T278 : sx_array_4;
  assign T301 = io_ptw_resp_valid & T302;
  assign T302 = T286[3'h4];
  assign T303 = T304 ? T278 : sx_array_5;
  assign T304 = io_ptw_resp_valid & T305;
  assign T305 = T286[3'h5];
  assign T306 = {sx_array_7, sx_array_6};
  assign T307 = T308 ? T278 : sx_array_6;
  assign T308 = io_ptw_resp_valid & T309;
  assign T309 = T286[3'h6];
  assign T310 = T311 ? T278 : sx_array_7;
  assign T311 = io_ptw_resp_valid & T312;
  assign T312 = T286[3'h7];
  assign T313 = T314 | bad_va;
  assign T314 = T333 | T315;
  assign T315 = T316 ^ 1'h1;
  assign T316 = T317[2'h2];
  assign T317 = T332 ? 3'h7 : T318;
  assign T318 = T323 | T319;
  assign T319 = T320 ? 3'h3 : 3'h0;
  assign T320 = T322 & T321;
  assign T321 = paddr < 32'h40010200;
  assign paddr = {io_resp_ppn, 12'h0};
  assign T322 = 32'h40010000 <= paddr;
  assign T323 = T328 | T324;
  assign T324 = T325 ? 3'h3 : 3'h0;
  assign T325 = T327 & T326;
  assign T326 = paddr < 32'h40010000;
  assign T327 = 32'h40008000 <= paddr;
  assign T328 = T329 ? 3'h1 : 3'h0;
  assign T329 = T331 & T330;
  assign T330 = paddr < 32'h40008000;
  assign T331 = 32'h40000000 <= paddr;
  assign T332 = paddr < 32'h40000000;
  assign T333 = addr_ok ^ 1'h1;
  assign addr_ok = T345 | T334;
  assign T334 = T338 | T335;
  assign T335 = T337 & T336;
  assign T336 = paddr < 32'h40010200;
  assign T337 = 32'h40010000 <= paddr;
  assign T338 = T342 | T339;
  assign T339 = T341 & T340;
  assign T340 = paddr < 32'h40010000;
  assign T341 = 32'h40008000 <= paddr;
  assign T342 = T344 & T343;
  assign T343 = paddr < 32'h40008000;
  assign T344 = 32'h40000000 <= paddr;
  assign T345 = paddr < 32'h40000000;
  assign io_resp_xcpt_st = T346;
  assign T346 = T351 | T347;
  assign T347 = tlb_hit & T348;
  assign T348 = T349 ^ 1'h1;
  assign T349 = T350 != 8'h0;
  assign T350 = w_array & tag_cam_io_hits;
  assign T351 = T352 | bad_va;
  assign T352 = T355 | T353;
  assign T353 = T354 ^ 1'h1;
  assign T354 = T317[1'h1];
  assign T355 = addr_ok ^ 1'h1;
  assign io_resp_xcpt_ld = T356;
  assign T356 = T439 | T357;
  assign T357 = tlb_hit & T358;
  assign T358 = T359 ^ 1'h1;
  assign T359 = T360 != 8'h0;
  assign T360 = r_array & tag_cam_io_hits;
  assign r_array = priv_s ? T401 : T361;
  assign T361 = T362;
  assign T362 = {T386, T363};
  assign T363 = {T379, T364};
  assign T364 = {ur_array_1, ur_array_0};
  assign T365 = T372 ? T366 : ur_array_0;
  assign T366 = T368 & T367;
  assign T367 = io_ptw_resp_bits_error ^ 1'h1;
  assign T368 = T370 & T369;
  assign T369 = io_ptw_resp_bits_pte_typ < 4'h8;
  assign T370 = io_ptw_resp_bits_pte_v & T371;
  assign T371 = 4'h2 <= io_ptw_resp_bits_pte_typ;
  assign T372 = io_ptw_resp_valid & T373;
  assign T373 = T374[1'h0];
  assign T374 = 1'h1 << T375;
  assign T375 = r_refill_waddr;
  assign T376 = T377 ? T366 : ur_array_1;
  assign T377 = io_ptw_resp_valid & T378;
  assign T378 = T374[1'h1];
  assign T379 = {ur_array_3, ur_array_2};
  assign T380 = T381 ? T366 : ur_array_2;
  assign T381 = io_ptw_resp_valid & T382;
  assign T382 = T374[2'h2];
  assign T383 = T384 ? T366 : ur_array_3;
  assign T384 = io_ptw_resp_valid & T385;
  assign T385 = T374[2'h3];
  assign T386 = {T394, T387};
  assign T387 = {ur_array_5, ur_array_4};
  assign T388 = T389 ? T366 : ur_array_4;
  assign T389 = io_ptw_resp_valid & T390;
  assign T390 = T374[3'h4];
  assign T391 = T392 ? T366 : ur_array_5;
  assign T392 = io_ptw_resp_valid & T393;
  assign T393 = T374[3'h5];
  assign T394 = {ur_array_7, ur_array_6};
  assign T395 = T396 ? T366 : ur_array_6;
  assign T396 = io_ptw_resp_valid & T397;
  assign T397 = T374[3'h6];
  assign T398 = T399 ? T366 : ur_array_7;
  assign T399 = io_ptw_resp_valid & T400;
  assign T400 = T374[3'h7];
  assign T401 = T402;
  assign T402 = {T424, T403};
  assign T403 = {T417, T404};
  assign T404 = {sr_array_1, sr_array_0};
  assign T405 = T410 ? T406 : sr_array_0;
  assign T406 = T408 & T407;
  assign T407 = io_ptw_resp_bits_error ^ 1'h1;
  assign T408 = io_ptw_resp_bits_pte_v & T409;
  assign T409 = 4'h2 <= io_ptw_resp_bits_pte_typ;
  assign T410 = io_ptw_resp_valid & T411;
  assign T411 = T412[1'h0];
  assign T412 = 1'h1 << T413;
  assign T413 = r_refill_waddr;
  assign T414 = T415 ? T406 : sr_array_1;
  assign T415 = io_ptw_resp_valid & T416;
  assign T416 = T412[1'h1];
  assign T417 = {sr_array_3, sr_array_2};
  assign T418 = T419 ? T406 : sr_array_2;
  assign T419 = io_ptw_resp_valid & T420;
  assign T420 = T412[2'h2];
  assign T421 = T422 ? T406 : sr_array_3;
  assign T422 = io_ptw_resp_valid & T423;
  assign T423 = T412[2'h3];
  assign T424 = {T432, T425};
  assign T425 = {sr_array_5, sr_array_4};
  assign T426 = T427 ? T406 : sr_array_4;
  assign T427 = io_ptw_resp_valid & T428;
  assign T428 = T412[3'h4];
  assign T429 = T430 ? T406 : sr_array_5;
  assign T430 = io_ptw_resp_valid & T431;
  assign T431 = T412[3'h5];
  assign T432 = {sr_array_7, sr_array_6};
  assign T433 = T434 ? T406 : sr_array_6;
  assign T434 = io_ptw_resp_valid & T435;
  assign T435 = T412[3'h6];
  assign T436 = T437 ? T406 : sr_array_7;
  assign T437 = io_ptw_resp_valid & T438;
  assign T438 = T412[3'h7];
  assign T439 = T440 | bad_va;
  assign T440 = T443 | T441;
  assign T441 = T442 ^ 1'h1;
  assign T442 = T317[1'h0];
  assign T443 = addr_ok ^ 1'h1;
  assign io_resp_ppn = T444;
  assign T444 = vm_enabled ? T446 : T445;
  assign T445 = io_req_bits_vpn[5'h13:1'h0];
  assign T446 = T451 | T447;
  assign T447 = T450 ? T448 : 20'h0;
  assign T448 = tag_ram[3'h7];
  assign T450 = tag_cam_io_hits[3'h7];
  assign T451 = T455 | T452;
  assign T452 = T454 ? T453 : 20'h0;
  assign T453 = tag_ram[3'h6];
  assign T454 = tag_cam_io_hits[3'h6];
  assign T455 = T459 | T456;
  assign T456 = T458 ? T457 : 20'h0;
  assign T457 = tag_ram[3'h5];
  assign T458 = tag_cam_io_hits[3'h5];
  assign T459 = T463 | T460;
  assign T460 = T462 ? T461 : 20'h0;
  assign T461 = tag_ram[3'h4];
  assign T462 = tag_cam_io_hits[3'h4];
  assign T463 = T467 | T464;
  assign T464 = T466 ? T465 : 20'h0;
  assign T465 = tag_ram[3'h3];
  assign T466 = tag_cam_io_hits[2'h3];
  assign T467 = T471 | T468;
  assign T468 = T470 ? T469 : 20'h0;
  assign T469 = tag_ram[3'h2];
  assign T470 = tag_cam_io_hits[2'h2];
  assign T471 = T475 | T472;
  assign T472 = T474 ? T473 : 20'h0;
  assign T473 = tag_ram[3'h1];
  assign T474 = tag_cam_io_hits[1'h1];
  assign T475 = T477 ? T476 : 20'h0;
  assign T476 = tag_ram[3'h0];
  assign T477 = tag_cam_io_hits[1'h0];
  assign io_resp_miss = tlb_miss;
  assign io_req_ready = T478;
  assign T478 = state == 2'h0;
  RocketCAM tag_cam(.clk(clk), .reset(reset),
       .io_clear( T221 ),
       .io_clear_mask( T181 ),
       .io_tag( T506 ),
       //.io_hit(  )
       .io_hits( tag_cam_io_hits ),
       .io_valid_bits( tag_cam_io_valid_bits ),
       .io_write( T167 ),
       .io_write_tag( T504 ),
       .io_write_addr( r_refill_waddr )
  );

  always @(posedge clk) begin
    if(T158) begin
      r_refill_waddr <= repl_waddr;
    end
    if(T27) begin
      R4 <= T6;
    end
    if(T44) begin
      uw_array_0 <= T36;
    end
    if(T49) begin
      uw_array_1 <= T36;
    end
    if(T53) begin
      uw_array_2 <= T36;
    end
    if(T56) begin
      uw_array_3 <= T36;
    end
    if(T61) begin
      uw_array_4 <= T36;
    end
    if(T64) begin
      uw_array_5 <= T36;
    end
    if(T68) begin
      uw_array_6 <= T36;
    end
    if(T71) begin
      uw_array_7 <= T36;
    end
    if(T84) begin
      sw_array_0 <= T78;
    end
    if(T89) begin
      sw_array_1 <= T78;
    end
    if(T93) begin
      sw_array_2 <= T78;
    end
    if(T96) begin
      sw_array_3 <= T78;
    end
    if(T101) begin
      sw_array_4 <= T78;
    end
    if(T104) begin
      sw_array_5 <= T78;
    end
    if(T108) begin
      sw_array_6 <= T78;
    end
    if(T111) begin
      sw_array_7 <= T78;
    end
    if(T120) begin
      dirty_array_0 <= io_ptw_resp_bits_pte_d;
    end
    if(T125) begin
      dirty_array_1 <= io_ptw_resp_bits_pte_d;
    end
    if(T129) begin
      dirty_array_2 <= io_ptw_resp_bits_pte_d;
    end
    if(T132) begin
      dirty_array_3 <= io_ptw_resp_bits_pte_d;
    end
    if(T137) begin
      dirty_array_4 <= io_ptw_resp_bits_pte_d;
    end
    if(T140) begin
      dirty_array_5 <= io_ptw_resp_bits_pte_d;
    end
    if(T144) begin
      dirty_array_6 <= io_ptw_resp_bits_pte_d;
    end
    if(T147) begin
      dirty_array_7 <= io_ptw_resp_bits_pte_d;
    end
    if(T158) begin
      r_refill_tag <= lookup_tag;
    end
    if(reset) begin
      state <= 2'h0;
    end else if(io_ptw_resp_valid) begin
      state <= 2'h0;
    end else if(T179) begin
      state <= 2'h3;
    end else if(T178) begin
      state <= 2'h3;
    end else if(T177) begin
      state <= 2'h2;
    end else if(T175) begin
      state <= 2'h0;
    end else if(T158) begin
      state <= 2'h1;
    end
    if(T192) begin
      valid_array_0 <= T191;
    end
    if(T197) begin
      valid_array_1 <= T191;
    end
    if(T201) begin
      valid_array_2 <= T191;
    end
    if(T204) begin
      valid_array_3 <= T191;
    end
    if(T209) begin
      valid_array_4 <= T191;
    end
    if(T212) begin
      valid_array_5 <= T191;
    end
    if(T216) begin
      valid_array_6 <= T191;
    end
    if(T219) begin
      valid_array_7 <= T191;
    end
    if(T158) begin
      r_req_instruction <= io_req_bits_instruction;
    end
    if(T158) begin
      r_req_store <= io_req_bits_store;
    end
    if(T244) begin
      ux_array_0 <= T236;
    end
    if(T249) begin
      ux_array_1 <= T236;
    end
    if(T253) begin
      ux_array_2 <= T236;
    end
    if(T256) begin
      ux_array_3 <= T236;
    end
    if(T261) begin
      ux_array_4 <= T236;
    end
    if(T264) begin
      ux_array_5 <= T236;
    end
    if(T268) begin
      ux_array_6 <= T236;
    end
    if(T271) begin
      ux_array_7 <= T236;
    end
    if(T284) begin
      sx_array_0 <= T278;
    end
    if(T289) begin
      sx_array_1 <= T278;
    end
    if(T293) begin
      sx_array_2 <= T278;
    end
    if(T296) begin
      sx_array_3 <= T278;
    end
    if(T301) begin
      sx_array_4 <= T278;
    end
    if(T304) begin
      sx_array_5 <= T278;
    end
    if(T308) begin
      sx_array_6 <= T278;
    end
    if(T311) begin
      sx_array_7 <= T278;
    end
    if(T372) begin
      ur_array_0 <= T366;
    end
    if(T377) begin
      ur_array_1 <= T366;
    end
    if(T381) begin
      ur_array_2 <= T366;
    end
    if(T384) begin
      ur_array_3 <= T366;
    end
    if(T389) begin
      ur_array_4 <= T366;
    end
    if(T392) begin
      ur_array_5 <= T366;
    end
    if(T396) begin
      ur_array_6 <= T366;
    end
    if(T399) begin
      ur_array_7 <= T366;
    end
    if(T410) begin
      sr_array_0 <= T406;
    end
    if(T415) begin
      sr_array_1 <= T406;
    end
    if(T419) begin
      sr_array_2 <= T406;
    end
    if(T422) begin
      sr_array_3 <= T406;
    end
    if(T427) begin
      sr_array_4 <= T406;
    end
    if(T430) begin
      sr_array_5 <= T406;
    end
    if(T434) begin
      sr_array_6 <= T406;
    end
    if(T437) begin
      sr_array_7 <= T406;
    end
    if (io_ptw_resp_valid)
      tag_ram[r_refill_waddr] <= io_ptw_resp_bits_pte_ppn;
  end
endmodule
