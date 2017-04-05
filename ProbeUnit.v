/**************2016/10***********
*Function:MSHRå¤±æ•ˆå¤„?†?Š¶æ€?œ?
*Organization:     MPRC
*Author:           lll
*Email:            liuwenli@pku.edu.cn
*Filename:         MSHRstatemachine
*Revision History: v0
********************************/
/*  prober.io.req.valid := io.mem.probe.valid && !lrsc_valid
  io.mem.probe.ready := prober.io.req.ready && !lrsc_valid
  prober.io.req.bits := io.mem.probe.bits
  releaseArb.io.in(1) <> prober.io.rep
  prober.io.way_en := s2_tag_match_way
  prober.io.block_state := s2_hit_state
  metaReadArb.io.in(2) <> prober.io.meta_read
  metaWriteArb.io.in(1) <> prober.io.meta_write
  prober.io.mshr_rdy := mshrs.io.probe_rdy
*/

//-----------definition--------------
`define s_invalid 0
`define s_meta_read 1
`define s_meta_resp 2
`define s_mshr_req 3
`define s_mshr_resp 4
`define s_release 5
`define s_writeback_req 6
`define s_writeback_resp 7
`define s_meta_write 8
//------------module:MSHR_State------------
module mprcProbeUnit(
    input clk, 
    input reset,
    input [3:0] io_way_en,
    input  io_mshr_rdy,
    input [1:0] io_block_state_state, 
    input  io_req_valid,
    input [25:0] io_req_bits_addr_block,
    input [1:0] io_req_bits_p_type,
    //input [1:0] io_req_bits_client_xact_i
    input  io_rep_ready,
    input  io_meta_read_ready,
    input  io_meta_write_ready,
    input  io_wb_req_ready,
	
	output io_req_ready,
	
	output io_rep_valid,
    output[1:0] io_rep_bits_addr_beat,
    output[25:0] io_rep_bits_addr_block,
    output[1:0] io_rep_bits_client_xact_id,
    output io_rep_bits_voluntary,
    output[2:0] io_rep_bits_r_type,
    output[127:0] io_rep_bits_data,
	
	output io_meta_read_valid,
    output[5:0] io_meta_read_bits_idx,
    //output[3:0] io_meta_read_bits_way_en
    output[19:0] io_meta_read_bits_tag,
	
	output io_meta_write_valid,
    output[5:0] io_meta_write_bits_idx,
    output[3:0] io_meta_write_bits_way_en,
    output[19:0] io_meta_write_bits_data_tag,
    output[1:0] io_meta_write_bits_data_coh_state,
	
    output io_wb_req_valid,
    output[1:0] io_wb_req_bits_addr_beat,
    output[25:0] io_wb_req_bits_addr_block,
    output[1:0] io_wb_req_bits_client_xact_id,
    output io_wb_req_bits_voluntary,
    output[2:0] io_wb_req_bits_r_type,
    output[127:0] io_wb_req_bits_data,
    output[3:0] io_wb_req_bits_way_en

);

	reg[3:0] cur_state;
	reg[3:0] next_state;
	reg[3:0] cur_way_en;
	reg[3:0] next_way_en;
	reg[1:0] cur_old_coh_state;
	reg[1:0] next_old_coh_state;
	reg[1:0] cur_req_p_type;
	reg[1:0] next_req_p_type;
	reg[25:0] cur_req_addr_block;
	reg[25:0] next_req_addr_block;
	//?Š¶æ€è¿ç§»ä¿¡??
	reg tag_match;
	reg need_writeback;
	//è¾“?‡ºç›¸å…³ä¿¡??
	reg[1:0] write_coh_state;
	reg[1:0] miss_coh_state;
	reg[1:0] coh_state;
	reg[2:0] reply_r_type;
	
	
	//?Š¶æ€?œ?
	always @(*)  begin
	
		tag_match = cur_way_en !=4'h0;
		need_writeback = (cur_old_coh_state == 2'h3) & tag_match;
		next_state = `s_invalid;
		case (cur_state)
			`s_invalid: begin
				if(io_req_valid && io_req_ready) begin
					next_state = `s_meta_read;
					next_req_p_type = io_req_bits_p_type;
					next_req_addr_block = io_req_bits_addr_block;
				end	
				else begin
					next_state = `s_invalid;
					next_req_p_type = cur_req_p_type;
					next_req_addr_block= cur_req_addr_block;
				end
			end
			`s_meta_read: begin
				if(io_meta_read_ready && io_meta_read_valid) 
					next_state = `s_meta_resp;
				else
					next_state = `s_invalid;
			end
			`s_meta_resp: begin
				next_state = `s_mshr_req;
			end
			`s_mshr_req: begin
				next_old_coh_state = io_block_state_state;
				next_way_en = io_way_en;
				if(io_mshr_rdy==0)
					next_state = `s_meta_read;
				else
					next_state = `s_mshr_resp;
			end
			`s_mshr_resp: begin
				if(need_writeback)
					next_state = `s_writeback_req;
				else
					next_state = `s_release;
			end
			`s_release: begin
				if(io_rep_ready && tag_match)
					next_state = `s_meta_write;
				else if(io_rep_ready && tag_match==0)
					next_state = `s_invalid;
				else
					next_state = `s_release;
			end
			`s_writeback_req: begin
				if(io_wb_req_ready && io_wb_req_valid)
					next_state = `s_writeback_resp;
				else
					next_state = `s_writeback_req;
			end
			`s_writeback_resp: begin
				if(io_wb_req_ready)
					next_state = `s_meta_write;
				else
					next_state = `s_writeback_resp;
			end
			`s_meta_write: begin
				if(io_meta_write_ready && io_meta_write_valid)
					next_state = `s_invalid;
				else
					next_state = `s_meta_write;
			end
			default: begin
				next_state = `s_invalid;
				next_req_p_type = cur_req_p_type;
				next_req_addr_block= cur_req_addr_block;
				next_old_coh_state = cur_old_coh_state;
				next_way_en = cur_way_en;
			end
		endcase
	end
				
	always @(posedge clk) begin
		if(reset) begin 
			cur_state<=`s_invalid;	
			//?˜???è¦reset?…¶ä?–?š„å¯„å­˜?™¡§
		end
		else begin
			cur_state<=next_state;
			cur_req_p_type<=next_req_p_type;
			cur_req_addr_block<=next_req_addr_block;
			cur_old_coh_state<=next_old_coh_state;
			cur_way_en<=next_way_en;
		end
	end		
	
	//è¾“?‡ºä¿¡??
	always @(*) begin
		//metaä¸€¨¨‡´æ€§çŠ¶æ€?š„?”Ÿ?ˆ
		if(cur_req_p_type == 2'h0)
			write_coh_state = 2'h0;
		else if(cur_req_p_type == 2'h1)
			write_coh_state = 2'h1;
		else if(cur_req_p_type == 2'h2) 
			write_coh_state = cur_old_coh_state;
		else
			write_coh_state = cur_old_coh_state;

		miss_coh_state = 2'h0;
		coh_state = tag_match ? cur_old_coh_state : miss_coh_state;
		//mem?€release?“ä½œç±»å‹?š„?”Ÿ?ˆ
		if(cur_req_p_type == 2'h0) begin
			if(coh_state == 2'h3)
				reply_r_type = 3'h0;
			else
				reply_r_type = 3'h3;
		end
		else if(cur_req_p_type == 2'h1) begin
			if(coh_state == 2'h3)
				reply_r_type = 3'h1;
			else
				reply_r_type = 3'h4;
		end
		else if(cur_req_p_type == 2'h2) begin
			if(coh_state == 2'h3)
				reply_r_type = 3'h2;
			else
				reply_r_type = 3'h5;
		end
		else
			reply_r_type = 3'h3;
	end
	//è¾“?‡ºä¿¡?·çš„?”Ÿ?ˆ	
	assign  io_req_ready = cur_state == `s_invalid;

	assign io_meta_read_valid = cur_state == `s_meta_read;
	assign io_meta_read_bits_idx = cur_req_addr_block[3'h5:1'h0];
	assign io_meta_read_bits_tag = cur_req_addr_block >> 3'h6; 

	assign io_meta_write_valid = cur_state == `s_meta_write;
	assign io_meta_write_bits_idx = cur_req_addr_block[3'h5:1'h0];
	assign io_meta_write_bits_way_en = cur_way_en;
	assign io_meta_write_bits_data_tag = cur_req_addr_block >> 3'h6;
	assign io_meta_write_bits_data_coh_state = write_coh_state;

	assign io_rep_valid = cur_state == `s_release;
	assign io_rep_bits_addr_beat = 2'h0;
	assign io_rep_bits_addr_block = cur_req_addr_block;//req_addr_block <= io_req_bits_addr_block
	assign io_rep_bits_client_xact_id = 2'h0;
	assign io_rep_bits_voluntary = 1'h0;
	assign io_rep_bits_r_type = reply_r_type;
	assign io_rep_bits_data = 128'h0;
	
	assign io_wb_req_valid = cur_state == `s_writeback_req;
	assign io_wb_req_bits_addr_beat = 2'h0;
	assign io_wb_req_bits_addr_block = cur_req_addr_block;
	assign io_wb_req_bits_client_xact_id = 2'h0;
	assign io_wb_req_bits_voluntary = 1'h0;
	assign io_wb_req_bits_r_type = reply_r_type;//req_p_type <= io_req_bits_p_type
	assign io_wb_req_bits_data = 128'h0;
	assign io_wb_req_bits_way_en = cur_way_en;//way_en <= io_way_en

endmodule


