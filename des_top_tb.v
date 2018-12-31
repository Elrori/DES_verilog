/**************************************************************************************
*   Name        :des_top_tb.v
*   Description :des_top.v's testbench
*   Origin      :20181231
*   Author      :helrori2011@gmail.com
**************************************************************************************/
`timescale 1 ns / 1 ps
module des_top_tb();
reg clk,rst_n,key_in_64_en,encrypt,data_input_en;
reg [1:64]key_in_64,data_64_in;
wire [1:64]data_64_out;
wire subkeys_16_valid;
initial begin
        $dumpfile("wave.vcd");              //for iverilog gtkwave.exe
        $dumpvars(0,des_top_tb);          //for iverilog select signal   
        clk = 0;
        rst_n = 1;
        key_in_64_en = 0;
        encrypt = 1;
        data_input_en = 0;
        key_in_64 = 64'h1334_5779_9BBC_DFF1;
        data_64_in= 64'h0123_4567_89AB_CDEF;
        #20 rst_n=0;
        #20 rst_n=1;
        #10 key_in_64_en = 1;
        #40 key_in_64_en = 0;
        #2500
        data_input_en=1;
        #400
        data_input_en=0;
        #5000
        $finish;
      
end
always begin#10 clk=~clk;end
des_top des_top
(
    .clk(clk),
    .rst_n(rst_n),
    //change keys:
    .encrypt(encrypt),//1: encrypt;0: decrypt
    .keys_64_in(key_in_64),  
    .change_keys_en(key_in_64_en),
    .subkeys_16_valid(subkeys_16_valid),
    //stream input(when subkeys_16_valid==1)
    .data_input_en(data_input_en),
    .data_64_in(data_64_in),
    .data_64_out(data_64_out)
    
);
endmodule
