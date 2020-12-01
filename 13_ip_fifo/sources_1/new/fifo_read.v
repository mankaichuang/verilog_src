`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/12/01 14:33:07
// Module Name: fifo_read
// Description: fifo读操作模块
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_read(
    input           sys_clk,
    input           sys_rst_n,

    input           almost_full,
    input           almost_empty,
    input [7:0]     fifo_rdata,

    output reg      fifo_rd_en      //读使能
);

//almost_full信号上升沿捕捉的寄存器
reg almost_full_T0;            //当前状态
reg almost_full_T1;            //上一时刻状态
wire almost_full_flag;         //上升沿标志

reg[1:0] read_state;           //读操作状态机状态
reg[3:0] delay_cnt;            //延时计数器

assign almost_full_flag = ~almost_full_T1 & almost_full_T0;  //上一状态为0当前状态为1是，代表上升沿到来

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        almost_full_T0 <= 1'b0;
        almost_full_T1 <= 1'b0;
    end
    else begin
        almost_full_T0 = almost_full;         //当前状态
        almost_full_T1 = almost_full_T0;      //上一时刻状态
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        fifo_rd_en <= 1'b0;         //读使能清零
        read_state <= 2'b0;         //读状态机清零
        delay_cnt <= 4'd0;          //延时计数器清零
    end
    else begin
        case(read_state)
            2'd0: begin
                if(almost_full_flag)       //如果检查到almost_full
                    read_state <= 2'd1;    //进入1状态
                else
                    read_state <= read_state; //状态不变
            end
            2'd1:begin              //1状态为延时状态，fifo内部信号有延时，确保fifo信号准备好
                if(delay_cnt == 4'd10)begin //延时了10个时钟周期
                    read_state <= 2'd2;     //进入2状态，2状态为写状态
                    fifo_rd_en <= 1'b1;     //打开读使能
                end
                else begin
                    delay_cnt <= delay_cnt + 1'b1;
                end
            end
            2'd2:begin
                if(almost_empty) begin      //如果快要读控了
                    fifo_rd_en <= 1'b0;     //关闭读使能
                    read_state <= 2'd0;     //回到状态0
                end
                else begin
                    fifo_rd_en <= 1'b1;     //打开读使能
                end
            end
            default: read_state <= 2'd0;
        endcase
    end
end

endmodule
