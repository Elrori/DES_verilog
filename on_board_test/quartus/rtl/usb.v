/************************************************************************************************
*  Name         :usb.v
*  Description  :fx2 usb通信模块,可传下载64bit寄存器数据，可以等量包上下载(pkg_1==1,适用于DES模块
*                请勿更改:下载1包上载1包。pkg_0==3:下载pkg_1包上载pkg_1包重复3次)。该模块支持等量
*                数据互传(PC下发一个包，FPGA立即上发一个包)但速度很慢，等效速度1.7Mbyts/s，如果应
*                用场合为非等量数据传输，请不要使用此模块。
*                FX2配置:EP2 OUT,FIFO 512Bx4,bulk;EP6 IN,FIFO 512Bx4 bulk;一包大小为512bytes
*                通信过程：协商-数传，再次协商-数传。
*                协商   : [cmd ][pkg_1][pkg_0]          [cmd ][?] 
*    
*                PC->FX2:"[LOPD][16'd1][16'd0]"        "[REGW][x]"
*                FX2->PC:"[LOPD][16'd1][16'd0]"        "[REGw][x]" FPGA直接回应接收到的命令
*                工作流程：  1.PC下发 "REGW",
*                            2.PC接收一包，前4个字节应当是"REGW"
*                            3.PC下发 "\x13\x34\x57\x79\x9B\xBC\xDF\xF1",出现在reg0上，用于des密钥
*                            4.REGW操作完成，FPGA进入空闲，等待下一个cmd
*                            5.PC下发 "LOPD\x00\x01\x00\x01",使得 pkg_1=16'd1;pkg_0=16'd1，意为下
*                              下步是下载一包上载一包，然后进入空闲态。
*                              如果是 "LOPD\x00\x02\x00\x02"意为下下步是下载2包上载2包，再下载2包
*                              上载2包(pkg_0的值就是重复次数)，然后进入空闲态
*                            6.PC接收一包，前8个字节应当是"LOPD\x00\x01\x00\x00"
*                            7.PC下发一包，PC接收一包
*                            8.LOPD操作完成，FPGA进入空闲，等待下一个cmd
*               其他建议：clk==clk_180==ifclk==24Mhz,clk_180 shift -210
*  Origin       :190106
*                190114
*  Author       :helrori2011@gmail.com
************************************************************************************************/
`define EP2_NOTHING  (cy_flaga==1'd0)//flaga fixed mode,PC->FPGA st_out
`define EP6_FULL     (cy_flagb==1'd0)//flagb fixed mode,FPGA->PC st_in
`define EP2_ADDRESS  (2'b00)
`define EP6_ADDRESS  (2'b10)
`define CYUSB_DELAY  (32'd20000000)//上电延迟,实际测试使用32'd20000000
`define NEGO_DELAY   (8'h0f) //协商 下载上载间隔

module usb
(
   input    wire     clk,        
   input    wire     clk_180,    //from pll,for FX2 slave fifo write clk
   input    wire     rst_n,
	input		wire     clk_24m_div4,
   //cyusb outside
   inout    wire    [15:0]cy_data,
   output   reg     [1:0]cy_addr,
   output   reg     cy_slrd_n,
   output   reg     cy_slwr_n,
   output   reg     cy_pkend_n,
   output   reg     cy_sloe_n,
   input    wire    cy_flaga,
   input    wire    cy_flagb,
   output   wire    cy_ifclk,
   output   reg     cy_ifclk_ok,
   //DES control
   output   reg     [63:0]reg0,
   
   output   wire    clk_div4,/*synthesis noprune*/
   output   wire    data_input_en,/*synthesis noprune*/
   output   wire    [63:0]data_64_in,/*synthesis noprune*/
    
   input    wire    [63:0]data_64_out,/*synthesis noprune*/
   input    wire    data_output_valid/*synthesis noprune*/

);
/*****************************************************
*  cy_ifclk_ok
*****************************************************/
always@(posedge clk_180 or negedge rst_n)begin
   if(!rst_n)
      cy_ifclk_ok <= 1'd0;
   else
      cy_ifclk_ok <= 1'd1;     
end

wire [15:0]cy_data_o;
assign   cy_data = (cy_slwr_n)?16'bz:cy_data_o;//cy_data默认高阻，仅当上载时接上cy_data_o
assign   cy_ifclk = clk_180;

/*************************************************************************************************
*   Negotiation state machine
*************************************************************************************************/
reg [2:0]reuse_state_down,reuse_state_up;//下载上载部分状态机需要复用，使用该信号加以区别
localparam DELAY = 4'd0,DELAY_DONE = 4'd1;
localparam READ_DOWN_DATA_BEGIN = 4'd2,   CLK1          = 4'd3,READ_DOWN_DATA = 4'd4,  READ_DOWN_DATA_DONE = 4'd5;
localparam DELAY2 = 4'd6,DELAY2_DONE = 4'd7;
localparam WRITE_UP_DATA_BEGIN  = 4'd8,   WRITE_UP_DATA = 4'd9,PK_END         = 4'd10, WRITE_UP_DATA_DONE  = 4'd11;
localparam NEGO_DONE = 4'd12;
localparam LOPD = 4'd13,REGW = 4'd14;
localparam DATATRANS_DONE = 4'd15;

localparam NEGO_STATE = 3'd0;//下行(上行)数据作为 协商 用
localparam LOPD_STATE = 3'd1,REGW_STATE = 3'd2;

reg  [63:0]nego_instruction;//在协商阶段被改变一次
wire [31:0]cmd;
wire [15:0]pkg_1;
reg  [15:0]pkg_1_cnt;
wire [15:0]pkg_0;/////////////////////////////////////////////////
reg  [15:0]pkg_0_cnt;
assign {cmd,pkg_1,pkg_0} = nego_instruction;
reg  [31:0]dly_cnt;
reg  [7 :0]dly2_cnt;
reg  [15:0]time_cnt;
reg  [3 :0]nego_current_state_b,nego_current_state,nego_next_state;
//reg  read_en_p  ;//read_en_p与clk上升沿同步,读FX2使能
reg  read_en    ;//read_en  与clk下降沿同步,读FX2使能
wire write_en_p ;//write_en 与clk上升沿同步,写FX2使能
assign write_en_p = ~cy_slwr_n;
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        nego_current_state_b <= 'd0;
    else
        nego_current_state_b <= nego_current_state;
end
always@(posedge clk or negedge rst_n)begin
   if(!rst_n)
      nego_current_state  <= DELAY;
   else
      nego_current_state  <= nego_next_state;
end
always@(*)begin
    nego_next_state = nego_current_state;
    case(nego_current_state)
        DELAY:begin         //上电延迟
            if(dly_cnt >= `CYUSB_DELAY)  nego_next_state = DELAY_DONE;
            else                         nego_next_state = DELAY;
        end
        DELAY_DONE:begin
            nego_next_state = READ_DOWN_DATA_BEGIN;
        end
        READ_DOWN_DATA_BEGIN:begin//等待PC下发(下载复用开始)
            if(!`EP2_NOTHING) nego_next_state = CLK1;
            else              nego_next_state = READ_DOWN_DATA_BEGIN;
        end
        CLK1:begin          //提早将sloe_n置低
            nego_next_state = READ_DOWN_DATA;
        end
        READ_DOWN_DATA:begin//读512bytes
            if(time_cnt >= 16'd256) nego_next_state = READ_DOWN_DATA_DONE;           
            else                    nego_next_state = READ_DOWN_DATA;
        end
        READ_DOWN_DATA_DONE:begin//(下载复用结束)
              nego_next_state = 
              (reuse_state_down==NEGO_STATE)?(DELAY2        ): //√/////////////xxx
              (reuse_state_down==LOPD_STATE)?(((pkg_1-1)==pkg_1_cnt)?WRITE_UP_DATA_BEGIN:LOPD)://√
              (reuse_state_down==REGW_STATE)?(DATATRANS_DONE)://√
              (READ_DOWN_DATA_BEGIN);//√
        end
        DELAY2:begin
            if(dly2_cnt == `NEGO_DELAY)  nego_next_state = DELAY2_DONE;
            else                         nego_next_state = DELAY2;
        end
        DELAY2_DONE:begin
            nego_next_state = WRITE_UP_DATA_BEGIN;
        end
        WRITE_UP_DATA_BEGIN:begin//等待上载fifo不满(上载复用开始)
            if(!`EP6_FULL) nego_next_state = WRITE_UP_DATA;
            else           nego_next_state = WRITE_UP_DATA_BEGIN;
            
        end
        WRITE_UP_DATA:begin//写512bytes
            if(time_cnt >= 16'd256) nego_next_state = PK_END;
            else                    nego_next_state = WRITE_UP_DATA;
        end
        PK_END:begin       
            nego_next_state = WRITE_UP_DATA_DONE;
        end
        WRITE_UP_DATA_DONE:begin//(上载载复用结束)
              nego_next_state = 
              (reuse_state_down==NEGO_STATE)?(NEGO_DONE): //√///////////////////////////////////////////////////////////// ((pkg_0-1)==pkg_0_cnt)?(DATATRANS_DONE):(READ_DOWN_DATA_BEGIN)   
              (reuse_state_down==LOPD_STATE)?((16'd0==pkg_1_cnt)?( ((pkg_0-1)==pkg_0_cnt)?(DATATRANS_DONE):(READ_DOWN_DATA_BEGIN)   ):LOPD):
              (READ_DOWN_DATA_BEGIN);//√         
        end
        NEGO_DONE:begin//协商结束
            case(cmd)
            "LOPD":begin
                nego_next_state = LOPD;//等量交替固定包模式(先下载)
            end
            "REGW":begin
                nego_next_state = REGW;//写32bit寄存器模式
            end
            default:nego_next_state = READ_DOWN_DATA_BEGIN;//收到错误cmd，下一个状态仍是协商
            endcase
        end
        LOPD:begin
            nego_next_state = (nego_current_state_b==NEGO_DONE          )?(READ_DOWN_DATA_BEGIN):
                              (nego_current_state_b==READ_DOWN_DATA_DONE)?(READ_DOWN_DATA_BEGIN):
                              (nego_current_state_b==WRITE_UP_DATA_DONE )?(WRITE_UP_DATA_BEGIN ):
                              (DATATRANS_DONE);
        end
        REGW:begin
            nego_next_state = READ_DOWN_DATA_BEGIN;
        end
        DATATRANS_DONE:begin//数传结束
            nego_next_state = READ_DOWN_DATA_BEGIN;
        end
        default:nego_next_state = DELAY;
    endcase
end
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        dly_cnt        <= 32'd0;
        time_cnt       <= 16'd0;
        dly2_cnt       <= 8'd0;
        pkg_1_cnt      <= 'd0;  
        pkg_0_cnt      <= 'd0;  ///////////////////////////////////////////////
        cy_addr        <= `EP2_ADDRESS;
        reuse_state_down  <=NEGO_STATE;
        reuse_state_up    <=NEGO_STATE;
        cy_slrd_n      <= 1;
        cy_sloe_n      <= 1;
        cy_slwr_n      <= 1;
        cy_pkend_n     <= 1;
    end else case(nego_next_state)
        DELAY:begin//上电延迟 \/
            dly_cnt     <= dly_cnt + 1'd1;
        end
        DELAY_DONE:begin
            dly_cnt     <= 32'd0;
        end
        READ_DOWN_DATA_BEGIN:begin              //等待PC下发 (下载复用开始)
            cy_addr     <= `EP2_ADDRESS;
                if(nego_current_state == WRITE_UP_DATA_DONE)///////////////////////////////////////////////////////////////////////
                    pkg_0_cnt <= pkg_0_cnt +1'd1;
        end
        CLK1:begin
            cy_sloe_n   <= 0;
//            read_en_p   <= 1;//read_en_p:与clk上升沿同步
        end        
        READ_DOWN_DATA:begin//读512bytes
            cy_slrd_n   <= 0;
            time_cnt    <= time_cnt + 1'd1;
        end
        READ_DOWN_DATA_DONE:begin               //(下载复用结束)
            time_cnt    <= 16'd0;
            cy_slrd_n   <= 1;
            cy_sloe_n   <= 1;
        end
        DELAY2:begin
            dly2_cnt   <= dly2_cnt + 1'd1;
        end   
        DELAY2_DONE:begin
            dly2_cnt   <= 8'd0;
        end
        WRITE_UP_DATA_BEGIN:begin               //等待上载fifo不满(上载复用开始)
            cy_addr     <= `EP6_ADDRESS;
        end
        WRITE_UP_DATA:begin//写512bytes
            cy_slwr_n   <= 0;
            time_cnt    <= time_cnt + 1'd1;
        end
        PK_END:begin  
            time_cnt    <= 16'd0;        
            cy_slwr_n   <= 1;
            cy_pkend_n  <= 1;//not use
        end
        WRITE_UP_DATA_DONE:begin                //(上载载复用结束)
            cy_pkend_n  <= 1;
        end
        NEGO_DONE:begin//协商结束

        end
        LOPD:begin
            case(nego_current_state)
            NEGO_DONE:begin
                reuse_state_down <= LOPD_STATE;
                reuse_state_up   <= LOPD_STATE;
            end
            READ_DOWN_DATA_DONE:begin
                pkg_1_cnt   <=  pkg_1_cnt + 1'd1;
            end
            WRITE_UP_DATA_DONE:begin
                pkg_1_cnt   <=  pkg_1_cnt - 1'd1;
            end
            default:begin pkg_1_cnt<='d0;reuse_state_down<=reuse_state_down;reuse_state_up<=reuse_state_up;end
            endcase
        end
        REGW:begin
            reuse_state_down <= REGW_STATE;//标注下行数据正在为 REGW数传阶段 服务
        end
        DATATRANS_DONE:begin//数传结束,下一阶段是协商
            reuse_state_down  <= NEGO_STATE;
            reuse_state_up    <= NEGO_STATE;     
            pkg_1_cnt         <= 'd0;  
            pkg_0_cnt         <= 'd0; ///////////////////////////////////////////
 
        end
        default:;
    endcase
end
//下载START---------------------------------------------------------------------------------------
/*************************************************************************************************
* PC下载到FPGA时，后端逻辑只需:在posedge clk&read_en时读取cy_data数据。(cy_data pre-fetched)
* 以下是 予操作
*************************************************************************************************/
always@(posedge clk_180 or negedge rst_n)begin
    if(!rst_n)begin
        read_en <= 1'd0;
    end else if(nego_current_state == CLK1 && nego_next_state == READ_DOWN_DATA)begin
        read_en <= 1'd1;
    end else if(nego_current_state == READ_DOWN_DATA && nego_next_state == READ_DOWN_DATA_DONE)begin
        read_en <= 1'd0;
    end else read_en <= read_en ;
end
wire rd_64b;//,rd_512b;
assign rd_64b =(read_en & (time_cnt < 16'd4) & ((nego_current_state == READ_DOWN_DATA)||(nego_next_state == READ_DOWN_DATA)));
//assign rd_512b=(read_en & ((nego_current_state == READ_DOWN_DATA)||(nego_next_state == READ_DOWN_DATA)));
/*************************************************************************************************
* PC下载到FPGA时，后端逻辑只需:在posedge clk&read_en时读取cy_data数据。(cy_data pre-fetched)
* 以下是 NEGO协商阶段 接收命令
*************************************************************************************************/
always@(posedge clk  or negedge rst_n)begin//保存指令到nego_instruction
    if(!rst_n)begin
        nego_instruction <= 64'd0;
    end else if(rd_64b && (reuse_state_down==NEGO_STATE) )begin//Ensure that it is in the negotiation phase
        nego_instruction <= {nego_instruction[47:0],cy_data[7:0],cy_data[15:8]};
    end else nego_instruction <= nego_instruction;
end
/*************************************************************************************************
* 以下是 REGW数传阶段，接收64bits寄存器数据
*************************************************************************************************/
always@(posedge clk  or negedge rst_n)begin
    if(!rst_n)begin
        reg0 <= 64'd0;   
    end else if(rd_64b && (reuse_state_down==REGW_STATE) )begin
        reg0 <= {reg0[47:0],cy_data[7:0],cy_data[15:8]};
    end else reg0 <= reg0;
end
/*************************************************************************************************
* 以下是 LOPD数传阶段,接收数据,产生clk_div4,data_input_en,data_64_in信号以控制DES_TOP.V.  USB--->DES.V
*************************************************************************************************/

b16_4to1_bridge b16_4to1_bridge_0//4时钟16bits合成 1时钟64bits
(
    .clk_i(clk),
	 .clk_i_div4(clk_24m_div4),
    .rst_n(rst_n),
    .d_i(cy_data),
    .d_i_en(read_en&(reuse_state_down==LOPD_STATE)),//d_i_en使能期间必须保证有4的倍数个时钟
    
    .clk_o(clk_div4),//connect to des_top.v
    .d_o(data_64_in),//connect to des_top.v
    .d_o_valid(data_input_en)//connect to des_top.v
);




//下载END-----------------------------------------------------------------------------------------



//上载START---------------------------------------------------------------------------------------
/*************************************************************************************************
* FPGA上载数据到PC时，后端逻辑只需:更新cy_data_o在write_en_p&posedge clk时。
* 要求cy_data_o提早输出第一个数据(cy_data_o pre-output)
* 以下是 予操作
*************************************************************************************************/
wire nego_write_en,lopd_write_en,wr_512b;
assign wr_512b = (write_en_p && ((nego_current_state == WRITE_UP_DATA)||(nego_next_state == WRITE_UP_DATA)));
assign nego_write_en = wr_512b & (reuse_state_up==NEGO_STATE) ;
assign lopd_write_en = wr_512b & (reuse_state_up==LOPD_STATE);

/*************************************************************************************************
* 以下是 协商阶段 LOPD数传阶段 返回收到的命令
*************************************************************************************************/
wire [15:0]lopd_o;
assign cy_data_o = 
(!nego_write_en)?((lopd_write_en)?lopd_o:16'dz):
(time_cnt == 16'd1)?({nego_instruction[55: 48],nego_instruction[63: 56]}): 
(time_cnt == 16'd2)?({nego_instruction[39: 32],nego_instruction[47: 40]}): 
(time_cnt == 16'd3)?({nego_instruction[23: 16],nego_instruction[31: 24]}): 
(time_cnt == 16'd4)?({nego_instruction[7:   0],nego_instruction[15:  8]}):
(16'd0);

/*************************************************************************************************
* 以下是 LOPD数传阶段 将DES处理好的数据上载到PC;   DES.V--->simple_ram_0
*************************************************************************************************/
//wire [63:0]q;
//reg [5:0]wraddress,rdaddress;
//
//always@(posedge clk_div4 or negedge rst_n)begin
//    if(!rst_n)
//        wraddress <= 'd0;
//    else if(data_output_valid)
//        wraddress <= wraddress + 1'd1;
//    else 
//        wraddress <= 'd0;
//end
//simple_ram #(.width(64),.widthad(6))//512bytes,64BITSx64
//simple_ram_0(
//    .clk(clk_div4),
//    .wren(data_output_valid),
//    .data(data_64_out),
//    .wraddress(wraddress),
//    
//    .rdaddress(rdaddress),
//    .q(q)
//);
//always@(posedge clk or negedge rst_n)begin
//    if(!rst_n)
//        rdaddress <= 'd0;
//    else if(lopd_write_en && (time_cnt[8:0]%4 == 9'd0) && time_cnt[8:0]!=9'd0)
//        rdaddress <= rdaddress + 1'd1;
//    else if(!lopd_write_en)
//        rdaddress <= 'd0;
//    else rdaddress <= rdaddress;
//end
//assign lopd_o = 
//(time_cnt[8:0]%4 == 9'd1)?({q[55: 48],q[63: 56]}):
//(time_cnt[8:0]%4 == 9'd2)?({q[39: 32],q[47: 40]}):
//(time_cnt[8:0]%4 == 9'd3)?({q[23: 16],q[31: 24]}):
//(time_cnt[8:0]%4 == 9'd0)?({q[7:   0],q[15:  8]}):
//(16'd0);
alt_fifo alt_fifo_0(//64bits to 16bit,64bitsx64 size,pre-output,output LSB first.64bits转16bit fifo 完成了上面注释掉的逻辑
   .aclr(0),
    .data(data_64_out),
    .wrclk(clk_div4),
    .wrreq(data_output_valid),  
    
    .rdclk(clk),
    .rdreq(lopd_write_en),
    .q(lopd_o)
);

//上载END----------------------------------------------------------------------------------------------------
endmodule
