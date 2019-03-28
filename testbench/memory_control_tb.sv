/*
  Cody Mann
  mann53@purdue.edu

  memory control test bench
*/

// mapped needs this
`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"
`include "cpu_ram_if.vh"

// import statements
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  // parameter definitions
  parameter PERIOD = 10;

  // number of cpus for cc
  parameter CPUS = 2;

  logic CLK = 0, nRST;

  // variables for dump memory
  cpu_types_pkg::word_t mem_addr, mem_load;
  logic mem_REN;

  // clock generation block
  always #(PERIOD/2) CLK++;

  // interface
  // coherence interface
  caches_if                 cif0();
  caches_if                cif1();
  cache_control_if #(.CPUS(CPUS))   ccif (cif0, cif1);
  cpu_ram_if ramif();

  // DUT declarations
  `ifndef MAPPED
    memory_control DUT(CLK, nRST, ccif);
    ram RAM(CLK, nRST, ramif);
  `else
    memory_control DUT(
      .\CLK (CLK), 
      .\nRST (nRST), 
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

  /***************Assign statements ********************/

  // assign statements memory control -> ram
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ramif.ramstore = ccif.ramstore;

  // assign statements ram -> memory control
  assign ccif.ramload = ramif.ramload;
  assign ccif.ramstate = ramif.ramstate;

  /***************Program Calls********************/
  // test program
  test PROG (
    .CLK(CLK),
    .nRST(nRST),
    .ccif (ccif),
    .ramif(ramif)
    );

endmodule

program test
  // modports
  (
  cache_control_if.cc ccif,
  cpu_ram_if.ram ramif,
  input logic CLK,
  output logic nRST
  );

/*********************** Variable Definitions *************************/
  int test_case_num;
  string test_description;

/*********************** Parameter Definitions *************************/
  parameter PERIOD = 10;

/*********************** Struct Definitions *************************/

/*********************** Task Definitions *************************/
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

  //Checks for correct snoop addresses and ccinv signals sent from one processor 
  // to the memory controller and then out to the non-requesting cache
  task check_coherence_signals; 
  begin 
    input logic processor_num; 
    input word_t daddr; 
    input logic dWEN; 
    input string test_case_description; 
    begin
      // if checking signals sent to cache1
      if (processor_num == 0) begin 
        // if the snoop address and daddr do not match 
        if (cif1.ccsnoopaddr != daddr) begin 
          $display("Time %00g The snoopaddres is not correct from 
                    cache1 for test case: %s"$time, test_description)
          $display("Expected snoop address: 0x%h. Given snoop address: 0x%h", 
                    daddr, cif1.ccsnoopaddr); 
        end 

        // if the invalidate signal is not correct 
        if (cif1.ccinv != dWEN) begin 
          $display("Time %00g The invalidate signal is not correct from 
                    cache1 for test case: %s"$time, test_description)
          $display("Expected ccinv: %d. Given ccinv: %d", 
                    dWEN, cif1.ccinv); 
        end 
      end 
      // else checking signals that were sent to cache0
      else begin 
        // if the snoop address and daddr do not match 
        if (cif0.ccsnoopaddr != daddr) begin 
          $display("Time %00g The snoopaddres is not correct from 
                    cache0 for test case: %s"$time, test_description)
          $display("Expected snoop address: 0x%h. Given snoop address: 0x%h", 
                    daddr, cif0.ccsnoopaddr); 
        end 

        // if the invalidate signal is not correct 
        if (cif0.ccinv != dWEN) begin 
          $display("Time %00g The invalidate signal is not correct from 
                    cache0 for test case: %s"$time, test_description)
          $display("Expected ccinv: %d. Given ccinv: %d", 
                    dWEN, cif0.ccinv); 
      end 
    end 
  endtask

  // Will wait for the snoop address and ccinv signal to be sent from controller.
  // The task will check to make sure that the requestors daddr and dWEN match up with
  // the snoop address and ccinv signals provided by the controller. 
  task perform_cache_coherence; 
  begin 
    input logic processor0,
                dWEN0, 
                dREN0,
                processor1,
                dWEN1, 
                dREN1;
    input word_t daddr0, 
                 daddr1; 
    input string test_case_description; 
    begin 
          // if processor 0 is requestor or both processors request at the same time
          if (processor0 == 1) begin 
            // at the next posedge of clock, let the memory controller 
            // know that the non-requesting cache is performing coherence operations
            @(posedge CLK); 
            cif1.cctrans = 1'b1; 

            // check the snoopaddr and the ccinv 
            #(1)
            check_coherence_signals(0, daddr0,dWEN0, test_case_description);

            // On the next posedge of the clock cycle tell the memory controller 
            // that the non-requesting cache is done with its coherence operations.
            @(posedge CLK); 
            cif1.cctrans = 1'b0; 
          end
          // if processor 1 is the requestor 
          else if (processor1 == 1) begin 
            // at the next posedge of clock, let the memory controller 
            // know that the non-requesting cache is performing coherence operations
            @(posedge CLK); 
            cif0.cctrans = 1'b1; 

            // check the snoopaddr and the ccinv 
            #(1)
            check_coherence_signals(1, daddr1,dWEN1, test_case_description);

            // On the next posedge of the clock cycle tell the memory controller 
            // that the non-requesting cache is done with its coherence operations.
            @(posedge CLK); 
            cif0.cctrans = 1'b0; 
          end    
    end 
  endtask

  // applies signals to request memory from controller
  task trigger_memory_request; 
  begin 
    input logic processor0,
                dWEN0, 
                dREN0,  
                processor1,
                dWEN1, 
                dREN1; 
    begin
      // at posedge of the clock 
      @(posedge CLK);
      // apply inputs to process a request from processor0 
      cif0.dWEN = processor0 & dWEN0; 
      cif0.dREN = processor0 & dREN0; 
      // apply inputs to process a request from processor1
      cif1.dWEN = processor1 & dWEN1; 
      cif1.dREN = processor1 & dREN1; 
    end
    end 
  endtask

  task relinquish_request
  begin 
    begin
      // wait unitl the ccwait goes back down
      // which means the memory controller is granting the cache to 
      // go off and service request from its processor
      wait((cif0.ccwait == 0) & (cif1.ccwait == 0));  
    end 
  endtask

  // performs the whole process of a memory request from one of the caches
  task perform_memory_request; 
  begin 
    input logic processor0,
                dWEN0, 
                dREN0, 
                processor1,
                dWEN1, 
                dREN1;
    input word_t daddr0, 
                 daddr1;  
    input string test_case_description; 
      begin
        // apply the propper signals to request memory from controller=
        trigger_memory_request(processor0, 
                               dWEN0, 
                               dREN0, 
                               processor1
                               dWEN1, 
                               dREN1); 
        #(5)

        // wait for a ccwait signal to both processors so that their cpus are 
        // halted during a coherence update
        wait((cif0.ccwait == 1) & (cif1.ccwait == 1)); 

        // check to make sure that propper snooping anc coherence signals are sent 
        // from one cache to the other
        perform_cache_coherence(processor0, 
                                dWEN0, 
                                dREN0, 
                                processor1, 
                                dWEN1, 
                                dWEN1, 
                                daddr0, 
                                daddr1, 
                                test_description); 

        // Process data block 
        process_block(); 

        // wait for memory controller to relinquish the memory request 
        relinquish_request; 

      end 
  endtask

  // used to dump the contents of ram back inot memcpu.hex
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



/*********************** Initial Block *************************/
  initial begin

    dump_memory();
  end
endprogram
