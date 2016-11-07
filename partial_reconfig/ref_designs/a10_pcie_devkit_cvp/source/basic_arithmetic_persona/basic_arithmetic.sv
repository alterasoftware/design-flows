// Copyright (C) 2001-2016 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions
// and other software and tools, and its AMPP partner logic
// functions, and any output files from any of the foregoing
// (including device programming or simulation files), and any
// associated documentation or information are expressly subject
// to the terms and conditions of the Intel Program License
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other
// applicable license agreement, including, without limitation,
// that your use is for the sole purpose of programming logic
// devices manufactured by Intel and sold by Intel or its
// authorized distributors.  Please refer to the applicable
// agreement for further details.


`timescale 1 ps / 1 ps
`default_nettype none
// Basic Arithmetic
// 
// This module conducts the arithmetic operation on the pr_operand and
// increment operand it receives and produces the result.

module basic_arithmetic (
      input  wire         pr_logic_clk_clk,       // pr_logic_clk.clk
      output reg  [31:0]  result,
      input  wire [30:0]  pr_operand,
      input  wire [30:0]  increment,
      input  wire         pr_logic_reset_reset_n  // pr_logic_reset.reset_n
   );
   always_ff @(posedge pr_logic_clk_clk or negedge pr_logic_reset_reset_n) begin
      // Active low HW reset
      if ( pr_logic_reset_reset_n == 1'b0 ) begin

         result <= 'b0;
      
      end
      else begin

         result <= pr_operand + increment;

      end
   end
endmodule
