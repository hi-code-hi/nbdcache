/*queue(clk,rst,enq_valid,deq_rdy,enq_bits,entris,enq_rdy,deq_valid,deq_bits,count)
by sunhaimeng
*/

module mprcQueue(
	input clk, input reset,
    output io_enq_ready,
    input  io_enq_valid,
    input [39:0] io_enq_bits_addr,
    input [8:0] io_enq_bits_tag,
    input [4:0] io_enq_bits_cmd,
    input [2:0] io_enq_bits_typ,
    input  io_enq_bits_kill,
    input  io_enq_bits_phys,
    input [4:0] io_enq_bits_sdq_id,
    input  io_deq_ready,
    output io_deq_valid,
    output[39:0] io_deq_bits_addr,
    output[8:0] io_deq_bits_tag,
    output[4:0] io_deq_bits_cmd,
    output[2:0] io_deq_bits_typ,
    output io_deq_bits_kill,
    output io_deq_bits_phys,
    output[4:0] io_deq_bits_sdq_id,
    output[4:0] io_count
);

  wire[4:0] T0;
  wire[3:0] ptr_diff;
  reg [3:0] R1;
  wire[3:0] T29;
  wire[3:0] T2;
  wire[3:0] T3;
  wire do_deq;
  reg [3:0] R4;
  wire[3:0] T30;
  wire[3:0] T5;
  wire[3:0] T6;
  wire do_enq;
  wire T7;
  wire ptr_match;
  reg  maybe_full;
  wire T31;
  wire T8;
  wire T9;
  wire[4:0] T10;
  wire[63:0] T11;
  reg [63:0] ram [15:0];
  wire[63:0] T12;
  wire[63:0] T13;
  wire[63:0] T14;
  wire[9:0] T15;
  wire[5:0] T16;
  wire[3:0] T17;
  wire[53:0] T18;
  wire[13:0] T19;
  wire T20;
  wire T21;
  wire[2:0] T22;
  wire[4:0] T23;
  wire[8:0] T24;
  wire[39:0] T25;
  wire T26;
  wire empty;
  wire T27;
  wire T28;
  wire full;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    R1 = {1{$random}};
    R4 = {1{$random}};
    maybe_full = {1{$random}};
    for (initvar = 0; initvar < 16; initvar = initvar+1)
      ram[initvar] = {2{$random}};
  end
// synthesis translate_on
`endif

  assign io_count = T0;
  assign T0 = {T7, ptr_diff};
  assign ptr_diff = R4 - R1;
  assign T29 = reset ? 4'h0 : T2;
  assign T2 = do_deq ? T3 : R1;
  assign T3 = R1 + 4'h1;
  assign do_deq = io_deq_ready & io_deq_valid;
  assign T30 = reset ? 4'h0 : T5;
  assign T5 = do_enq ? T6 : R4;
  assign T6 = R4 + 4'h1;
  assign do_enq = io_enq_ready & io_enq_valid;
  assign T7 = maybe_full & ptr_match;
  assign ptr_match = R4 == R1;
  assign T31 = reset ? 1'h0 : T8;
  assign T8 = T9 ? do_enq : maybe_full;
  assign T9 = do_enq != do_deq;
  assign io_deq_bits_sdq_id = T10;
  assign T10 = T11[3'h4:1'h0];
  assign T11 = ram[R1];
  assign T13 = T14;
  assign T14 = {T18, T15};
  assign T15 = {T17, T16};
  assign T16 = {io_enq_bits_phys, io_enq_bits_sdq_id};
  assign T17 = {io_enq_bits_typ, io_enq_bits_kill};
  assign T18 = {io_enq_bits_addr, T19};
  assign T19 = {io_enq_bits_tag, io_enq_bits_cmd};
  assign io_deq_bits_phys = T20;
  assign T20 = T11[3'h5];
  assign io_deq_bits_kill = T21;
  assign T21 = T11[3'h6];
  assign io_deq_bits_typ = T22;
  assign T22 = T11[4'h9:3'h7];
  assign io_deq_bits_cmd = T23;
  assign T23 = T11[4'he:4'ha];
  assign io_deq_bits_tag = T24;
  assign T24 = T11[5'h17:4'hf];
  assign io_deq_bits_addr = T25;
  assign T25 = T11[6'h3f:5'h18];
  assign io_deq_valid = T26;
  assign T26 = empty ^ 1'h1;
  assign empty = ptr_match & T27;
  assign T27 = maybe_full ^ 1'h1;
  assign io_enq_ready = T28;
  assign T28 = full ^ 1'h1;
  assign full = ptr_match & maybe_full;

  always @(posedge clk) begin
    if(reset) begin
      R1 <= 4'h0;
    end else if(do_deq) begin
      R1 <= T3;
    end
    if(reset) begin
      R4 <= 4'h0;
    end else if(do_enq) begin
      R4 <= T6;
    end
    if(reset) begin
      maybe_full <= 1'h0;
    end else if(T9) begin
      maybe_full <= do_enq;
    end
    if (do_enq)
      ram[R4] <= T13;
  end
endmodule