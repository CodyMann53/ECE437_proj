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

  // parameter definitions 
  parameter PERIOD = 10;
  parameter REGISTER_SIZE = 32; 

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;


  // clock generation block 
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
    .wsel(rfif.wsel), 
    .rsel1(rfif.rsel1),
    .rsel2(rfif.rsel2), 
    .wdat(rfif.wdat)); 


endmodule

program test(
  input logic CLK,
  input cpu_types_pkg::word_t rdat1, rdat2, 
  output logic WEN, nRST, 
  output cpu_types_pkg::regbits_t wsel, rsel1, rsel2,
  output cpu_types_pkg::word_t wdat); 

  // import statements 
  import cpu_types_pkg::*; 

  // parameter definitions  
  parameter PERIOD = 10;
  parameter REGISTER_SIZE = 32; 

  // variable definitions 
  regbits_t memory_selection; 
  word_t reg_data; 

  // task definitions 
  task reset_dut; 
    begin 

      // get away from posedge of clock 
      @(negedge CLK); 

      // bring nRST low 
      nRST = 1'b0; 

      // wait for a period 
      #(PERIOD)

      // get away from posedge of clock 
      @(negedge CLK); 

      // bring nRST back high 
      nRST = 1'b1; 
    end 
  endtask

  task write; 
    input word_t data;
    input regbits_t mem_location;  
    begin 

      // get away from rising edge 
      @(negedge CLK); 

      // set write enable to 1 
      WEN = 1'b1;

      // set write memory location 
      wsel = mem_location; 

      // put data on bus 
      wdat = data;  

      // get away from rising clock edge to bring WEN back to 0 
      @(negedge CLK); 
      WEN = 1'b0; 
    
    end 
  endtask 

  task read1; 
    input word_t expected_data;
    input regbits_t mem_location;  
    begin 

      // get away from rising edge 
      @(negedge CLK); 

      // set write enable to 0 for reading 
      WEN = 1'b0;

      // set write memory location 
      rsel1 = mem_location; 

      // check if read data is equal to expected data 
      if (expected_data != rdat1) begin 

        // display error message 
        $display("Error in reading from memory location %0d", mem_location); 
      end 
    end 
  endtask 


  //initial block  
  initial begin

  // initialize local variables 
  memory_selection = 5'd0; 
  reg_data = 32'd100; 

    // reset the register file 
    reset_dut();

    // loop through all of the registers
    for (int i = 0; i < REGISTER_SIZE; i++) begin 

      // write to memory 
      write(reg_data, memory_selection); 

      // read from memory using read selection one and check 
      read1(reg_data, memory_selection);

      // read from memory using read selectio none and check 
      read2(reg_data, memory_selection);

      // increment memory selection 
      memory_selection = memory_selection + 1; 
      reg_data = reg_data + 1; 
    end 
  end 
endprogram
