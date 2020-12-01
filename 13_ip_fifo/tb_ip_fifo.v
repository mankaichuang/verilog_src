`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/12/01 18:20:33
// Module Name: tb_ip_fifo 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_ip_fifo();

reg sys_clk;
reg sys_rst_n;

always #10 sys_clk <= ~sys_clk;

initial begin
        sys_clk         <= 1'b0;
        sys_rst_n       <= 1'b0;
    #20 sys_rst_n       <= 1'b1;
end

ip_fifo u_ip_fifo(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n)
);

endmodule
