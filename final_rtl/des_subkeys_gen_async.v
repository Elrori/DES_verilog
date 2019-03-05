/**************************************************************************************
*   Name        :des_subkeys_gen_async.v
*   Description :与des_subkeys_gen.v文件可以相互替换，des_subkeys_gen_async.v是用异步
*                组合逻辑实现的,延迟较长，置key_in_64后，至少等待20ns
*   Origin      :20190103
*   Author      :helrori2011@gmail.com
**************************************************************************************/
module des_subkeys_gen_async
(
    input  wire  clk,//无效
    input  wire  rst_n,//无效
    input  wire  encrypt,//1: encrypt;0: decrypt
    input  wire  key_in_64_en,//无效
    input  wire  [1:64]key_in_64,
    output wire  [1:48]subkeys_1,
    output wire  [1:48]subkeys_2,
    output wire  [1:48]subkeys_3,
    output wire  [1:48]subkeys_4,
    output wire  [1:48]subkeys_5,
    output wire  [1:48]subkeys_6,
    output wire  [1:48]subkeys_7,
    output wire  [1:48]subkeys_8,
    output wire  [1:48]subkeys_9,
    output wire  [1:48]subkeys_10,
    output wire  [1:48]subkeys_11,
    output wire  [1:48]subkeys_12,
    output wire  [1:48]subkeys_13,
    output wire  [1:48]subkeys_14,
    output wire  [1:48]subkeys_15,
    output wire  [1:48]subkeys_16,
    output wire  subkeys_16_valid,//无效,一直为高
    output wire  parity_check_error
);
assign subkeys_16_valid = 1'b1;
assign parity_check_error = ~((^key_in_64[1:8])&(^key_in_64[9:16])&(^key_in_64[17:24])&(^key_in_64[25:32])
                            &(^key_in_64[33:40])&(^key_in_64[41:48])&(^key_in_64[49:56])&(^key_in_64[57:64]));
                         
wire [1:28] pc1_lo_28, pc1_ro_28;                       
wire [1:28] left0, right0;
wire [1:28] left1, right1;
wire [1:28] left2, right2;
wire [1:28] left3, right3;
wire [1:28] left4, right4;
wire [1:28] left5, right5;
wire [1:28] left6, right6;
wire [1:28] left7, right7;
wire [1:28] left8, right8;
wire [1:28] left9, right9;
wire [1:28] left10, right10;
wire [1:28] left11, right11;
wire [1:28] left12, right12;
wire [1:28] left13, right13;
wire [1:28] left14, right14;
wire [1:28] left15, right15;

des_pc1 des_pc1_0
(
    .in_64(key_in_64),
    .lo_28(pc1_lo_28),
    .ro_28(pc1_ro_28)
);
des_pc2 des_pc2_1
(
    .li_28(left0),
    .ri_28(right0),
    .kout_48(subkeys_1)
);
des_pc2 des_pc2_2
(
    .li_28(left1),
    .ri_28(right1),
    .kout_48(subkeys_2)
);
des_pc2 des_pc2_3
(
    .li_28(left2),
    .ri_28(right2),
    .kout_48(subkeys_3)
);
des_pc2 des_pc2_4
(
    .li_28(left3),
    .ri_28(right3),
    .kout_48(subkeys_4)
);
des_pc2 des_pc2_5
(
    .li_28(left4),
    .ri_28(right4),
    .kout_48(subkeys_5)
);
des_pc2 des_pc2_6
(
    .li_28(left5),
    .ri_28(right5),
    .kout_48(subkeys_6)
);
des_pc2 des_pc2_7
(
    .li_28(left6),
    .ri_28(right6),
    .kout_48(subkeys_7)
);
des_pc2 des_pc2_8
(
    .li_28(left7),
    .ri_28(right7),
    .kout_48(subkeys_8)
);
des_pc2 des_pc2_9
(
    .li_28(left8),
    .ri_28(right8),
    .kout_48(subkeys_9)
);
des_pc2 des_pc2_10
(
    .li_28(left9),
    .ri_28(right9),
    .kout_48(subkeys_10)
);
des_pc2 des_pc2_11
(
    .li_28(left10),
    .ri_28(right10),
    .kout_48(subkeys_11)
);
des_pc2 des_pc2_12
(
    .li_28(left11),
    .ri_28(right11),
    .kout_48(subkeys_12)
);
des_pc2 des_pc2_13
(
    .li_28(left12),
    .ri_28(right12),
    .kout_48(subkeys_13)
);
des_pc2 des_pc2_14
(
    .li_28(left13),
    .ri_28(right13),
    .kout_48(subkeys_14)
);
des_pc2 des_pc2_15
(
    .li_28(left14),
    .ri_28(right14),
    .kout_48(subkeys_15)
);
des_pc2 des_pc2_16
(
    .li_28(left15),
    .ri_28(right15),
    .kout_48(subkeys_16)
);


