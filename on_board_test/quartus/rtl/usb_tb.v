`timescale 1 ns / 1 ps
`define TT 10 
module usb_tb();
reg clk,rst_n,cy_flaga,cy_flagb,out_en;
wire clk_180,cy_pkend_n,cy_slrd_n,cy_slwr_n,cy_sloe_n,cy_ifclk;
wire [1:0]cy_addr;
reg [15:0]men[7:0];
reg [2:0]cnt;
wire  [15:0]cy_data;
assign cy_data = (!cy_sloe_n)?men[cnt]:16'dz;
initial begin
    $dumpfile("wave.vcd");              //for iverilog gtkwave.exe
    $dumpvars(0,usb_tb);          //for iverilog select signal 
    cnt    = 'd0; 
    men[0] = {"O","L"};
    men[1] = {"D","P"};
    men[2] = {8'd1,8'd0};
    men[3] = {8'd0,8'd0};
    men[4] = {8'd0,8'd0};
    men[5] = {8'd0,8'd0};
    men[6] = {8'd0,8'd0};
    men[7] = {8'd0,8'hFF};
    cy_flagb = 1;
    clk   = 1;
    rst_n = 1;
    cy_flaga = 0;
    cy_flagb = 1;
    #(`TT*5) rst_n = 0; #(`TT*4) rst_n = 1;
    #(`TT*100)
        
    #(`TT/2) cy_flaga = 1; #(`TT*5) cy_flaga = 0; 
    #(`TT*400)
    
    #(`TT*500)
    cy_flaga = 1; #(`TT*5) cy_flaga = 0;    
    #(`TT*1000)
    
    cy_flaga = 1; #(`TT*5) cy_flaga = 0;    
    #(`TT*1000)
    
    $finish;
end
always begin #(`TT/2) clk = ~clk; end
assign clk_180 = ~clk;


always@(posedge cy_ifclk)begin
    if(cy_slrd_n==0)
        cnt <= cnt +1'd1;
end

wire clk_div4,data_input_en,data_output_valid;
wire [63:0]data_64_in,reg0,data_64_out;
usb usb
(
   .clk(clk),        //from pll,The same clock as the ADC
   .clk_180(clk_180),    //from pll,for FX2 slave fifo write clk
   .rst_n(rst_n),
   //cyusb outside
   .cy_data(cy_data),
   .cy_addr(cy_addr),
   .cy_slrd_n(cy_slrd_n),
   .cy_slwr_n(cy_slwr_n),
   .cy_pkend_n(cy_pkend_n),
   .cy_sloe_n(cy_sloe_n),
   .cy_flaga(cy_flaga),
   .cy_flagb(cy_flagb),
   .cy_ifclk(cy_ifclk),
   .cy_ifclk_ok(),
   
   .reg0(reg0),
   
   .clk_div4(clk_div4),
   .data_input_en(data_input_en),
   .data_64_in(data_64_in),
   
   .data_64_out(data_64_out),
   .data_output_valid(data_output_valid)
   
);
des_top des_top
(
    .clk(clk_div4),
    .rst_n(rst_n),
    //change keys:
    .encrypt(1'd1),//1: encrypt;0: decrypt
    .keys_64_in(reg0),  
    .change_keys_en(),
    .subkeys_16_valid(),
    //stream input(when subkeys_16_valid==1)
    .data_input_en(data_input_en),
    .data_64_in(data_64_in),
    .data_64_out(data_64_out),
    .data_output_valid(data_output_valid)
    
);
endmodule
