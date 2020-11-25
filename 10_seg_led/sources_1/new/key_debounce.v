//////////////////////////////////////////////////////////////////////////////////
//
// Engineer: mankaichuang
// Create Date: 2020/11/20 13:37:09
// Module Name: key_debounce
// Description: һ�ְ���ȥ�����ķ���
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module key_debounce(
    input           sys_clk,            //ϵͳʱ��
    input           sys_rst_n,          //��λ
    input[3:0]      key,                //���밴��
    
    output reg[3:0] keyvalue,           //����ֵ
    output reg      keyflag             //�����ɹ���־
);

reg[19:0]           cnt;                //������
reg[3:0]            key_reg;            //������ֵ�Ĵ���

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin                //��λ��ʱ�򣬰���ֵĬ��Ϊ1������������
        key_reg <= 4'b1111;                
        cnt <= 20'd0;
    end
    else begin                          //������������״̬
        if(key_reg != key) begin        //���keyֵ�仯��
            cnt <= 20'd100_0000;        //���ü�����ʼֵ���¸�ʱ�����ڿ�ʼ������һ��������ʱ20ms������ļ�������ʱ�����ڼ��㣩
            // cnt <= 20'd4;            //����ʱʹ��
            key_reg <= key;             //���浱ǰkeyֵ
        end 
        else begin                      //���keyֵ����
            if(cnt > 20'd0)             //��⵽��һ��ʱ�����ڼ�������ʼ����
                cnt <= cnt - 1'b1;      //��ʼ����
            else
                cnt <= 20'd0;
        end
   end        
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin                //��λ��ʱ�򣬰���ֵĬ��Ϊ1��������־Ϊ0
        keyvalue <= 4'b1111;               
        keyflag  <= 1'b0;
    end
    else if(cnt == 20'd1) begin         //����������20ms�ˣ���ʾ�����ȶ���
        keyflag  <= 1'b1;               //����������ɣ���������־λ��1
        keyvalue <= key;                //���浱ǰ�İ���ֵ
    end
    else begin
        keyflag  <= 1'b0;
        keyvalue <= keyvalue;
    end    
end
endmodule
