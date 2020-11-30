`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: mankaichuang
// Create Date: 2020/11/30 11:34:31
// Module Name: ip_ram
// Description: IP�˵�RAM��дʵ��
//
//////////////////////////////////////////////////////////////////////////////////


module ip_ram(
    input           sys_clk,
    input           sys_rst_n    
);

wire            ram_en;         //ʹ��
wire            ram_we;         //��дƬѡ
wire [4:0]      ram_addr;       //��ַ
wire [7:0]      ram_wdata;      //д����
wire [7:0]      ram_rdata;      //������


ram_rw u_ram_rw(
    .sys_clk            (sys_clk),
    .sys_rst_n          (sys_rst_n),

    .ram_en             (ram_en),         
    .ram_we             (ram_we),             
    .ram_addr           (ram_addr),           
    .ram_wdata          (ram_wdata)           
);


blk_mem_gen_0 ip_ram_instance(
  .clka(sys_clk),    // input wire clka
  .ena(ram_en),      // input wire ena
  .wea(ram_we),      // input wire [0 : 0] wea
  .addra(ram_addr),  // input wire [4 : 0] addra
  .dina(ram_wdata),    // input wire [7 : 0] dina
  .douta(ram_rdata)  // output wire [7 : 0] douta
);
endmodule
