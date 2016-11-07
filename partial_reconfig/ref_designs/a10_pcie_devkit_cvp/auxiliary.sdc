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


# set asynchronous clock domains
set_clock_groups -asynchronous -group {u_pcie_subsystem|a10_pcie|a10_pcie|wys~CORE_CLK_OUT} -group {u_mem_ctlr|ddr4a|ddr4a_phy_clk_0 u_mem_ctlr|ddr4a|ddr4a_phy_clk_1 u_mem_ctlr|ddr4a|ddr4a_phy_clk_2 u_mem_ctlr|ddr4a|ddr4a_phy_clk_l_0 u_mem_ctlr|ddr4a|ddr4a_phy_clk_l_1 u_mem_ctlr|ddr4a|ddr4a_phy_clk_l_2 u_mem_ctlr|ddr4a|ddr4a_core_cal_slave_clk} -group {u_iopll|iopll_0|outclk1 u_iopll|iopll_0|outclk_50mhz}

# set false path on the signals crossing the async clock domains
set_false_path -from {u_freeze_wrapper|u_pr_logic|u_synchronizer_cal_success|d[0]} -to {u_freeze_wrapper|u_pr_logic|u_synchronizer_cal_success|c[0]}
set_false_path -from {u_freeze_wrapper|u_pr_logic|u_synchronizer_cal_fail|d[0]} -to {u_freeze_wrapper|u_pr_logic|u_synchronizer_cal_fail|c[0]}
set_false_path -from [get_keepers {u_freeze_wrapper|u_pr_logic|u_rst_blk|ddr4a_global_reset}] -to [get_clocks {u_ddr4_ctlr|*}]
