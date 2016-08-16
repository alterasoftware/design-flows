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


# This SDC is used to constrain a design that includes the Altera PR IP with JTAG
# enabled. Note that when the IP is configured in this way a modification to
# the standard jtag.sdc is required to disable the set_clock_groups exception
# for the altera_reserved_tck JTAG clock

namespace eval pr_ip_timing {
    # Configuration
    ###############################
    # Instance name of the PR IP
    variable pr_ip_inst {u_pr_ip|alt_pr_0}
    # Name of all clocks to exclude from the JTAG clock
    variable pr_ip_jtag_exclude_clocks [list "clock" reg_clock]
    # Name of the PR IP supplied user clock
    variable pr_ip_user_clock {reg_clock}
    # Enable multicycle time on the PR atom. This can ease
    # P2C/C2P timing
    variable pr_ip_enable_multicycle 1
    ###############################

# PR atom timing:
#
# Clk
#   ------    ------    -----     -----
#   |    |    |    |    |    |    |
#        ------    ------    ------
# Neg Clk
#        ------    ------    ------
#   |    |    |    |    |    |    |
#   ------    ------    -----     -----
# enable_dclk_reg  
#             ---------------------
#             |                   |
#   -----------                   ------
# enable_dclk_neg_reg
#                  ---------------------
#                  |                   |
#   ----------------                   -----
# PR Atom CLK (neg_Clk & enable_dclk_reg & enable_dclk_neg_reg)
#                  ------    ------
#                  |    |    |    |
#   ----------------    -----     -----
     
    proc set_pr_ip_constraints {} {
        variable pr_ip_inst
        variable pr_ip_jtag_exclude_clocks
        variable pr_ip_user_clock
        variable pr_ip_enable_multicycle
        
        set pr_ip_reg "${pr_ip_inst}|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|enable_dclk_neg_reg"
        post_message -type info "Constraining PR IP gated clock $pr_ip_reg"
        set pr_ip_reg2 "${pr_ip_inst}|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|enable_dclk_reg"
        post_message -type info "Constraining PR IP gated clock $pr_ip_reg2"
        
        # Make the JTAG clock exclusive to only the clock "clock"
        set_clock_groups -asynchronous -group {altera_reserved_tck} -group $pr_ip_jtag_exclude_clocks
    
        #
        # Create the pr_clk_enable_dclk_neg_reg_jtag_clk derived from altera_reserved_tck
        create_generated_clock -name pr_clk_enable_dclk_neg_reg_jtag_clk -source {altera_reserved_tck} -divide_by 1 -invert $pr_ip_reg
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_neg_reg_jtag_clk} -group $pr_ip_jtag_exclude_clocks
        
        # Create the pr_clk_enable_dclk_neg_reg_user_clk derived from $pr_ip_user_clock
        create_generated_clock -add -name pr_clk_enable_dclk_neg_reg_user_clk -source [get_clock_info -targets [get_clocks $pr_ip_user_clock]] -divide_by 1 -invert $pr_ip_reg
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_neg_reg_user_clk} -group {altera_reserved_tck}
        
        #
        # Create the pr_clk_enable_dclk_reg_jtag_clk derived from altera_reserved_tck
        create_generated_clock -name pr_clk_enable_dclk_reg_jtag_clk -source {altera_reserved_tck} -divide_by 1 $pr_ip_reg2
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg_jtag_clk} -group $pr_ip_jtag_exclude_clocks
        
        # Create the pr_clk_enable_dclk_reg_user_clk derived from $pr_ip_user_clock
        create_generated_clock -add -name pr_clk_enable_dclk_reg_user_clk -source [get_clock_info -targets [get_clocks $pr_ip_user_clock]] -divide_by 1 $pr_ip_reg2
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg_user_clk} -group {altera_reserved_tck}
        
        #######################################################################
        # PR atom outputs
        #######################################################################
        if {$pr_ip_enable_multicycle} {
            # Multicycle the output of the PR atom to core registers      
            set_multicycle_path -from ${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg -to {*} -setup -start 2                                               
            set_multicycle_path -from ${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg -to {*} -hold -start 1
            set_multicycle_path -to ${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg -from {*} -setup -start 2                                               
            set_multicycle_path -to ${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg -from {*} -hold -start 1
        }
    }
    
    proc report_pr_timing {} {
        variable pr_ip_inst
        
        report_timing -from "${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg" -setup -npaths 200 -detail full_path -panel_name "PR IP ${pr_ip_inst}||From pr block (P2C)- setup" -multi_corner
        report_timing -to "${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg" -setup -npaths 200 -detail full_path -panel_name "PR IP ${pr_ip_inst}||To pr block (C2P) - setup" -multi_corner
        report_timing -from "${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg" -hold -npaths 200 -detail full_path -panel_name "PR IP ${pr_ip_inst}||From pr block (P2C)- hold" -multi_corner
        report_timing -to "${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg" -hold -npaths 200 -detail full_path -panel_name "PR IP ${pr_ip_inst}||To pr block (C2P) - hold" -multi_corner
    
    }
}
pr_ip_timing::set_pr_ip_constraints
