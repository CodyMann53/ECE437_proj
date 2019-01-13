/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();

  // DUT
  `ifndef MAPPED
    register_file DUT(CLK, nRST, rfif);
  `else
    register_file DUT(
      .\rfif.rdat2 (rfif.rdat2),
      .\rfif.rdat1 (rfif.rdat1),
      .\rfif.wdat (rfif.wdat),
      .\rfif.rsel2 (rfif.rsel2),
      .\rfif.rsel1 (rfif.rsel1),
      .\rfif.wsel (rfif.wsel),
      .\rfif.WEN (rfif.WEN),
      .\nRST (nRST),
      .\CLK (CLK)
    );
  `endif

  // test program
  test PROG ( 
    .CLK(CLK),
    .nRST(nRST),
    .rdat1(rfif.rdat1),
    .rdat2(rfif.rdat2), 
    .WEN(rfif.WEN), 
    .nRST(rfif.nRST), 
    .wsel(rfif.wsel), 
    .rsel1(rfif.rsel1),
    .rsel2(rfif.rsel2), 
    wdat(rfif.wdat)); 
endmodule

program test(
  input logic CLK,
  input cpu_types_pkg::word_t rdat1, rdat2, 
  output logic WEN, nRST, 
  output cpu_types_pkg::regbits_t wsel, rsel1, rsel2,
  output cpu_types_pkg::word_t wdat); 

  // defining the period 
  parameter PERIOD = 10;

  // variable for reading register value 
  word_t value; 

  //initial block  
  initial begin

    $monitor("@%00g CLK = %b nRST = %b value = %0d", $time, CLK, nRST, value);

    // wait for a positive clock edge 
    @(posedge CLK); 
    // apply a read from memory location zero
    wsel = 1'b0; 
    rsel2 = 32'd1; 
    rsel1 = 0'd0; 

    // read value 
    value = rdata1; 

  end 
endprogram
