//////////////////////////////////////////////////////////////////////////////////
//  
// Engineer: mankaichuang 
// Create Date: 2020/11/25 11:22:19
// Module Name: seg_led_driver
// Description: This is seg_led driver
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps


module seg_led_driver(
    input               sys_clk,
    input               sys_rst_n,
    input [5:0]         point,              //�����point����ʾ״̬��0Ϊ��ʾ��1Ϊ����ʾ��
    input               seg_en,             //�����ʹ�ܣ�0Ϊ�رգ�1Ϊ��
    input               seg_sign,           //����ܷ���λ��0Ϊ����ʾ��1Ϊ��ʾ��
    input [19:0]        data,               //��ǰҪ��ʾ������             

    output reg[5:0]     seg_cs,
    output reg[7:0]     seg_led
);

localparam CLK_DIV = 4'd10;                 //ʱ�ӷ�Ƶϵ����
localparam MAX_CNT = 13'd5000;              //�����5Mʱ����1ms����ļ���

reg[3:0]        clk_cnt;                    //ʱ�ӷ�Ƶ��������
reg             seg_clk;                    //�����ʱ�ӣ�5Mhz
reg[23:0]       seg_num;                    //6λ����ܵ�24λBCD�������
reg[12:0]       cnt_1ms;                    //1ms�ļ�����
reg             flag_1ms;                   //1ms������ɱ�־
reg[2:0]        cnt_cs;                     //�����ѡλ��Ƭѡ��������
reg[3:0]        seg_dip;                    //��ǰ�������ʾ������
reg             dot_dip;                    //��ǰ�������ʾ��point

wire[3:0]       data0;                      //��λ
wire[3:0]       data1;                      //ʮλ
wire[3:0]       data2;                      //��λ
wire[3:0]       data3;                      //ǧλ
wire[3:0]       data4;                      //��λ
wire[3:0]       data5;                      //ʮ��λ


//��ȡ����λ��Ӧ��ʮ��������
assign data0 = data % 4'd10;                //��λ��
assign data1 = data / 4'd10 % 4'd10;        //ʮλ��
assign data2 = data / 7'd100 % 4'd10;       //��λ��
assign data3 = data / 10'd1000 % 4'd10;     //ǧλ��
assign data4 = data / 14'd10000 % 4'd10;    //��λ��
assign data5 = data / 17'd100000;           //ʮ��λ��

//��ϵͳʱ�ӽ���10��Ƶ�������������ܵ�5Mhz��ʱ��Ƶ��seg_clk
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
       clk_cnt <= 4'd0;
       seg_clk <= 1'b1;
    end
    else begin
        if(clk_cnt < CLK_DIV/2 -1)begin
            clk_cnt <= clk_cnt + 1'b1;
            seg_clk <= seg_clk;
        end
        else begin
            seg_clk <= ~seg_clk;
            clk_cnt <= 4'd0;
        end
    end  
end

