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

// This module is used to count number of PASS asserted by ddr_wr_rd module

module perf_cntr (
      input  wire         pr_logic_clk_clk,                 //       pr_logic_clk.clk
      input  wire         sw_reset,
      input  wire         pass,
      output reg [31:0]   performance_cntr,
      input  wire         pr_logic_reset_reset_n            //     pr_logic_reset.reset_n
   );


   always_ff @(posedge pr_logic_clk_clk or negedge pr_logic_reset_reset_n) begin

      // Active low HW reset
      if (  pr_logic_reset_reset_n == 1'b0 ) begin

         performance_cntr <= 'b0;

      end
      // Active high SW reset
      else if (  sw_reset == 1'b1 ) begin

         performance_cntr <= 'b0;

      end
      else begin

         if ( pass == 1'b1 ) begin

            performance_cntr <= performance_cntr + 1;
            
         end

      end
   end

endmodule
