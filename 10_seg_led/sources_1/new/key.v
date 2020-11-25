//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang  
// Create Date: 2020/11/25 09:34:15
// Module Name: key
// Description: key state
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module key(
    input           sys_clk,
    input           sys_rst_n,
    input[3:0]      keyvalue,
    input           keyflag,

    output reg[5:0] point,              //�����point����ʾ״̬��0Ϊ��ʾ��1Ϊ����ʾ��
    output reg      cnt_flag,           //���������״̬��0Ϊ������1Ϊ�ݼ�
    output reg      seg_en,             //�����ʹ�ܣ�0Ϊ�رգ�1Ϊ��
    output reg      seg_sign            //����ܷ���λ��0Ϊ����ʾ��1Ϊ��ʾ��
);

reg[2:0]    point_reg;                  //�����point�Ĵ���

//ͨ��point_reg�жϵ�ǰӦ���ĸ�point����,key[2]ÿ��һ�Σ�point_reg��ֵ�ı�һ��
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        point_reg <= 3'd0;
    else begin
        if((keyflag) && (keyvalue == 4'b1011)) begin
            if(point_reg < 3'd6)
                point_reg <= point_reg + 1'b1;
            else
                point_reg <= 3'd0;
        end
        else
            point_reg <= point_reg;
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        point <= 6'b111111;             //�ر������point��ʾ
        cnt_flag <= 1'b0;               //Ĭ������ܵ���״̬
        seg_en <= 1'b1;                 //Ĭ�ϴ������ʹ��
        seg_sign <= 1'b0;               //Ĭ�ϲ���ʾ����λ
    end
    else begin
        if(keyflag)
            case(keyvalue)
                4'b1110:begin
                    seg_en <= ~seg_en;      //key[0]����,�������߹ر������
                    point <= point;
                    cnt_flag <= cnt_flag;
                    seg_sign <= seg_sign;
                end
                4'b1101:begin
                    cnt_flag <= ~cnt_flag;  //key[1]���£��ı�˫���������״̬
                    seg_en <= seg_en;
                    point <= point;
                    seg_sign <= seg_sign;
                end
                4'b1011:begin               //key[2]���£��ı�pointλ��
                    seg_en <= seg_en;
                    cnt_flag <= cnt_flag;
                    seg_sign <= seg_sign;
                    case(point_reg)
                        3'd1:point <= 6'b111110;
                        3'd2:point <= 6'b111101;
                        3'd3:point <= 6'b111011;
                        3'd4:point <= 6'b110111;
                        3'd5:point <= 6'b101111;
                        3'd6:point <= 6'b011111;
                        default:point <= 6'b111111;
                    endcase
                end
                4'b0111:begin               //key[3]���¸ı����λ
                    seg_sign <= ~seg_sign;
                    seg_en <= seg_en;
                    point <= point;
                    cnt_flag <= cnt_flag;
                end
            default begin
                point <= point;             //�����point��ʾ״̬����
                cnt_flag <= cnt_flag;       //���������״̬����
                seg_en <= seg_en;           //�����ʹ��״̬����
                seg_sign <= seg_sign;       //����ܷ���λ״̬����
            end
            endcase
        else begin
            point <= point;             //�����point��ʾ״̬����
            cnt_flag <= cnt_flag;       //���������״̬����
            seg_en <= seg_en;           //�����ʹ��״̬����
            seg_sign <= seg_sign;       //����ܷ���λ״̬����
        end
    end         
end
endmodule
