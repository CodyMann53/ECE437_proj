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

  // performs the whole process of a memory request from one of the caces 
  task perform_memory_request; 
  begin 
      input logic processor0,
                dWEN0, 
                dREN0, 
                processor1,
                dWEN1, 
                dREN1; 
      begin
        // apply the propper signals to request memory from controller=
        trigger_memory_request(processor0, 
                               dWEN0, 
                               dREN0, 
                               processor1
                               dWEN1, 
                               dREN1); 
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
