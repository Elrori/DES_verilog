`timescale 1 ns / 1 ps
module des_s_box_tb();
reg  [1:6]address;
wire [1:4]sout;
initial begin
        $dumpfile("wave.vcd");              //for iverilog gtkwave.exe
        $dumpvars(0,des_s_box_tb);          //for iverilog select signal      
        address = 'b0;
        
        repeat(64)begin
        #5 address = address + 1'd1;    
        end
        #10 $finish;        
end
    
des_s_box #(.datafile("G:/WORK_SPACE/Verilog_HDL_CODE/Data_Encryption_Standard/s_box_1.txt"))
des_s_box_1
(
    .address(address),//6bits
    .sout(sout)//4bits
);

endmodule