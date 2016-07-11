Arria 10 Blinking LED Partial Reconfiguration Tutorial
=================================================================

This readme file accompanies the Arria 10 Blinking LED Partial Reconfiguration Tutorial.

This readme file contains the following information:

*  Arria 10 Blinking LED Partial Reconfiguration Tutorial Contents--lists the contents of this tutorial.
*  Technical Documentation--directs you where to find documentation for Arria 10 Blinking LED Partial Reconfiguration walkthrough.
*  System Requirements--lists the system requirements.

# Arria 10 Blinking LED Partial Reconfiguration Tutorial Contents

*  flat/ - This directory contains the flat version of the reference design. The following are the design files available in this folder:
	* top.sv--top-level file containing the flat implementation of the design.
	* blinking_led.sdc--defines the timing constraints for the project.
	* blinking_led.sv--System Verilog file that causes the LEDs to blink using a 32-bit counter.
	* blinking_led.qpf--Quartus Prime project file containing the base revision information.
	* blinking_led.qsf--Quartus Prime settings file containing the assignments and settings for the project.

*  pr/ - This directory contains the PR version of the reference design. The following are the complete set of files you will be creating with this tutorial:
	* blinking_led.qsf--Quartus Prime settings file containing the assignments and settings for the blinking_led persona.
	* blinking_led.sv--System Verilog file that causes the LEDs to blink using a 32-bit counter.
	* blinking_led_empty.qsf--Quartus Prime project file containing the assignments and settings for blinking_led_empty persona.
	* blinking_led_empty.sv--System Verilog file that causes the LEDs to stay ON.
	* blinking_led_pr.qpf--Quartus Prime project file containing the synthesis revision information for the personas.
	* blinking_led_pr.qsf--Quartus Prime settings file containing the assignments and settings for the PR project.
	* blinking_led_pr.sdc--defines the timing constraints for the PR project.
	* blinking_led_pr_alpha.qsf--Quartus Prime settings file containing the assignments and settings for the blinking_led project.
	* blinking_led_pr_bravo.qsf--Quartus Prime settings file containing the assignments and settings for the blinking_led project.
	* blinking_led_pr_charlie.qsf--Quartus Prime settings file containing the assignments and settings for the blinking_led project.
	* blinking_led_slow.qsf--Quartus Prime project file containing the assignments and settings for blinking_led_slow persona.
	* blinking_led_slow.sv--System Verilog file that causes the LEDs to blink slower.
	* pr_ip.qsys--IP variation file for instantiating PR IP core in the design
	* setup.tcl--contains configuration for the a10_partial_reconfig.tcl flow script   
	* top.sv--top-level file containing the PR implementation of the design.
                 
# Technical Documentation

*  AN-770.pdf Application Note provides information about the reference design, and walks you through partially reconfiguring a flat design.

*  This document is available on the GitHub:
   https://github.com/alterasoftware/design-flows/blob/master/partial_reconfig/tutorials/a10_soc_devkit_blinking_led/AN-770.pdf

# System Requirements

*  Quartus Prime Pro Edition software version 16.0
*  Arria 10 SoC development kit

