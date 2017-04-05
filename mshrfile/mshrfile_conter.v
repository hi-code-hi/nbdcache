/*counter(clk,rst,en,n,v_out,c_complete)
by sunhaimeng
*/

module mprccounter(
clk,
rst,
en,
n,
v_out,
c_complete
);
parameter depth=8;
input clk;
input rst;
input en;
input [depth-1:0] n;

output [depth-1:0] v_out;
output c_complete;

reg[depth-1:0] value;
reg[depth-1:0] v_in;
reg wrap;
reg[depth-1:0] tmp1;
///////////////////////////////////////////
assign v_out=value;
assign c_complete=en&wrap;
///////////////////////////////////////////
always @ *
begin
  if(wrap)
    v_in = 0;
  else
    v_in = v_out+1'b1;
end

//always @ *
//begin 
//  tmp = n-1'b1;
//end
always @*
begin
    tmp1 <= n-1;
    if(v_out ^ tmp1)
    wrap = 0;
    else
    wrap = 1;
end

always @ (posedge clk)
begin
  if(rst)begin
    value <= 0;
    wrap <=0;
  end
  else
  begin
  if(en) begin
    value<=v_in;
  end
  else
    value<=value;
/*  if(v_out ^ tmp1)
    wrap <= 0;
  else
    wrap <= 1;*/
  end
end
endmodule