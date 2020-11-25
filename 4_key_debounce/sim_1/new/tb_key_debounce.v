//////////////////////////////////////////////////////////////////////////////////
// Engineer: mankaichuang
// Create Date: 2020/11/20 13:48:46
// Module Name: tb_key_debounce
// Description: ����ȥ����Testbench
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module tb_key_debounce();

parameter T = 20;             //ʱ������

reg key;
reg sys_clk;
reg sys_rst_n;

wire keyvalue;
wire keyflag;

initial begin
        key                     <=1'b1;     //������ʼֵΪ1
        sys_clk                 <=1'b0;     //ʱ�ӵ͵�ƽ
        sys_rst_n               <=1'b0;     //��λ��ʼΪ�͵�ƽ
#20     sys_rst_n               <=1'b1;     //20ns��λ��ɣ��ָߵ�ƽ
#30     key                     <=1'b0;     //50ns�󰴼�����
#20     key                     <= 1'b1;    //ģ�ⶶ��
#20     key                     <= 1'b0;    //ģ�ⶶ��
#20     key                     <= 1'b1;    //ģ�ⶶ��
#20     key                     <= 1'b0;    //ģ�ⶶ��
#170    key                     <= 1'b1;    //�ڵ� 300ns ��ʱ���ɿ�����
#20     key                     <= 1'b0;    //ģ�ⶶ��
#20     key                     <= 1'b1;    //ģ�ⶶ��
#20     key                     <= 1'b0;    //ģ�ⶶ��
#20     key                     <= 1'b1;    //ģ�ⶶ��
#170    key                     <= 1'b0;    //�ڵ� 550ns ��ʱ���ٴΰ��°���
#20     key                     <= 1'b1;    //ģ�ⶶ��
#20     key                     <= 1'b0;    //ģ�ⶶ��
#20     key                     <= 1'b1;    //ģ�ⶶ��
#20     key                     <= 1'b0;    //ģ�ⶶ��
#170    key                     <= 1'b1;    //�ڵ� 800ns ��ʱ���ɿ�����
#20     key                     <= 1'b0;    //ģ�ⶶ��
#20     key                     <= 1'b1;    //ģ�ⶶ��
#20     key                     <= 1'b0;    //ģ�ⶶ��
#20     key                     <= 1'b1;    //ģ�ⶶ��
#20     key                     <= 1'b0;
end

always # (T/2) sys_clk <= ~sys_clk;     //ʱ������Ϊ20ns��10ns��תһ��

key_debounce tb_key_debounce(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    .key            (key),
    
    .keyvalue       (keyvalue),
    .keyflag        (keyflag)
);
endmodule
