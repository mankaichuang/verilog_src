`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/12/01 14:33:07
// Module Name: fifo_read
// Description: fifo������ģ��
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_read(
    input           sys_clk,
    input           sys_rst_n,

    input           almost_full,
    input           almost_empty,
    input [7:0]     fifo_rdata,

    output reg      fifo_rd_en      //��ʹ��
);

//almost_full�ź������ز�׽�ļĴ���
reg almost_full_T0;            //��ǰ״̬
reg almost_full_T1;            //��һʱ��״̬
wire almost_full_flag;         //�����ر�־

reg[1:0] read_state;           //������״̬��״̬
reg[3:0] delay_cnt;            //��ʱ������

assign almost_full_flag = ~almost_full_T1 & almost_full_T0;  //��һ״̬Ϊ0��ǰ״̬Ϊ1�ǣ����������ص���

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        almost_full_T0 <= 1'b0;
        almost_full_T1 <= 1'b0;
    end
    else begin
        almost_full_T0 = almost_full;         //��ǰ״̬
        almost_full_T1 = almost_full_T0;      //��һʱ��״̬
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        fifo_rd_en <= 1'b0;         //��ʹ������
        read_state <= 2'b0;         //��״̬������
        delay_cnt <= 4'd0;          //��ʱ����������
    end
    else begin
        case(read_state)
            2'd0: begin
                if(almost_full_flag)       //�����鵽almost_full
                    read_state <= 2'd1;    //����1״̬
                else
                    read_state <= read_state; //״̬����
            end
            2'd1:begin              //1״̬Ϊ��ʱ״̬��fifo�ڲ��ź�����ʱ��ȷ��fifo�ź�׼����
                if(delay_cnt == 4'd10)begin //��ʱ��10��ʱ������
                    read_state <= 2'd2;     //����2״̬��2״̬Ϊд״̬
                    fifo_rd_en <= 1'b1;     //�򿪶�ʹ��
                end
                else begin
                    delay_cnt <= delay_cnt + 1'b1;
                end
            end
            2'd2:begin
                if(almost_empty) begin      //�����Ҫ������
                    fifo_rd_en <= 1'b0;     //�رն�ʹ��
                    read_state <= 2'd0;     //�ص�״̬0
                end
                else begin
                    fifo_rd_en <= 1'b1;     //�򿪶�ʹ��
                end
            end
            default: read_state <= 2'd0;
        endcase
    end
end

endmodule
