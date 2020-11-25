//////////////////////////////////////////////////////////////////////////////////
//  
// Engineer: mankaichuang 
// Create Date: 2020/11/25 11:22:19
// Module Name: seg_led_driver
// Description: This is seg_led driver
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps


module seg_led_driver(
    input               sys_clk,
    input               sys_rst_n,
    input [5:0]         point,              //数码管point的显示状态，0为显示，1为不显示；
    input               seg_en,             //数码管使能，0为关闭，1为打开
    input               seg_sign,           //数码管符号位，0为不显示，1为显示；
    input [19:0]        data,               //当前要显示的数据             

    output reg[5:0]     seg_cs,
    output reg[7:0]     seg_led
);

localparam CLK_DIV = 4'd10;                 //时钟分频系数；
localparam MAX_CNT = 13'd5000;              //数码管5M时钟下1ms所需的计数

reg[3:0]        clk_cnt;                    //时钟分频计数器；
reg             seg_clk;                    //数码管时钟，5Mhz
reg[23:0]       seg_num;                    //6位数码管的24位BCD码计数器
reg[12:0]       cnt_1ms;                    //1ms的计数器
reg             flag_1ms;                   //1ms计数完成标志
reg[2:0]        cnt_cs;                     //数码管选位（片选）计数器
reg[3:0]        seg_dip;                    //当前数码管显示的数据
reg             dot_dip;                    //当前数码管显示的point

wire[3:0]       data0;                      //个位
wire[3:0]       data1;                      //十位
wire[3:0]       data2;                      //百位
wire[3:0]       data3;                      //千位
wire[3:0]       data4;                      //万位
wire[3:0]       data5;                      //十万位


//获取各数位对应的十进制数据
assign data0 = data % 4'd10;                //个位数
assign data1 = data / 4'd10 % 4'd10;        //十位数
assign data2 = data / 7'd100 % 4'd10;       //百位数
assign data3 = data / 10'd1000 % 4'd10;     //千位数
assign data4 = data / 14'd10000 % 4'd10;    //万位数
assign data5 = data / 17'd100000;           //十万位数

//对系统时钟进行10分频，获得驱动数码管的5Mhz的时钟频率seg_clk
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
       clk_cnt <= 4'd0;
       seg_clk <= 1'b1;
    end
    else begin
        if(clk_cnt < CLK_DIV/2 -1)begin
            clk_cnt <= clk_cnt + 1'b1;
            seg_clk <= seg_clk;
        end
        else begin
            seg_clk <= ~seg_clk;
            clk_cnt <= 4'd0;
        end
    end  
end

