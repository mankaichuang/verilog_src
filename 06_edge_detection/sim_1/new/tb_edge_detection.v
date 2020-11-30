//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/11/20 15:23:42
// Module Name: tb_edge_detection
// Description: 边沿检测Testbench
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb_edge_detection();

parameter T = 20;

reg signal;
reg sys_clk;
reg sys_rst_n;

wire rise_flag;
wire fall_flag;

initial begin
        signal                  <=1'b0;         
        sys_clk                 <=1'b0;
        sys_rst_n               <=1'b0;
#20     sys_rst_n               <=1'b1;
#80     signal                  <=1'b1;    //100ns之后信号上升沿来到
#100    signal                  <=1'b0;    //200ns之后信号下降沿来到
#100    signal                  <=1'b1;    //300ns之后信号上升沿来到
#100    signal                  <=1'b0;    //400ns之后信号下降沿来到 
end

always # (T/2) sys_clk <= ~sys_clk;

edge_detection tb_edge_detection(
    .sys_clk            (sys_clk),
    .sys_rst_n          (sys_rst_n),
    .signal             (signal),
    
    .rise_flag          (rise_flag),        //上升沿标志
    .fall_flag          (fall_flag)         //下降沿标志
);

endmodule
