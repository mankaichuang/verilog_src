#clock
create_clock -period 20.00 -name sys_clk [get_ports sys_clk]
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports sys_clk]
#rst
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]
#touch_key
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports touch_key]
#led
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports led]