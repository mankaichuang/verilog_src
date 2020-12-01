`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer:  mankaichuang
// Create Date: 2020/12/01 11:21:44
// Module Name: ip_fifo
// Description: fifo¶¥²ãÄ£¿é
// 
//////////////////////////////////////////////////////////////////////////////////


module ip_fifo(
    input           sys_clk,
    input           sys_rst_n
);

wire almost_full;
wire almost_empty;
wire fifo_wr_en;
wire fifo_rd_en;
wire[7:0] fifo_wdata;
wire[7:0] fifo_rdata;


fifo_write u_fifo_write(
    .sys_clk            (sys_clk),
    .sys_rst_n          (sys_rst_n),

    .almost_full        (almost_full),
    .almost_empty       (almost_empty),

    .fifo_wr_en         (fifo_wr_en),     
    .fifo_wdata         (fifo_wdata)
);

fifo_read u_fifo_read(
    .sys_clk            (sys_clk),
    .sys_rst_n          (sys_rst_n),

    .almost_full        (almost_full),
    .almost_empty       (almost_empty),
    .fifo_rdata         (fifo_rdata),

    .fifo_rd_en         (fifo_rd_en)     
);


fifo_generator_0 fifo_instance (
  .wr_clk(sys_clk),                // input wire wr_clk
  .rd_clk(sys_clk),                // input wire rd_clk
  .din(fifo_wdata),                      // input wire [7 : 0] din
  .wr_en(fifo_wr_en),                  // input wire wr_en
  .rd_en(fifo_rd_en),                  // input wire rd_en
  .dout(fifo_rdata),                    // output wire [7 : 0] dout
  .full(full),                    // output wire full
  .almost_full(almost_full),      // output wire almost_full
  .empty(empty),                  // output wire empty
  .almost_empty(almost_empty),    // output wire almost_empty
  .rd_data_count(rd_data_count),  // output wire [7 : 0] rd_data_count
  .wr_data_count(wr_data_count)  // output wire [7 : 0] wr_data_count
);

endmodule
