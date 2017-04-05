module mprcStage1(
    //cpu发出的请求信号:
    input clk,
    input reset,
    input init,
    input [8:0] io_cpu_req_bits_tag,
    input [4:0] io_cpu_req_bits_cmd,
    input [2:0] io_cpu_req_bits_typ,
    input  io_cpu_req_bits_kill,
    input  io_cpu_req_bits_phys,
    input [63:0] io_cpu_req_bits_data,
    input io_cpu_req_ready,
    
    
    //mshr 
    input[8:0] mshrs_io_replay_bits_tag,
    input[4:0] mshrs_io_replay_bits_cmd,
    input[2:0] mshrs_io_replay_bits_typ,
    input mshrs_io_replay_bits_kill,
    input mshrs_io_replay_bits_phys,
    input[63:0] mshrs_io_replay_bits_data,
     
    
    
    //s2_req
    input[39:0] s2_req_addr,
    input[8:0] s2_req_tag,
    input[4:0] s2_req_cmd,
    input[2:0] s2_req_typ,
    input s2_req_kill,
    input s2_req_phys,
    input[63:0] s2_req_data,
    
    
    
    //readmetaArb 
    output metaReadArb_io_in_4_ready,
    input  io_cpu_req_valid,
    input[39:0] io_cpu_req_bits_addr,
    
    output metaReadArb_io_in_3_ready,
    input wb_io_meta_read_valid,
    input[19:0] wb_io_meta_read_bits_tag,
    input[5:0] wb_io_meta_read_bits_idx,
    
    output metaReadArb_io_in_2_ready,
    input prober_io_meta_read_valid,
    input[19:0] prober_io_meta_read_bits_tag,
    input[5:0] prober_io_meta_read_bits_idx,
    
    output metaReadArb_io_in_1_ready,
    input mshrs_io_meta_read_valid,
    input[5:0] mshrs_io_meta_read_bits_idx,
    input[3:0] mshrs_io_meta_read_bits_way_en,
    
    input s2_recycle,
    
    
    
    //readdataArb
    output readArb_io_in_3_ready,
    output readArb_io_in_2_ready,
    input wb_io_data_req_valid,
    input[3:0] wb_io_data_req_bits_way_en,
    input[11:0] wb_io_data_req_bits_addr,
    output readArb_io_in_1_ready,
    input mshrs_io_replay_valid,
    input[39:0] mshrs_io_replay_bits_addr,
    
    input narrow_grant_valid,
    input narrow_grant_ready,

    
    
    //meta write wire
    output meta_io_write_ready,
    input metaWriteArb_io_out_valid,
    input[5:0] metaWriteArb_io_out_bits_idx,
    input[3:0] metaWriteArb_io_out_bits_way_en,
    input[19:0] metaWriteArb_io_out_bits_data_tag,
    input[1:0] metaWriteArb_io_out_bits_data_coh_state,
    
      
    
    //data write wire
    output data_io_write_ready,
    input writeArb_io_out_valid,
    input[3:0] writeArb_io_out_bits_way_en,
    input[11:0] writeArb_io_out_bits_addr,
    input[1:0] writeArb_io_out_bits_wmask,
    input[127:0] writeArb_io_out_bits_data,
    
    
    
    
    //meta output
    output[19:0] meta_io_resp_3_tag,
    output[19:0] meta_io_resp_2_tag,
    output[19:0] meta_io_resp_1_tag,
    output[19:0] meta_io_resp_0_tag,
    output[1:0] meta_io_resp_3_coh_state,
    output[1:0] meta_io_resp_2_coh_state,
    output[1:0] meta_io_resp_1_coh_state,
    output[1:0] meta_io_resp_0_coh_state,
    
    
    
    //data output
    output[127:0] data_io_resp_3,
    output[127:0] data_io_resp_2,
    output[127:0] data_io_resp_1,
    output[127:0] data_io_resp_0,
  

    //s1/s2 pipeline registers output
    output reg s1_valid,
    output reg s1_replay,
    output reg s1_recycled,
    output reg s1_clk_en,
    output reg[39:0] s1_req_addr,
    output reg[8:0] s1_req_tag,
    output reg[4:0] s1_req_cmd,
    output reg[2:0] s1_req_typ,
    output reg s1_req_kill,
    output reg s1_req_phys,
    output reg[63:0] s1_req_data,
    
    output metaReadArb_io_out_valid

);



//wire between modules
wire meta_io_read_ready;
wire[5:0] metaReadArb_io_out_bits_idx;
wire[3:0] metaReadArb_io_out_bits_way_en;
wire[3:0] readArb_io_out_bits_way_en;
wire[11:0] readArb_io_out_bits_addr;
wire readArb_io_out_valid;



//wire temperate to generate combinatorial logic
wire[5:0] cpu_req_addr_idx;
wire[39:0] wb_io_meta_read_bits_addr;
wire[39:0] prober_io_meta_read_bits_addr;


wire[25:0] block_wb;
wire[31:0] block_shift_left_wb;

wire[25:0] block_prober;
wire[31:0] block_shift_left_prober;

