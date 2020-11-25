//////////////////////////////////////////////////////////////////////////////////
//
// Engineer: mankaichuang
// Create Date: 2020/11/20 13:37:09
// Module Name: key_debounce
// Description: 一种按键去抖动的方法
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module key_debounce(
    input           sys_clk,            //系统时钟
    input           sys_rst_n,          //复位
    input[3:0]      key,                //输入按键
    
    output reg[3:0] keyvalue,           //按键值
    output reg      keyflag             //按键成功标志
);

reg[19:0]           cnt;                //计数器
reg[3:0]            key_reg;            //按键键值寄存器

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin                //复位的时候，按键值默认为1，计数器清零
        key_reg <= 4'b1111;                
        cnt <= 20'd0;
    end
    else begin                          //进入正常工作状态
        if(key_reg != key) begin        //如果key值变化了
            cnt <= 20'd100_0000;        //设置计数初始值，下个时钟周期开始计数（一般消抖延时20ms，这里的计数根据时钟周期计算）
            // cnt <= 20'd4;            //仿真时使用
            key_reg <= key;             //保存当前key值
        end 
        else begin                      //如果key值保持
            if(cnt > 20'd0)             //检测到上一个时钟周期计数器初始化了
                cnt <= cnt - 1'b1;      //开始计数
            else
                cnt <= 20'd0;
        end
   end        
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin                //复位的时候，按键值默认为1，按键标志为0
        keyvalue <= 4'b1111;               
        keyflag  <= 1'b0;
    end
    else if(cnt == 20'd1) begin         //计数器持续20ms了，表示按键稳定了
        keyflag  <= 1'b1;               //按键消抖完成，将按键标志位置1
        keyvalue <= key;                //保存当前的按键值
    end
    else begin
        keyflag  <= 1'b0;
        keyvalue <= keyvalue;
    end    
end
endmodule
