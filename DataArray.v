/**************2016/11***********
*Function:         cache?•°æ??š„è¯»å†™
*Organization:     MPRC
*Author:           lll
*Email:            liuwenli@pku.edu.cn
*Filename:         dataarray
*Revision History: v0
**********************/
//-----------definition--------------
`define rowOffBits 3'h4
//`define SYNTHESIS 
module mprcDataArray(
	input clk,
    input io_read_valid,
    input [3:0] io_read_bits_way_en,//4ä¸?way
    input [11:0] io_read_bits_addr,//row?ç§?
	
    input  io_write_valid,
    input [3:0] io_write_bits_way_en,//4ä¸?row
    input [11:0] io_write_bits_addr,//
    input [1:0] io_write_bits_wmask,//é«˜ä½ä½?©ç?
    input [127:0] io_write_bits_data,//è¦?†™?…¥çš„ä¸€è·??š„?•°æ?
	
	output io_read_ready,
	output io_write_ready,
    output[127:0] io_resp_3,//row3?•°æ?
    output[127:0] io_resp_2,//row2?•°æ?
    output[127:0] io_resp_1,//row1?•°æ?
    output[127:0] io_resp_0//row0?•°æ?
    //input  init
);
	
	wire[7:0] raddr;
	wire[7:0] waddr;
	reg [11:0] read_bits_addr;
	wire read_data_comb_flag;
	//wire[1:0] io_read_bits_way_en;
	//wire[1:0] io_write_bits_way_en;
	wire[63:0] write_bits_mask_h_10;
	wire[63:0] write_bits_mask_l_10;
	wire[127:0] write_bits_mask_10;
	wire ren_0;
	wire[127:0] write_bits_data_0;
	wire wen_0;
	wire[127:0] resp_0;
	wire ren_1;
	wire[127:0] write_bits_data_1;
	wire wen_1;
	wire[127:0] resp_1;
	//wire[1:0] io_read_bits_way_en;
	//wire[1:0] io_write_bits_way_en;
	wire[63:0] write_bits_mask_h_32;
	wire[63:0] write_bits_mask_l_32;
	wire[127:0] write_bits_mask_32;
	wire ren_2;
	wire[127:0] write_bits_data_2;
	wire wen_2;
	wire[127:0] resp_2;
	wire ren_3;
	wire[127:0] write_bits_data_3;
	wire wen_3;
	wire[127:0] resp_3;
	wire[63:0] resp_0_l;
	wire[63:0] resp_0_h;
	wire[63:0] resp_1_l;
	wire[63:0] resp_1_h;
	wire[63:0] resp_2_l;
	wire[63:0] resp_2_h;
	wire[63:0] resp_3_l;
	wire[63:0] resp_3_h;
	
	//ram0-3?…??”¨å˜¨¦‡
	assign raddr = io_read_bits_addr >> `rowOffBits;
	assign waddr = io_write_bits_addr >> `rowOffBits;
	assign read_data_comb_flag=read_bits_addr[2'h3];//
	
	//ram1ram0?…??”¨å˜¨¦‡
	//assign io_read_bits_way_en=io_read_bits_way_en[1'h1:1'h0];
	//assign io_write_bits_way_en=io_write_bits_way_en[1'h1:1'h0];
	
	assign write_bits_mask_l_10=64'h0-{63'h0,io_write_bits_way_en[1'h0]};
	assign write_bits_mask_h_10=64'h0-{63'h0,io_write_bits_way_en[1'h1]};
	assign write_bits_mask_10={write_bits_mask_h_10,write_bits_mask_l_10};
	
	//ram0
	assign write_bits_data_0={io_write_bits_data[6'h3f:1'h0],io_write_bits_data[6'h3f:1'h0]};
	assign wen_0=(io_write_bits_way_en[1'h1:1'h0] != 2'h0) & io_write_valid & io_write_bits_wmask[1'h0];
	assign ren_0=(io_read_bits_way_en[1'h1:1'h0] != 2'h0) & io_read_valid;
	
	mprcDataArray_RAM Ram0 (
		.CLK(clk),
		//.init(init),
		.write_idx(waddr),
		.write_en(wen_0),
		.write_bits_data(write_bits_data_0),
		.write_bits_mask(write_bits_mask_10),
		.read_idx(raddr),
		.read_en(ren_0),
		.resp(resp_0)
	);
	
	//ram1
	assign write_bits_data_1={io_write_bits_data[7'h7f:7'h40],io_write_bits_data[7'h7f:7'h40]};
    assign ren_1=(io_read_bits_way_en[1'h1:1'h0] != 2'h0) & io_read_valid;
	assign wen_1=(io_write_bits_way_en[1'h1:1'h0] != 2'h0) & io_write_valid & io_write_bits_wmask[1'h1];

	mprcDataArray_RAM Ram1 (
		.CLK(clk),
		//.init(init),
		.write_idx(waddr),
		.write_en(wen_1),
		.write_bits_data(write_bits_data_1),
		.write_bits_mask(write_bits_mask_10),
		.read_idx(raddr),
		.read_en(ren_1),
		.resp(resp_1)
    );
	
	//ram3ram2?…??”¨å˜¨¦‡
	//assign io_read_bits_way_en=io_read_bits_way_en[2'h3:2'h2];
	//assign io_write_bits_way_en=io_write_bits_way_en[2'h3:2'h2];
	assign write_bits_mask_l_32=64'h0-{63'h0,io_write_bits_way_en[2'h2]};
	assign write_bits_mask_h_32=64'h0-{63'h0,io_write_bits_way_en[2'h3]};
	assign write_bits_mask_32={write_bits_mask_h_32,write_bits_mask_l_32};
	
	//ram2
	assign write_bits_data_2={io_write_bits_data[6'h3f:1'h0],io_write_bits_data[6'h3f:1'h0]};
	assign ren_2=(io_read_bits_way_en[2'h3:2'h2] != 2'h0) & io_read_valid;
	assign wen_2=(io_write_bits_way_en[2'h3:2'h2] != 2'h0) & io_write_valid & io_write_bits_wmask[1'h0];
	
	mprcDataArray_RAM Ram2 (
		.CLK(clk),
		//.init(init),
		.write_idx(waddr),
		.write_en(wen_2),
		.write_bits_data(write_bits_data_2),
		.write_bits_mask(write_bits_mask_32),
		.read_idx(raddr),
		.read_en(ren_2),
		.resp(resp_2)
	);
	
	
	//ram3
	assign write_bits_data_3={io_write_bits_data[7'h7f:7'h40],io_write_bits_data[7'h7f:7'h40]};
	assign ren_3=(io_read_bits_way_en[2'h3:2'h2] != 2'h0) & io_read_valid;
	assign wen_3=(io_write_bits_way_en[2'h3:2'h2] != 2'h0) & io_write_valid & io_write_bits_wmask[1'h1];

	mprcDataArray_RAM Ram3 (
		.CLK(clk),
		//.init(init),
		.write_idx(waddr),
		.write_en(wen_3),
		.write_bits_data(write_bits_data_3),
		.write_bits_mask(write_bits_mask_32),
		.read_idx(raddr),
		.read_en(ren_3),
		.resp(resp_3)
    );
    
    //è¯?ram0
	assign resp_0_l=read_data_comb_flag ? resp_1[6'h3f:1'h0] : resp_0[6'h3f:1'h0];
	assign resp_0_h=resp_1[6'h3f:1'h0];
	assign io_resp_0={resp_0_h,resp_0_l};
	
	//è¯?ram1
	assign resp_1_l=read_data_comb_flag ? resp_1[7'h7f:7'h40] : resp_0[7'h7f:7'h40];
	assign resp_1_h=resp_1[7'h7f:7'h40];
	assign io_resp_1={resp_1_h,resp_1_l};
	
	//è¯?ram2
	assign resp_2_l=read_data_comb_flag ? resp_3[6'h3f:1'h0] : resp_2[6'h3f:1'h0];
	assign resp_2_h=resp_3[6'h3f:1'h0];
	assign io_resp_2={resp_2_h,resp_2_l};
	
	//è¯?ram3
	assign resp_3_l=read_data_comb_flag ? resp_3[7'h7f:7'h40] : resp_2[7'h7f:7'h40];
	assign resp_3_h=resp_3[7'h7f:7'h40];
	assign io_resp_3={resp_3_h,resp_3_l};
	
  //readyä¿¡å·è?“?‡?
  assign io_write_ready = 1'h1;
  assign io_read_ready = 1'h1;
	
	always @(posedge clk) begin
		if(io_read_valid) begin
			read_bits_addr <= io_read_bits_addr;
		end
    end
    
endmodule

//?…±å››?‰‡ramï¼Œè¯»å†™ä¸€?‰‡ram
module mprcDataArray_RAM(
	input CLK,
	//input RST;
	//input init;
	input [7:0] write_idx,
	input write_en,
	input [127:0] write_bits_data,
	input [127:0] write_bits_mask,
	input [7:0] read_idx,
	input read_en,
	output [127:0] resp
);

	reg [7:0] reg_read_idx;
	reg [127:0] ram [255:0];//256ä¸?way?•¡ã
  
  integer i;
  always @(posedge CLK) begin//?†™ä¸€ä¸?row
    if (read_en) reg_read_idx <= read_idx;//è¯»ä?€ä¸?row
	else reg_read_idx <= reg_read_idx;
    for (i = 0; i < 128; i=i+1) begin
      if (write_en && write_bits_mask[i]) ram[write_idx][i] <= write_bits_data[i];
	  else ram[write_idx][i] <= ram[write_idx][i];
    end
  end
  assign resp = ram[reg_read_idx];//è¯»ä?€ä¸?row

endmodule