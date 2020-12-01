`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/11/30 09:49:48 
// Module Name: tb_ip_clk 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_ip_clk();

reg sys_clk;
reg sys_rst_n;

wire clk_100M;
wire clk_100M_180dis;
wire clk_50M;
wire clk_25M;
wire locked;

always #10 sys_clk = ~sys_clk;

initial begin
            sys_clk         =1'b0;
            sys_rst_n       =1'b0;
    #200    sys_rst_n       =1'b1;
end

ip_clk_wiz u_ip_clk_wiz(
    .sys_clk            (sys_clk),
    .sys_rst_n          (sys_rst_n),
    .clk_100M           (clk_100M),
    .clk_100M_180dis    (clk_100M_180dis),
    .clk_50M            (clk_50M),
    .clk_25M            (clk_25M),
    .locked             (locked)
);

endmodule
