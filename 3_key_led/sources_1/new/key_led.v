`timescale 1ns / 1ps

module key_led(
    input               sys_clk,
    input               sys_rst_n,
    input[3:0]          key,
    
    output reg[3:0]     led
);

reg[23:0]   cnt;
reg[1:0]    led_ctrl;

//创建定时器0.2s
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt <= 1'b0;
    else if(cnt < 24'd1000_0000)
        cnt <= cnt + 1'b1;
    else
        cnt <= 1'b0;
end

//led状态
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        led_ctrl <= 2'b00;
    else if(cnt == 24'd1000_0000)
        led_ctrl <= led_ctrl + 1'b1;
    else
        led_ctrl <= led_ctrl;
end

//led控制
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        led <= 4'b0000;
    else if(key[0] == 1'b0)
        case(led_ctrl)
            2'b00: led <= 4'b0001;
            2'b01: led <= 4'b0010;
            2'b10: led <= 4'b0100;
            2'b11: led <= 4'b1000;
            default: led <= 4'b0000;
        endcase
    else if(key[1] == 1'b0)
        case(led_ctrl)
            2'b00: led <= 4'b1000;
            2'b01: led <= 4'b0100;
            2'b10: led <= 4'b0010;
            2'b11: led <= 4'b0001;
            default: led <= 4'b0000;
        endcase
    else if(key[2] == 1'b0)
        case(led_ctrl)
            2'b00: led <= 4'b1111;
            2'b01: led <= 4'b0000;
            2'b10: led <= 4'b1111;
            2'b11: led <= 4'b0000;
            default: led <= 4'b0000;
        endcase
    else if(key[3] == 1'b0)
        led <= 4'b1111;
    else
        led <= 4'b0000;
end

endmodule
