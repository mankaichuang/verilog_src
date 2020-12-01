`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/11/30 11:35:21
// Module Name: ram_rw
// Description: ram数据读写操作
// 
//////////////////////////////////////////////////////////////////////////////////


module ram_rw(
    input           sys_clk,
    input           sys_rst_n,

    output          ram_en,             //使能
    output          ram_we,             //读写片选
    output reg[4:0] ram_addr,           //地址
    output reg[7:0] ram_wdata           //要写入的数据
);

reg[5:0]    rw_cnt;

assign ram_en = sys_rst_n;
assign ram_we = (rw_cnt <= 6'd31) ? 1'b1 : 1'b0;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        rw_cnt <= 6'b0;
    else begin
        if(ram_en) begin
            if(rw_cnt == 6'd63)
                rw_cnt <= 6'b0;
            else
                rw_cnt <= rw_cnt + 6'b1;
        end
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        ram_addr <= 5'b0;
    else begin
        if(ram_en) begin
            if(ram_addr == 5'd31)
                ram_addr <= 5'b0;
            else
                ram_addr <= ram_addr + 5'b1;
        end
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        ram_wdata <= 8'b0;
    else begin
        if(ram_en) begin
            if(rw_cnt < 5'd31)
                ram_wdata <= ram_wdata + 8'b1;
            else
                ram_wdata <= 8'b0;
        end
    end        
end

endmodule
