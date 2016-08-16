# Copyright (C) 2001-2016 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions
# and other software and tools, and its AMPP partner logic
# functions, and any output files from any of the foregoing
# (including device programming or simulation files), and any
# associated documentation or information are expressly subject
# to the terms and conditions of the Intel Program License
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel MegaCore Function License Agreement, or other
# applicable license agreement, including, without limitation,
# that your use is for the sole purpose of programming logic
# devices manufactured by Intel and sold by Intel or its
# authorized distributors.  Please refer to the applicable
# agreement for further details.


# The clock is defined as a 100MHz clock (10ns period)
create_clock -name {clock} -period 10.00 -waveform { 0.00 5.00 } [get_ports {clock}]

# allocating a 1ns flight time for LED control signals on the board
set_output_delay -clock clock 1 [get_ports {led_*_on}]
