`timescale 1ns / 1ps

module tb_led_twinkle();

reg         sys_clk;
reg         sys_rst_n;
wire[1:0]   led;

initial begin
    sys_clk = 0;
    sys_rst_n = 0;
    #200 sys_rst_n = 1;
end

always #10 sys_clk = ~sys_clk;

led_twinkle u_led_twinkle(
    .sys_clk    (sys_clk),
    .sys_rst_n  (sys_rst_n),
    .led        (led)
);

endmodule