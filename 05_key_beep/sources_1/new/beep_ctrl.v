`timescale 1ns / 1ps

module beep_ctrl(
    input           sys_clk,
    input           sys_rst_n,
    input           keyflag,
    input           keyvalue,
    
    output  reg     beep
);

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        beep <= 1'b0;
    else if(keyflag == 1'b1) begin
        if(keyvalue == 1'b0)
            beep <= 1'b1;
        else
            beep <= 1'b0;
    end
    else
        beep <= beep;    //����beep����Ϊ����֮ǰ��״̬��Ҫ��Ȼbeepֻ����keyflag=1����˲��Ϊ1
end

endmodule
