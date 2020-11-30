`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Engineer: mankaichuang
// Create Date: 2020/11/30 08:59:17
// Module Name: ip_clk_wiz
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////


module ip_clk_wiz(
    input           sys_clk,
    input           sys_rst_n,

    output          clk_100M,
    output          clk_100M_180dis,
    output          clk_50M,
    output          clk_25M,
    output          locked
);

clk_wiz_0 MMCM_CLK(
    // Clock out ports
    .clk_out1(clk_100M),            // output clk_out1
    .clk_out2(clk_100M_180dis),     // output clk_out2
    .clk_out3(clk_50M),             // output clk_out3
    .clk_out4(clk_25M),             // output clk_out4
    
    // Status and control signals
    .resetn(sys_rst_n),             // input resetn
    .locked(locked),                // output locked
    
   // Clock in ports
    .clk_in1(sys_clk)               // input clk_in1
);      
endmodule
