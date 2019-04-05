/*
  Cody Mann
  mann53@purdue.edu
  
  data cache testbench
*/

// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module dcache_tb;

  // parameter definitions 
  parameter PERIOD = 10; 

  logic CLK = 0, nRST;

  // clock generation block 
  always #(PERIOD/2) CLK++;

  // interfaces
  datapath_cache_if dcif();
 
  // coherence interface
  caches_if cif();

  // DUT
  `ifndef MAPPED
    dcache DUT(CLK, nRST, dcif, cif);
    //memory_control DUT_MEMORY_CONTROL(CLK, nRST, ccif);
    //ram RAM(CLK, nRST, ramif);
  `else
    dcache DUT(
      .\dcif.halt(dcif.halt),
      .\dcif.dmemREN(dcif.dmemREN),
      .\dcif.dmemWEN(dcif.dmemWEN),
      .\dcif.datomic(dcif.datomic),
      .\dcif.dmemstore(dcif.dmemstore),
      .\dcif.dmemaddr(dcif.dmemaddr),
      .\cif.dwait(cif.dwait),
      .\cif.dload(cif.dload),
      .\cif.ccwait(cif.ccwait),
      .\cif.ccinv(cif.ccinv),
      .\cif.ccsnoopaddr(cif.ccsnoopaddr),
      .\nRST (nRST),
      .\CLK (CLK) 
      ); 
    /*
    memory_control MEMORY_CONTROL(
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
      .\ccif.ccsnoopaddr (ccif.ccsnoopaddr)
    );
    ram RAM(
    .\CLK (CLK),
    .\nRST (nRST),
    .\ramif.ramaddr (ramif.ramaddr),
    .\ramif.ramstore (ramif.ramstore),
    .\ramif.ramREN (ramif.ramREN),
    .\ramif.ramWEN (ramif.ramWEN),
    .\ramif.ramstate (ramif.ramstate),
    .\ramif.ramload (ramif.ramload)
    );*/
  `endif

/*******************  CONNECTIONS ********************/
  /*
  // assign statements memory control -> ram
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ramif.ramstore = ccif.ramstore;

  // assign statements ram -> memory control
  assign ccif.ramload = ramif.ramload;
  assign ccif.ramstate = ramif.ramstate;
  */


  // test program
  test PROG ( 
    .CLK(CLK),
    .nRST(nRST),
    .dcif(dcif), 
    .cif(cif)
    ); 

endmodule

/******************* TEST PROGRAM ********************/
program test(
  input logic CLK,
  output logic nRST, 
  datapath_cache_if dcif, 
  caches_if cif
  ); 

  // import statements 
  import cpu_types_pkg::*; 

/******************* TEST VARIABLE DECLARATIONS ********************/
  // parameter definitions  
  parameter PERIOD = 10;

  // test information 
  int test_case = 0;
  word_t correct_word;
  word_t correct_addr;
  initial begin 

  nRST = 1;
  dcif.halt = 0;
  dcif.dmemREN = 0;
  dcif.dmemWEN = 0;
  dcif.datomic = 0;
  dcif.dmemstore = 0;
  dcif.dmemaddr = 0;
  cif.dwait = 1;
  cif.dload = 0;
  cif.ccwait = 0;
  cif.ccinv = 0;
  cif.ccsnoopaddr = 0;

  @(negedge CLK); 
  nRST = 0;
  @(negedge CLK); 
  nRST = 1;

  // Test Case 1: Load cache block with data then testing a cache hit
    test_case++;
    dcif.dmemREN = 1'b1;
    dcif.dmemaddr = {26'd2, 3'd1, 3'b000};
    @(negedge CLK); 
    cif.dload = 32'h11111111;
    cif.dwait = 0;
    @(negedge CLK); 
    cif.dwait = 1;
    @(negedge CLK); 
    @(negedge CLK); 
    cif.dload = 32'h22222222;
    cif.dwait = 0;
    @(negedge CLK); 
    cif.dwait = 1;
    dcif.dmemREN = 1'b0;
    // Testing the cache hit
    @(negedge CLK); 
    @(negedge CLK); 
    dcif.dmemREN = 1'b1;
    dcif.dmemaddr = {26'd2, 3'd1, 3'b100};    
    @(negedge CLK);
    correct_word = 32'h22222222;
    assert(dcif.dhit == 1 && dcif.dmemload == correct_word)
       $display("test case %d passed", test_case);
    else
    begin
       $display("test case %d FAILED", test_case);
    end  
    @(negedge CLK);

  // Test Case 2: Load cache block with same index and test for a cache hit
    test_case++;
    dcif.dmemREN = 1'b1;
    dcif.dmemaddr = {26'd3, 3'd1, 3'b000};
    @(negedge CLK); 
    cif.dload = 32'h33333333;
    cif.dwait = 0;
    @(negedge CLK); 
    cif.dwait = 1;
    @(negedge CLK); 
    @(negedge CLK); 
    cif.dload = 32'h44444444;
    cif.dwait = 0;
    @(negedge CLK); 
    cif.dwait = 1;
    dcif.dmemREN = 1'b0;
    // Testing the cache hit
    @(negedge CLK); 
    @(negedge CLK); 
    dcif.dmemREN = 1'b1;
    dcif.dmemaddr = {26'd3, 3'd1, 3'b000};    
    @(negedge CLK);
    correct_word = 32'h33333333;
    assert(dcif.dhit == 1 && dcif.dmemload == correct_word)
       $display("test case %d passed", test_case);
    else
    begin
       $display("test case %d FAILED", test_case);
    end  
    @(negedge CLK);  

  // Test Case 3 and 4: Load cache block with same index and test for LRU replacement
    test_case++;
    dcif.dmemREN = 1'b1;
    dcif.dmemaddr = {26'd4, 3'd1, 3'b000};
    @(negedge CLK); 
    cif.dload = 32'h55555555;
    cif.dwait = 0;
    @(negedge CLK); 
    cif.dwait = 1;
    @(negedge CLK); 
    @(negedge CLK); 
    cif.dload = 32'h66666666;
    cif.dwait = 0;
    @(negedge CLK); 
    cif.dwait = 1;
    dcif.dmemREN = 1'b0;
    // Testing the cache hit
    @(negedge CLK); 
    @(negedge CLK); 
    dcif.dmemREN = 1'b1;
    dcif.dmemaddr = {26'd4, 3'd1, 3'b000};    
    @(negedge CLK);
    correct_word = 32'h55555555;
    assert(dcif.dhit == 1 && dcif.dmemload == correct_word)
       $display("test case %d passed", test_case);
    else
    begin
       $display("test case %d FAILED", test_case);
    end  
    dcif.dmemREN = 1'b0;
    @(negedge CLK); 
    test_case++; 
    dcif.dmemREN = 1'b1;
    dcif.dmemaddr = {26'd3, 3'd1, 3'b000};    
    @(negedge CLK);
    correct_word = 32'h33333333;
    assert(dcif.dhit == 1 && dcif.dmemload == correct_word)
       $display("test case %d passed", test_case);
    else
    begin
       $display("test case %d FAILED", test_case);
    end  
    @(negedge CLK);  

  // Test Case 5: Testing snooping block that is in the shared state
    test_case++;
    cif.ccwait = 1'b1;
    @(negedge CLK);
    cif.ccsnoopaddr = {26'd3, 3'd1, 3'b000};
    @(negedge CLK);
    assert(cif.cctrans == 1 && cif.ccwrite == 0)
       $display("test case %d passed", test_case);
    else
    begin
       $display("test case %d FAILED", test_case);
    end  
    @(negedge CLK);

  // Test Case 6: Testing snooping block when the tag doesn't match
    test_case++;
    cif.ccwait = 1'b1;
    @(negedge CLK);
    cif.ccsnoopaddr = {26'd2, 3'd1, 3'b000};
    @(negedge CLK);
    assert(cif.cctrans == 1 && cif.ccwrite == 0)
       $display("test case %d passed", test_case);
    else
    begin
       $display("test case %d FAILED", test_case);
    end  
    @(negedge CLK);

  // Test Case 7 and 8: Testing snooping block when the tag matches and in modified state
    test_case++;
    @(negedge CLK);
    cif.ccwait = 1'b0;
    dcif.dmemREN = 0;
    dcif.dmemWEN = 0;
    @(negedge CLK);
    @(negedge CLK);
    dcif.dmemWEN = 1;
    dcif.dmemaddr = {26'd3, 3'd1, 3'b000};
    dcif.dmemstore = 32'haaaaaaaa;
    // Cache Read1
    @(negedge CLK);
    cif.dwait = 0;
    @(negedge CLK);
    cif.dwait = 1;
    // Cache Read2
    @(negedge CLK);
    cif.dwait = 0;
    // Cache Idle
    @(negedge CLK);
    cif.dwait = 1;
    @(negedge CLK);
    dcif.dmemWEN = 0;
    cif.ccwait = 1'b1;
    // Cache Snoop
    @(negedge CLK);    
    cif.ccsnoopaddr = {26'd3, 3'd1, 3'b000};
    @(negedge CLK);
    correct_word = 32'haaaaaaaa;
    correct_addr = {26'd3, 3'd1, 3'b000};
    assert(cif.cctrans == 1 && cif.ccwrite == 1 && cif.daddr == correct_addr && cif.dstore == correct_word)
       $display("test case %d passed", test_case);
    else
    begin
       $display("test case %d FAILED", test_case);
    end  
    cif.dwait = 0;
    @(negedge CLK);
    test_case++;
    cif.dwait = 1;
    cif.ccsnoopaddr = {26'd3, 3'd1, 3'b100};
    @(negedge CLK);
    correct_word = 32'h44444444;
    correct_addr = {26'd3, 3'd1, 3'b100};
    assert(cif.daddr == correct_addr && cif.dstore == correct_word)
       $display("test case %d passed", test_case);
    else
    begin
       $display("test case %d FAILED", test_case);
    end  
    cif.dwait = 0;
    @(negedge CLK);
    cif.dwait = 0;
  end  
endprogram
