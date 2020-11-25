`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: 
// Create Date: 2020/11/24 14:04:39 
// Module Name: digitron_driver 
// Description: This is digitron driver 
// 
//////////////////////////////////////////////////////////////////////////////////


module digitron_driver(
    input           sys_clk,
    input           sys_rst_n,
    input           add_flag,
    
    output reg[5:0] seg_sel,
    output reg[7:0] seg_led
);

reg[4:0]      seg_state;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        seg_sel <= 6'b111111;
    else
        seg_sel <= 6'b000000;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        seg_state <= 5'b11111;
    else if(add_flag) begin
        if(seg_state < 5'b10000)
            seg_state <= seg_state + 1'b1;
        else
            seg_state <= 5'b00000;
    end
    else
        seg_state <= seg_state;   
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        seg_led <= 8'b1111_1111;                       
    else begin
        case(seg_state)
            5'h00 : seg_led <= 8'b1100_0000;           //0
            5'h01 : seg_led <= 8'b1111_1001;           //1
            5'h02 : seg_led <= 8'b1010_0100;           //2
            5'h03 : seg_led <= 8'b1011_0000;           //3
            5'h04 : seg_led <= 8'b1001_1001;           //4
            5'h05 : seg_led <= 8'b1001_0010;           //5
            5'h06 : seg_led <= 8'b1000_0010;           //6
            5'h07 : seg_led <= 8'b1111_1000;           //7
            5'h08 : seg_led <= 8'b1000_0000;           //8
            5'h09 : seg_led <= 8'b1001_0000;           //9
            5'h0a : seg_led <= 8'b1000_1000;           //A
            5'h0b : seg_led <= 8'b1000_0011;           //B
            5'h0c : seg_led <= 8'b1100_0110;           //C
            5'h0d : seg_led <= 8'b1010_0001;           //D
            5'h0e : seg_led <= 8'b1000_0110;           //E
            5'h0f : seg_led <= 8'b1000_1110;           //F
            5'h10 : seg_led <= 8'b0111_1111;           //.
            default : seg_led <= 8'b1111_1111; 
        endcase
    end 
end

endmodule
