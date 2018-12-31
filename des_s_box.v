/**************************************************************************************
*   Name        :des_s_box.v
*   Description :DES des_s_box,part of des_top.v 
*                输入最高位编号1，最低为编号64,其他类似
*   Origin      :20181229
*   Author      :helrori2011@gmail.com
**************************************************************************************/
module des_s_box
(
    input wire  [1:6]address,
    output wire [1:4]sout
);
parameter width     = 4;
parameter widthad   = 6;
parameter datafile  = "none";
reg [width-1:0] mem [(2**widthad)-1:0];
//reg[6:0] n;

/*
    CAUTION $readmemh 部分综合工具可能无法综合!
*/
initial
begin
$readmemh(datafile, mem,0,63);
//$display("datafile : %s ",datafile);
//for(n=0;n<64;n=n+1)
//	$display("0x%h ",mem[n]);
end

wire [5:0]new_address;
assign new_address = {address[1],address[6],address[2:5]};
assign sout = mem[new_address];

endmodule
