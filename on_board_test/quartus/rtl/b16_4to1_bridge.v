/************************************************************************************************
*  Name         :b16_4to1_bridge.v
*  Description  :4时钟16bits合成 1时钟64bits.d_i,d_i_en 与clk_i 上升沿同步(数据提早准备)。 d_o,d_o_valid 与clk_i上升沿同步。
*                clk_o与d_o,d_o_valid,d_i_en...相位不确定,但clk_o上升沿可以采到d_o。？
*  Origin       :190112
*  Author       :helrori2011@gmail.com
************************************************************************************************/

module b16_4to1_bridge//4时钟16bits合成 1时钟64bits
(
    input   wire    clk_i,
	 input   wire    clk_i_div4,
    input   wire    rst_n,
    input   wire    [15: 0]d_i,
    input   wire    d_i_en,//d_i_en使能期间必须保证有4的倍数个时钟
    
    output  wire    clk_o,//clk_o与d_o,d_o_valid,d_i_en...相位不确定
    output  reg     [63:0]d_o,
    output  wire    d_o_valid

);
reg [47:0]b;
reg [1: 0]c;
always@(posedge clk_i or negedge rst_n)begin
    if(!rst_n)begin
        c <= 2'd0;
    end else if(d_i_en)begin
        c <= c + 1'd1;
    end else begin
        c <= 2'd0;
    end
end

always@(posedge clk_i or negedge rst_n)begin
    if(!rst_n)begin
        d_o <= 64'd0;
        b   <= 48'd0;
    end else if(d_i_en)begin
        if(c == 2'd3)
            d_o <= {b,d_i[7:0],d_i[15:8]};//交换高低字节(FX2先发的字节在低位)
        else
            b   <= {b[31:0],d_i[7:0],d_i[15:8]};
    end
end

reg [3:0]shifft_buff;
assign d_o_valid = shifft_buff[3];//迟4个clk_i, 并与clk_i上升沿同步
always@(posedge clk_i or negedge rst_n)begin
    if(!rst_n)shifft_buff <= 4'd0;
    else      shifft_buff <= {shifft_buff[2:0],d_i_en};
end



assign clk_o = clk_i_div4;//4分频使用pll源
reg [1:0]cnt_div4;
always@(posedge clk_i or negedge rst_n)begin
    if(!rst_n)
        cnt_div4 <= 2'd0;
    else
        cnt_div4 <= cnt_div4 + 1'd1;
end

endmodule