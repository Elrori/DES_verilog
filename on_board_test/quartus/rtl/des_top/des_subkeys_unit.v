/**************************************************************************************
*   Name        :des_subkeys_unit.v
*   Description :part of des_subkeys_gen.v.
*   Origin      :20181230
*                20181231
*   Author      :helrori2011@gmail.com
**************************************************************************************/
module des_subkeys_unit
(
    input  wire [4:0]cnt_0,
    input  wire encrypt,
    input  wire [1:28]li_28,
    input  wire [1:28]ri_28,
    output wire [1:48]subkeys_48_wire,
    output reg [1:28]lo_28,
    output reg [1:28]ro_28 
);
always@(*)
if(encrypt)
    case(cnt_0)
        5'd0,5'd1,5'd8,5'd15:begin
        lo_28=li_28<<1;
        ro_28=ri_28<<1;
        lo_28[28]=li_28[1];
        ro_28[28]=ri_28[1];
        end
        5'd2,5'd3,5'd4,5'd5,5'd6,5'd7,5'd9,5'd10,5'd11,5'd12,5'd13,5'd14:begin
        lo_28=li_28<<2;
        ro_28=ri_28<<2;
        lo_28[27:28]=li_28[1:2];
        ro_28[27:28]=ri_28[1:2];
        end
//        default:;
    endcase
else 
    case(cnt_0)
        5'd1,5'd8,5'd15:begin
        lo_28=li_28>>1;
        ro_28=ri_28>>1;
        lo_28[1]=li_28[28];
        ro_28[1]=ri_28[28];
        end
        5'd2,5'd3,5'd4,5'd5,5'd6,5'd7,5'd9,5'd10,5'd11,5'd12,5'd13,5'd14:begin
        lo_28=li_28>>2;
        ro_28=ri_28>>2;
        lo_28[1:2]=li_28[27:28];
        ro_28[1:2]=ri_28[27:28];
        end
        5'd0:begin lo_28=li_28;ro_28=ri_28;end
//        default:;
    endcase
des_pc2 des_pc2_1
(
    .li_28(lo_28),
    .ri_28(ro_28),
    .kout_48(subkeys_48_wire)
);
endmodule