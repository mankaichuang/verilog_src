#clock
create_clock -period 20.00 -name sys_clk [get_ports sys_clk]
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports sys_clk]
#rst
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]
#key
set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports key]
#beep
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports beep]