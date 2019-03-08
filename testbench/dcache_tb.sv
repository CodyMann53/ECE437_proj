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
  caches_if                 cif0();

  // cif1 will not be used, but ccif expects it as an input
  caches_if                cif1();
  cache_control_if #(.CPUS(1))   ccif (cif0, cif1);
  cpu_ram_if ramif();

  // DUT
  `ifndef MAPPED
    dcache DUT(CLK, nRST, dcif, cif0);
    memory_control DUT_MEMORY_CONTROL(ccif);
    ram RAM(CLK, nRST, ramif);
  `else
    dcache DUT(
      .\dcif.dhit (dcif.dhit), 
      .\dcif.dmemREN(dcif.dmemREN), 
      .\dcif.dmemWEN (dcif.dmemWEN), 
      .\dcif.dmemstore(dcif.dmemstore), 
      .\dcif.dmemaddr (dcif.dmemaddr), 
      .\dcif.dmemload (dcif.dmemload),
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

/*******************  CONNECTIONS ********************/

  // assign statements memory control -> ram
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ramif.ramstore = ccif.ramstore;

  // assign statements ram -> memory control
  assign ccif.ramload = ramif.ramload;
  assign ccif.ramstate = ramif.ramstate;

  //assign dcache -> memory control 
  //assign ccif.dREN = cif0.dREN; 
  //assign ccif.dWEN = cif0.dWEN; 
  //assign ccif.daddr = cif0.daddr; 
  //assign ccif.dstore = cif0.dstore; 

  // assign memory control -> dcache 
  //assign cif0.dwait = ccif.dwait; 
  //assign cif0.dload = ccif.dload; 


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

  // Data and address testbench variables 
  dcachef_t [4:0] address_stream;
  word_t [31:0] data;  

/******************* TEST VECTORS ********************/

/******************* TEST TASK DEFINITIONS ********************/

  // checks the read data from dcache
  task check_data_read; 
    input dcachef_t byte_address; 
    input word_t exp_data; 
    begin 
      // if the data output from dcache is not the same as expected
      if (dcif.dmemload != exp_data) begin
        // raise an error 
        $display("Time: %00gns Expecting %0d to be read from byte_address 0x%0h and not %0d.", $time, exp_data, byte_address, dcif.dmemload); 
      end 
    end 
  endtask 

  // task to wait for a request to cache to complete and then checks for a valid dhit
  task complete_transaction;
    input dcachef_t byte_address; 
    input logic block_present; 
    begin
      integer count;
      // wait a little to allow inputs to settle 
      #(10)
      count = 0; 
      // wait for transaction to complete between dcache and memory or just move on because tag is already in the cache and no write dirty contents to memory should occur. 
      while(dcif.dhit == 0) begin 
        @(posedge CLK); 
        count += 1; 
      end  

      // If block was expected to be present in the dcache 
      if (block_present == 1) begin 
        // if dhit was not given back in same clock cycle 
        if (count != 0) begin
          // flag an error message 
          $display("Time: %00gns Dhit was not given back in same clock cycle for byte_address: 0x%0h that was expected to be in cache.", $time, byte_address); 
        end 
      end

      // remove the dcache inputs 
      remove_dcache_inputs(); 
    end 
  endtask

  // requests a read from the dcache
  task request_read; 
    input dcachef_t byte_address; 
    begin 
      // get away from the negative edge of clock 
      @(negedge CLK); 
      // apply propper inputs to cache for a read
      dcif.halt = 1'b0; 
      dcif.dmemREN = 1'b1; 
      dcif.dmemWEN = 1'b0; 
      dcif.dmemstore = 32'd0; 
      dcif.dmemaddr = byte_address; 
    end 
  endtask 

  // requests a write to the dcache
  task request_write; 
    input dcachef_t byte_address; 
    input word_t data; 
    begin 
      // get away from the negative edge of clock 
      @(negedge CLK); 
      // apply propper inputs to cache for a write
      dcif.halt = 1'b0; 
      dcif.dmemREN = 1'b0; 
      dcif.dmemWEN = 1'b1; 
      dcif.dmemstore = data; 
      dcif.dmemaddr = byte_address; 
    end 
  endtask

  // clears the inputs to the dcache
  task remove_dcache_inputs; 
    begin 
      // get away from the negative edge of clock cycle
      @(negedge CLK); 
      dcif.halt = 1'b0; 
      dcif.dmemREN = 1'b0; 
      dcif.dmemWEN = 1'b0; 
      dcif.dmemstore = 32'd0; 
      dcif.dmemaddr = 32'd0; 
    end 
  endtask

  // task to read from the dcache
  task read_dcache;
    input dcachef_t byte_address;
    input logic block_present;  
    input word_t exp_data; 
    input logic check_data; 
    begin
      // request a read from the dcache
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
    end 
  endtask

    // task to write to the dcache 
  task write_dcache;
    input dcachef_t byte_address; 
    input block_present; 
    input word_t data; 
    begin
      // request a write from the dcache 
      request_write(byte_address, data); 
      // wait for the transaction to complete and check for valid dhit 
      complete_transaction(byte_address, block_present); 
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

  // dumps the meory from ram at end of testbench
  task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    cif0.daddr = 0;
    cif0.dREN = 0;
    cif0.dWEN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif0.daddr = i << 2;
      cif0.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif0.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin

      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask

/******************* TEST INITIAL BLOCK ********************/
  initial begin


    /******************* START RUNNING THROUGH TEST CASES ********************/
    // initialize all inputs 
    remove_dcache_inputs;
    // reset the system
    reset_dut();

    /************************************
    *
    *       Test case 1: Testing for a compulsory miss
    *
    ************************************/
    test_description = "Testing for compulsory misses.";

    // reads
    read_dcache(32'd0, 0, 0, 0); 
    read_dcache(32'd0, 1, 0, 0); 
    read_dcache(32'd0, 1, 0, 0);

    // dump the memory into memcpu.hex after testbench is finished 
    //dump_memory(); 
  end 
endprogram
