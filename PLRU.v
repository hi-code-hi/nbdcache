/**************2016/12***********
*Function:         cache_PLRU  
*Organization:     MPRC
*Author:           Yang Ruichao
*Email:            yangruichao@pku.edu.cn
*Filename:         PLRU
*Revision History: v0
********************************/

module mprcPLRU(
	  input clk, 
    input reset,
    input [5:0] set,
    input valid,
    input hit,
    input [3:0] way_in,
    output [3:0] way_out
);

reg[2:0] state_reg[0:63];
reg[2:0] B_idx;
reg[3:0] replaced_way_en;
reg[2:0] idx_tmp;
integer k;

assign way_out = replaced_way_en;

always @(*)  begin
  
if(valid) begin
  B_idx <= state_reg[set];
  
  if(hit == 1) begin
		replaced_way_en <= way_in;
		case(way_in)
			4'b0001 : begin idx_tmp <= {B_idx[2], 2'b11}; end
			4'b0010 : begin idx_tmp <= {B_idx[2],2'b01}; end
			4'b0100 : begin idx_tmp <= {1'b1, B_idx[1],1'b0}; end
			4'b1000 : begin idx_tmp <= {1'b0, B_idx[1],1'b0}; end
			default : begin idx_tmp <= B_idx; end
		endcase
		
  end else begin	  
		  case(B_idx)
		  	3'b000 : begin replaced_way_en <= 4'b0001; idx_tmp <= {B_idx[2], 2'b11}; end
		  	3'b100 : begin replaced_way_en <= 4'b0001; idx_tmp <= {B_idx[2], 2'b11}; end
			3'b010 : begin replaced_way_en <= 4'b0010; idx_tmp <= {B_idx[2],2'b01}; end
			3'b110 : begin replaced_way_en <= 4'b0010; idx_tmp <= {B_idx[2],2'b01}; end
			3'b001 : begin replaced_way_en <= 4'b0100; idx_tmp <= {1'b1, B_idx[1],1'b0}; end
			3'b011 : begin replaced_way_en <= 4'b0100; idx_tmp <= {1'b1, B_idx[1],1'b0}; end
			3'b101 : begin replaced_way_en <= 4'b1000; idx_tmp <= {1'b0, B_idx[1],1'b0}; end
			3'b111 : begin replaced_way_en <= 4'b1000; idx_tmp <= {1'b0, B_idx[1],1'b0}; end
			default : begin replaced_way_en <= 4'b0000; idx_tmp <= B_idx; end
		  endcase

	end	 
end else begin
  replaced_way_en <= way_in;
  case(way_in)
			4'b0001 : idx_tmp <= {B_idx[2], 2'b11};
			4'b0010 : idx_tmp <= {B_idx[2], 2'b01};
			4'b0100 : idx_tmp <= {1'b1, B_idx[1],1'b0};
			4'b1000 : idx_tmp <= {1'b0, B_idx[1],1'b0};
			default : idx_tmp <= B_idx;
		endcase

end
end


always @(posedge clk) begin

if(reset) begin
  for(k = 0; k < 22; k = k + 1) begin state_reg[k] <= 3'b000; 
  end
  state_reg[22] <= 3'b000;
  for(k = 23; k < 45; k = k + 1) begin state_reg[k] <= 3'b000;
    end
    state_reg[45] <= 3'b000;
   for(k = 46; k < 64; k = k + 1) begin state_reg[k] <= 3'b000;
    end 
  //B_idx <= 3'b011;
end
if(valid) begin
  state_reg[set] = idx_tmp;
end

end

endmodule
