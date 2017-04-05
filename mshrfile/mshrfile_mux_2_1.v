module mprcmux2_1(
	a,
	b,
	ctr,
	res
);
parameter width=8;
input [width-1:0]a;
input [width-1:0]b;
input ctr;
output reg [width-1:0]res;

always @ *
begin
    if(ctr == 1)
	    res = a;
    else
	    res = b;
end

endmodule

