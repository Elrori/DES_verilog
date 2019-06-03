/************************************************************************************************
*  Name         :top.v
*  Description  :FPGA based DES design
*                ifclk==24Mhz shift -210
*  Origin       :190106
*                190114
*                190414
*  Author       :helrori2011@gmail.com
************************************************************************************************/
module   top
(
   input             clk_50M,
   input             rst_n,
   
   inout    [15:0]   USB_FD,
   output            USB_PKTADR0,
   output            USB_PKTADR1,
   output            USB_SLRD,
   output            USB_SLWR,
   output            USB_PKTEND,
   output            USB_SLOE,
   input             USB_FLAGA,
   input             USB_FLAGB,
   output            USB_IFCLK,
   output            USB_SLCS,//config as gpio
   output            clk_120m_180,
   output   [7:0]    LED

);
wire [63:0]reg0;
assign LED[0] = reg0[0];
wire clk_24m,clk_24m_180,rst_n_;
pll pll(
	.inclk0(clk_50M),
	.areset(!rst_n),
	.c0(clk_24m),
	.c1(clk_24m_180),
	.c2(clk_24m_div4),
	.locked(rst_n_)
);
wire clk_div4,data_input_en,data_output_valid;
wire [63:0]data_64_in,data_64_out;
usb usb
(
   .clk(clk_24m),        //from pll,The same clock as the ADC
   .clk_180(clk_24m_180),    //from pll,for FX2 slave fifo write clk
	.clk_24m_div4(clk_24m_div4),
   .rst_n(rst_n_),
   //cyusb outside
   .cy_data(USB_FD),
   .cy_addr({USB_PKTADR1,USB_PKTADR0}),
   .cy_slrd_n(USB_SLRD),
   .cy_slwr_n(USB_SLWR),
   .cy_pkend_n(USB_PKTEND),
   .cy_sloe_n(USB_SLOE),
   .cy_flaga(USB_FLAGA),
   .cy_flagb(USB_FLAGB),
   .cy_ifclk(USB_IFCLK),
   .cy_ifclk_ok(USB_SLCS),
   
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
    .rst_n(rst_n_),
    //change keys:
    .encrypt(reg0[0]),//1: encrypt;0: decrypt
    .keys_64_in(reg0),  
    .change_keys_en(),
    .subkeys_16_valid(),
    //stream input(when subkeys_16_valid==1)
    .data_input_en(data_input_en),
    .data_64_in(data_64_in),
    .data_64_out(data_64_out),
    .data_output_valid(data_output_valid),
    .pipeline_en(LED[1])
);

endmodule
