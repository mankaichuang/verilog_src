//////////////////////////////////////////////////////////////////////////////////
// Engineer: mankaichuang
// Create Date: 2020/11/20 13:48:46
// Module Name: tb_key_debounce
// Description: 按键去抖的Testbench
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module tb_key_debounce();

parameter T = 20;             //时钟周期

reg key;
reg sys_clk;
reg sys_rst_n;

wire keyvalue;
wire keyflag;

initial begin
        key                     <=1'b1;     //按键初始值为1
        sys_clk                 <=1'b0;     //时钟低电平
        sys_rst_n               <=1'b0;     //复位初始为低电平
#20     sys_rst_n               <=1'b1;     //20ns后复位完成，持高电平
#30     key                     <=1'b0;     //50ns后按键按下
#20     key                     <= 1'b1;    //模拟抖动
#20     key                     <= 1'b0;    //模拟抖动
#20     key                     <= 1'b1;    //模拟抖动
#20     key                     <= 1'b0;    //模拟抖动
#170    key                     <= 1'b1;    //在第 300ns 的时候松开按键
#20     key                     <= 1'b0;    //模拟抖动
#20     key                     <= 1'b1;    //模拟抖动
#20     key                     <= 1'b0;    //模拟抖动
#20     key                     <= 1'b1;    //模拟抖动
#170    key                     <= 1'b0;    //在第 550ns 的时候再次按下按键
#20     key                     <= 1'b1;    //模拟抖动
#20     key                     <= 1'b0;    //模拟抖动
#20     key                     <= 1'b1;    //模拟抖动
#20     key                     <= 1'b0;    //模拟抖动
#170    key                     <= 1'b1;    //在第 800ns 的时候松开按键
#20     key                     <= 1'b0;    //模拟抖动
#20     key                     <= 1'b1;    //模拟抖动
#20     key                     <= 1'b0;    //模拟抖动
#20     key                     <= 1'b1;    //模拟抖动
#20     key                     <= 1'b0;
end

always # (T/2) sys_clk <= ~sys_clk;     //时钟周期为20ns，10ns反转一次

key_debounce tb_key_debounce(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    .key            (key),
    
    .keyvalue       (keyvalue),
    .keyflag        (keyflag)
);
endmodule
