`timescale 1ns / 1ps

module tb_key_debounce();

parameter T = 20;

reg key;
reg sys_clk;
reg sys_rst_n;

wire beep;

initial begin
    key                     <=1'b1;
    sys_clk                 <=1'b0;
    sys_rst_n               <=1'b0;
#20 sys_rst_n               <=1'b1;
#30 key                     <=1'b0;
#20 key                     <= 1'b1; //ģ�ⶶ��
#20 key                     <= 1'b0; //ģ�ⶶ��
#20 key                     <= 1'b1; //ģ�ⶶ��
#20 key                     <= 1'b0; //ģ�ⶶ��
#170 key                    <= 1'b1; //�ڵ� 300ns ��ʱ���ɿ�����
#20 key                     <= 1'b0; //ģ�ⶶ��
#20 key                     <= 1'b1; //ģ�ⶶ��
#20 key                     <= 1'b0; //ģ�ⶶ��
#20 key                     <= 1'b1; //ģ�ⶶ��
#170 key                    <= 1'b0; //�ڵ� 550ns ��ʱ���ٴΰ��°���
#20 key                     <= 1'b1; //ģ�ⶶ��
#20 key                     <= 1'b0; //ģ�ⶶ��
#20 key                     <= 1'b1; //ģ�ⶶ��
#20 key                     <= 1'b0; //ģ�ⶶ��
#170 key                    <= 1'b1; //�ڵ� 800ns ��ʱ���ɿ�����
#20 key                     <= 1'b0; //ģ�ⶶ��
#20 key                     <= 1'b1; //ģ�ⶶ��
#20 key                     <= 1'b0; //ģ�ⶶ��
#20 key                     <= 1'b1; //ģ�ⶶ��
#20 key                     <= 1'b0;
end

always # (T/2) sys_clk <= ~sys_clk;

key_beep tb1(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    .key            (key),
    
    .beep           (beep)
);
endmodule
