//Copyright (C)2014-2022 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.8.07 
//Created Time: 2022-10-19 01:13:27
create_clock -name i_clk -period 20 -waveform {0 10} [get_ports {i_clk}]
