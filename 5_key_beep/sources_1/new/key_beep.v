`timescale 1ns / 1ps

module key_beep(
    input           sys_clk,
    input           sys_rst_n,
    input           key,

    output          beep
);

wire keyvalue;
wire keyflag;

key_debounce u_key_debounce(
    .sys_clk            (sys_clk),
    .sys_rst_n          (sys_rst_n),
    .key                (key),

    .keyvalue           (keyvalue),
    .keyflag            (keyflag)

);

beep_ctrl u_beep_ctrl(
    .sys_clk            (sys_clk),
    .sys_rst_n          (sys_rst_n),
    .keyvalue           (keyvalue),
    .keyflag            (keyflag),

    .beep               (beep)

);

endmodule
