//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang 
// Create Date: 2020/11/24 15:29:11
// Module Name: data_value 
// Description: ÿ��0.2s�ı�һ�����������
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module data_value(
    input               sys_clk,
    input               sys_rst_n,
    input               cnt_flag,

    output reg[19:0]    data            //��ǰҪ��ʾ������
);

parameter MAX_CNT = 24'd1000_0000;

reg[23:0]   cnt;
reg         timer_flag;

//����0.2ms�Ķ�ʱ��
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        cnt <= 24'd0;
        timer_flag <= 1'b0;
    end
    else begin
        if(cnt < MAX_CNT - 1'b1) begin
            timer_flag <= 1'b0;
            cnt <= cnt + 1'b1;
        end
        else begin
            timer_flag <=1'b1;
            cnt <= 24'd0;
        end
    end

end

//ÿ0.2ms���ݸ���һ��
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        data <= 20'd0;
    else begin
        if(timer_flag) begin        //0.2s���ˣ���������
            if(cnt_flag) begin      //�ݼ�״̬
                if(data > 20'd0)
                    data <= data - 1'b1;
                else
                    data <= 20'd999999; 
            end
            else begin              //����״̬
                if(data < 20'd999999)
                    data <= data + 1'b1;
                else
                    data <= 20'd0; 
            end
        end
        else
            data <= data;     
    end
end

endmodule
