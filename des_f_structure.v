/**************************************************************************************
*   Name        :des_f_structure.v
*   Description :DES Feistel structure,part of des_top.v 
*                输入最高位编号1，最低为编号64,其他类似
*                des_f_structure.v中除了F函数，还包含外部异或门 以构成Feistel结构
*   Origin      :20181228
*   Author      :helrori2011@gmail.com
**************************************************************************************/
module des_f_structure
(
    input wire  [1:32]li,
    input wire  [1:32]ri,
    input wire  [1:48]ki,
    output wire [1:32]lo,
    output wire [1:32]ro
);
wire [1:32]sout2p;
wire [1:32]po;

// E extend
wire [1:48]e_out;
assign e_out = {
ri[32], ri[1],  ri[2],  ri[3],  ri[4],  ri[5],
ri[4],  ri[5],  ri[6],  ri[7],  ri[8],  ri[9],
ri[8],  ri[9],  ri[10], ri[11], ri[12], ri[13],
ri[12], ri[13], ri[14], ri[15], ri[16], ri[17],

ri[16], ri[17], ri[18], ri[19], ri[20], ri[21],
ri[20], ri[21], ri[22], ri[23], ri[24], ri[25],
ri[24], ri[25], ri[26], ri[27], ri[28], ri[29],
ri[28], ri[29], ri[30], ri[31], ri[32], ri[1]
};
// E extend end

// internal xor 
wire [1:48]xor_out;
assign xor_out = e_out^ki;
// internal xor end

// S box
des_s_box #(.datafile("G:/WORK_SPACE/Verilog_HDL_CODE/Data_Encryption_Standard/s_box_1.txt"))
des_s_box_1
(
    .address(xor_out[1:6]),//6bits
    .sout(sout2p[1:4])//4bits
);
des_s_box #(.datafile("G:/WORK_SPACE/Verilog_HDL_CODE/Data_Encryption_Standard/s_box_2.txt"))
des_s_box_2
(
    .address(xor_out[7:12]),//6bits
    .sout(sout2p[5:8])//4bits
);
des_s_box #(.datafile("G:/WORK_SPACE/Verilog_HDL_CODE/Data_Encryption_Standard/s_box_3.txt"))
des_s_box_3
(
    .address(xor_out[13:18]),//6bits
    .sout(sout2p[9:12])//4bits
);
des_s_box #(.datafile("G:/WORK_SPACE/Verilog_HDL_CODE/Data_Encryption_Standard/s_box_4.txt"))
des_s_box_4
(
    .address(xor_out[19:24]),//6bits
    .sout(sout2p[13:16])//4bits
);
des_s_box #(.datafile("G:/WORK_SPACE/Verilog_HDL_CODE/Data_Encryption_Standard/s_box_5.txt"))
des_s_box_5
(
    .address(xor_out[25:30]),//6bits
    .sout(sout2p[17:20])//4bits
);
des_s_box #(.datafile("G:/WORK_SPACE/Verilog_HDL_CODE/Data_Encryption_Standard/s_box_6.txt"))
des_s_box_6
(
    .address(xor_out[31:36]),//6bits
    .sout(sout2p[21:24])//4bits
);
des_s_box #(.datafile("G:/WORK_SPACE/Verilog_HDL_CODE/Data_Encryption_Standard/s_box_7.txt"))
des_s_box_7
(
    .address(xor_out[37:42]),//6bits
    .sout(sout2p[25:28])//4bits
);
des_s_box #(.datafile("G:/WORK_SPACE/Verilog_HDL_CODE/Data_Encryption_Standard/s_box_8.txt"))
des_s_box_8
(
    .address(xor_out[43:48]),//6bits
    .sout(sout2p[29:32])//4bits
);
// S box end

// P置换
assign po = {
sout2p[16], sout2p[7],  sout2p[20], sout2p[21],
sout2p[29], sout2p[12], sout2p[28], sout2p[17],
sout2p[1],  sout2p[15], sout2p[23], sout2p[26],
sout2p[5],  sout2p[18], sout2p[31], sout2p[10],

sout2p[2],  sout2p[8],  sout2p[24], sout2p[14],
sout2p[32], sout2p[27], sout2p[3],  sout2p[9],
sout2p[19], sout2p[13], sout2p[30], sout2p[6],
sout2p[22], sout2p[11], sout2p[4],  sout2p[25]
};
// P置换 end

assign ro = li^po   ;
assign lo = ri      ;



endmodule
