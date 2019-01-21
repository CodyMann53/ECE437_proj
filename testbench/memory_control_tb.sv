/*
  Cody Mann
  mann53@purdue.edu

  memory control test bench
*/

// mapped needs this
`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  // parameter definitions 
  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock generation block 
  always #(PERIOD/2) CLK++;

  // interface
  cache_control_if ccif ();

  // DUT
  `ifndef MAPPED
    memory_control DUT_MEMORY_CONTROL(CLK, nRST, ccif);
    ram DUT_RAM(CLK, nRST, cpu_ram_if.ram ramif); 

  `else
    memory_control DUT(
      .\ccif.iREN (ccif.iREN),
      .\ccif.dREN (ccif.dREN), 
      .\ccif.dWEN (ccif.dWEN),
      .\ccif.dstore (ccif.dstore), 
      .\ccif.iaddr (ccif.iaddr), 
      .\ccif.daddr (ccif.daddr), 
      .\ccif.ramload (ccif.ramload), 
      .\ccif.ramstate (ccif.ramstate), 
      .\ccif.ccwrite (ccif.ccwrite), 
      .\ccif.cctrans (ccif.cctrans), 
      .\ccif.iwait (ccif.iwait), 
      .\ccif.dwait (ccif.dwait), 
      .\ccif.iload (ccif.iload), 
      .\ccif.dload (ccif.dload), 
      .\ccif.ramstore (ccif.ramstore), 
      .\ccif.ramaddr (ccif.ramaddr), 
      .\ccif.ramWEN (ccif.ramWEN), 
      .\ccif.ramREN (ccif.ramREN), 
      .\ccif.ccwait (ccif.ccwait), 
      .\ccif.ccinv (ccif.ccinv), 
      .\ccif.ccsnoopaddr (ccif.ccsnoopaddr),
      .\nRST (nRST),
      .\CLK (CLK)
    );
  `endiff

  // test program
  test PROG ( 
    .CLK(CLK),
    .nRST(nRST),
    .iwait(ccif.iwait), 
    .dwait(ccif.dwait), 
    .ramWEN(ccif.ramWEN), 
    .ramREN(ccif.ramREN), 
    .iload(ccif.iload), 
    .dload(ccif.dload),
    .ramaddr(ccif.ramaddr), 
    .ramstore(ccif.ramstore), 
    .iREN(ccif.iREN), 
    .dREN(ccif.dREN), 
    .dWEN(ccif.dWEN),
    .dstore(ccif.dstore),
    .iaddr(ccif.iaddr), 
    .daddr(ccif.daddr), 
    .ramload(ccif.ramload), 
    .ramstate(ccif.ramstate) 
    ); 

endmodule

program test
  // import statements 
  import cpu_types_pkg::*; 
  // modports
  (
  input logic CLK, iwait, dwait, ramWEN, ramREN, 
  input word_t iload, dload, ramaddr, ramstore,
  output logic nRST, iREN, dREN, dWEN, 
  output word_t dstore, iaddr, daddr, ramload,
  output ramstate_t ramstate
  ); 

  // variable definitions for test case description 
  int test_case_num = 0; 
  string test_description = "NULL"; 

  // parameter definitions  
  parameter PERIOD = 10;

  // enumeration definitions 
  typedef enum logic [1:0] {
    READ_INSTR = 2'd0, 
    READ_DATA = 2'd1, 
    WRITE_DATA = 2'd2
  } descriptor; 

  // test vector definitions 
  typedef struct{
    string test_name; 
    word_t memory_address; 
    word_t data; 
    descripto test_type;  
  }  test_vector; 

  // declare the unpacted/dynamically sized test-vector array 
  test_vector tb_test_cases []; 

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

  //initial block  
  initial begin
  end 
endprogram
