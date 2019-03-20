/*
  Mitchell Keeney
  mkeeney@purdue.edu
  instruction cache testbench
*/

// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module icache_tb;

  // parameter definitions 
  parameter PERIOD = 10; 

  logic CLK = 0, nRST;

  // clock generation block 
  always #(PERIOD/2) CLK++;

  // interfaces
  datapath_cache_if dcif();
 
  // coherence interface
  caches_if                 cif0();

  // cif1 will not be used, but ccif expects it as an input
  caches_if                cif1();
  cache_control_if #(.CPUS(1))   ccif (cif0, cif1);
  cpu_ram_if ramif();

  // DUT
  `ifndef MAPPED
    icache DUT(CLK, nRST, dcif, cif0);
    memory_control DUT_MEMORY_CONTROL(ccif);
    ram RAM(CLK, nRST, ramif);
  `else
    icache DUT(
      .\dcif.dhit (dcif.dhit), 
      .\dcif.imemREN(dcif.imemREN), 
      .\dcif.imemWEN (dcif.imemWEN), 
      .\dcif.imemstore(dcif.imemstore), 
      .\dcif.imemaddr (dcif.imemaddr), 
      .\dcif.imemload (dcif.imemload),
      .\cif.dwait (cif.dwait), 
      .\cif.dload (cif.dload), 
      .\cif.dREN (cif.dREN), 
      .\cif.dWEN (cif.dWEN), 
      .\cif.daddr (cif.daddr), 
      .\cif.dstore (cif.dstore),  
      .\nRST (nRST),
      .\CLK (CLK) 
      ); 
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
    );
  `endif

  // assign statements memory control -> ram
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ramif.ramstore = ccif.ramstore;
  assign cif0.dREN = 1'b0; 
  assign cif0.dWEN = 1'b0; 


  // assign statements ram -> memory control
  assign ccif.ramload = ramif.ramload;
  assign ccif.ramstate = ramif.ramstate;


  // test program
  test PROG ( 
    .CLK(CLK),
    .nRST(nRST),
    .dcif(dcif), 
    .ccif(ccif)
    ); 

endmodule

/******************* TEST PROGRAM ********************/
program test(
  input logic CLK,
  output logic nRST, 
  datapath_cache_if dcif, 
  cache_control_if ccif
  ); 

  // import statements 
  import cpu_types_pkg::*; 

/******************* TEST VARIABLE DECLARATIONS ********************/
  // parameter definitions  
  parameter PERIOD = 10;

  // test information 
  int test_case_num = 0; 
  string test_description = "Initializing"; 

  // checks the read data from icache
  task check_data_read; 
    input icachef_t byte_address; 
    input word_t exp_data; 
    begin 
      // if the data output from icache is not the same as expected
      if (dcif.imemload != exp_data) begin
        // raise an error 
        $display("Time: %00gns Expecting %0d to be read from byte_address 0x%0h and not %0d.", $time, exp_data, byte_address, dcif.imemload); 
      end 
    end 
  endtask 

  // task to wait for a request to cache to complete and then checks for a valid dhit
  task complete_transaction;
    input icachef_t byte_address; 
    input logic block_present; 
    begin
      integer count;
      // wait a little to allow inputs to settle 
      #(10)
      count = 0; 
      
      // wait for transaction to complete between icache and memory or just move on because tag is already in the cache and no write dirty contents to memory should occur. 
      while(dcif.ihit == 0) begin 
        @(posedge CLK); 
        count += 1; 
      end  

      // If block was expected to be present in the icache 
      if (block_present == 1) begin 
        // if dhit was not given back in same clock cycle 
        if (count != 0) begin
          // flag an error message 
          $display("Ihit was not given back in same clock cycle for byte_address: 0x%0h that was expected to be in cache.", byte_address); 
        end 
      end
    end 
  endtask

  // requests a read from the icache
  task request_read; 
    input icachef_t byte_address; 
    begin 
      // get away from the negative edge of clock 
      @(posedge CLK); 
      // apply propper inputs to cache for a read
      dcif.halt = 1'b0; 
      dcif.imemREN = 1'b1; 
      dcif.imemaddr = byte_address; 
    end 
  endtask 

  // clears the inputs to the icache
  task remove_icache_inputs; 
    begin 
      // get away from the negative edge of clock cycle
      @(posedge CLK); 
      dcif.halt = 1'b0; 
      dcif.imemREN = 1'b0;  
      dcif.imemaddr = 32'd0; 
    end 
  endtask

  // task to read from the icache
  task read_icache;
    input icachef_t byte_address;
    input logic block_present;  
    input word_t exp_data; 
    input logic check_data; 
    begin
      // request a read from the icache
      request_read(byte_address); 
      // Wait for the transaction to complete
      complete_transaction(byte_address, block_present); 

      // wait a little for data to settle 
      #(10)
      // if supposed to check the data for validity
      if (check_data == 1) begin 
        // check data read 
        check_data_read(byte_address, exp_data); 
      end 
      // remove the inputs away from the icache
      remove_icache_inputs();  
    end 
  endtask

  // resets the whole system 
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

/******************* TEST INITIAL BLOCK ********************/
  initial begin


    /******************* START RUNNING THROUGH TEST CASES ********************/
    // initialize all inputs 
    remove_icache_inputs;
    // reset the system
    reset_dut();

    /************************************
    *
    *       Test case 1: Testing simple reads back to back from same block location.
    *
    ************************************/
    test_description = "Testing simple reads back to back from same block location.";

    // reads
    read_icache(32'd0, 0, 0, 0); 
    read_icache(32'd0, 1, 0, 0); 

    /************************************
    *
    *       Test case 2: Testing capacity misses.
    *
    ************************************/
    test_description = "Testing simple reads back to back from same block location.";

    // reads
    read_icache(32'd0, 0, 32'h341EFFFC, 1); 
    read_icache(32'd4, 0, 32'h341DFFFC, 1); 
    read_icache(32'd8, 0, 32'h34040304, 1); 
    read_icache(32'd12, 0, 32'h8C100300, 1); 
    read_icache(32'd16, 0, 32'h34090001, 1); 
    read_icache(32'd20, 0, 32'h01302806, 1); 
    read_icache(32'd24, 0, 32'h00048825, 1);
    read_icache(32'd28, 0, 32'h00059025, 1); 
    read_icache(32'd32, 0, 32'h0C00001D, 1); 
    read_icache(32'd36, 0, 32'h34090001, 1); 
    read_icache(32'd40, 0, 32'h01304006, 1); 
    read_icache(32'd44, 0, 32'h02082823, 1); 
    read_icache(32'd48, 0, 32'h34090002, 1); 
    read_icache(32'd52, 0, 32'h01284004, 1); 
    read_icache(32'd56, 0, 32'h34040304, 1); 
    read_icache(32'd60, 0, 32'h00882021, 1);
    read_icache(32'd64, 0, 32'h00049825, 1);
    read_icache(32'd0, 0, 32'h341EFFFC, 1); 
    read_icache(32'd8, 1, 32'h34040304, 1);

    // dump the memory into memcpu.hex after testbench is finished 
    // dump_memory(); 

    /*read_icache(32'd232, 0, 32'h00000000, 0); 
    read_icache(32'd236, 0, 32'h00000000, 0); 
    read_icache(32'd240, 0, 32'h00000000, 0); 
    read_icache(32'd244, 0, 32'h00000000, 0); 
    read_icache(32'd348, 0, 32'h00000000, 0); 
    read_icache(32'd252, 0, 32'h00000000, 0); 
    read_icache(32'd256, 0, 32'h00000000, 0);
    read_icache(32'd260, 0, 32'h00000000, 0); 
    read_icache(32'd264, 0, 32'h00000000, 0); 
    read_icache(32'd268, 0, 32'h00000000, 0); 
    read_icache(32'd272, 0, 32'h00000000, 0); 
    read_icache(32'd276, 0, 32'h00000000, 0); 
    read_icache(32'd280, 0, 32'h00000000, 0); 
    read_icache(32'd284, 0, 32'h00000000, 0); 
    read_icache(32'd288, 0, 32'h00000000, 0); 
    read_icache(32'd292, 0, 32'h00000000, 0);
    read_icache(32'd296, 0, 32'h00000000, 0);

    read_icache(32'd300, 0, 32'h11111111, 0); 
    read_icache(32'd304, 0, 32'h11111111, 0); 
    read_icache(32'd308, 0, 32'h11111111, 0); 
    read_icache(32'd312, 0, 32'h11111111, 0); 
    read_icache(32'd316, 0, 32'h11111111, 0); 
    read_icache(32'd320, 0, 32'h11111111, 0); 
    read_icache(32'd324, 0, 32'h11111111, 0);
    read_icache(32'd328, 0, 32'h11111111, 0); 
    read_icache(32'd332, 0, 32'h11111111, 0); 
    read_icache(32'd336, 0, 32'h11111111, 0); 
    read_icache(32'd340, 0, 32'h11111111, 0); 
    read_icache(32'd344, 0, 32'h11111111, 0); 
    read_icache(32'd348, 0, 32'h11111111, 0); 
    read_icache(32'd352, 0, 32'h11111111, 0); 
    read_icache(32'd356, 0, 32'h11111111, 0); 
    read_icache(32'd360, 0, 32'h11111111, 0);
    read_icache(32'd364, 0, 32'h11111111, 0);*/

    read_icache({24'hffffff, 2'b11, 4'b0000, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0001, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0010, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0011, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0100, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0101, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0110, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0111, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1000, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1001, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1010, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1011, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1100, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1101, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1110, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1111, 2'b11}, 0, 0 , 0);

    read_icache({24'h000000, 2'b00, 4'b0000, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b0001, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b0010, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b0011, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b0100, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b0101, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b0110, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b0111, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b1000, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b1001, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b1010, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b1011, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b1100, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b1101, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b1110, 2'b00}, 0, 0 , 0);
    read_icache({24'h000000, 2'b00, 4'b1111, 2'b00}, 0, 0 , 0);

    read_icache({24'hffffff, 2'b11, 4'b0000, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0001, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0010, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0011, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0100, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0101, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0110, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b0111, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1000, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1001, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1010, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1011, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1100, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1101, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1110, 2'b11}, 0, 0 , 0);
    read_icache({24'hffffff, 2'b11, 4'b1111, 2'b11}, 0, 0 , 0);

    reset_dut();

  end 
endprogram