//将24位的2进制数转换位8421BCD码（使用4位二进制数表示1位十进制数）
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) 
        seg_num <= 0;
    else begin
        if(data5) begin                 //如果十万位有数据
            seg_num[23:20] <= data5;    //给数码管的各数位赋值
            seg_num[19:16] <= data4;
            seg_num[15:12] <= data3;
            seg_num[11:8]  <= data2;
            seg_num[7:4]   <= data1;
            seg_num[3:0]   <= data0;
        end
        else begin
            if(data4) begin             //如果万位有数据
                seg_num[19:0] <= {data4,data3,data2,data1,data0};
                if(seg_sign)
                    seg_num[23:20] <= 4'd11;     //如果有负号，十万位显示负号
                else
                    seg_num[23:20] <= 4'd10;     //如果没有负号，十万位不显示    
            end
            else begin
                if(data3) begin         //如果千位有数据
                    seg_num[15:0] <= {data3,data2,data1,data0};
                    seg_num[23:20] <= 4'd10;    //十万位不显示
                    if(seg_sign)
                        seg_num[19:16] <= 4'd11;     //如果有负号，万位显示负号
                    else
                        seg_num[19:16] <= 4'd10;     //如果没有负号,万位不显示  
                end
                else begin
                    if(data2) begin     //如果百位有数据
                        seg_num[11:0] <= {data2,data1,data0};
                        seg_num[23:16] <= {2{4'd10}};    //十万位和万位不显示
                        if(seg_sign)
                            seg_num[15:12] <= 4'd11;     //如果有负号，千位显示负号
                        else
                            seg_num[15:12] <= 4'd10;     //如果没有负号,千位不显示 
                    end
                    else begin
                        if(data1) begin     //如果十位有数据
                            seg_num[7:0] <= {data1,data0};
                            seg_num[23:12] <= {3{4'd10}};    //十万位、万位和千位不显示
                            if(seg_sign)
                                seg_num[11:8] <= 4'd11;     //如果有负号，百位显示负号
                            else
                                seg_num[11:8] <= 4'd10;     //如果没有负号,百位不显示 
                        end
                        else begin //如果个位有数据
                                seg_num[3:0] <= data0;
                                seg_num[23:8] <= {4{4'd10}}; //十万位、万位、千位、百位不显示
                                if(seg_sign)
                                    seg_num[7:4] <= 4'd11;     //如果有负号，十位显示负号
                                else
                                    seg_num[7:4] <= 4'd10;     //如果没有负号,十位不显示 
                        end
                    end
                end
            end
        end
    end
end

//定义一个1ms的定时器
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        cnt_1ms <= 13'd0;
        flag_1ms <= 1'b0;
    end
    else begin
        if(cnt_1ms < MAX_CNT - 1)begin
            cnt_1ms <= cnt_1ms + 1'b1;
            flag_1ms <= 1'b0;
        end
        else begin
            flag_1ms <= 1'b1;
            cnt_1ms <= 13'd0;
        end
    end
end

//cnt_cs片选计数器，根据该计数器的值确定当前要片选显示哪个数码管
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt_cs <= 3'd0;
    else if(flag_1ms) begin
        if(cnt_cs < 3'd5)
            cnt_cs <= cnt_cs + 1'b1;
        else
            cnt_cs <= 3'd0; 
    end
    else
        cnt_cs <= cnt_cs;
end

//根据片选计数器cnt_cs的值，轮流显示各个数码管
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        seg_cs <= 6'b111111;        //关闭数码管
        seg_dip <= 4'd10;           //不显示            
        dot_dip <= 1'b1;            //point不显示
    end
    else begin
        if(seg_en) begin
            case(cnt_cs)
                3'd0:begin
                    seg_cs <= 6'b111110;    //数码管个位显示
                    seg_dip <= seg_num[3:0];
                    dot_dip <= point[0];
                end
                3'd1:begin
                    seg_cs <= 6'b111101;    //数码管十位显示
                    seg_dip <= seg_num[7:4];
                    dot_dip <= point[1]; 
                end
                3'd2:begin
                    seg_cs <= 6'b111011;    //数码管百位显示
                    seg_dip <= seg_num[11:8];
                    dot_dip <= point[2]; 
                end
                3'd3:begin
                    seg_cs <= 6'b110111;    //数码管千位显示
                    seg_dip <= seg_num[15:12];
                    dot_dip <= point[3]; 
                end
                3'd4:begin
                    seg_cs <= 6'b101111;    //数码管十位显示
                    seg_dip <= seg_num[19:16];
                    dot_dip <= point[4]; 
                end
                3'd5:begin
                    seg_cs <= 6'b011111;    //数码管十位显示
                    seg_dip <= seg_num[23:20];
                    dot_dip <= point[5]; 
                end
                default: begin
                    seg_cs <= 6'b111111;        //关闭数码管
                    seg_dip <= 4'd10;           //不显示            
                    dot_dip <= 1'b1;            //point不显示
                end     
            endcase
        end
        else begin
            seg_cs <= 6'b111111;        //关闭数码管
            seg_dip <= 4'd10;           //不显示            
            dot_dip <= 1'b1;            //point不显示
        end
    end

end

//控制数码管显示数字
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        seg_led <= 8'b11000000;     //显示0
    else begin
        case(seg_dip)
            4'd0 : seg_led <= {dot_dip,7'b1000000}; //显示数字 0
            4'd1 : seg_led <= {dot_dip,7'b1111001}; //显示数字 1
            4'd2 : seg_led <= {dot_dip,7'b0100100}; //显示数字 2
            4'd3 : seg_led <= {dot_dip,7'b0110000}; //显示数字 3
            4'd4 : seg_led <= {dot_dip,7'b0011001}; //显示数字 4
            4'd5 : seg_led <= {dot_dip,7'b0010010}; //显示数字 5
            4'd6 : seg_led <= {dot_dip,7'b0000010}; //显示数字 6
            4'd7 : seg_led <= {dot_dip,7'b1111000}; //显示数字 7
            4'd8 : seg_led <= {dot_dip,7'b0000000}; //显示数字 8
            4'd9 : seg_led <= {dot_dip,7'b0010000}; //显示数字 9
            4'd10: seg_led <= 8'b11111111; //不显示任何字符
            4'd11: seg_led <= 8'b10111111; //显示负号(-)
            default:
                seg_led <= {dot_dip,7'b1000000};
        endcase
    end 
end

endmodule