//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/11/20 14:55:33 
// Module Name: edge_detection
// Description: һ�ֱ��ؼ��ķ���
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module edge_detection(
    input           sys_clk,
    input           sys_rst_n,
    input           signal,
    
    output          rise_flag,          //�����ر�־
    output          fall_flag           //�½��ر�־
    );
    
reg         T0;                         //��ʾ��ǰ�ź�ֵ
reg         T1;                         //��ʾ��һʱ���ź�ֵ

assign rise_flag = (~T1) & T0;          //��ǰʱ��Ϊ1����һʱ��Ϊ0��Ϊ������
assign fall_flag = (~T0) & T1;          //��ǰʱ��Ϊ0����һʱ��Ϊ1��Ϊ�½���
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin                //��λʱ��������
        T0 <= 1'b0;
        T1 <= 1'b0;
    end
    else begin
        T0 <= signal;
        T1 <= T0;
    end
end
endmodule
