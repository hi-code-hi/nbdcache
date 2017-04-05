`include "common.vh"

module mprcStage4(
  input clk,
  input reset,
  
  input metaReadArb_io_out_valid,
  
  input s3_valid,
  input [3:0] s3_way,
  
  input [39:0] s3_req_addr,
  input [4:0] s3_req_cmd,
  input [2:0] s3_req_typ,
  input [8:0] s3_req_tag,
  input s3_req_kill,
  input s3_req_phys,
  input [63:0] s3_req_data, 
  
  output prober_meta_write_ready,
	input prober_meta_write_valid,
  input [5:0] prober_meta_write_bits_idx,
  input [3:0] prober_meta_write_bits_way_en,
  input [19:0] prober_meta_write_bits_data_tag,
  input [1:0] prober_meta_write_bits_data_coh_state,
  
  output  mshr_meta_write_ready,
  input mshr_meta_write_valid,
  input [5:0] mshr_meta_write_bits_idx,
  input [3:0] mshr_meta_write_bits_way_en,
  input [19:0] mshr_meta_write_bits_data_tag,
  input [1:0] mshr_meta_write_bits_data_coh_state,
  
  input [3:0] mshr_refill_way_en,
  input [11:0] mshr_refill_addr,
  
  output  FlowThroughSerializer_io_out_ready,
  input  FlowThroughSerializer_io_out_valid,
  input [1:0] FlowThroughSerializer_io_out_bits_client_xact_id,
  input  FlowThroughSerializer_io_out_bits_is_builtin_type,
  input [3:0] FlowThroughSerializer_io_out_bits_g_type,
  input [127:0] FlowThroughSerializer_io_out_bits_data,
  
  output reg s4_valid,
  output reg [39:0] s4_req_addr,
  output reg [4:0] s4_req_cmd,
  output reg [63:0] s4_req_data, 
  
  input meta_io_write_ready,
  output meta_io_write_valid,
  output [5:0] meta_io_write_idx,
  output [3:0] meta_io_write_way_en,
  output [19:0] meta_io_write_data_tag,
  output [1:0] meta_io_write_data_coh_state,

  input data_io_write_ready,
  output data_io_write_valid,
  output [3:0] data_io_write_way_en,
  output [11:0] data_io_write_addr,
  output [1:0] data_io_write_wmask,
  output [127:0] data_io_write_data
);

  wire writeArb_io_in_1_valid;
  wire writeArb_io_in_1_ready;
  wire [127:0] writeArb_io_out_bits_data;
  wire gnt_multi_data;
  wire s4_clk_en;
  wire grant_is_mshr;
  wire T1;
  wire T2;

  assign gnt_multi_data = FlowThroughSerializer_io_out_bits_is_builtin_type ? T2 : T1;
  assign T1 = (4'h0 == FlowThroughSerializer_io_out_bits_g_type) | (4'h1 == FlowThroughSerializer_io_out_bits_g_type);
  assign T2 = (4'h4 == FlowThroughSerializer_io_out_bits_g_type) | (4'h5 == FlowThroughSerializer_io_out_bits_g_type);  
  assign grant_is_mshr = FlowThroughSerializer_io_out_bits_client_xact_id < 2'h2;
  assign writeArb_io_in_1_valid = grant_is_mshr & FlowThroughSerializer_io_out_valid & gnt_multi_data;

  assign FlowThroughSerializer_io_out_ready = writeArb_io_in_1_ready | ~gnt_multi_data;
  assign s4_clk_en = metaReadArb_io_out_valid & s3_valid;
  
  mprcArbiter_1 metaWriteArb(
       .io_in_1_ready( prober_meta_write_ready ),
       .io_in_1_valid( prober_meta_write_valid ),
       .io_in_1_bits_idx( prober_meta_write_bits_idx ),
       .io_in_1_bits_way_en( prober_meta_write_bits_way_en ),
       .io_in_1_bits_data_tag( prober_meta_write_bits_data_tag ),
       .io_in_1_bits_data_coh_state( prober_meta_write_bits_data_coh_state ),
       
       .io_in_0_ready( mshr_meta_write_ready ),
       .io_in_0_valid( mshr_meta_write_valid ),
       .io_in_0_bits_idx( mshr_meta_write_bits_idx ),
       .io_in_0_bits_way_en( mshr_meta_write_bits_way_en ),
       .io_in_0_bits_data_tag( mshr_meta_write_bits_data_tag ),
       .io_in_0_bits_data_coh_state( mshr_meta_write_bits_data_coh_state ),
       
       .io_out_ready( meta_io_write_ready ),
       .io_out_valid( meta_io_write_valid ),
       .io_out_bits_idx( meta_io_write_idx ),
       .io_out_bits_way_en( meta_io_write_way_en ),
       .io_out_bits_data_tag( meta_io_write_data_tag ),
       .io_out_bits_data_coh_state( meta_io_write_data_coh_state ),
       .io_chosen( )
  );
  
  mprcArbiter_3 writeArb(
       .io_in_1_ready( writeArb_io_in_1_ready ),
       .io_in_1_valid( writeArb_io_in_1_valid ),
       .io_in_1_bits_way_en( mshr_refill_way_en ),
       .io_in_1_bits_addr( mshr_refill_addr ),
       .io_in_1_bits_wmask( 2'h3 ),
       .io_in_1_bits_data( FlowThroughSerializer_io_out_bits_data ),
       .io_in_0_valid( s3_valid ),
       .io_in_0_ready(  ),
       .io_in_0_bits_way_en( s3_way ),
       .io_in_0_bits_addr( s3_req_addr[4'hb:1'h0] ),
       .io_in_0_bits_wmask( 2'h1 << s3_req_addr[2'h3] ),
       .io_in_0_bits_data( {s3_req_data,s3_req_data} ),
       .io_out_ready( data_io_write_ready ),
       .io_out_valid( data_io_write_valid ),
       .io_out_bits_way_en( data_io_write_way_en ),
       .io_out_bits_addr( data_io_write_addr ),
       .io_out_bits_wmask( data_io_write_wmask ),
       .io_out_bits_data( writeArb_io_out_bits_data ),
       .io_chosen( )
  );
  
  mprcEncode encode(
    .encode_data_in(writeArb_io_out_bits_data),
    .encode_data_out(data_io_write_data)
  );
  
  always @(posedge clk) begin
    if (reset)
      s4_valid <= 1'h0;
    else
      s4_valid <= s3_valid;
    
    if(reset)begin
      s4_req_addr <= 40'h0;
      s4_req_cmd <= 5'h0;
      s4_req_data <= 64'h0;
    end else
    if (s4_clk_en) begin
      s4_req_addr <= s3_req_addr;
      s4_req_cmd <= s3_req_cmd;
      s4_req_data <= s3_req_data;
    end
  end
endmodule