assign cpu_req_addr_idx = io_cpu_req_bits_addr[11:6];
assign block_wb = {wb_io_meta_read_bits_tag, wb_io_meta_read_bits_idx};
assign block_shift_left_wb = block_wb << 6;
assign wb_io_meta_read_bits_addr = {8'h0,block_shift_left_wb};
assign block_prober = {prober_io_meta_read_bits_tag, prober_io_meta_read_bits_idx};
assign block_shift_left_prober = block_prober << 6;
assign prober_io_meta_read_bits_addr = {8'h0,block_shift_left_prober};





/* metaRedaArb instantiation
 ** 5 input
 **   4:cpu
 **   3:wb
 **   2:probe
 **   1:mshr
 **   0:recycle
 */
mprcArbiter_0 metaReadArb(
  .io_in_4_ready(metaReadArb_io_in_4_ready),
  .io_in_4_valid(io_cpu_req_valid),
  .io_in_4_bits_idx(cpu_req_addr_idx),
  
  .io_in_3_ready(metaReadArb_io_in_3_ready),
  .io_in_3_valid( wb_io_meta_read_valid ),
  .io_in_3_bits_idx( wb_io_meta_read_bits_idx ),
  
  .io_in_2_ready( metaReadArb_io_in_2_ready ),
  .io_in_2_valid( prober_io_meta_read_valid ),
  .io_in_2_bits_idx( prober_io_meta_read_bits_idx ),
  
  .io_in_1_ready( metaReadArb_io_in_1_ready ),
  .io_in_1_valid( mshrs_io_meta_read_valid ),
  .io_in_1_bits_idx( mshrs_io_meta_read_bits_idx ),
  .io_in_1_bits_way_en( mshrs_io_meta_read_bits_way_en ),
  
  .io_in_0_valid(s2_recycle),
  .io_in_0_bits_idx(s2_req_addr[11:6]),
  
  .io_out_ready(meta_io_read_ready),
  .io_out_valid(metaReadArb_io_out_valid),
  .io_out_bits_idx( metaReadArb_io_out_bits_idx ),
  .io_out_bits_way_en( metaReadArb_io_out_bits_way_en )
  
);

  //meta instantiation
  mprcMetadataArray meta(.clk(clk), .reset(reset),
    .io_read_ready( meta_io_read_ready ),
    .io_read_valid( metaReadArb_io_out_valid ),
    .io_read_bits_idx( metaReadArb_io_out_bits_idx ),
    .io_read_bits_way_en( metaReadArb_io_out_bits_way_en ),
    
    .io_write_ready( meta_io_write_ready ),
    .io_write_valid( metaWriteArb_io_out_valid ),
    .io_write_bits_idx( metaWriteArb_io_out_bits_idx ),
    .io_write_bits_way_en( metaWriteArb_io_out_bits_way_en ),
    .io_write_bits_data_tag(metaWriteArb_io_out_bits_data_tag),
    .io_write_bits_data_coh_state(metaWriteArb_io_out_bits_data_coh_state),


    .io_resp_3_tag(meta_io_resp_3_tag),
    .io_resp_3_coh_state(meta_io_resp_3_coh_state),
    .io_resp_2_tag( meta_io_resp_2_tag ),
    .io_resp_2_coh_state( meta_io_resp_2_coh_state ),
    .io_resp_1_tag( meta_io_resp_1_tag ),
    .io_resp_1_coh_state( meta_io_resp_1_coh_state ),
    .io_resp_0_tag( meta_io_resp_0_tag ),
    .io_resp_0_coh_state( meta_io_resp_0_coh_state ),
    
    .init(init)
  );


 //dataReadArb instantiation
 /* 4 input
 **   3:cpu
 **   2:wb
 **   1:mshr replay
 **   0:recycle
 */
mprcArbiter_2 readArb(
  .io_in_3_ready(readArb_io_in_3_ready),
  .io_in_3_valid(io_cpu_req_valid),
  .io_in_3_bits_way_en(4'hf),
  .io_in_3_bits_addr(io_cpu_req_bits_addr[4'hb:1'h0]),
  
  .io_in_2_ready(readArb_io_in_2_ready),
  .io_in_2_valid(wb_io_data_req_valid),
  .io_in_2_bits_way_en(wb_io_data_req_bits_way_en),
  .io_in_2_bits_addr(wb_io_data_req_bits_addr[4'hb:1'h0]),
  
  .io_in_1_ready(readArb_io_in_1_ready),
  .io_in_1_valid(mshrs_io_replay_valid),
  .io_in_1_bits_way_en(4'hf),
  .io_in_1_bits_addr(mshrs_io_replay_bits_addr[4'hb:1'h0]),
  
  //.io_in_0_ready()
  .io_in_0_valid(s2_recycle),
  .io_in_0_bits_way_en( 4'hf ),
  .io_in_0_bits_addr(s2_req_addr[4'hb:1'h0]),
  
  
  .io_out_ready(  !narrow_grant_valid | narrow_grant_ready ),   //.........1..........
  .io_out_valid( readArb_io_out_valid ),
  .io_out_bits_way_en( readArb_io_out_bits_way_en ),
  .io_out_bits_addr( readArb_io_out_bits_addr )
  );

//data instantiation
    mprcDataArray data(
      .clk(clk),
      
      .io_read_valid(readArb_io_out_valid),
      .io_read_bits_way_en( readArb_io_out_bits_way_en ),
      .io_read_bits_addr(readArb_io_out_bits_addr),
      
      .io_write_ready(data_io_write_ready),
      .io_write_valid( writeArb_io_out_valid ),
      .io_write_bits_way_en( writeArb_io_out_bits_way_en ),
      .io_write_bits_addr( writeArb_io_out_bits_addr ),
      .io_write_bits_wmask( writeArb_io_out_bits_wmask ),
      .io_write_bits_data( writeArb_io_out_bits_data  ),//some different from official website
      
      .io_resp_3( data_io_resp_3 ),
      .io_resp_2( data_io_resp_2 ),
      .io_resp_1( data_io_resp_1 ),
      .io_resp_0( data_io_resp_0 )
    );



always @(posedge clk)
begin
  
  // s1/s2 pipeline registers
  if(reset)begin
    s1_valid <=1'h0;
  end else begin
    s1_valid <= io_cpu_req_ready & io_cpu_req_valid;
  end
  
  if(reset)begin
    s1_replay <=1'h0;
  end else begin
    s1_replay <= mshrs_io_replay_valid & readArb_io_in_1_ready;
  end
  
  if(reset)begin
    s1_recycled <= 1'h0;
  end else begin
    s1_recycled <= s2_recycle;
  end
  
  if(reset)begin
    s1_clk_en <= 1'h0;
  end else begin
    s1_clk_en <= metaReadArb_io_out_valid;
  end
  
  
  if(reset)begin
    s1_req_addr <= 40'h0;
  end  else if(s2_recycle)begin
    s1_req_addr <= s2_req_addr;
  end else if(mshrs_io_replay_valid)begin
    s1_req_addr <= mshrs_io_replay_bits_addr;
  end else if(prober_io_meta_read_valid) begin
    s1_req_addr <= prober_io_meta_read_bits_addr;
  end else if(wb_io_meta_read_valid)begin
    s1_req_addr <= wb_io_meta_read_bits_addr;
  end else if(io_cpu_req_valid) begin
    s1_req_addr <= io_cpu_req_bits_addr;
  end
  
  if(reset)begin
    s1_req_phys <= 1'h1;
  end else if(s2_recycle) begin
    s1_req_phys <= s2_req_phys;
  end else if(mshrs_io_replay_valid) begin
    s1_req_phys <= mshrs_io_replay_bits_phys;
  end else if(prober_io_meta_read_valid) begin
    s1_req_phys <= 1'h1;
  end else if(wb_io_meta_read_valid) begin
    s1_req_phys <= 1'h1;
  end else if(io_cpu_req_valid) begin
    s1_req_phys <= io_cpu_req_bits_phys;
  end
  
  if(reset)begin
    s1_req_tag <= 9'h0;
  end if(s2_recycle) begin
     s1_req_tag <= s2_req_tag;
  end else if(mshrs_io_replay_valid) begin
    s1_req_tag <= mshrs_io_replay_bits_tag;
  end else if(io_cpu_req_valid) begin
    s1_req_tag <= io_cpu_req_bits_tag;
  end
  
  if(reset)begin
    s1_req_cmd <= 5'h0;
  end else if(s2_recycle) begin
    s1_req_cmd <= s2_req_cmd;
  end else if(mshrs_io_replay_valid) begin
    s1_req_cmd <= mshrs_io_replay_bits_cmd;
  end else if(io_cpu_req_valid) begin
    s1_req_cmd <= io_cpu_req_bits_cmd;
  end
  
  if(reset)begin
    s1_req_typ <= 3'h0;
  end else if(s2_recycle) begin
    s1_req_typ <= s2_req_typ;
  end else if(mshrs_io_replay_valid) begin
    s1_req_typ <= mshrs_io_replay_bits_typ;
  end else if(io_cpu_req_valid) begin
    s1_req_typ <= io_cpu_req_bits_typ;
  end
  
  if(reset)begin
    s1_req_kill <= 1'h0;
  end else if(s2_recycle) begin
    s1_req_kill <= s2_req_kill;
  end else if(mshrs_io_replay_valid) begin
    s1_req_kill <= mshrs_io_replay_bits_kill;
  end else if(io_cpu_req_valid) begin
    s1_req_kill <= io_cpu_req_bits_kill;
  end
  
  
  if(reset)begin
    s1_req_data <= 64'h0;
  end else if(s2_recycle) begin
    s1_req_data <= s2_req_data;
  end else if(mshrs_io_replay_valid) begin
    s1_req_data <= mshrs_io_replay_bits_data;
  end else if(io_cpu_req_valid) begin
    s1_req_data <= io_cpu_req_bits_data;
  end


end

endmodule