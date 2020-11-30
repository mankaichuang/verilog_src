`timescale 1ns / 1ps

module tb_key_debounce();

parameter T = 20;

reg key;
reg sys_clk;
reg sys_rst_n;

wire beep;

initial begin
    key                     <=1'b1;
    sys_clk                 <=1'b0;
    sys_rst_n               <=1'b0;
#20 sys_rst_n               <=1'b1;
#30 key                     <=1'b0;
#20 key                     <= 1'b1; //模拟抖动
#20 key                     <= 1'b0; //模拟抖动
#20 key                     <= 1'b1; //模拟抖动
#20 key                     <= 1'b0; //模拟抖动
#170 key                    <= 1'b1; //在第 300ns 的时候松开按键
#20 key                     <= 1'b0; //模拟抖动
#20 key                     <= 1'b1; //模拟抖动
#20 key                     <= 1'b0; //模拟抖动
#20 key                     <= 1'b1; //模拟抖动
#170 key                    <= 1'b0; //在第 550ns 的时候再次按下按键
#20 key                     <= 1'b1; //模拟抖动
#20 key                     <= 1'b0; //模拟抖动
#20 key                     <= 1'b1; //模拟抖动
#20 key                     <= 1'b0; //模拟抖动
#170 key                    <= 1'b1; //在第 800ns 的时候松开按键
#20 key                     <= 1'b0; //模拟抖动
#20 key                     <= 1'b1; //模拟抖动
#20 key                     <= 1'b0; //模拟抖动
#20 key                     <= 1'b1; //模拟抖动
#20 key                     <= 1'b0;
end

always # (T/2) sys_clk <= ~sys_clk;

key_beep tb1(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    .key            (key),
    
    .beep           (beep)
);
endmodule
