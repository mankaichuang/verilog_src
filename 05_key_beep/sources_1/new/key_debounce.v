`timescale 1ns / 1ps

module key_debounce(
    input           sys_clk,
    input           sys_rst_n,
    input           key,
    
    output reg      keyvalue,
    output reg      keyflag
);

reg[19:0]           cnt;
reg                 key_reg;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        key_reg <= 1'b1;
        cnt <= 20'd0;
    end
    else begin
        if(key_reg != key) begin        //如果key值变化了
            cnt <=  20'd100_0000;       //设置计数初始值
//        cnt <=  20'd4;                //仅仿真时候使用
            key_reg <= key;             //保存当前key值
        end 
        else begin                      //如果key值保持
            if(cnt > 20'd0)             //判断现在有没有准备计数
                cnt <= cnt - 1'b1;      //开始计数
            else
                cnt <= 20'd0;
        end
   end        
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        keyvalue <= 1'b1;
        keyflag  <= 1'b0;
    end
    else if(cnt == 20'd1) begin         //按键状态持续20ms
        keyflag  <= 1'b1;               //按键消抖完成
        keyvalue <= key;                //当前的按键值
    end
    else begin
        keyflag  <= 1'b0;
        keyvalue <= keyvalue;
    end    
end
endmodule
