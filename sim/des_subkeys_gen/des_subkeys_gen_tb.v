`timescale 1 ns / 1 ps
module des_subkeys_gen_tb();
reg clk,rst_n,key_in_64_en,encrypt;
reg [1:64]key_in_64;
wire [1:48]subkeys_1,subkeys_2,subkeys_3,subkeys_4,subkeys_5,subkeys_6,subkeys_7,subkeys_8;
wire [1:48]subkeys_9,subkeys_10,subkeys_11,subkeys_12,subkeys_13,subkeys_14,subkeys_15,subkeys_16;
wire subkeys_16_valid,parity_check_error;
initial begin
        $dumpfile("wave.vcd");              //for iverilog gtkwave.exe
        $dumpvars(0,des_subkeys_gen_tb);          //for iverilog select signal   
        clk = 0;
        rst_n = 1;
        key_in_64_en = 0;
        encrypt = 0;
        key_in_64 = 64'h1334_5779_9BBC_DFF1;
        #20 rst_n=0;
        #20 rst_n=1;
        #10 key_in_64_en = 1;
        #40 key_in_64_en = 0;
//       repeat(128)begin
        #5000
        key_in_64 = 64'hF0F0_0A0A_8888_1111;
        key_in_64_en = 1;
        #20
        key_in_64_en = 0;
        #5000
        rst_n = 0;
        #20
        rst_n = 1;
        #5000
        
//        end
        $finish;
      
end
always begin#10 clk=~clk;end
des_subkeys_gen des_subkeys_gen_0
(
    .clk(clk),
    .rst_n(rst_n),
    .key_in_64_en(key_in_64_en),
    .encrypt(encrypt),
    .key_in_64(key_in_64),
    .subkeys_1(subkeys_1),
    .subkeys_2(subkeys_2),
    .subkeys_3(subkeys_3),
    .subkeys_4(subkeys_4),
    .subkeys_5(subkeys_5),
    .subkeys_6(subkeys_6),
    .subkeys_7(subkeys_7),
    .subkeys_8(subkeys_8),
    .subkeys_9(subkeys_9),
    .subkeys_10(subkeys_10),
    .subkeys_11(subkeys_11),
    .subkeys_12(subkeys_12),
    .subkeys_13(subkeys_13),
    .subkeys_14(subkeys_14),
    .subkeys_15(subkeys_15),
    .subkeys_16(subkeys_16),
    .subkeys_16_valid(subkeys_16_valid),
    .parity_check_error(parity_check_error)
);
endmodule

