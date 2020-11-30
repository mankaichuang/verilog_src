`timescale 1ns / 1ps

module key_debounce(
    input           sys_clk,
    input           sys_rst_n,
    input           key,
    
    output reg      keyvalue,
    output reg      keyflag
);

reg[19:0]           cnt;
reg                 key_reg;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        key_reg <= 1'b1;
        cnt <= 20'd0;
    end
    else begin
        if(key_reg != key) begin        //���keyֵ�仯��
            cnt <=  20'd100_0000;       //���ü�����ʼֵ
//        cnt <=  20'd4;                //������ʱ��ʹ��
            key_reg <= key;             //���浱ǰkeyֵ
        end 
        else begin                      //���keyֵ����
            if(cnt > 20'd0)             //�ж�������û��׼������
                cnt <= cnt - 1'b1;      //��ʼ����
            else
                cnt <= 20'd0;
        end
   end        
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        keyvalue <= 1'b1;
        keyflag  <= 1'b0;
    end
    else if(cnt == 20'd1) begin         //����״̬����20ms
        keyflag  <= 1'b1;               //�����������
        keyvalue <= key;                //��ǰ�İ���ֵ
    end
    else begin
        keyflag  <= 1'b0;
        keyvalue <= keyvalue;
    end    
end
endmodule
