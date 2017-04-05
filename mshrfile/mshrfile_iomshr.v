`include "../util/common.vh"                                                                         

module mprcIOMSHR(input clk, input reset,
    output io_req_ready,
    input  io_req_valid,
    
    input [39:0] io_req_bits_addr,
    input [8:0] io_req_bits_tag,
    input [4:0] io_req_bits_cmd,
    input [2:0] io_req_bits_typ,
    input  io_req_bits_kill,
    input  io_req_bits_phys,
    input [63:0] io_req_bits_data,
    
    input  io_acquire_ready,
    output io_acquire_valid,
    output[25:0] io_acquire_bits_addr_block,
    output[1:0] io_acquire_bits_client_xact_id,
    output[1:0] io_acquire_bits_addr_beat,
    output io_acquire_bits_is_builtin_type,
    output[2:0] io_acquire_bits_a_type,
    output[16:0] io_acquire_bits_union,
    output[127:0] io_acquire_bits_data,
    
    input  io_grant_valid,
    input [1:0] io_grant_bits_addr_beat,
    input [1:0] io_grant_bits_client_xact_id,
    input [3:0] io_grant_bits_manager_xact_id,
    input  io_grant_bits_is_builtin_type,
    input [3:0] io_grant_bits_g_type,
    input [127:0] io_grant_bits_data,
    
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
    output[63:0] io_resp_bits_store_data
);

  wire is_read;
  wire [127:0] T25;
  wire req_cmd_sc;
  
  wire [63:0] loadgen_data;
  
  wire [63:0] storegen_data;
  wire [7:0] storegen_mask;
  wire [63:0] wmask;
  wire [15:0] beat_mask;
  wire [127:0] bmask;
  
  reg [1:0] state;
  
  reg [39:0] req_addr;
  reg [8:0] req_tag;
  reg [4:0] req_cmd;
  reg [2:0] req_typ;
  reg req_kill;
  reg req_phys;
  reg [63:0] req_data;
  
  reg [63:0] grant_word;
  
  assign is_read =  (req_cmd[2'h3] == 1'h1) |
                    (req_cmd == `M_XA_SWAP) |
                    (req_cmd == `M_XRD) |
                    (req_cmd == `M_XLR) |
                    (req_cmd == `M_XSC);
  
  assign io_req_ready = state == 2'h0;
  assign io_acquire_valid = state == 2'h1;
  assign io_resp_valid = state == 2'h3;
  
  assign T25 = io_grant_bits_data >> {req_addr[2'h3], 6'h0};
  assign req_cmd_sc = req_cmd == `M_XSC;

  assign wmask = {8'h0 - storegen_mask[3'h7],
                  8'h0 - storegen_mask[3'h6],
                  8'h0 - storegen_mask[3'h5],
                  8'h0 - storegen_mask[3'h4],
                  8'h0 - storegen_mask[3'h3],
                  8'h0 - storegen_mask[3'h2],
                  8'h0 - storegen_mask[3'h1],
                  8'h0 - storegen_mask[3'h0]};
  
  assign beat_mask = storegen_mask << {req_addr[2'h3], 3'h0};
  assign bmask = wmask << {req_addr[2'h3], 6'h0};
  
  assign io_acquire_bits_addr_block = req_addr[5'h1f:3'h6];
  assign io_acquire_bits_client_xact_id = 2'h2;
  assign io_acquire_bits_addr_beat = req_addr[3'h5:3'h4];
  assign io_acquire_bits_is_builtin_type = 1'h1;
  assign io_acquire_bits_a_type = is_read ? 3'h0 : 3'h2;
  assign io_acquire_bits_union = is_read ? {4'h0, req_addr[2'h3:1'h0], req_typ, 6'h0} : {beat_mask, 1'h0};
  assign io_acquire_bits_data = {storegen_data, storegen_data} & bmask;
  
  assign io_resp_bits_addr = req_addr;
  assign io_resp_bits_tag = req_tag;
  assign io_resp_bits_cmd = req_cmd;
  assign io_resp_bits_typ = req_typ;
  assign io_resp_bits_data = loadgen_data;
  assign io_resp_bits_nack = 1'h0;
  assign io_resp_bits_replay = io_resp_valid;
  assign io_resp_bits_has_data = is_read;
  assign io_resp_bits_store_data = req_data;
  
  mprcLoadGen loadgen(
  .typ(req_typ),
  .addr(req_addr),
  .data_in({64'h0, grant_word}),
  .zero(req_cmd_sc),
  .data_out(loadgen_data),
  .data_word( )
  );
  
  mprcStoreGen storegen(
  .typ(req_typ),
  .addr(req_addr),
  .data_in({64'h0, req_data}),
  .data_out(storegen_data),
  .mask(storegen_mask),
  .data_word( )
  );
  always @(posedge clk) begin
    if(io_req_ready & io_req_valid) begin
      req_data <= io_req_bits_data;
      req_cmd <= io_req_bits_cmd;
      req_addr <= io_req_bits_addr;
      req_typ <= io_req_bits_typ;
      req_tag <= io_req_bits_tag;
      req_kill <= io_req_bits_kill;
      req_phys <= io_req_bits_phys;
    end
    
    if((state == 2'h2) & io_grant_valid & is_read) begin
      grant_word <= T25[6'h3f:1'h0];
    end
    
    if(reset) begin
      state <= 2'h0;
    end else if(io_resp_ready & io_resp_valid) begin
      state <= 2'h0;
    end else if((state == 2'h2) & io_grant_valid & ~is_read) begin
      state <= 2'h0;
    end else if((state == 2'h2) & io_grant_valid & is_read) begin
      state <= 2'h3;
    end else if(io_acquire_ready & io_acquire_valid) begin
      state <= 2'h2;
    end else if(io_req_ready & io_req_valid) begin
      state <= 2'h1;
    end
  end
endmodule