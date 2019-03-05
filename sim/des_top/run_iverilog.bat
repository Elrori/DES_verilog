iverilog -y../../final_rtl/ -o des_top.vvp ../../final_rtl/des_top_tb.v
vvp des_top.vvp
gtkwave wave.gtkw