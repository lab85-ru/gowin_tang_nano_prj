//Copyright (C)2014-2020 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.7 Beta
//Created Time: 2020-11-21 23:40:25
create_clock -name CLK_24MHZ -period 41.667 -waveform {0 20.834} [get_ports {i_clk}]
