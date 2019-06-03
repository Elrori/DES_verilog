# 
# Name   :sdc.sdc
# Origin :190414
# Author :helrori
# 建议    :ifclk==24Mhz shift -210


#
#	parameter set
#
set ifclk_pll "pll|altpll_component|auto_generated|pll1|clk[1]"
#set cy_outputs [get_ports {
#	USB_SLCS
#	USB_SLOE
#	USB_PKTEND
#	USB_SLWR
#	USB_SLRD
#	USB_PKTADR1
#	USB_PKTADR0
#	USB_FD[*]
#}]
#set cy_inputs [get_ports {
#	USB_FD[*]
#	USB_FLAGA
#	USB_FLAGB
#}]


#
#	clock
#
create_clock -period 20 [get_ports clk_50M]
create_generated_clock -name ifclk_out -source $ifclk_pll [get_ports {USB_IFCLK}]
derive_pll_clocks
derive_clock_uncertainty
#
#	set input and output delay
#
set_output_delay \
	-clock ifclk_out \
	-min -4.5 \
	[get_ports {USB_FD[*]}]
set_output_delay \
	-clock ifclk_out \
	-max 3.2 \
	[get_ports {USB_FD[*]}]
set_output_delay \
	-clock ifclk_out \
	-min -3.6 \
	[get_ports {USB_SLWR}]
set_output_delay \
	-clock ifclk_out \
	-max 12.1 \
	[get_ports {USB_SLWR}]


set_input_delay \
	-clock ifclk_out \
	-min 15 \
	[get_ports {USB_FD[*]}]
set_input_delay \
	-clock ifclk_out \
	-max 15 \
	[get_ports {USB_FD[*]}]
set_input_delay \
	-clock ifclk_out \
	-min 13.5 \
	[get_ports {USB_FLAGA USB_FLAGB}]
set_input_delay \
	-clock ifclk_out \
	-max 13.5 \
	[get_ports {USB_FLAGA USB_FLAGB}]