/**************************************************************************************
*   Name        :des_ip.v
*   Description :DES initial permutation,part of des_top.v 
*                输入最高位编号1，最低为编号64,其他类似
*   Origin      :20181228
*   Author      :helrori2011@gmail.com
**************************************************************************************/
module des_ip
(
    input   wire [1:64] in_64,
    output  wire [1:32] lo_32,
    output  wire [1:32] ro_32
);
assign {lo_32,ro_32} = {
in_64[58], in_64[50], in_64[42], in_64[34], in_64[26], in_64[18], in_64[10], in_64[2], 
in_64[60], in_64[52], in_64[44], in_64[36], in_64[28], in_64[20], in_64[12], in_64[4], 
in_64[62], in_64[54], in_64[46], in_64[38], in_64[30], in_64[22], in_64[14], in_64[6], 
in_64[64], in_64[56], in_64[48], in_64[40], in_64[32], in_64[24], in_64[16], in_64[8], 

in_64[57], in_64[49], in_64[41], in_64[33], in_64[25], in_64[17], in_64[9],  in_64[1], 
in_64[59], in_64[51], in_64[43], in_64[35], in_64[27], in_64[19], in_64[11], in_64[3], 
in_64[61], in_64[53], in_64[45], in_64[37], in_64[29], in_64[21], in_64[13], in_64[5], 
in_64[63], in_64[55], in_64[47], in_64[39], in_64[31], in_64[23], in_64[15], in_64[7]
};
endmodule
