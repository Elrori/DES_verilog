/**************************************************************************************
*   Name        :des_top_tb.v
*   Description :des_top.v's testbench
*   Origin      :20181231
*                20190102
*   Author      :helrori2011@gmail.com
**************************************************************************************/
`timescale 1 ns / 10 ps
module des_top_tb();
parameter TT = 20;
reg clk,rst_n,key_in_64_en,encrypt,data_input_en,data_input_en_late1;
reg [1:64]key_in_64,data_64_in;
wire [1:64]data_64_out;
wire subkeys_16_valid,data_output_valid;
initial begin
        $dumpfile("wave.vcd");              //for iverilog gtkwave.exe
        $dumpvars(0,des_top_tb);          //for iverilog select signal   
        clk          = 0;
        rst_n        = 1;
        key_in_64_en = 0;
        encrypt      = 1;
        data_input_en = 0;
		  data_input_en_late1 = 0;
        key_in_64 = 64'h1334_5779_9BBC_DFF1;
        data_64_in= 64'h0123_4567_89AB_CDEF;//64'h85E8_1354_0F0A_B405;
        #20 rst_n=0;#20 rst_n=1;
		  wait(subkeys_16_valid==1)begin
			  #500  key_in_64_en = 1;  #TT    key_in_64_en = 0;#40
			  wait(subkeys_16_valid==1)begin
			  #500  data_input_en=1;   #(2*TT) data_input_en=0;
			  #1000		  
			  $stop;	  
			  end
		  end
        
end
always begin#(TT/2) clk=~clk;end

always@(posedge clk)begin
	data_input_en_late1 <= data_input_en;
end
always@(negedge clk)begin
	if(data_input_en_late1&&(data_64_in==64'h0123_4567_89AB_CDEF))
	    data_64_in <= 64'h0123_4567_89AB_0000;
//	else if(data_input_en_late1&&(data_64_in==64'h0123_4567_89AB_0000))
//	    data_64_in <= 64'h0123_4567_89AB_CDEF;
end
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
    .data_64_out(data_64_out),
	 .data_output_valid(data_output_valid)
    
);
endmodule
