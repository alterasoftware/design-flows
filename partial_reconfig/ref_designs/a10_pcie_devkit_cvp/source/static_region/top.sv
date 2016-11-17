// Copyright (c) 2001-2016 Intel Corporation
//  
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//  
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//  
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

`timescale 1 ps / 1 ps
`default_nettype none

// This is the top module of the design where major sub-system are instantiated:
// 1. IOPLL
// 2. Freeze_wrapper that includes PR Logic
// 3. mem_ctlr that includes EMIF
// 4. pcie_subsystem
//
module top (
   output wire        board_pins_L0_led,              //    board_pins.L0_led
   output wire        board_pins_alive_led,           //              .alive_led
   output wire        board_pins_comp_led,            //              .comp_led
   input  wire        board_pins_free_clk,            //              .free_clk
   output wire        board_pins_gen2_led,            //              .gen2_led
   output wire        board_pins_gen3_led,            //              .gen3_led
   output wire [3:0]  board_pins_lane_active_led,     //              .lane_active_led
   input  wire        board_pins_req_compliance_pb,   //              .req_compliance_pb
   input  wire        board_pins_set_compliance_mode, //              .set_compliance_mode
   input  wire        config_clk_clk,                 //    config_clk.clk
   input  wire        pcie_rstn_npor,                 //     pcie_rstn.npor
   input  wire        pcie_rstn_pin_perst,            //              .pin_perst


   // DDR4
   input  wire        pll_ref_clk,                    // reference clock for the DDR Memory PLL
   input  wire        oct_rzqin,
   output wire [1:0]  mem_ba,
   output wire [0:0]  mem_bg,
   output wire [0:0]  mem_cke,
   output wire [0:0]  mem_ck,
   output wire [0:0]  mem_ck_n,
   output wire [0:0]  mem_cs_n,
   output wire [0:0]  mem_reset_n,
   output wire [0:0]  mem_odt,
   output wire [0:0]  mem_act_n,
   output wire [16:0] mem_a,
   inout  wire [63:0] mem_dq,
   output wire [0:0]  mem_par,
   input  wire [0:0]  mem_alert_n,
   inout  wire [7:0]  mem_dqs,
   inout  wire [7:0]  mem_dqs_n,
   inout  wire [7:0]  mem_dbi_n,


   // PCIe 
   input  wire        ref_clk_clk,                    //        refclk.clk
   input  wire        xcvr_rx_in0,                    //          xcvr.rx_in0
   input  wire        xcvr_rx_in1,                    //              .rx_in1
   input  wire        xcvr_rx_in2,                    //              .rx_in2
   input  wire        xcvr_rx_in3,                    //              .rx_in3
   input  wire        xcvr_rx_in4,                    //              .rx_in4
   input  wire        xcvr_rx_in5,                    //              .rx_in5
   input  wire        xcvr_rx_in6,                    //              .rx_in6
   input  wire        xcvr_rx_in7,                    //              .rx_in7
   output wire        xcvr_tx_out0,                   //              .tx_out0
   output wire        xcvr_tx_out1,                   //              .tx_out1
   output wire        xcvr_tx_out2,                   //              .tx_out2
   output wire        xcvr_tx_out3,                   //              .tx_out3
   output wire        xcvr_tx_out4,                   //              .tx_out4
   output wire        xcvr_tx_out5,                   //              .tx_out5
   output wire        xcvr_tx_out6,                   //              .tx_out6
   output wire        xcvr_tx_out7                    //              .tx_out7
   );

   wire         alt_pr_freeze_freeze;
   wire         pr_logic_clk_clk;
   wire         pr_logic_cra_waitrequest;
   wire [31:0]  pr_logic_cra_readdata;
   wire         pr_logic_cra_readdatavalid;
   wire [0:0]   pr_logic_cra_burstcount;
   wire [31:0]  pr_logic_cra_writedata;
   wire [13:0]  pr_logic_cra_address;
   wire         pr_logic_cra_write;
   wire         pr_logic_cra_read;
   wire [3:0]   pr_logic_cra_byteenable;
   wire         pr_logic_cra_debugaccess;
   wire         pr_logic_reset_reset_n;
   wire         iopll_locked;
   wire         clock_250mhz_clk;
   wire         alt_pr_50mhz_clk;
   wire  [63:0] pcie_dma_wr_master_address;
   wire         pcie_dma_wr_master_read;
   wire   [4:0] pcie_dma_wr_master_burstcount;
   wire         pr_logic_mm_waitrequest;
   wire [511:0] pr_logic_mm_readdata;
   wire         pr_logic_mm_readdatavalid;
   wire [4:0]   pr_logic_mm_burstcount;
   wire [511:0] pr_logic_mm_writedata;
   wire [30:0]  pr_logic_mm_address;
   wire         pr_logic_mm_write;
   wire         pr_logic_mm_read;
   wire [63:0]  pr_logic_mm_byteenable;
   wire         pr_logic_mm_debugaccess;
   wire         local_cal_success;
   wire         local_cal_fail;
   wire         emif_out_clk;
   wire         emif_out_reset;
   wire         ddr4a_global_reset;
   wire         pr_logic_reset;
   

   // the iopll generates 50MHz and 250MHz clocks for PR IP logic
   iopll u_iopll(
      .locked                                     ( iopll_locked ),
      .outclk_0                                   ( alt_pr_50mhz_clk ),
      .outclk_1                                   ( clock_250mhz_clk ),
      .refclk                                     ( config_clk_clk ),
      .rst                                        ( ~pr_logic_reset_reset_n )
   );

   // freeze_wrapper handles stablizing pr_logic output ports dring PR by using
   // alt_pr_freeze_freeze control signal
   freeze_wrapper u_freeze_wrapper (
      .alt_pr_freeze_freeze                       ( alt_pr_freeze_freeze ),          // 
      .pr_logic_clk_clk                           ( clock_250mhz_clk ),              // pr_logic_clk.clk
      .iopll_locked                               ( iopll_locked ),

      // DDR4 interface
      .pr_logic_mm_waitrequest                    ( pr_logic_mm_waitrequest ),       // pr_logic_mm_s0.waitrequest
      .pr_logic_mm_readdata                       ( pr_logic_mm_readdata ),          //     .readdata
      .pr_logic_mm_readdatavalid                  ( pr_logic_mm_readdatavalid ),     //     .readdatavalid
      .pr_logic_mm_burstcount                     ( pr_logic_mm_burstcount ),        //     .burstcount
      .pr_logic_mm_writedata                      ( pr_logic_mm_writedata ),         //     .writedata
      .pr_logic_mm_address                        ( pr_logic_mm_address ),           //     .address
      .pr_logic_mm_write                          ( pr_logic_mm_write ),             //     .write
      .pr_logic_mm_read                           ( pr_logic_mm_read ),              //     .read
      .pr_logic_mm_byteenable                     ( pr_logic_mm_byteenable ),        //     .byteenable
      .pr_logic_mm_debugaccess                    ( pr_logic_mm_debugaccess ),       //     .debugaccess
      .local_cal_success                          ( local_cal_success ),
      .local_cal_fail                             ( local_cal_fail ),
      .emif_out_clk                               ( emif_out_clk ),                  //    emif_out_clk.clk
      .emif_out_reset                             ( emif_out_reset ),                //  emif_out_reset.reset
      .ddr4a_global_reset                         ( ddr4a_global_reset ),
      .pr_logic_reset                             ( pr_logic_reset ),

       // PCIe interface
      .pr_logic_cra_waitrequest                   ( pr_logic_cra_waitrequest ),      // pr_logic_cra.waitrequest (hold to 1 during freeze)
      .pr_logic_cra_readdata                      ( pr_logic_cra_readdata ),         //             .readdata
      .pr_logic_cra_readdatavalid                 ( pr_logic_cra_readdatavalid ),    //             .readdatavalid (hold to 0 during freeze)
      .pr_logic_cra_burstcount                    ( pr_logic_cra_burstcount ),       //             .burstcount
      .pr_logic_cra_writedata                     ( pr_logic_cra_writedata ),        //             .writedata
      .pr_logic_cra_address                       ( pr_logic_cra_address ),          //             .address
      .pr_logic_cra_write                         ( pr_logic_cra_write ),            //             .write
      .pr_logic_cra_read                          ( pr_logic_cra_read ),             //             .read
      .pr_logic_cra_byteenable                    ( pr_logic_cra_byteenable ),       //             .byteenable
      .pr_logic_cra_debugaccess                   ( pr_logic_cra_debugaccess ),      //             .debugaccess
      .pr_logic_reset_reset_n                     ( pr_logic_reset_reset_n )         // pr_logic_reset.reset_n
   );
   ddr4_ctlr u_ddr4_ctlr (
      .ddr4_global_reset_reset_sink_reset              ( ddr4a_global_reset ),         // ddr4a_global_reset_reset_sink.reset_n
      .ddr4_mem_conduit_end_1_mem_ck                   ( mem_ck ),                     //         ddr4a_mem_conduit_end.mem_ck
      .ddr4_mem_conduit_end_1_mem_ck_n                 ( mem_ck_n ),                   //                              .mem_ck_n
      .ddr4_mem_conduit_end_1_mem_a                    ( mem_a ),                      //                              .mem_a
      .ddr4_mem_conduit_end_1_mem_act_n                ( mem_act_n ),                  //                              .mem_act_n
      .ddr4_mem_conduit_end_1_mem_ba                   ( mem_ba ),                     //                              .mem_ba
      .ddr4_mem_conduit_end_1_mem_bg                   ( mem_bg ),                     //                              .mem_bg
      .ddr4_mem_conduit_end_1_mem_cke                  ( mem_cke ),                    //                              .mem_cke
      .ddr4_mem_conduit_end_1_mem_cs_n                 ( mem_cs_n ),                   //                              .mem_cs_n
      .ddr4_mem_conduit_end_1_mem_odt                  ( mem_odt ),                    //                              .mem_odt
      .ddr4_mem_conduit_end_1_mem_reset_n              ( mem_reset_n ),                //                              .mem_reset_n
      .ddr4_mem_conduit_end_1_mem_par                  ( mem_par ),                    //                             .mem_par
      .ddr4_mem_conduit_end_1_mem_alert_n              ( mem_alert_n ),                //                             .mem_alert_n
      .ddr4_mem_conduit_end_1_mem_dqs                  ( mem_dqs ),                    //                              .mem_dqs
      .ddr4_mem_conduit_end_1_mem_dqs_n                ( mem_dqs_n ),                  //                              .mem_dqs_n
      .ddr4_mem_conduit_end_1_mem_dq                   ( mem_dq ),                     //                              .mem_dq
      .ddr4_mem_conduit_end_1_mem_dbi_n                ( mem_dbi_n ),                  //                              .mem_dbi_n
      .ddr4_oct_conduit_end_1_oct_rzqin                ( oct_rzqin ),                  //         ddr4a_oct_conduit_end.oct_rzqin
      .ddr4_pll_ref_clk_clock_sink_1_clk               ( pll_ref_clk ),                //  ddr4a_pll_ref_clk_clock_sink.clk
      .ddr4_status_conduit_end_1_local_cal_success     ( local_cal_success ),          //      ddr4a_status_conduit_end.local_cal_success
      .ddr4_status_conduit_end_1_local_cal_fail        ( local_cal_fail ),             //                              .local_cal_fail
      .emif_out_clk_clk                                ( emif_out_clk ),               //                   emif_out_clk.clk
      .emif_out_reset_reset                            ( emif_out_reset ),             //                   emif_out_reset.reset
      .pr_logic_clock_clk                              ( clock_250mhz_clk ),           //                pr_logic_clock.clk
      .pr_logic_mm_s0_waitrequest                      ( pr_logic_mm_waitrequest ),    //                pr_logic_mm.waitrequest
      .pr_logic_mm_s0_readdata                         ( pr_logic_mm_readdata ),       //                           .readdata
      .pr_logic_mm_s0_readdatavalid                    ( pr_logic_mm_readdatavalid ),  //                           .readdatavalid
      .pr_logic_mm_s0_burstcount                       ( pr_logic_mm_burstcount ),     //                           .burstcount
      .pr_logic_mm_s0_writedata                        ( pr_logic_mm_writedata ),      //                           .writedata
      .pr_logic_mm_s0_address                          ( pr_logic_mm_address ),        //                           .address
      .pr_logic_mm_s0_write                            ( pr_logic_mm_write ),          //                           .write
      .pr_logic_mm_s0_read                             ( pr_logic_mm_read ),           //                           .read
      .pr_logic_mm_s0_byteenable                       ( pr_logic_mm_byteenable ),     //                           .byteenable
      .pr_logic_mm_s0_debugaccess                      ( pr_logic_mm_debugaccess ),    //                           .debugaccess
      .pr_logic_reset_reset                            ( pr_logic_reset )              //                pr_logic_reset.reset
   );
   // pcie_subsystem includes:
   // a.  The PCIe Express IP, a Gen3x8 having a 256-bit Interface running at
   //     250 MHz
   // b.  PR IP
   //
   pcie_subsystem u_pcie_subsystem (
      .alt_pr_freeze_freeze              ( alt_pr_freeze_freeze ),
      .board_pins_L0_led                 ( board_pins_L0_led ),
      .board_pins_alive_led              ( board_pins_alive_led ),
      .board_pins_comp_led               ( board_pins_comp_led ),
      .board_pins_free_clk               ( board_pins_free_clk ),
      .board_pins_gen2_led               ( board_pins_gen2_led ),
      .board_pins_gen3_led               ( board_pins_gen3_led ),
      .board_pins_lane_active_led        ( board_pins_lane_active_led ),
      .board_pins_req_compliance_pb      ( board_pins_req_compliance_pb ),
      .board_pins_set_compliance_mode    ( board_pins_set_compliance_mode ),
      .alt_pr_clk_clk                    ( alt_pr_50mhz_clk ),
      .clock_250mhz_clk                  ( clock_250mhz_clk ),
      .pcie_dma_wr_master_address        ( pcie_dma_wr_master_address ),                // pcie_dma_wr_master.address[63:0]   - output
      .pcie_dma_wr_master_read           ( pcie_dma_wr_master_read ),                   //                   .read            - output
      .pcie_dma_wr_master_readdata       ( 256'b0 ),                                    //                   .readdata[255:0] - input  
      .pcie_dma_wr_master_waitrequest    ( 1'b0 ),                                      //                   .waitrequest     - input     
      .pcie_dma_wr_master_burstcount     ( pcie_dma_wr_master_burstcount ),             //                   .burstcount[4:0] - output   
      .pcie_dma_wr_master_readdatavalid  ( 1'b1 ),                                      //                   .readdatavalid   - input       
      .pcie_rstn_npor                    ( pcie_rstn_npor ),
      .pcie_rstn_pin_perst               ( pcie_rstn_pin_perst ),

   // Start of simulation only ports ( virtual in physical view )
   // port names prefix:pipe_sim_only_
   // input ports are tied low
      .hip_ctrl_test_in                  ( 32'b0 ),
      .hip_ctrl_simu_mode_pipe           ( 1'b0 ),
      .pipe_sim_only_sim_pipe_pclk_in    ( 1'b0 ),
      .pipe_sim_only_sim_pipe_rate       (),
      .pipe_sim_only_sim_ltssmstate      (),
      .pipe_sim_only_eidleinfersel0      (),
      .pipe_sim_only_eidleinfersel1      (),
      .pipe_sim_only_eidleinfersel2      (),
      .pipe_sim_only_eidleinfersel3      (),
      .pipe_sim_only_eidleinfersel4      (),
      .pipe_sim_only_eidleinfersel5      (),
      .pipe_sim_only_eidleinfersel6      (),
      .pipe_sim_only_eidleinfersel7      (),
      .pipe_sim_only_powerdown0          (),
      .pipe_sim_only_powerdown1          (),
      .pipe_sim_only_powerdown2          (),
      .pipe_sim_only_powerdown3          (),
      .pipe_sim_only_powerdown4          (),
      .pipe_sim_only_powerdown5          (),
      .pipe_sim_only_powerdown6          (),
      .pipe_sim_only_powerdown7          (),
      .pipe_sim_only_rxpolarity0         (),
      .pipe_sim_only_rxpolarity1         (),
      .pipe_sim_only_rxpolarity2         (),
      .pipe_sim_only_rxpolarity3         (),
      .pipe_sim_only_rxpolarity4         (),
      .pipe_sim_only_rxpolarity5         (),
      .pipe_sim_only_rxpolarity6         (),
      .pipe_sim_only_rxpolarity7         (),
      .pipe_sim_only_txcompl0            (),
      .pipe_sim_only_txcompl1            (),
      .pipe_sim_only_txcompl2            (),
      .pipe_sim_only_txcompl3            (),
      .pipe_sim_only_txcompl4            (),
      .pipe_sim_only_txcompl5            (),
      .pipe_sim_only_txcompl6            (),
      .pipe_sim_only_txcompl7            (),
      .pipe_sim_only_txdata0             (),
      .pipe_sim_only_txdata1             (),
      .pipe_sim_only_txdata2             (),
      .pipe_sim_only_txdata3             (),
      .pipe_sim_only_txdata4             (),
      .pipe_sim_only_txdata5             (),
      .pipe_sim_only_txdata6             (),
      .pipe_sim_only_txdata7             (),
      .pipe_sim_only_txdatak0            (),
      .pipe_sim_only_txdatak1            (),
      .pipe_sim_only_txdatak2            (),
      .pipe_sim_only_txdatak3            (),
      .pipe_sim_only_txdatak4            (),
      .pipe_sim_only_txdatak5            (),
      .pipe_sim_only_txdatak6            (),
      .pipe_sim_only_txdatak7            (),
      .pipe_sim_only_txdetectrx0         (),
      .pipe_sim_only_txdetectrx1         (),
      .pipe_sim_only_txdetectrx2         (),
      .pipe_sim_only_txdetectrx3         (),
      .pipe_sim_only_txdetectrx4         (),
      .pipe_sim_only_txdetectrx5         (),
      .pipe_sim_only_txdetectrx6         (),
      .pipe_sim_only_txdetectrx7         (),
      .pipe_sim_only_txelecidle0         (),
      .pipe_sim_only_txelecidle1         (),
      .pipe_sim_only_txelecidle2         (),
      .pipe_sim_only_txelecidle3         (),
      .pipe_sim_only_txelecidle4         (),
      .pipe_sim_only_txelecidle5         (),
      .pipe_sim_only_txelecidle6         (),
      .pipe_sim_only_txelecidle7         (),
      .pipe_sim_only_txdeemph0           (),
      .pipe_sim_only_txdeemph1           (),
      .pipe_sim_only_txdeemph2           (),
      .pipe_sim_only_txdeemph3           (),
      .pipe_sim_only_txdeemph4           (),
      .pipe_sim_only_txdeemph5           (),
      .pipe_sim_only_txdeemph6           (),
      .pipe_sim_only_txdeemph7           (),
      .pipe_sim_only_txmargin0           (),
      .pipe_sim_only_txmargin1           (),
      .pipe_sim_only_txmargin2           (),
      .pipe_sim_only_txmargin3           (),
      .pipe_sim_only_txmargin4           (),
      .pipe_sim_only_txmargin5           (),
      .pipe_sim_only_txmargin6           (),
      .pipe_sim_only_txmargin7           (),
      .pipe_sim_only_txswing0            (),
      .pipe_sim_only_txswing1            (),
      .pipe_sim_only_txswing2            (),
      .pipe_sim_only_txswing3            (),
      .pipe_sim_only_txswing4            (),
      .pipe_sim_only_txswing5            (),
      .pipe_sim_only_txswing6            (),
      .pipe_sim_only_txswing7            (),
      .pipe_sim_only_phystatus0          ( 1'b0 ),
      .pipe_sim_only_phystatus1          ( 1'b0 ),
      .pipe_sim_only_phystatus2          ( 1'b0 ),
      .pipe_sim_only_phystatus3          ( 1'b0 ),
      .pipe_sim_only_phystatus4          ( 1'b0 ),
      .pipe_sim_only_phystatus5          ( 1'b0 ),
      .pipe_sim_only_phystatus6          ( 1'b0 ),
      .pipe_sim_only_phystatus7          ( 1'b0 ),
      .pipe_sim_only_rxdata0             ( 32'b0 ),
      .pipe_sim_only_rxdata1             ( 32'b0 ),
      .pipe_sim_only_rxdata2             ( 32'b0 ),
      .pipe_sim_only_rxdata3             ( 32'b0 ),
      .pipe_sim_only_rxdata4             ( 32'b0 ),
      .pipe_sim_only_rxdata5             ( 32'b0 ),
      .pipe_sim_only_rxdata6             ( 32'b0 ),
      .pipe_sim_only_rxdata7             ( 32'b0 ),
      .pipe_sim_only_rxdatak0            ( 4'b0 ),
      .pipe_sim_only_rxdatak1            ( 4'b0 ),
      .pipe_sim_only_rxdatak2            ( 4'b0 ),
      .pipe_sim_only_rxdatak3            ( 4'b0 ),
      .pipe_sim_only_rxdatak4            ( 4'b0 ),
      .pipe_sim_only_rxdatak5            ( 4'b0 ),
      .pipe_sim_only_rxdatak6            ( 4'b0 ),
      .pipe_sim_only_rxdatak7            ( 4'b0 ),
      .pipe_sim_only_rxelecidle0         ( 1'b0 ),
      .pipe_sim_only_rxelecidle1         ( 1'b0 ),
      .pipe_sim_only_rxelecidle2         ( 1'b0 ),
      .pipe_sim_only_rxelecidle3         ( 1'b0 ),
      .pipe_sim_only_rxelecidle4         ( 1'b0 ),
      .pipe_sim_only_rxelecidle5         ( 1'b0 ),
      .pipe_sim_only_rxelecidle6         ( 1'b0 ),
      .pipe_sim_only_rxelecidle7         ( 1'b0 ),
      .pipe_sim_only_rxstatus0           ( 3'b0 ),
      .pipe_sim_only_rxstatus1           ( 3'b0 ),
      .pipe_sim_only_rxstatus2           ( 3'b0 ),
      .pipe_sim_only_rxstatus3           ( 3'b0 ),
      .pipe_sim_only_rxstatus4           ( 3'b0 ),
      .pipe_sim_only_rxstatus5           ( 3'b0 ),
      .pipe_sim_only_rxstatus6           ( 3'b0 ),
      .pipe_sim_only_rxstatus7           ( 3'b0 ),
      .pipe_sim_only_rxvalid0            ( 1'b0 ),
      .pipe_sim_only_rxvalid1            ( 1'b0 ),
      .pipe_sim_only_rxvalid2            ( 1'b0 ),
      .pipe_sim_only_rxvalid3            ( 1'b0 ),
      .pipe_sim_only_rxvalid4            ( 1'b0 ),
      .pipe_sim_only_rxvalid5            ( 1'b0 ),
      .pipe_sim_only_rxvalid6            ( 1'b0 ),
      .pipe_sim_only_rxvalid7            ( 1'b0 ),
      .pipe_sim_only_rxdataskip0         ( 1'b0 ),
      .pipe_sim_only_rxdataskip1         ( 1'b0 ),
      .pipe_sim_only_rxdataskip2         ( 1'b0 ),
      .pipe_sim_only_rxdataskip3         ( 1'b0 ),
      .pipe_sim_only_rxdataskip4         ( 1'b0 ),
      .pipe_sim_only_rxdataskip5         ( 1'b0 ),
      .pipe_sim_only_rxdataskip6         ( 1'b0 ),
      .pipe_sim_only_rxdataskip7         ( 1'b0 ),
      .pipe_sim_only_rxblkst0            ( 1'b0 ),
      .pipe_sim_only_rxblkst1            ( 1'b0 ),
      .pipe_sim_only_rxblkst2            ( 1'b0 ),
      .pipe_sim_only_rxblkst3            ( 1'b0 ),
      .pipe_sim_only_rxblkst4            ( 1'b0 ),
      .pipe_sim_only_rxblkst5            ( 1'b0 ),
      .pipe_sim_only_rxblkst6            ( 1'b0 ),
      .pipe_sim_only_rxblkst7            ( 1'b0 ),
      .pipe_sim_only_rxsynchd0           ( 2'b0 ),
      .pipe_sim_only_rxsynchd1           ( 2'b0 ),
      .pipe_sim_only_rxsynchd2           ( 2'b0 ),
      .pipe_sim_only_rxsynchd3           ( 2'b0 ),
      .pipe_sim_only_rxsynchd4           ( 2'b0 ),
      .pipe_sim_only_rxsynchd5           ( 2'b0 ),
      .pipe_sim_only_rxsynchd6           ( 2'b0 ),
      .pipe_sim_only_rxsynchd7           ( 2'b0 ),
      .pipe_sim_only_currentcoeff0       (),
      .pipe_sim_only_currentcoeff1       (),
      .pipe_sim_only_currentcoeff2       (),
      .pipe_sim_only_currentcoeff3       (),
      .pipe_sim_only_currentcoeff4       (),
      .pipe_sim_only_currentcoeff5       (),
      .pipe_sim_only_currentcoeff6       (),
      .pipe_sim_only_currentcoeff7       (),
      .pipe_sim_only_currentrxpreset0    (),
      .pipe_sim_only_currentrxpreset1    (),
      .pipe_sim_only_currentrxpreset2    (),
      .pipe_sim_only_currentrxpreset3    (),
      .pipe_sim_only_currentrxpreset4    (),
      .pipe_sim_only_currentrxpreset5    (),
      .pipe_sim_only_currentrxpreset6    (),
      .pipe_sim_only_currentrxpreset7    (),
      .pipe_sim_only_txsynchd0           (),
      .pipe_sim_only_txsynchd1           (),
      .pipe_sim_only_txsynchd2           (),
      .pipe_sim_only_txsynchd3           (),
      .pipe_sim_only_txsynchd4           (),
      .pipe_sim_only_txsynchd5           (),
      .pipe_sim_only_txsynchd6           (),
      .pipe_sim_only_txsynchd7           (),
      .pipe_sim_only_txblkst0            (),
      .pipe_sim_only_txblkst1            (),
      .pipe_sim_only_txblkst2            (),
      .pipe_sim_only_txblkst3            (),
      .pipe_sim_only_txblkst4            (),
      .pipe_sim_only_txblkst5            (),
      .pipe_sim_only_txblkst6            (),
      .pipe_sim_only_txblkst7            (),
      .pipe_sim_only_txdataskip0         (),
      .pipe_sim_only_txdataskip1         (),
      .pipe_sim_only_txdataskip2         (),
      .pipe_sim_only_txdataskip3         (),
      .pipe_sim_only_txdataskip4         (),
      .pipe_sim_only_txdataskip5         (),
      .pipe_sim_only_txdataskip6         (),
      .pipe_sim_only_txdataskip7         (),
      .pipe_sim_only_rate0               (),
      .pipe_sim_only_rate1               (),
      .pipe_sim_only_rate2               (),
      .pipe_sim_only_rate3               (),
      .pipe_sim_only_rate4               (),
      .pipe_sim_only_rate5               (),
      .pipe_sim_only_rate6               (),
      .pipe_sim_only_rate7               (),
   // End of simulation only ports (virtual in physical view)

      .pr_logic_clk_clk                  ( pr_logic_clk_clk ),
      .pr_logic_cra_waitrequest          ( pr_logic_cra_waitrequest ),
      .pr_logic_cra_readdata             ( pr_logic_cra_readdata ),
      .pr_logic_cra_readdatavalid        ( pr_logic_cra_readdatavalid ),
      .pr_logic_cra_burstcount           ( pr_logic_cra_burstcount ),
      .pr_logic_cra_writedata            ( pr_logic_cra_writedata ),
      .pr_logic_cra_address              ( pr_logic_cra_address ),
      .pr_logic_cra_write                ( pr_logic_cra_write ),
      .pr_logic_cra_read                 ( pr_logic_cra_read ),
      .pr_logic_cra_byteenable           ( pr_logic_cra_byteenable ),
      .pr_logic_cra_debugaccess          ( pr_logic_cra_debugaccess ),
      .pr_logic_reset_reset_n            ( pr_logic_reset_reset_n ),
      .ref_clk_clk                       ( ref_clk_clk ),
      .xcvr_rx_in0                       ( xcvr_rx_in0 ),
      .xcvr_rx_in1                       ( xcvr_rx_in1 ),
      .xcvr_rx_in2                       ( xcvr_rx_in2 ),
      .xcvr_rx_in3                       ( xcvr_rx_in3 ),
      .xcvr_rx_in4                       ( xcvr_rx_in4 ),
      .xcvr_rx_in5                       ( xcvr_rx_in5 ),
      .xcvr_rx_in6                       ( xcvr_rx_in6 ),
      .xcvr_rx_in7                       ( xcvr_rx_in7 ),
      .xcvr_tx_out0                      ( xcvr_tx_out0 ),
      .xcvr_tx_out1                      ( xcvr_tx_out1 ),
      .xcvr_tx_out2                      ( xcvr_tx_out2 ),
      .xcvr_tx_out3                      ( xcvr_tx_out3 ),
      .xcvr_tx_out4                      ( xcvr_tx_out4 ),
      .xcvr_tx_out5                      ( xcvr_tx_out5 ),
      .xcvr_tx_out6                      ( xcvr_tx_out6 ),
      .xcvr_tx_out7                      ( xcvr_tx_out7 )
   );


endmodule
