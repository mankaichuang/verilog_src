//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang  
// Create Date: 2020/11/25 09:34:15
// Module Name: key
// Description: key state
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module key(
    input           sys_clk,
    input           sys_rst_n,
    input[3:0]      keyvalue,
    input           keyflag,

    output reg[5:0] point,              //数码管point的显示状态，0为显示，1为不显示；
    output reg      cnt_flag,           //数码管增减状态，0为递增，1为递减
    output reg      seg_en,             //数码管使能，0为关闭，1为打开
    output reg      seg_sign            //数码管符号位，0为不显示，1为显示；
);

reg[2:0]    point_reg;                  //数码管point寄存器

//通过point_reg判断当前应该哪个point点亮,key[2]每按一次，point_reg的值改变一次
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        point_reg <= 3'd0;
    else begin
        if((keyflag) && (keyvalue == 4'b1011)) begin
            if(point_reg < 3'd6)
                point_reg <= point_reg + 1'b1;
            else
                point_reg <= 3'd0;
        end
        else
            point_reg <= point_reg;
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        point <= 6'b111111;             //关闭数码管point显示
        cnt_flag <= 1'b0;               //默认数码管递增状态
        seg_en <= 1'b1;                 //默认打开数码管使能
        seg_sign <= 1'b0;               //默认不显示符号位
    end
    else begin
        if(keyflag)
            case(keyvalue)
                4'b1110:begin
                    seg_en <= ~seg_en;      //key[0]按下,开启或者关闭数码管
                    point <= point;
                    cnt_flag <= cnt_flag;
                    seg_sign <= seg_sign;
                end
                4'b1101:begin
                    cnt_flag <= ~cnt_flag;  //key[1]按下，改变双数码管增减状态
                    seg_en <= seg_en;
                    point <= point;
                    seg_sign <= seg_sign;
                end
                4'b1011:begin               //key[2]按下，改变point位置
                    seg_en <= seg_en;
                    cnt_flag <= cnt_flag;
                    seg_sign <= seg_sign;
                    case(point_reg)
                        3'd1:point <= 6'b111110;
                        3'd2:point <= 6'b111101;
                        3'd3:point <= 6'b111011;
                        3'd4:point <= 6'b110111;
                        3'd5:point <= 6'b101111;
                        3'd6:point <= 6'b011111;
                        default:point <= 6'b111111;
                    endcase
                end
                4'b0111:begin               //key[3]按下改变符号位
                    seg_sign <= ~seg_sign;
                    seg_en <= seg_en;
                    point <= point;
                    cnt_flag <= cnt_flag;
                end
            default begin
                point <= point;             //数码管point显示状态不变
                cnt_flag <= cnt_flag;       //数码管增减状态不变
                seg_en <= seg_en;           //数码管使能状态不变
                seg_sign <= seg_sign;       //数码管符号位状态不变
            end
            endcase
        else begin
            point <= point;             //数码管point显示状态不变
            cnt_flag <= cnt_flag;       //数码管增减状态不变
            seg_en <= seg_en;           //数码管使能状态不变
            seg_sign <= seg_sign;       //数码管符号位状态不变
        end
    end         
end
endmodule
