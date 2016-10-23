###################################################################

# Created by write_sdc on Thu Sep  8 18:14:15 2016

###################################################################
set sdc_version 1.3

create_clock [get_ports Clk]  -period 2.5  -waveform {0 1.25}
set_max_delay 2.5  -from [list [get_ports Clk] [get_ports Rst]]  -to [get_ports exception]
