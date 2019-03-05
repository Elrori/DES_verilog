top        
======

des_top.v

Description 
--------------

基于FPGA的DES算法设计.(Data Encryption Standard ECB mode in verilog)

子密钥提前生成的f函数16级流水线结构,包含输入输出指示的时序结构,输入寄存,

输出无寄存

操作顺序(NOT define USE_SUBKEYS_ASYNC)：

    1.先置encrypt，keys_64_in，(这两个信号必须一同操作)，

    2.再置keys_64_in为高一个或多个时钟，

    3.等待(19clk)subkeys_16_valid置高，

    4.进行stream input端口操作。

操作顺序(define USE_SUBKEYS_ASYNC)：

    1.先置encrypt，keys_64_in，

    2.等待20ns，

    3.进行stream input端口操作。
    
Origin
-------------- 
181228

--------------
License     
MIT
   
Authors
--------------
helrori2011@gmail.com
   
