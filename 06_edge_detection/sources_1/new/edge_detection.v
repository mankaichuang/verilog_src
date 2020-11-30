//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/11/20 14:55:33 
// Module Name: edge_detection
// Description: 一种边沿检测的方法
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module edge_detection(
    input           sys_clk,
    input           sys_rst_n,
    input           signal,
    
    output          rise_flag,          //上升沿标志
    output          fall_flag           //下降沿标志
    );
    
reg         T0;                         //表示当前信号值
reg         T1;                         //表示上一时刻信号值

assign rise_flag = (~T1) & T0;          //当前时刻为1，上一时刻为0，为上升沿
assign fall_flag = (~T0) & T1;          //当前时刻为0，上一时刻为1，为下降沿
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin                //复位时数据清零
        T0 <= 1'b0;
        T1 <= 1'b0;
    end
    else begin
        T0 <= signal;
        T1 <= T0;
    end
end
endmodule
