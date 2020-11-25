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
        beep <= beep;    //这里beep必须为保留之前的状态，要不然beep只有在keyflag=1的那瞬间为1
end

endmodule