assign  left0  = (encrypt==1)?{pc1_lo_28[2:28],pc1_lo_28[1]}:pc1_lo_28;//<<1\>>0
assign  right0 = (encrypt==1)?{pc1_ro_28[2:28],pc1_ro_28[1]}:pc1_ro_28;
        
assign  left1  = (encrypt==1)?{left0[2:28],  left0[1]}: {left0[28],  left0[1:27]};//<<1\>>1
assign  right1 = (encrypt==1)?{right0[2:28], right0[1]}:{right0[28],  right0[1:27]};
        
        
assign  left2  = (encrypt==1)?{left1[3:28],  left1[1:2]}: {left1[27:28],  left1[1:26]};
assign  right2 = (encrypt==1)?{right1[3:28], right1[1:2]}:{right1[27:28],  right1[1:26]};
        
assign  left3  = (encrypt==1)?{left2[3:28],  left2[1:2]}: {left2[27:28],  left2[1:26]};
assign  right3 = (encrypt==1)?{right2[3:28], right2[1:2]}:{right2[27:28],  right2[1:26]};

assign  left4  = (encrypt==1)?{left3[3:28],  left3[1:2]}: {left3[27:28],  left3[1:26]};
assign  right4 = (encrypt==1)?{right3[3:28], right3[1:2]}:{right3[27:28],  right3[1:26]};

assign  left5  = (encrypt==1)?{left4[3:28],  left4[1:2]}: {left4[27:28],  left4[1:26]};
assign  right5 = (encrypt==1)?{right4[3:28], right4[1:2]}:{right4[27:28],  right4[1:26]};

assign  left6  = (encrypt==1)?{left5[3:28],  left5[1:2]}: {left5[27:28],  left5[1:26]};
assign  right6 = (encrypt==1)?{right5[3:28], right5[1:2]}:{right5[27:28],  right5[1:26]};

assign  left7  = (encrypt==1)?{left6[3:28],  left6[1:2]}: {left6[27:28],  left6[1:26]};
assign  right7 = (encrypt==1)?{right6[3:28], right6[1:2]}:{right6[27:28],  right6[1:26]};

       
assign  left8  = (encrypt==1)?{left7[2:28],  left7[1]}: {left7[28],  left7[1:27]};//<<1\>>1
assign  right8 = (encrypt==1)?{right7[2:28], right7[1]}:{right7[28], right7[1:27]};
        

assign  left9  = (encrypt==1)?{left8[3:28],  left8[1:2]}: {left8[27:28],  left8[1:26]};
assign  right9 = (encrypt==1)?{right8[3:28], right8[1:2]}:{right8[27:28], right8[1:26]};

assign  left10  = (encrypt==1)?{left9[3:28],  left9[1:2]}: {left9[27:28],  left9[1:26]};
assign  right10 = (encrypt==1)?{right9[3:28], right9[1:2]}:{right9[27:28], right9[1:26]};

assign  left11  = (encrypt==1)?{left10[3:28],  left10[1:2]}: {left10[27:28],  left10[1:26]};
assign  right11 = (encrypt==1)?{right10[3:28], right10[1:2]}:{right10[27:28], right10[1:26]};

assign  left12  = (encrypt==1)?{left11[3:28],  left11[1:2]}: {left11[27:28],  left11[1:26]};
assign  right12 = (encrypt==1)?{right11[3:28], right11[1:2]}:{right11[27:28], right11[1:26]};

assign  left13  = (encrypt==1)?{left12[3:28],  left12[1:2]}: {left12[27:28],  left12[1:26]};
assign  right13 = (encrypt==1)?{right12[3:28], right12[1:2]}:{right12[27:28],  right12[1:26]};

assign  left14  = (encrypt==1)?{left13[3:28],  left13[1:2]}: {left13[27:28],  left13[1:26]};
assign  right14 = (encrypt==1)?{right13[3:28], right13[1:2]}:{right13[27:28],  right13[1:26]};

        
assign  left15  = (encrypt==1)?{left14[2:28],  left14[1]}: {left14[28],  left14[1:27]};//<<1\>>1
assign  right15 = (encrypt==1)?{right14[2:28], right14[1]}:{right14[28], right14[1:27]};        


endmodule
