# modelsim do file
# helrori
# 190302
vlib work
vlog ../../final_rtl/*.v
vsim des_top_tb
#add wave /des_top_tb/*
do wave.do
radix hex
run -all