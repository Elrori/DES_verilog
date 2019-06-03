top        
======

des_top.v

Description 
--------------

基于FPGA的DES算法设计.(Data Encryption Standard ECB mode in verilog)

子密钥提前生成的f函数16级流水线结构,包含输入输出指示的时序结构,输入寄存,

输出无寄存。

on_board_test内包含上位机和下位机代码，可以下载进行测试，测试下位机硬件要求：

USB2.0 IC CY7C680138,FPGA EP4CE10,引脚约束见csv.csv文件，请通过引脚连接确

定您的板子是否符合条件。上位机要求：Python3环境，pyusb库；对CY7C680138安装

CYPRESS驱动用于刷写固件，对CY7C680138安装libusb驱动(zadig)用于python通信。

sim内包含RTL仿真方法，使用iverilog或modelsim。

quartus_for_gate_sim内包含一个门级仿真工程。


操作顺序(NOT define USE_SUBKEYS_ASYNC)：

    1.先置encrypt，keys_64_in，(这两个信号必须一同操作)，

    2.再置keys_64_in为高一个或多个时钟，

    3.等待(19clk)subkeys_16_valid置高，

    4.进行stream input端口操作。

操作顺序(define USE_SUBKEYS_ASYNC，on_board_test使用这种方式)：

    1.先置encrypt，keys_64_in，

    2.等待20ns，

    3.进行stream input端口操作。
    
Origin
--------------
 
181228

License    
--------------
 
MIT
   
Authors
--------------
helrori2011@gmail.com
   
