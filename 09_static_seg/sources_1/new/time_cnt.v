`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang 
// Create Date: 2020/11/24 15:29:11
// Module Name: time_cnt 
// Description: the timer is 0.5s
// 
//////////////////////////////////////////////////////////////////////////////////


module time_cnt(
    input           sys_clk,
    input           sys_rst_n,
    
    output reg      add_flag    
);

parameter MAX_CNT = 25'd2500_0000;

reg[24:0]   cnt;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        cnt <= 25'd0;
        add_flag <= 1'b0;
    end
    else begin
        if(cnt < MAX_CNT - 1'b1) begin
            add_flag <= 1'b0;
            cnt <= cnt + 1'b1;
        end
        else begin
            add_flag <=1'b1;
            cnt <= 25'd0;
        end
    end

end

endmodule
