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

// This is a Linear Feedback Shift Register that generates 32-bit pseudo-random data

module lfsr (
      input  wire         pr_logic_clk_clk,                 //       pr_logic_clk.clk
      input  wire         sw_reset,
      input  wire         load_seed,
      input  wire [31:0]  seed,
      output reg  [31:0]  rndm_data,
      input  wire         pr_logic_reset_reset_n            //     pr_logic_reset.reset_n
   );

   reg [31:0] data;

   // Ref equation from
   // http://courses.cse.tamu.edu/csce680/walker/lfsr_table.pdf
   always_comb
   begin
      data[31]    = rndm_data[0];
      data[30]    = rndm_data[31];
      data[29]    = ~(rndm_data[30] ^ rndm_data[0]);
      data[28:26] = rndm_data[29:27];
      data[25]    = ~(rndm_data[26] ^ rndm_data[0]);
      data[24]    = ~(rndm_data[25] ^ rndm_data[0]);
      data[23:0]  = rndm_data[24:1];
   end

   always_ff @(posedge pr_logic_clk_clk or negedge pr_logic_reset_reset_n) begin

      // Active low HW reset
      if (  pr_logic_reset_reset_n == 1'b0 ) begin

         rndm_data <= 'b0;

      end
      // Active high SW reset
      else if ( sw_reset == 1'b1 ) begin

         rndm_data <= 'b0;

      end
      else begin

         if ( load_seed == 1'b1 )
            rndm_data <= seed;
         else begin
            rndm_data <= data;
         end

      end
   end

endmodule
