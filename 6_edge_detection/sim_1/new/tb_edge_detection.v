//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/11/20 15:23:42
// Module Name: tb_edge_detection
// Description: ���ؼ��Testbench
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
#80     signal                  <=1'b1;    //100ns֮���ź�����������
#100    signal                  <=1'b0;    //200ns֮���ź��½�������
#100    signal                  <=1'b1;    //300ns֮���ź�����������
#100    signal                  <=1'b0;    //400ns֮���ź��½������� 
end

always # (T/2) sys_clk <= ~sys_clk;

edge_detection tb_edge_detection(
    .sys_clk            (sys_clk),
    .sys_rst_n          (sys_rst_n),
    .signal             (signal),
    
    .rise_flag          (rise_flag),        //�����ر�־
    .fall_flag          (fall_flag)         //�½��ر�־
);

endmodule
