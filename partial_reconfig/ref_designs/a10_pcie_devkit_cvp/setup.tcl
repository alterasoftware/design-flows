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


# Define the name of the project.
define_project a10_pcie_devkit_cvp

# Define the base revision name. This revision represents the static
# region of the design
define_base_revision a10_pcie_devkit_cvp

# Define each of the partial reconfiguration implementation revisions
define_pr_impl_partition -impl_rev_name a10_pcie_devkit_cvp_ddr4_access \
	-partition_name pr_partition \
    -source_rev_name  ddr4_access

define_pr_impl_partition -impl_rev_name a10_pcie_devkit_cvp_register_file \
	-partition_name pr_partition \
    -source_rev_name  register_file

define_pr_impl_partition -impl_rev_name a10_pcie_devkit_cvp_basic_arithmetic \
    -partition_name pr_partition \
    -source_rev_name  basic_arithmetic

define_pr_impl_partition -impl_rev_name pr_example_template_impl \
    -partition_name pr_partition \
    -source_rev_name  pr_example_template_synth
