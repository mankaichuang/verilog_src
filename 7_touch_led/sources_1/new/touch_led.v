//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/11/20 13:33:37
// Module Name: touch_led
// Description: ������������led��ת
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module touch_led(
    input           sys_clk,
    input           sys_rst_n,
    input           touch_key,          //��������
    
    output  reg     led                //led
);
    
wire        led_en;                  //�����ر�־ 
reg         T0;                         //��ʾ��ǰ�ź�ֵ
reg         T1;                         //��ʾ��һʱ���ź�ֵ

assign led_en = (~T1) & T0;          //��ǰʱ��Ϊ1����һʱ��Ϊ0��Ϊ������,
                                     //��led_enΪ1ʱ��ʾ����������

always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin                //��λʱ��������
        T0 <= 1'b0;
        T1 <= 1'b0;
    end
    else begin
        T0 <= touch_key;
        T1 <= T0;
    end
end

always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)                  //��λʱledĬ�ϵ���
        led <= 1'b1;
    else if(led_en == 1'b1)
        led <= ~led;                //led��ת
    else
        led <= led;
end
endmodule

