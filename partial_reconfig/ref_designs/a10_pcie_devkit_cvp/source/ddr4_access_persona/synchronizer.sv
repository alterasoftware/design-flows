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

// Synchronize one signal originated from a different
// clock domain to the current clock domain.

module synchronizer #(
   parameter WIDTH = 16,
   parameter STAGES = 3 // should not be less than 2
)
(
   input wire clk_in,arst_in,
   input wire clk_out,arst_out,
   
   input wire [WIDTH-1:0] dat_in,
   output reg [WIDTH-1:0] dat_out  
);

// launch register
reg [WIDTH-1:0] d /* synthesis preserve */;
always @(posedge clk_in or posedge arst_in) begin
   if (arst_in) d <= 0;
   else d <= dat_in;
end

// capture registers
reg [STAGES*WIDTH-1:0] c /* synthesis preserve */;
always @(posedge clk_out or posedge arst_out) begin
   if (arst_out) c <= 0;
   else c <= {c[(STAGES-1)*WIDTH-1:0],d};
end

assign dat_out = c[STAGES*WIDTH-1:(STAGES-1)*WIDTH];

endmodule
