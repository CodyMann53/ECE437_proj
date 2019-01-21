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
  cpu_ram_if ramif (); 

  // DUT declarations 
  `ifndef MAPPED
    memory_control DUT_MEMORY_CONTROL(CLK, nRST, ccif);
    ram DUT_RAM(CLK, nRST, cpu_ram_if.ram ramif); 
  `else
    memory_control DUT_MEMORY_CONTROL(
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
    ram DUT_RAM(
      .\CLK (CLK),
      .\nRST (nRST), 
      .\ramaddr (ramif.ramaddr),
      .\ramstore (ramif.ramstore), 
      .\ramREN (ramif.ramREN), 
      .\ramWEN (ramif.ramWEN), 
      .\ramstate (ramif.ramstate), 
      .\ramload (ramif.ramload)
    );
  `endiff

  // assign statements memory control -> ram 
  assign ramif.ramaddr = ccif.ramaddr; 
  assign ramif.ramREN = ccif.ramREN; 
  assign ramif.ramWEN = ccif.ramWEN; 
  assign ramif.ramstore = ccif.ramstore; 

  // assign statements ram -> memory control 
  assign ccif.ramload = ramif.ramload; 
  assign ccif.ramstate = ramif.ramstate; 

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
  input logic CLK, iwait, dwait,  
  input word_t iload, dload,
  output logic nRST, iREN, dREN, dWEN, 
  output word_t dstore, iaddr, daddr
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
  } operation_command; 

  // test vector definitions 
  typedef struct{
    string test_name; 
    word_t memory_address; 
    word_t test_data; 
    operation_command test_type;  
  }  test_vector; 

  // declare the unpacted/dynamically sized test-vector array 
  test_vector tb_test_cases []; 

  /*************** task definitions *************************************/
  
  // toggles the reset line 
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

  // assigns an element in array of test vectors its information 
  task add_test; 
    input logic array_element; 
    input string test_name; 
    input word_t memory_address, test_data; 
    input operation_command test_type; 
    begin 

      // pass value into array 
      tb_test_cases[array_element].test_name = test_name; 
      tb_test_cases[array_element].memory_address = memory_address; 
      tb_test_cases[array_element].test_data = test_data; 
      tb_test_cases[array_element].test_type = test_type; 
    end 
  endtask

  // task to read instruction from memory
  task read_instruction; 
    input word_t memory_address; 
    begin 

      // apply propper inputs to memory control for a read instruciton
      iREN = 1'b1; 
      iaddr = memory_address; 

      // wait a little to allow inputs to be applied before checking iwait 
      #(0.5)

      // wait until iwait is brought back low 
      while (iwait == 1'b1) begin 
        // do nothing here (just waiting)
      end 

      // check for expected instruction value
      check_data(memory_address);
    end 
  endtask

  //initial block  
  initial begin

  // initialize all of the outputs to the memory controller (default values)
  nRST = 1'b0; 
  iREN = 1'b0; 
  dREN = 1'b0; 
  dWEN = 1'b0; 
  dstore = 32'd0; 
  iaddr = 32'd0; 
  daddr = 32'd0; 

  // loop through all of the test cases


  end 
endprogram
