`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/12/01 14:32:50
// Module Name: fifo_write
// Description: fifoд����ģ��
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_write(
    input           sys_clk,
    input           sys_rst_n,

    input           almost_full,
    input           almost_empty,

    output reg      fifo_wr_en,     //дʹ��
    output reg[7:0] fifo_wdata
);

//almost_empty�ź������ز�׽�ļĴ���
reg almost_empty_T0;            //��ǰ״̬
reg almost_empty_T1;            //��һʱ��״̬
wire almost_empty_flag;          //�����ر�־

reg[1:0] write_state;           //д����״̬��״̬
reg[3:0] delay_cnt;             //��ʱ������

assign almost_empty_flag = ~almost_empty_T1 & almost_empty_T0;  //��һ״̬Ϊ0��ǰ״̬Ϊ1�ǣ����������ص���

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        almost_empty_T0 <= 1'b0;
        almost_empty_T1 <= 1'b0;
    end
    else begin
        almost_empty_T0 <= almost_empty;         //��ǰ״̬
        almost_empty_T1 <= almost_empty_T0;      //��һʱ��״̬
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        fifo_wr_en <= 1'b0;         //дʹ������
        fifo_wdata <= 8'd0;         //д��������
        write_state <= 2'b0;        //д״̬������
        delay_cnt <= 4'd0;          //��ʱ����������
    end
    else begin
        case(write_state)
            2'd0: begin
                if(almost_empty_flag)       //�����鵽almost_empty
                    write_state <= 2'd1;    //����1״̬
                else
                    write_state <= write_state; //״̬����
            end
            2'd1:begin              //1״̬Ϊ��ʱ״̬��fifo�ڲ��ź�����ʱ��ȷ��fifo�ź�׼����
                if(delay_cnt == 4'd10)begin //��ʱ��10��ʱ������
                    write_state <= 2'd2;    //����2״̬��2״̬Ϊд״̬
                    fifo_wr_en <= 1'b1;     //��дʹ��
                    delay_cnt <= 4'd0; 
                end
                else begin
                    delay_cnt <= delay_cnt + 1'b1;
                end
            end
            2'd2:begin
                if(almost_full) begin       //�����Ҫд����
                    fifo_wr_en <= 1'b0;     //�ر�дʹ��
                    fifo_wdata <= 8'd0;     //д��������
                    write_state <= 2'd0;    //�ص�״̬0
                end
                else begin
                    fifo_wr_en <= 1'b1;     //��дʹ��
                    fifo_wdata <= fifo_wdata + 1'b1;    //д���ݵ����仯
                end
            end
            default:write_state <= 2'd0;
        endcase
    end
end

endmodule
