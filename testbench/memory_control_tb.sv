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


/*********************** Parameters Definitions *************************/
  // enumberation to describe what type of memory request the test case will be
  typedef enum logic [1:0]{
    DATA_READ = 2'd0, 
    DATA_WRITE = 2'd1, 
    INSTRUCTION_READ = 2'd2, 
    NONE = 2'd3
  }request_type; 

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

  // task to request a cache instruction memory request
  task cache_instruction_memory_request; 
  begin 
    input logic cache_num; 
    input word_t address; 
    begin
      // wait for next clock cycle before applying inputs 
      @(posedge CLK); 

      // if cache0 instruction request
      if (cache_num == 0) begin 
        cif0.iREN = 1'b1; 
        cif0.iaddr = address; 
      end 
      // cache1 instruction request
      else begin 
        cif1.iREN = 1'b1; 
        cif1.iaddr = address; 
      end  
    end 
  endtask

  // task to create a cache data memory request
  task cache_data_memory_request;
  begin 
    input logic cache_num;
    input logic write; 
    input word_t address; 
    begin 
      // wait for next clock cycle before applying inputs 
      @(posedge CLK); 

      // if cache0 is making a request 
      if (cache_num == 0) begin 
        cif0.dWEN = write;
        cif0.dREN = ~write;  
        cif0.daddr = address;
        cif0.dstore = 32'habcdef;  
      end 
      // else cache1 is making a request
      else begin
        cif1.dWEN = write; 
        cif1.dREN = ~write; 
        cif1.daddr = address;
        cif1.dstore = 32'habcdef;  
      end 
  endtask

  // task to relieve a cache request inputs 
  task deasert_inputs; 
  begin 
    begin 
        // deasert the inputs on next clock cycle
        @(posedge CLK); 
        // inputs from cache0
        cif0.iREN = 1'b0; 
        cif0.dREN = 1'b0; 
        cif0.dWEN = 1'b0; 
        cif0.iaddr = 32'd0; 
        cif0.daddr = 32'd0; 
        // inputs from cache1
        cif1.iREN = 1'b0; 
        cif1.dREN = 1'b0; 
        cif1.dWEN = 1'b0; 
        cif1.iaddr = 32'd0; 
        cif1.daddr = 32'd0; 
      end 
    end 
  endtask

  // applys cache requests based on what the test case asks for
  task apply_cache_requests; 
    input logic cache0_request, 
                cache1_request;
    input request_type cache0_request_type, 
                       cache1_request_type; 
    input word_t address; 
    begin 
      // if cache0 is to perform a request 
      if (cache0_request == 1) begin 
        // determine what type of request cache0 is to make 
        casez (cache0_request_type) 
          DATA_READ: cache_data_memory_request(0, 0, address); 
          DATA_WRITE: cache_data_memory_request(0, 1, address); 
          INSTRUCTION_READ: cache_instruction_memory_request(0,address); 
        endcase
      end 

      // if cache1 is to perform a request 
      if (cache1_request == 1) begin 
        // determine what type of request cache1 is to make 
        casez (cache1_request_type) 
          DATA_READ: cache_data_memory_request(1, 0, address); 
          DATA_WRITE: cache_data_memory_request(1, 1, address); 
          INSTRUCTION_READ: cache_instruction_memory_request(0,address); 
        endcase
      end
    end 
  endtask 

  task check_snooping; 
  begin 
    input logic cache_num; 
    input word_t expected_ccsnoopaddr; 
    input logic expected_ccinv; 
    begin
      // if checking cache0 snoop address
      if (cache_num == 0) begin 
        // check the snoop address
        if (cif0.ccsnoopaddr != expected_ccsnoopaddr) begin 
          $display("Time %00gns The ccsnoopaddr to cache0 is not correct. Expecting 0x%h."$time, expected_ccsnoopaddr); 
        end 

        // checking the invalidate signal 
        if (cif0.ccinv != expected_ccinv) begin 
          $display("Time %00gns The ccinv to cache0 is not correct. Expecting %d."$time, expected_ccinv);
        end 
      end
      // else checking cache1
      else begin 
        // check the snoop address
        if (cif1.ccsnoopaddr != expected_ccsnoopaddr) begin 
          $display("Time %00gns The ccsnoopaddr to cache1 is not correct. Expecting 0x%h."$time, expected_ccsnoopaddr); 
        end 

        // checking the invalidate signal 
        if (cif1.ccinv != expected_ccinv) begin 
          $display("Time %00gns The ccinv to cache1 is not correct. Expecting %d."$time, expected_ccinv);
        end 
      end  
    end 
  endtask

  // runs through a data_write_process
  task data_write_process; 
  begin 
    input logic cache_num; 
    input word_t address; 
    begin 
    // if cache0 was the requestor
    if (cache_num == 0) begin 
      // wait for cache0 dwait to go low 
      wait(cif0.dwait == 0); 
      // increment the address to next block but just keep data the same
      cif0.daddr = address + 4; 
      // wait a little to allow knew address to settle 
      #(1)
      // wait for last dwait to go low
      wait (cif0.dwait == 0); 
    end
    // else cache1 was the requestor
    else begin 
      // wait for cache1 dwait to go low 
      wait(cif1.dwait == 0); 
      //increment the address to next block but just keep data the same
      cif1.daddr = address + 4; 
      // wait a little to allow knew address to settle 
      #(1)
      // wait for last dwait to go low
      wait (cif1.dwait == 0); 
    end
  end 
  endtask

  // runs through a data read process (note: needs to be written)
  task data_read_process; 
  begin 
    input logic cache_num; 
    input word_t address;
    input logic non_requesting_cache_wb;  
    begin 
      // if cache request for cache0
      if (cache_num == 0) begin  
        // check to make sure that the memory controller has provided the correct cache with snoop address and invalidate signal
        check_snooping(~cache_num, address, 0); 
        // if a the non-requesting cache is supposed to do the wb 
        if ( non_requesting_cache_wb == 1) begin 
        end 
        // else memory controller should go to ram 
        else begin 
          // at the next clock cycle apply signals to memory controller 
          // to say that non-requesting cache is done transitioning and does not have the block to write back
          @(posedge CLK); 
          cif1.cctrans = 1'b1;
          cif1.ccwrite = 1'b0; 

          //at the next clock cycle bring cctrans low 
          @(posedge CLK); 
          cif1.cctrans = 1'b0; 

          // wait for memory controller to give the requesting cache0 two dwaits in a row (wb block from ram to cache0)
          wait(cif0.dwait == 0); 
          #(1)
          wait(cif0.dwait == 0); 

          // process is finished and the memory controller should now be back in the idle state
        end 
      end 
      // else the cache request is for cache1
      else begin 
      end 
    end 
  endtask

  // runs through a instruction read process
  task instruction_read_process;
  begin 
    input logic cache_num; 
    input word_t address; 
    begin 
      // if cache request is from cache0
      if (cache_num == 0) begin 
      end 
      // else the cache request is for cache1
      else begin 
      end 
    end 
  endtask 

  // runs through a cache 0 request
  task run_cache0_request; 
  begin 
    input request_type cache0_request_type; 
    input word_t address;
    input logic non_requesting_cache_wb;   
    begin 
      // check what type of request this is 
      casez(cache0_request_type)
        DATA_READ: data_read_process(0, address, non_requesting_cache_wb); 
        DATA_WRITE: data_write_process(0, address); 
        INSTRUCTION_READ: instruction_read_process(0, address); 
      endcase
    end 
  endtask

  // runs through a cache 1 request
  task run_cache1_request; 
  begin 
    input request_type cache1_request_type; 
    input word_t address; 
    input logic non_requesting_cache_wb; 
    begin 
      // check what type of request this is 
      casez(cache1_request_type)
        DATA_READ: data_read_process(1, address, non_requesting_cache_wb); 
        DATA_WRITE: data_write_process(1, address); 
        INSTRUCTION_READ: instruction_read_process(1, address); 
      endcase
    end 
  endtask

  // task to perform a given test case
  task perform_test_case; 
  begin
    input logic cache0_request, 
                cache1_request, 
                non_requesting_cache_wb; 
    input request_type cache0_request_type, 
                       cache1_request_type; 
    input word_t address; 
    begin 

      // for the given test case, apply the proper cache requests to the memory controller
      apply_cache_requests(cache0_request, 
                           cache1_request, 
                           cache0_request_type, 
                           cache1_request_type, 
                           address); 

      // wait a little to allow inputs to settle 
      #(1)
      // if cache0 is a requestor 
      if (cache0_request == 1) begin 
        // Run through the service of cache0 request
        run_cache0_request(cache0_request_type, address, data, non_requesting_cache_wb); 
      end 
      // else if cache0 is a requestor 
      else if (cache1_request == 1) begin 
        // run through the service of cache1 request
      end 

      // remove the inputs to the memory controller 
      // because the chosen cache request has been serviced
      deasert_inputs; 

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

  // initialize inputs 
  nRST = 1'b1; 
  cif0.iREN = 1'b0; 
  cif0.dREN = 1'b0; 
  cif0.dWEN = 1'b0; 
  cif0.iaddr = 32'd0; 
  cif0.daddr = 32'd0;
  cif0.ccwrite = 1'b0; 
  cif0.cctrans = 1'b0;  
  cif1.iREN = 1'b0; 
  cif1.dREN = 1'b0; 
  cif1.dWEN = 1'b0; 
  cif1.iaddr = 32'd0; 
  cif1.daddr = 32'd0;
  cif1.ccwrite = 1'b0; 
  cif1.cctrans = 1'b0; 
  // initialize testbench signals
  test_case_num = 0; 
  test_description = "NULL";  

  /****************************************************************
  *
  *   
  * Test Case #1: Testing for cache0 request memory read and is provided by ram. 
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Testing for cache0 request memory read and is provided by ram."

  reset_dut();
  perform_test_case(1, 0, 0, DATA_READ, NONE, 32'h1C); 

  dump_memory();
  end

endprogram
