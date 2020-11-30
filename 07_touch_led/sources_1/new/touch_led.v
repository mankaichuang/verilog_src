//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/11/20 13:33:37
// Module Name: touch_led
// Description: 触摸按键控制led翻转
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module touch_led(
    input           sys_clk,
    input           sys_rst_n,
    input           touch_key,          //触摸按键
    
    output  reg     led                //led
);
    
wire        led_en;                  //上升沿标志 
reg         T0;                         //表示当前信号值
reg         T1;                         //表示上一时刻信号值

assign led_en = (~T1) & T0;          //当前时刻为1，上一时刻为0，为上升沿,
                                     //当led_en为1时表示按键按下了

always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin                //复位时数据清零
        T0 <= 1'b0;
        T1 <= 1'b0;
    end
    else begin
        T0 <= touch_key;
        T1 <= T0;
    end
end

always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)                  //复位时led默认点亮
        led <= 1'b1;
    else if(led_en == 1'b1)
        led <= ~led;                //led反转
    else
        led <= led;
end
endmodule

