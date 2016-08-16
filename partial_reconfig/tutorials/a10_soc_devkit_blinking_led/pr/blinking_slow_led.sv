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


///////////////////////////////////////////////////////////
// blinking_slow_led.v
// a simple design to get LEDs blink using a 32-bit counter
///////////////////////////////////////////////////////////
`timescale 1 ps / 1 ps
`default_nettype none

module blinking_slow_led (

    // Control signals for the LEDs
    led_two_on,
    led_three_on,

    // clock 
    clock
);

    // assuming single bit control signal to turn LED 'on'
    output  wire   led_two_on;
    output  wire   led_three_on;

    // clock 
    input   wire    clock;

    // the 32-bit counter
    reg      [31:0] count;

    localparam COUNTER_TAP = 27;

    // The counter:
    always_ff @(posedge clock)
    begin
        count <= count + 1;
    end

   assign  led_two_on    = count[COUNTER_TAP];
   assign  led_three_on  = ~count[COUNTER_TAP];

endmodule
