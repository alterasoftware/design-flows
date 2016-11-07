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


derive_pll_clocks -create_base_clocks

#set_clock_groups -asynchronous -group {u_pcie_subsystem|a10_pcie|a10_pcie|wys~CORE_CLK_OUT} -group {u_mem_ctlr|ddr4a|ddr4a_*_clk*}
#set_clock_groups -asynchronous -group {u_mem_ctlr|ddr4a|ddr4a_*_clk*} -group {u_iopll|iopll_0|outclk1}

if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[0]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[0]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[1]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[1]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[2]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[2]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[3]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[3]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[4]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[4]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[5]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[5]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[6]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[6]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[7]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[7]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[8]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[8]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[9]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[9]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[10]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[10]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[11]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[11]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[12]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[12]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[13]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[13]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[14]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[14]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[15]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[15]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[16]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[16]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[17]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[17]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[18]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[18]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[19]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[19]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[20]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[20]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[21]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[21]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[22]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[22]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[23]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[23]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[24]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[24]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[25]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[25]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[26]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[26]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[27]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[27]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[28]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[28]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[29]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[29]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[30]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[30]}] -to *
}
if { [ get_collection_size [get_registers -nocase -nowarn {*altpcie_test_in_static_signal_to_be_false_path[31]}]] > 0 } {
   set_false_path -from [get_registers {*altpcie_test_in_static_signal_to_be_false_path[31]}] -to *
}
if { [ get_collection_size [get_ports -nocase -nowarn {*board_pins_lane_active_led[0]}]] > 0 } {
   set_false_path  -from * -to [get_ports {*board_pins_lane_active_led[0]}] 
}
if { [ get_collection_size [get_ports -nocase -nowarn {*board_pins_lane_active_led[1]}]] > 0 } {
   set_false_path  -from * -to [get_ports {*board_pins_lane_active_led[1]}] 
}
if { [ get_collection_size [get_ports -nocase -nowarn {*board_pins_lane_active_led[2]}]] > 0 } {
   set_false_path  -from * -to [get_ports {*board_pins_lane_active_led[2]}] 
}
if { [ get_collection_size [get_ports -nocase -nowarn {*board_pins_lane_active_led[3]}]] > 0 } {
   set_false_path  -from * -to [get_ports {*board_pins_lane_active_led[3]}] 
}
if { [ get_collection_size [get_ports -nocase -nowarn {*board_pins_gen2_led}]] > 0 } {
   set_false_path  -from * -to [get_ports {*board_pins_gen2_led}] 
}
if { [ get_collection_size [get_ports -nocase -nowarn {*board_pins_gen3_led}]] > 0 } {
   set_false_path  -from * -to [get_ports {*board_pins_gen3_led}] 
}
if { [ get_collection_size [get_ports -nocase -nowarn {*board_pins_L0_led}]] > 0 } {
   set_false_path  -from * -to [get_ports {*board_pins_L0_led}] 
}
if { [ get_collection_size [get_ports -nocase -nowarn {*board_pins_alive_led}]] > 0 } {
   set_false_path  -from * -to [get_ports {*board_pins_alive_led}] 
}
if { [ get_collection_size [get_ports -nocase -nowarn {*board_pins_comp_led}]] > 0 } {
   set_false_path  -from * -to [get_ports {*board_pins_comp_led}] 
}
if { [ get_collection_size [get_ports -nocase -nowarn {*board_pins_req_compliance_pb}]] > 0 } {
   set_false_path -from [get_ports {*board_pins_req_compliance_pb}] -to *
}
if { [ get_collection_size [get_ports -nocase -nowarn {*board_pins_set_compliance_mode}]] > 0 } {
   set_false_path -from [get_ports {*board_pins_set_compliance_mode}] -to *
}
if { [ get_collection_size [get_ports -nocase -nowarn {*hip_ctrl_*}]] > 0 } {
   set_false_path -from [get_ports {*hip_ctrl_*}] -to *
}
if { [ get_collection_size [get_ports -nocase -nowarn {*pcie_rstn_pin_perst}]] > 0 } {
   set_false_path -from [get_ports {*pcie_rstn_pin_perst}] -to *
}
if { [ get_collection_size [get_ports -nocase -nowarn {*pcie_rstn_npor}]] > 0 } {
   set_false_path -from [get_ports {*pcie_rstn_npor}] -to *
}
if { [ get_collection_size [get_ports -nocase -nowarn {*pipe_sim_only*ltssmstate[*]}]] > 0 } {
   set_false_path  -from * -to [get_ports {*pipe_sim_only*ltssmstate[*]}] 
}
