#set_property PACKAGE_PIN T3 [get_ports {key[3]}]
#set_property PACKAGE_PIN W2 [get_ports {key[2]}]
#set_property PACKAGE_PIN U1 [get_ports {key[1]}]
#set_property PACKAGE_PIN T1 [get_ports {key[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {key[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {key[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {key[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {key[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
#set_property PACKAGE_PIN Y2 [get_ports {led[3]}]
#set_property PACKAGE_PIN V2 [get_ports {led[2]}]
#set_property PACKAGE_PIN R3 [get_ports {led[1]}]
#set_property PACKAGE_PIN R2 [get_ports {led[0]}]
#set_property PACKAGE_PIN R4 [get_ports sys_clk]
#set_property PACKAGE_PIN U2 [get_ports sys_rst_n]
#set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
#set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]

#set_property CFGBVS VCCO [current_design]
#set_property CONFIG_VOLTAGE 3.3 [current_design]
#set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
#set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
#set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]

#clock
create_clock -period 20.00 -name sys_clk [get_ports sys_clk]
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports sys_clk]
#rst
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]
#key
set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports {key[0]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {key[1]}]
set_property -dict {PACKAGE_PIN W2 IOSTANDARD LVCMOS33} [get_ports {key[2]}]
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports {key[3]}]
#led
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN R3 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN Y2 IOSTANDARD LVCMOS33} [get_ports {led[3]}]
#spiflash
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]