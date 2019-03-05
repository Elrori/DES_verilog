onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /des_top_tb/clk
add wave -noupdate /des_top_tb/rst_n
add wave -noupdate /des_top_tb/key_in_64_en
add wave -noupdate /des_top_tb/encrypt
add wave -noupdate /des_top_tb/data_input_en
add wave -noupdate /des_top_tb/key_in_64
add wave -noupdate /des_top_tb/data_64_in
add wave -noupdate /des_top_tb/data_64_out
add wave -noupdate /des_top_tb/subkeys_16_valid
add wave -noupdate /des_top_tb/data_output_valid
add wave -noupdate /des_top_tb/des_top/data_64_in_buff
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4450123 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {4395818 ps} {4815258 ps}