//��24λ��2������ת��λ8421BCD�루ʹ��4λ����������ʾ1λʮ��������
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) 
        seg_num <= 0;
    else begin
        if(data5) begin                 //���ʮ��λ������
            seg_num[23:20] <= data5;    //������ܵĸ���λ��ֵ
            seg_num[19:16] <= data4;
            seg_num[15:12] <= data3;
            seg_num[11:8]  <= data2;
            seg_num[7:4]   <= data1;
            seg_num[3:0]   <= data0;
        end
        else begin
            if(data4) begin             //�����λ������
                seg_num[19:0] <= {data4,data3,data2,data1,data0};
                if(seg_sign)
                    seg_num[23:20] <= 4'd11;     //����и��ţ�ʮ��λ��ʾ����
                else
                    seg_num[23:20] <= 4'd10;     //���û�и��ţ�ʮ��λ����ʾ    
            end
            else begin
                if(data3) begin         //���ǧλ������
                    seg_num[15:0] <= {data3,data2,data1,data0};
                    seg_num[23:20] <= 4'd10;    //ʮ��λ����ʾ
                    if(seg_sign)
                        seg_num[19:16] <= 4'd11;     //����и��ţ���λ��ʾ����
                    else
                        seg_num[19:16] <= 4'd10;     //���û�и���,��λ����ʾ  
                end
                else begin
                    if(data2) begin     //�����λ������
                        seg_num[11:0] <= {data2,data1,data0};
                        seg_num[23:16] <= {2{4'd10}};    //ʮ��λ����λ����ʾ
                        if(seg_sign)
                            seg_num[15:12] <= 4'd11;     //����и��ţ�ǧλ��ʾ����
                        else
                            seg_num[15:12] <= 4'd10;     //���û�и���,ǧλ����ʾ 
                    end
                    else begin
                        if(data1) begin     //���ʮλ������
                            seg_num[7:0] <= {data1,data0};
                            seg_num[23:12] <= {3{4'd10}};    //ʮ��λ����λ��ǧλ����ʾ
                            if(seg_sign)
                                seg_num[11:8] <= 4'd11;     //����и��ţ���λ��ʾ����
                            else
                                seg_num[11:8] <= 4'd10;     //���û�и���,��λ����ʾ 
                        end
                        else begin //�����λ������
                                seg_num[3:0] <= data0;
                                seg_num[23:8] <= {4{4'd10}}; //ʮ��λ����λ��ǧλ����λ����ʾ
                                if(seg_sign)
                                    seg_num[7:4] <= 4'd11;     //����и��ţ�ʮλ��ʾ����
                                else
                                    seg_num[7:4] <= 4'd10;     //���û�и���,ʮλ����ʾ 
                        end
                    end
                end
            end
        end
    end
end

//����һ��1ms�Ķ�ʱ��
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        cnt_1ms <= 13'd0;
        flag_1ms <= 1'b0;
    end
    else begin
        if(cnt_1ms < MAX_CNT - 1)begin
            cnt_1ms <= cnt_1ms + 1'b1;
            flag_1ms <= 1'b0;
        end
        else begin
            flag_1ms <= 1'b1;
            cnt_1ms <= 13'd0;
        end
    end
end

//cnt_csƬѡ�����������ݸü�������ֵȷ����ǰҪƬѡ��ʾ�ĸ������
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt_cs <= 3'd0;
    else if(flag_1ms) begin
        if(cnt_cs < 3'd5)
            cnt_cs <= cnt_cs + 1'b1;
        else
            cnt_cs <= 3'd0; 
    end
    else
        cnt_cs <= cnt_cs;
end

//����Ƭѡ������cnt_cs��ֵ��������ʾ���������
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        seg_cs <= 6'b111111;        //�ر������
        seg_dip <= 4'd10;           //����ʾ            
        dot_dip <= 1'b1;            //point����ʾ
    end
    else begin
        if(seg_en) begin
            case(cnt_cs)
                3'd0:begin
                    seg_cs <= 6'b111110;    //����ܸ�λ��ʾ
                    seg_dip <= seg_num[3:0];
                    dot_dip <= point[0];
                end
                3'd1:begin
                    seg_cs <= 6'b111101;    //�����ʮλ��ʾ
                    seg_dip <= seg_num[7:4];
                    dot_dip <= point[1]; 
                end
                3'd2:begin
                    seg_cs <= 6'b111011;    //����ܰ�λ��ʾ
                    seg_dip <= seg_num[11:8];
                    dot_dip <= point[2]; 
                end
                3'd3:begin
                    seg_cs <= 6'b110111;    //�����ǧλ��ʾ
                    seg_dip <= seg_num[15:12];
                    dot_dip <= point[3]; 
                end
                3'd4:begin
                    seg_cs <= 6'b101111;    //�����ʮλ��ʾ
                    seg_dip <= seg_num[19:16];
                    dot_dip <= point[4]; 
                end
                3'd5:begin
                    seg_cs <= 6'b011111;    //�����ʮλ��ʾ
                    seg_dip <= seg_num[23:20];
                    dot_dip <= point[5]; 
                end
                default: begin
                    seg_cs <= 6'b111111;        //�ر������
                    seg_dip <= 4'd10;           //����ʾ            
                    dot_dip <= 1'b1;            //point����ʾ
                end     
            endcase
        end
        else begin
            seg_cs <= 6'b111111;        //�ر������
            seg_dip <= 4'd10;           //����ʾ            
            dot_dip <= 1'b1;            //point����ʾ
        end
    end

end

//�����������ʾ����
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        seg_led <= 8'b11000000;     //��ʾ0
    else begin
        case(seg_dip)
            4'd0 : seg_led <= {dot_dip,7'b1000000}; //��ʾ���� 0
            4'd1 : seg_led <= {dot_dip,7'b1111001}; //��ʾ���� 1
            4'd2 : seg_led <= {dot_dip,7'b0100100}; //��ʾ���� 2
            4'd3 : seg_led <= {dot_dip,7'b0110000}; //��ʾ���� 3
            4'd4 : seg_led <= {dot_dip,7'b0011001}; //��ʾ���� 4
            4'd5 : seg_led <= {dot_dip,7'b0010010}; //��ʾ���� 5
            4'd6 : seg_led <= {dot_dip,7'b0000010}; //��ʾ���� 6
            4'd7 : seg_led <= {dot_dip,7'b1111000}; //��ʾ���� 7
            4'd8 : seg_led <= {dot_dip,7'b0000000}; //��ʾ���� 8
            4'd9 : seg_led <= {dot_dip,7'b0010000}; //��ʾ���� 9
            4'd10: seg_led <= 8'b11111111; //����ʾ�κ��ַ�
            4'd11: seg_led <= 8'b10111111; //��ʾ����(-)
            default:
                seg_led <= {dot_dip,7'b1000000};
        endcase
    end 
end

endmodule