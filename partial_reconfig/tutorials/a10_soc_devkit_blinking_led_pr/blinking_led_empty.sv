// (C) 2001-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


///////////////////////////////////////////////////////////
// blinking_led_empty.v
// a persona to drive LEDs ON
///////////////////////////////////////////////////////////
`timescale 1 ps / 1 ps
`default_nettype none

module blinking_led_empty (

    // Control signals for the LEDs
    led_two_on,
    led_three_on,

    // clock
    clock
);

    // Control signal to turn LED 'on'
    output  wire    led_two_on;
    output  wire    led_three_on;

    // clock
    input   wire    clock;

    // LED is active low
    assign  led_two_on    = 1'b0;
    assign  led_three_on  = 1'b0;

endmodule
