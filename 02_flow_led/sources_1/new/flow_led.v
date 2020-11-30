`timescale 1ns / 1ps

module flow_led(
    input           sys_clk,
    input           sys_rst_n,
    
    output reg[3:0] led    
);

reg[23:0]   cnt;

always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt <= 24'd0;
    else if(cnt < 24'd1000_0000)
        cnt <= cnt + 1'b1;
    else
        cnt <= 24'd0;
end

always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        led <= 4'b0001;
    else if(cnt == 24'd1000_0000)
        led[3:0] <= {led[2:0], led[3]};
    else
        led <= led;
end
endmodule
