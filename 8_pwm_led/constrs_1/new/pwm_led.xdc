#clock
create_clock -period 20.00 -name sys_clk [get_ports sys_clk]
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports sys_clk]
#rst
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]
#led
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports led]