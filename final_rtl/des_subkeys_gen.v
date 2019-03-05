/**************************************************************************************
*   Name        :des_subkeys_gen.v
*   Description :part of des_top.v.迭代法生成subkeys
*                输入最高位编号1，最低为编号64,其他类似。
*                系统上电后(or 通过key_in_64_en同步更新密码后)执行19个周期提前产生subkeys
*                key_in_64_en __|~~~~~~~~~|___________________________
*                clk          __|~~~~|____|~~~~|____|~~~~|____|~~~~|__
*                key_in_64_buff0_ok ~~~~~~|_________|~~~~~~~~~~~~~~~~~
*                key_in_64_buff0 __________XXXXXXXXXXXXXXXXXXXXXXXXXXX
*                state        ________________________________X  1   X
*   Origin      :20181230
*                20181231
*   Author      :helrori2011@gmail.com
**************************************************************************************/

module des_subkeys_gen
(
    input  wire clk,
    input  wire rst_n,//复位后会产生全零的subkeys
    input  wire encrypt,//1: encrypt;0: decrypt，此信号变必须与密码一同变更(即用key_in_64_en进行刷新subkeys操作)
    input  wire key_in_64_en,//allow key_in_64 to change the keys,以key_in_64_en==1时的最后一个clk上升沿为采样点
    input  wire [1:64]key_in_64,
    output reg  [1:48]subkeys_1,
    output reg  [1:48]subkeys_2,
    output reg  [1:48]subkeys_3,
    output reg  [1:48]subkeys_4,
    output reg  [1:48]subkeys_5,
    output reg  [1:48]subkeys_6,
    output reg  [1:48]subkeys_7,
    output reg  [1:48]subkeys_8,
    output reg  [1:48]subkeys_9,
    output reg  [1:48]subkeys_10,
    output reg  [1:48]subkeys_11,
    output reg  [1:48]subkeys_12,
    output reg  [1:48]subkeys_13,
    output reg  [1:48]subkeys_14,
    output reg  [1:48]subkeys_15,
    output reg  [1:48]subkeys_16,
    output wire subkeys_16_valid,
    output wire parity_check_error
    
);
/*
*   缓冲密码
*   input  key_in_64
*   output key_in_64_buff0,key_in_64_buff0_ok
*/
reg [1:64]key_in_64_buff0;
assign parity_check_error = ~((^key_in_64_buff0[1:8])&(^key_in_64_buff0[9:16])&(^key_in_64_buff0[17:24])&(^key_in_64_buff0[25:32])
                           &(^key_in_64_buff0[33:40])&(^key_in_64_buff0[41:48])&(^key_in_64_buff0[49:56])&(^key_in_64_buff0[57:64]));
reg key_in_64_buff0_ok;                           
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        key_in_64_buff0_ok  <= 1'd0;
        key_in_64_buff0     <= 64'd0;//默认密码64'd0
    end else if(key_in_64_en)begin
        key_in_64_buff0_ok  <= 1'd0;
        key_in_64_buff0     <= key_in_64;
    end else begin
        key_in_64_buff0_ok  <= 1'd1;
        key_in_64_buff0     <= key_in_64_buff0;
    end
end
/*
*   cnt_0 des_subkeys_unit块选
*/
reg [4:0]cnt_0;
reg [1:0]state;
assign subkeys_16_valid = (state == 2'd3);//state == 3为subkeys稳定有效状态,其他状态是生成subkeys过程中
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_0 <= 'd0;
        state <= 'd0;
    end else if(key_in_64_buff0_ok)begin//user updated keys
        if(state == 2'd0)begin
            state <= state + 2'd1;
        end else if(state == 2'd1 && cnt_0 < 5'd15)begin
            cnt_0 <= cnt_0 + 1'd1;
        end else if(state == 2'd1)begin//转至空闲state
            state <= state + 2'd1;
            cnt_0 <= 5'd0;
        end else if(state == 2'd2)begin
            state <= state + 2'd1;
        end else state <= state;//subkeys generated
    end else begin//user try to update keys
        state <= 'd0;
        cnt_0 <= 5'd0;
    end
end
wire [1:28]pc1_lo_28,pc1_ro_28,li_28,ri_28,lo_28,ro_28;
wire [1:48]subkeys_48_wire;
reg  [1:28]lo_28_buff,ro_28_buff;
assign li_28 = (cnt_0 == 5'd0)?pc1_lo_28:lo_28_buff;
assign ri_28 = (cnt_0 == 5'd0)?pc1_ro_28:ro_28_buff;
des_pc1 des_pc1_0
(
    .in_64(key_in_64_buff0),
    .lo_28(pc1_lo_28),
    .ro_28(pc1_ro_28)
);
des_subkeys_unit des_subkeys_unit_0
(
    .cnt_0(cnt_0),
    .encrypt(encrypt),
    .li_28(li_28),
    .ri_28(ri_28),
    .subkeys_48_wire(subkeys_48_wire),
    .lo_28(lo_28),
    .ro_28(ro_28)
);
always@(posedge clk or negedge rst_n)begin
if(!rst_n)begin
    lo_28_buff <= 28'd0;
    ro_28_buff <= 28'd0;
end else if(key_in_64_buff0_ok && state == 2'd1)begin
    lo_28_buff<=lo_28;
    ro_28_buff<=ro_28;
    case(cnt_0)
    4'd0:subkeys_1   <= subkeys_48_wire;
    4'd1:subkeys_2   <= subkeys_48_wire;
    4'd2:subkeys_3   <= subkeys_48_wire;
    4'd3:subkeys_4   <= subkeys_48_wire;
    4'd4:subkeys_5   <= subkeys_48_wire;
    4'd5:subkeys_6   <= subkeys_48_wire;
    4'd6:subkeys_7   <= subkeys_48_wire;
    4'd7:subkeys_8   <= subkeys_48_wire;
    4'd8:subkeys_9   <= subkeys_48_wire;
    4'd9:subkeys_10  <= subkeys_48_wire;
    4'd10:subkeys_11 <= subkeys_48_wire;
    4'd11:subkeys_12 <= subkeys_48_wire;
    4'd12:subkeys_13 <= subkeys_48_wire;
    4'd13:subkeys_14 <= subkeys_48_wire;
    4'd14:subkeys_15 <= subkeys_48_wire;
    4'd15:subkeys_16 <= subkeys_48_wire;
    endcase
end
end
endmodule