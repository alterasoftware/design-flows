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


////////////////////////////////////////////////////////////////////////////
// top.v
// a simple design to get LEDs blink using a 32-bit counter
//
// Some of the lines of code are commented out. They are not
// needed since this is the flat implementation of the design
//
// As the accompanied application note document explains, the commented lines
// would be needed as the design implementation migrates from flat to
// Partial-Reconfiguration (PR) mode
////////////////////////////////////////////////////////////////////////////
`timescale 1 ps / 1 ps
`default_nettype none

module top (

    ////////////////////////////////////////////////////////////////////////
    // Control signals for the LEDs
    ////////////////////////////////////////////////////////////////////////
    led_zero_on,
    led_one_on,
    led_two_on,
    led_three_on,

    ////////////////////////////////////////////////////////////////////////
    // clock
    ////////////////////////////////////////////////////////////////////////
    clock
);

    ////////////////////////////////////////////////////////////////////////
    // assuming single bit control signal to turn LED 'on'
    ////////////////////////////////////////////////////////////////////////
    output  reg   led_zero_on;
    output  reg   led_one_on;
    output  reg   led_two_on;
    output  reg   led_three_on;

    ////////////////////////////////////////////////////////////////////////
    // clock
    ////////////////////////////////////////////////////////////////////////
    input   wire    clock;

    localparam COUNTER_TAP = 24;

    ////////////////////////////////////////////////////////////////////////
    // the 32-bit counter
    ////////////////////////////////////////////////////////////////////////
    reg      [31:0] count;

    ////////////////////////////////////////////////////////////////////////
    // wire declarations
    ////////////////////////////////////////////////////////////////////////
    wire            freeze;          // freeze is not used until design is changed to PR
    wire      [2:0] pr_ip_status;
    wire            pr_led_two_on;
    wire            pr_led_three_on;

    wire            led_zero_on_w;
    wire            led_one_on_w;
    wire            led_two_on_w;
    wire            led_three_on_w;

    ////////////////////////////////////////////////////////////////////////
    // The counter:
    ////////////////////////////////////////////////////////////////////////
    always_ff @(posedge clock)
    begin
        count <= count + 1;
    end
  
    ////////////////////////////////////////////////////////////////////////
    // Register the LED outputs
    ////////////////////////////////////////////////////////////////////////
    always_ff @(posedge clock)
    begin
          led_zero_on <= led_zero_on_w;
		  led_one_on <= led_one_on_w;
		  led_two_on <= led_two_on_w;
		  led_three_on <= led_three_on_w;
    end

    ////////////////////////////////////////////////////////////////////////
    // driving LEDs to show PR as the rest of logic is running
    ////////////////////////////////////////////////////////////////////////
    assign  led_zero_on_w   = count[COUNTER_TAP];
    assign  led_one_on_w    = count[COUNTER_TAP];

    ////////////////////////////////////////////////////////////////////////
    // When moving from flat design to PR the following two
    // lines of assign statements need to be used.  
    // User needs to uncomment them.
    //
    // The output ports driven by PR logic need to stablized
    // during PR reprograming.  Using "freeze" control signal,
    // from PR IP, to drive these output to logic 1 during
    // reconfiguration. The logic 1 is chosen because LED is active low.
    ////////////////////////////////////////////////////////////////////////
    // The following line is used in PR implementation
//  assign led_two_on_w    = freeze ? 1'b1 : pr_led_two_on;
    
    // The following line is used in PR implementation
//  assign led_three_on_w  = freeze ? 1'b1 : pr_led_three_on;

    ////////////////////////////////////////////////////////////////////////
    // instance of the default persona
    ////////////////////////////////////////////////////////////////////////
    blinking_led u_blinking_led
    (
        .led_two_on    (led_two_on_w),       // used in flat implementation
//      .led_two_on    (pr_led_two_on),    // used in PR implementation

        .led_three_on  (led_three_on_w),     // used in flat implementation
//      .led_three_on  (pr_led_three_on),  // used in PR implementation

        .clock         (clock)
    );

//  ////////////////////////////////////////////////////////////////////////
//  // when moving from flat design to PR then the following
//  // pr_ip needs to be instantiated in order to be able to
//  // partially reconfigure the design.
//  // 
//  // This tutorial implements PR over JTAG
//  ////////////////////////////////////////////////////////////////////////
//  pr_ip u_pr_ip
//  (
//      .clk           (clock),
//      .nreset        (1'b1),
//      .freeze        (freeze),
//      .double_pr     (1'b0),            // ignored for JTAG
//      .pr_start      (1'b0),            // ignored for JTAG
//      .status        (pr_ip_status),
//      .data          (16'b0),
//      .data_valid    (1'b0),
//      .data_ready    ()
//  );

endmodule
