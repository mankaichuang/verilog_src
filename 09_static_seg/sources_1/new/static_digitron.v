`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Engineer: mankaichuang
// Create Date: 2020/11/24 14:01:41
// Module Name: static_digitron
// Description: static digitron ctrl
// 
//////////////////////////////////////////////////////////////////////////////////


module static_digitron(
    input           sys_clk,
    input           sys_rst_n,

    output [5:0]    seg_sel,
    output [7:0]    seg_led
);

parameter TIME_SHOW = 25'd2500_0000;
wire  add_flag;

digitron_driver u_digitron_driver(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    .add_flag       (add_flag),

    .seg_sel        (seg_sel),
    .seg_led        (seg_led)
);

time_cnt #(
    .MAX_CNT        (TIME_SHOW)
) u_time_cnt(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    
    .add_flag       (add_flag)    
);

endmodule
