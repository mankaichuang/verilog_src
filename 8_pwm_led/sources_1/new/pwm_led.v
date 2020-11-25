//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: 
// Create Date: 2020/11/23 10:05:32
// Module Name: pwm_led
// Description: pwm ctrl led
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module pwm_led(
    input           sys_clk,
    input           sys_rst_n,

    output          led
);

reg[15:0]       period_cnt;
reg[15:0]       duty_cycle;
reg             inc_dec_flag;

//定义一个1ms的定时器
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        period_cnt <= 16'd0;
    else if(period_cnt < 16'd5_0000)
        period_cnt <= period_cnt + 1'b1; 
    else
        period_cnt <= 16'd0;
        
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        duty_cycle <= 16'd0;            
        inc_dec_flag <= 1'b0;
    end
    else begin
        if(period_cnt == 16'd5_0000) begin
            if(inc_dec_flag == 0) begin
                if(duty_cycle == 16'd5_0000)
                    inc_dec_flag <= ~inc_dec_flag;
                else
                    duty_cycle <= duty_cycle + 5'd25;
            end 
            else begin
                if(duty_cycle == 16'd0)
                    inc_dec_flag <= ~inc_dec_flag;
                else
                    duty_cycle <= duty_cycle - 5'd25;
            end
        end    
    end 
end

assign led = (period_cnt >= duty_cycle) ? 1'b1 : 1'b0;

endmodule
