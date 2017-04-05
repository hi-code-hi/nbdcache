/**************2016/10***********
*Function:MSHRÂ§±ÊïàÂ§Ñ?êÜ?ä∂ÊÄÅ?ú?
*Organization:     MPRC
*Author:           lll
*Email:            liuwenli@pku.edu.cn
*Filename:         MSHRstatemachine
*Revision History: v0
********************************/
//-----------definition--------------
`define s_invalid 0
`define s_wb_req 1
`define s_wb_resp 2
`define s_meta_clear 3
`define s_refill_req 4
`define s_refill_resp 5
`define s_meta_write_req 6
`define s_meta_write_resp 7
`define s_drain_rpq 8
//------------module:MSHR_State------------
module mprcMSHR_State(
	input clk, 
	input reset,
	
	input io_req_pri_val,
	input io_req_bits_tag_match,
	input io_mem_grant_valid,
	input io_meta_write_ready,
	input io_replay_ready,
	
	input idx_match,
	input cmd_requires_second_acquire,
	
	input coh_isHit,
	input coh_require_wb,
	input wb_req_fire,
	input wb_req_requireAck,
	input mem_req_fire,
	
	input rpq_deq_valid,
	input refill_done,
	
	input[1:0] coh_on_grant,
	input[1:0] coh_on_hit,
	//input mshr_io_idx_match,
	
	output io_wb_req_valid,
	output io_meta_write_valid,
	output io_mem_req_valid,
	output io_meta_read_valid,
	output io_replay_valid,
	output io_idx_match,
	output io_req_pri_rdy,
	output rpq_dep_ready,
	
	output[1:0] new_coh_state,
	output sec_rdy,
	
	output [3:0] out_state,
	//output req_cmd
	
	
	input io_mem_release_valid,
  input[1:0] io_mem_release_bits_addr_beat
);
	reg[3:0] cur_state,next_state;
	//wire idx_match;
	//reg[1:0] coh_state;
	//wire sec_rdy;
	reg[1:0] coh_state;
	
	always @(*)  begin
	
		case (cur_state)
			//0000
			`s_invalid: begin
				if(io_req_pri_val && io_req_pri_rdy) begin
					if(io_req_bits_tag_match) begin//hit
						if(coh_isHit) begin//just need to modify local cache coh state
							next_state=`s_meta_write_req; 
							coh_state=coh_on_hit; //new_coh_state
						end
						else
							next_state=`s_refill_req; // need to modify other caches coh state
					end	
					else begin//miss
						next_state=coh_require_wb?`s_wb_req:`s_meta_clear;
					end
				end
				else
					next_state=`s_invalid; 
			end
			//0001
			`s_wb_req: begin
				if(wb_req_fire) 
					next_state=wb_req_requireAck?`s_wb_resp:`s_meta_clear;
				else
					next_state=`s_wb_req;
			end
			
			//0010
			`s_wb_resp: begin                                                      //this place is different the original design
				if(io_mem_release_valid && (io_mem_release_bits_addr_beat == 2'b11))//the original design : if(io_mem_grant_valid)
					next_state=`s_meta_clear;
				else
					next_state=`s_wb_resp;
			end
		
			//0011
			`s_meta_clear: begin
				coh_state=2'b00;
				if(io_meta_write_ready) begin
					next_state=`s_refill_req;
				end
				else
					next_state=`s_meta_clear;
			end
		
			//0100
			`s_refill_req: begin
				if(mem_req_fire)
					next_state=`s_refill_resp;
				else
					next_state=`s_refill_req;
			end
			
			//0101
			`s_refill_resp: begin
				if(refill_done)
					next_state=`s_meta_write_req;
				else
					next_state=`s_refill_resp;
				if(io_mem_grant_valid) 
					coh_state=coh_on_grant;
			end
			
			//0110
			`s_meta_write_req: begin
				if(io_meta_write_ready)
					next_state=`s_meta_write_resp;
				else
					next_state=`s_meta_write_req;
			end
				
			//0111
			`s_meta_write_resp: begin
				next_state=`s_drain_rpq;
			end
			
			//1000
			`s_drain_rpq: begin
				if(!rpq_deq_valid)
					next_state=`s_invalid;
				else
					next_state=`s_drain_rpq;
			end
			
			default: begin
				next_state=`s_invalid;
			end
		endcase
	end
	
	always @(posedge clk) begin
		if(reset) begin 
			cur_state<=`s_invalid;
			coh_state<=2'b00;
		end
		else
			cur_state<=next_state;
	end
  
  assign out_state = cur_state;	
	assign rpq_dep_ready = (io_replay_ready && cur_state===`s_drain_rpq) || cur_state===`s_invalid;
	assign io_req_pri_rdy = cur_state===`s_invalid;
	assign io_meta_write_valid = cur_state===`s_meta_write_req || cur_state===`s_meta_clear;
	assign new_coh_state = coh_state; 
	assign io_wb_req_valid = cur_state === `s_wb_req;
	assign io_mem_req_valid = cur_state ===`s_refill_req;
	assign io_meta_read_valid = cur_state ===`s_drain_rpq;
	assign io_replay_valid = cur_state ===`s_drain_rpq && rpq_deq_valid;
	assign sec_rdy=idx_match && ((cur_state == `s_wb_req || cur_state == `s_wb_resp || cur_state == `s_meta_clear) || ((cur_state == `s_refill_req || cur_state == `s_refill_resp) &&  !cmd_requires_second_acquire));
	assign io_idx_match = (cur_state != `s_invalid) && idx_match;
			
endmodule		