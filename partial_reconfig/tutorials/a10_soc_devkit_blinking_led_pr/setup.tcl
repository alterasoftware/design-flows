# (C) 2001-2016 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


###############################################################################
# SETUP CONFIGURTION SCRIPT
###############################################################################
# Define the name of the project.
define_project blinking_led_pr

# Define the base revision name. This revision represents the static
# region of the design
define_base_revision blinking_led_pr

# Define each of the partial reconfiguration implementation revisions
define_pr_revision -impl_rev_name blinking_led_pr_alpha \
	-impl_block [list pr_partition blinking_led]

define_pr_revision -impl_rev_name blinking_led_pr_bravo \
	-impl_block [list pr_partition blinking_slow_led]

define_pr_revision -impl_rev_name blinking_led_pr_charlie \
	-impl_block [list pr_partition blinking_led_empty]
