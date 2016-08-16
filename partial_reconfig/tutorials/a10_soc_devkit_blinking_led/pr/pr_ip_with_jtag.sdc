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

# PR clock mux timing:
#
# Clk
#   ------    ------    -----     -----
#   |    |    |    |    |    |    |
#        ------    ------    ------
# Neg Clk
#        ------    ------    ------
#   |    |    |    |    |    |    |
#   ------    ------    -----     -----
# ena_r2
#                  ---------------------
#                  |                   |
#   ----------------                   -----
# Clock Mux output
#                       ------    ------
#                       |    |    |    |
#   ---------------------    -----     -----

     
    proc set_pr_ip_constraints {} {
        variable pr_ip_inst
        variable pr_ip_jtag_exclude_clocks
        variable pr_ip_user_clock
        variable pr_ip_enable_multicycle
        
        set pr_ip_reg "${pr_ip_inst}|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|enable_dclk_neg_reg"
        post_message -type info "Constraining PR IP gated clock $pr_ip_reg"
        set pr_ip_reg2 "${pr_ip_inst}|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|enable_dclk_reg"
        post_message -type info "Constraining PR IP gated clock $pr_ip_reg2"

        set pr_ip_jtag_clk_mux_reg "${pr_ip_inst}|pr_jtag_clk_mux|ena_r2[1]"
        post_message -type info "Constraining PR IP JTAG clock mux $pr_ip_jtag_clk_mux_reg"
        set pr_ip_user_clk_mux_reg "${pr_ip_inst}|pr_jtag_clk_mux|ena_r2[0]"
        post_message -type info "Constraining PR IP User clock mux $pr_ip_user_clk_mux_reg"

        # Make the JTAG clock exclusive to only the named clocks
        set_clock_groups -asynchronous -group {altera_reserved_tck} -group $pr_ip_jtag_exclude_clocks
    
        
        #######################################################################
        # Create the pr_jtag_clk_mux generated clocks
        #######################################################################
        # JTAG Clock
        create_generated_clock -name pr_clk_pr_clk_mux_jtag_clk -source {altera_reserved_tck} -divide_by 1 -invert $pr_ip_jtag_clk_mux_reg
        set_clock_groups -asynchronous -group {pr_clk_pr_clk_mux_jtag_clk} -group $pr_ip_jtag_exclude_clocks
    
        # User Clock
        create_generated_clock -name pr_clk_pr_clk_mux_user_clk -source [get_clock_info -targets [get_clocks $pr_ip_user_clock]] -divide_by 1 -invert $pr_ip_user_clk_mux_reg
        set_clock_groups -asynchronous -group {pr_clk_pr_clk_mux_user_clk} -group {altera_reserved_tck}
        set_clock_groups -asynchronous -group {pr_clk_pr_clk_mux_user_clk} -group {pr_clk_pr_clk_mux_jtag_clk}
    
        #######################################################################
        #######################################################################
        # Create the enable_dclk_neg_reg generated clocks
        #######################################################################
        # JTAG Clock
        create_generated_clock -name pr_clk_enable_dclk_neg_reg_jtag_clk -source {altera_reserved_tck} -divide_by 1 -invert $pr_ip_reg
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_neg_reg_jtag_clk} -group $pr_ip_jtag_exclude_clocks
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_neg_reg_jtag_clk} -group {pr_clk_pr_clk_mux_user_clk}
        
        # pr_clk_pr_clk_mux_jtag_clk Clock
        create_generated_clock -add -name pr_clk_enable_dclk_neg_reg_jtag_mux_clk -source [get_clock_info -targets [get_clocks pr_clk_pr_clk_mux_jtag_clk]] -divide_by 1 -invert $pr_ip_reg
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_neg_reg_jtag_mux_clk} -group $pr_ip_jtag_exclude_clocks
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_neg_reg_jtag_mux_clk} -group {pr_clk_pr_clk_mux_user_clk}

        # User Clock
        create_generated_clock -add -name pr_clk_enable_dclk_neg_reg_user_clk -source [get_clock_info -targets [get_clocks $pr_ip_user_clock]] -divide_by 1 -invert $pr_ip_reg
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_neg_reg_user_clk} -group {altera_reserved_tck}
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_neg_reg_user_clk} -group {pr_clk_pr_clk_mux_jtag_clk}
                
        # pr_clk_pr_clk_mux_user_clk Clock
        create_generated_clock -add -name pr_clk_enable_dclk_neg_reg_user_mux_clk -source [get_clock_info -targets [get_clocks pr_clk_pr_clk_mux_user_clk]] -divide_by 1 -invert $pr_ip_reg
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_neg_reg_user_mux_clk} -group {altera_reserved_tck}
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_neg_reg_user_mux_clk} -group {pr_clk_pr_clk_mux_jtag_clk}
        
        
        #######################################################################
        # Create the enable_dclk_reg generated clocks
        #######################################################################
        # JTAG Clock
        create_generated_clock -name pr_clk_enable_dclk_reg_jtag_clk -source {altera_reserved_tck} -divide_by 1 $pr_ip_reg2
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg_jtag_clk} -group $pr_ip_jtag_exclude_clocks
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg_jtag_clk} -group {pr_clk_pr_clk_mux_user_clk}
        
        # pr_clk_pr_clk_mux_jtag_clk Clock
        create_generated_clock -add -name pr_clk_enable_dclk_reg_jtag_mux_clk -source [get_clock_info -targets [get_clocks pr_clk_pr_clk_mux_jtag_clk]] -divide_by 1 $pr_ip_reg2
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg_jtag_mux_clk} -group $pr_ip_jtag_exclude_clocks
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg_jtag_mux_clk} -group {pr_clk_pr_clk_mux_user_clk}

        # User Clock
        create_generated_clock -add -name pr_clk_enable_dclk_reg_user_clk -source [get_clock_info -targets [get_clocks $pr_ip_user_clock]] -divide_by 1 $pr_ip_reg2
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg_user_clk} -group {altera_reserved_tck}
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg_user_clk} -group {pr_clk_pr_clk_mux_jtag_clk}
        
        # pr_clk_enable_dclk_reg_user_mux_clk Clock
        create_generated_clock -add -name pr_clk_enable_dclk_reg_user_mux_clk -source [get_clock_info -targets [get_clocks pr_clk_pr_clk_mux_user_clk]] -divide_by 1 $pr_ip_reg2
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg_user_mux_clk} -group {altera_reserved_tck}
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg_user_mux_clk} -group {pr_clk_pr_clk_mux_jtag_clk}
    
        #######################################################################
        # Multicycles between generated clocks and clocks
        #######################################################################
        # The generated clock to the clock mux transfers are 1.5 cycles. Achieve this using a multicycle of 2 since the
        # first 0.5 cycle is take my the clock inversion
        set_multicycle_path -to [get_clocks {pr_clk_pr_clk_mux_jtag_clk}] -from [get_clocks {altera_reserved_tck}] -setup 2
        set_multicycle_path -to [get_clocks {pr_clk_pr_clk_mux_jtag_clk}] -from [get_clocks {altera_reserved_tck}] -hold 1
        
        set_multicycle_path -from [get_clocks {pr_clk_pr_clk_mux_jtag_clk}] -to [get_clocks {altera_reserved_tck}] -setup 2
        set_multicycle_path -from [get_clocks {pr_clk_pr_clk_mux_jtag_clk}] -to [get_clocks {altera_reserved_tck}] -hold 1

        set_multicycle_path -to [get_clocks pr_clk_pr_clk_mux_user_clk] -from [get_clocks [list $pr_ip_user_clock]] -setup 2
        set_multicycle_path -to [get_clocks pr_clk_pr_clk_mux_user_clk] -from [get_clocks [list $pr_ip_user_clock]] -hold 1
        
        set_multicycle_path -from [get_clocks pr_clk_pr_clk_mux_user_clk] -to [get_clocks [list $pr_ip_user_clock]] -setup 2
        set_multicycle_path -from [get_clocks pr_clk_pr_clk_mux_user_clk] -to [get_clocks [list $pr_ip_user_clock]] -hold 1

        # Multicycle the paths $pr_ip_reg->$pr_ip_reg where the source and dest clock are different to reduce their criticality
        # siand increase slack since these are not real paths
        set_multicycle_path -from [get_clocks {pr_clk_enable_dclk_reg_user_mux_clk}] -to [get_clocks {clock}] -setup -end -through $pr_ip_reg2 2
        set_multicycle_path -from [get_clocks {pr_clk_enable_dclk_reg_user_mux_clk}] -to [get_clocks {clock}] -hold -end -through $pr_ip_reg2 1
        set_multicycle_path -from [get_clocks {pr_clk_enable_dclk_reg_user_clk}] -to [get_clocks {clock}] -setup -end -through $pr_ip_reg2 2
        set_multicycle_path -from [get_clocks {pr_clk_enable_dclk_reg_user_clk}] -to [get_clocks {clock}] -hold -end -through $pr_ip_reg2 1
        set_multicycle_path -from [get_clocks {pr_clk_enable_dclk_reg_user_mux_clk}] -to [get_clocks {pr_clk_pr_clk_mux_user_clk}] -setup -end -through $pr_ip_reg2 2
        set_multicycle_path -from [get_clocks {pr_clk_enable_dclk_reg_user_mux_clk}] -to [get_clocks {pr_clk_pr_clk_mux_user_clk}] -hold -end -through $pr_ip_reg2 1
        set_multicycle_path -from [get_clocks {pr_clk_enable_dclk_reg_user_clk}] -to [get_clocks {pr_clk_pr_clk_mux_user_clk}] -setup -end -through $pr_ip_reg2 2
        set_multicycle_path -from [get_clocks {pr_clk_enable_dclk_reg_user_clk}] -to [get_clocks {pr_clk_pr_clk_mux_user_clk}] -hold -end -through $pr_ip_reg2 1

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
