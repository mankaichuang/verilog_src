`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/12/01 14:32:50
// Module Name: fifo_write
// Description: fifo写操作模块
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_write(
    input           sys_clk,
    input           sys_rst_n,

    input           almost_full,
    input           almost_empty,

    output reg      fifo_wr_en,     //写使能
    output reg[7:0] fifo_wdata
);

//almost_empty信号上升沿捕捉的寄存器
reg almost_empty_T0;            //当前状态
reg almost_empty_T1;            //上一时刻状态
wire almost_empty_flag;          //上升沿标志

reg[1:0] write_state;           //写操作状态机状态
reg[3:0] delay_cnt;             //延时计数器

assign almost_empty_flag = ~almost_empty_T1 & almost_empty_T0;  //上一状态为0当前状态为1是，代表上升沿到来

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        almost_empty_T0 <= 1'b0;
        almost_empty_T1 <= 1'b0;
    end
    else begin
        almost_empty_T0 <= almost_empty;         //当前状态
        almost_empty_T1 <= almost_empty_T0;      //上一时刻状态
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        fifo_wr_en <= 1'b0;         //写使能清零
        fifo_wdata <= 8'd0;         //写数据清零
        write_state <= 2'b0;        //写状态机清零
        delay_cnt <= 4'd0;          //延时计数器清零
    end
    else begin
        case(write_state)
            2'd0: begin
                if(almost_empty_flag)       //如果检查到almost_empty
                    write_state <= 2'd1;    //进入1状态
                else
                    write_state <= write_state; //状态不变
            end
            2'd1:begin              //1状态为延时状态，fifo内部信号有延时，确保fifo信号准备好
                if(delay_cnt == 4'd10)begin //延时了10个时钟周期
                    write_state <= 2'd2;    //进入2状态，2状态为写状态
                    fifo_wr_en <= 1'b1;     //打开写使能
                    delay_cnt <= 4'd0; 
                end
                else begin
                    delay_cnt <= delay_cnt + 1'b1;
                end
            end
            2'd2:begin
                if(almost_full) begin       //如果快要写满了
                    fifo_wr_en <= 1'b0;     //关闭写使能
                    fifo_wdata <= 8'd0;     //写数据清零
                    write_state <= 2'd0;    //回到状态0
                end
                else begin
                    fifo_wr_en <= 1'b1;     //打开写使能
                    fifo_wdata <= fifo_wdata + 1'b1;    //写数据递增变化
                end
            end
            default:write_state <= 2'd0;
        endcase
    end
end

endmodule
