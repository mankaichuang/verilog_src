//////////////////////////////////////////////////////////////////////////////////
//
// Engineer: mankaichuang 
// Create Date: 2020/11/25 14:13:56
// Module Name: top_seg_led 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module top_seg_led(
    input               sys_clk,
    input               sys_rst_n,
    input[3:0]          key,

    output[5:0]         seg_cs,
    output[7:0]         seg_led
);

wire[3:0]   keyvalue;
wire        keyflag;

wire[5:0]   point;
wire        cnt_flag;
wire        seg_en;
wire        seg_sign;  

wire[19:0]  data;

key_debounce u_key_debounce(
    .sys_clk        (sys_clk),            
    .sys_rst_n      (sys_rst_n),          
    .key            (key),           
    
    .keyvalue       (keyvalue),           
    .keyflag        (keyflag)             
);

key u_key(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    .keyvalue       (keyvalue),
    .keyflag        (keyflag),

    .point          (point),   
    .cnt_flag       (cnt_flag),   
    .seg_en         (seg_en),   
    .seg_sign       (seg_sign)  
);

data_value u_data_value(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    .cnt_flag       (cnt_flag),

    .data           (data)           
);

seg_led_driver u_seg_led_driver(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    .point          (point),  
    .seg_en         (seg_en),           
    .seg_sign       (seg_sign),        
    .data           (data),                         

    .seg_cs         (seg_cs),
    .seg_led        (seg_led)
);
  

endmodule
