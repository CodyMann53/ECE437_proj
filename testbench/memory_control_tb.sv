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
  word_t data, data2, address; 
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
    input logic cache_num;
    input logic write; 
    input word_t address; 
    input logic invalidate; 
    begin 
      // wait for next clock cycle before applying inputs 
      @(posedge CLK); 

      // if cache0 is making a request 
      if (cache_num == 0) begin 
        cif0.dWEN = write;
        cif0.dREN = ~write;  
        cif0.daddr = address;
        cif0.dstore = data;
        cif1.dstore = data;  
        cif0.ccwrite = invalidate; 
      end 
      // else cache1 is making a request
      else begin
        cif1.dWEN = write; 
        cif1.dREN = ~write; 
        cif1.daddr = address;
        cif1.dstore = data; 
        cif0.dstore = data;  
        cif1.ccwrite = invalidate; 
      end 
    end 
  endtask

  // task to relieve a cache request inputs 
  task deasert_inputs; 
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
  endtask

  // applys cache requests based on what the test case asks for
  task apply_cache_requests; 
    input logic cache0_request, 
                cache1_request;
    input request_type cache0_request_type, 
                       cache1_request_type; 
    input word_t address;
    input logic invalidate;  
    begin 
      // if cache0 is to perform a request 
      if (cache0_request == 1) begin 
        // determine what type of request cache0 is to make 
        casez (cache0_request_type) 
          DATA_READ: cache_data_memory_request(0, 0, address, invalidate); 
          DATA_WRITE: cache_data_memory_request(0, 1, address, invalidate); 
          INSTRUCTION_READ: cache_instruction_memory_request(0,address); 
        endcase
      end 

      // if cache1 is to perform a request 
      if (cache1_request == 1) begin 
        // determine what type of request cache1 is to make 
        casez (cache1_request_type) 
          DATA_READ: cache_data_memory_request(1, 0, address, invalidate); 
          DATA_WRITE: cache_data_memory_request(1, 1, address, invalidate); 
          INSTRUCTION_READ: cache_instruction_memory_request(1,address); 
        endcase
      end
    end 
  endtask 

  task check_cache0_coherence_outputs; 
    input word_t expected_ccsnoopaddr; 
    input logic expected_ccinv, 
                expected_ccwait; 
    begin
      // check the snoop address
      if (cif0.ccsnoopaddr != expected_ccsnoopaddr) begin 
        $display("Time %00gns The ccsnoopaddr to cache0 is not correct. Expecting 0x%h.", $time, expected_ccsnoopaddr); 
      end 

      // checking the invalidate signal 
      if (cif0.ccinv != expected_ccinv) begin 
        $display("Time %00gns The ccinv to cache0 is not correct. Expecting %d.", $time, expected_ccinv);
      end 

      // checking the ccwait signal 
      if (cif0.ccwait != expected_ccwait) begin 
        $display("Time %00gns The ccwait to cache0 is not correct. Expecting %d.", $time, expected_ccwait);
      end 
    end 
  endtask

  task check_cache1_coherence_outputs; 
    input word_t expected_ccsnoopaddr; 
    input logic expected_ccinv, 
                expected_ccwait; 
    begin
      // check the snoop address
      if (cif1.ccsnoopaddr != expected_ccsnoopaddr) begin 
        $display("Time %00gns The ccsnoopaddr to cache1 is not correct. Expecting 0x%h.", $time, expected_ccsnoopaddr); 
      end 

      // checking the invalidate signal 
      if (cif1.ccinv != expected_ccinv) begin 
        $display("Time %00gns The ccinv to cache1 is not correct. Expecting %d.", $time, expected_ccinv);
      end 

      // checking the ccwait signal 
      if (cif1.ccwait != expected_ccwait) begin 
        $display("Time %00gns The ccwait to cache1 is not correct. Expecting %d.", $time, expected_ccwait);
      end 
    end 
  endtask

  task check_ram_outputs; 
    input word_t expected_ramstore,
                 expected_ramaddr; 
    input logic expected_ramWEN, 
                expected_ramREN; 
    begin 
      // check ramstore 
      if (ccif.ramstore != expected_ramstore) begin 
        $display("Time %00gns The ramstore is not correct. Expecting 0x%h.", $time, expected_ramstore); 
      end 
      // check ramaddr
      if (ccif.ramaddr != expected_ramaddr) begin 
        $display("Time %00gns The ramaddr is not correct. Expecting 0x%h.", $time, expected_ramaddr); 
      end 
      // check ramWEN
      if (ccif.ramWEN != expected_ramWEN) begin 
        $display("Time %00gns The ramWEN is not correct. Expecting 0x%h.", $time, expected_ramWEN); 
      end 
      // check ramREN
      if (ccif.ramREN != expected_ramREN) begin 
        $display("Time %00gns The ramREN is not correct. Expecting 0x%h.", $time, expected_ramREN); 
      end 
    end 
  endtask

  // check the cache outputs 
  task check_cache0_outputs; 
    input logic expected_iwait, 
                expected_dwait; 
    input word_t expected_iload, 
                 expected_dload; 
    begin
      // check iwait 
      if (cif0.iwait != expected_iwait) begin 
        $display("Time %00gns The iwait to cache0 is not correct. Expecting 0x%h.", $time, expected_iwait); 
      end 
      // check dwait 
      if (cif0.dwait != expected_dwait) begin 
        $display("Time %00gns The dwait to cache0 is not correct. Expecting 0x%h.", $time, expected_dwait); 
      end 
      // check iload 
      if (cif0.iload != expected_iload) begin 
        $display("Time %00gns The iload to cache0 is not correct. Expecting 0x%h.", $time, expected_iload); 
      end
      // check dload 
      if (cif0.dload != expected_dload) begin 
        $display("Time %00gns The dload to cache0 is not correct. Expecting 0x%h.", $time, expected_dload); 
      end
    end 
  endtask

  // check the cache outputs 
  task check_cache1_outputs; 
    input logic expected_iwait, 
                expected_dwait; 
    input word_t expected_iload, 
                 expected_dload; 
    begin
      // check iwait 
      if (cif1.iwait != expected_iwait) begin 
        $display("Time %00gns The iwait to cache1 is not correct. Expecting 0x%h.", $time, expected_iwait); 
      end 
      // check dwait 
      if (cif1.dwait != expected_dwait) begin 
        $display("Time %00gns The dwait to cache1 is not correct. Expecting 0x%h.", $time, expected_dwait); 
      end 
      // check iload 
      if (cif1.iload != expected_iload) begin 
        $display("Time %00gns The iload to cache1 is not correct. Expecting 0x%h.", $time, expected_iload); 
      end
      // check dload 
      if (cif1.dload != expected_dload) begin 
        $display("Time %00gns The dload to cache1 is not correct. Expecting 0x%h.", $time, expected_dload); 
      end
    end 
  endtask

  // runs through a data_write_process
  task data_write_process_cache0;  
    input word_t address; 
    begin
        // wait one more clock cycle for memory controller to move out of its idle state
        @(posedge CLK); 
        #(1)
        // check to make sure that inputs to ram are correct
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, //ccinv
                                         0 // ccwait
                                         ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(data, // ramstore
                                address, // ramaddr
                                1, // ramWEN
                                0  // ramREN
                                );  

        // wait for ram state to give access
        wait(ccif.ramstate == ACCESS);
        //increment the address by 4
        cif0.daddr = address + 4; 
        #(5)

        // check to make sure that inputs to ram are correct
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, //ccinv
                                         0 // ccwait
                                         ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(data, // ramstore
                                address + 4, // ramaddr
                                1, // ramWEN
                                0  // ramREN
                                );  

        // wait for one more access
        wait(ccif.ramstate == ACCESS);
        // wait a clock cycle and then check to make sure that inputs were removed 
        @(posedge CLK); 
        // deasert the inputs to ram 
        deasert_inputs; 
        @(posedge CLK)
        // check to make sure that inputs to ram are correct
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, //ccinv
                                         0 // ccwait
                                         ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                                32'd0, // ramaddr
                                0, // ramWEN
                                0  // ramREN
                                );  
    end  
  endtask

  // runs through a data_write_process
  task data_write_process_cache1;  
    input word_t address; 
    begin
        // wait one more clock cycle for memory controller to move out of its idle state
        @(posedge CLK); 
        #(1)
        // check to make sure that inputs to ram are correct
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, //ccinv
                                         0 // ccwait
                                         ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(data, // ramstore
                                address, // ramaddr
                                1, // ramWEN
                                0  // ramREN
                                );  

        // wait for ram state to give access
        wait(ccif.ramstate == ACCESS);
        //increment the address by 4
        cif1.daddr = address + 4; 
        #(5)

        // check to make sure that inputs to ram are correct
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, //ccinv
                                         0 // ccwait
                                         ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(data, // ramstore
                                address + 4, // ramaddr
                                1, // ramWEN
                                0  // ramREN
                                );  

        // wait for one more access
        wait(ccif.ramstate == ACCESS);
        // wait a clock cycle and then check to make sure that inputs were removed 
        @(posedge CLK); 
        // deasert the inputs to ram 
        deasert_inputs; 
        @(posedge CLK)
        // check to make sure that inputs to ram are correct
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, //ccinv
                                         0 // ccwait
                                         ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                                32'd0, // ramaddr
                                0, // ramWEN
                                0  // ramREN
                                );  
    end  
  endtask

  // runs through a data read process 
  task data_read_process_cache0; 
    input word_t address;
    input logic non_requesting_cache_wb, 
                invalidate; 
    begin 
      // if a the non-requesting cache is supposed to do the wb 
      if ( non_requesting_cache_wb == 1) begin 
        // wait one clock cycle for the memory controller transfer into the grant cache stage
        @(posedge CLK); 
        // wait another clock cycle for the memory controller to latch coherence signals
        @(posedge CLK); 

        // check to make sure that the memory controller has provided the correct coherence signals to cache1
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache1_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                                32'd0, // ramaddr
                                0, // ramWEN
                                0  // ramREN
                                ); 

        // wait another clock cycle to mimic cache controller changing states 
        @(posedge CLK); 
        // tell memory controller that done transitioning states
        // and that it wants to do a write back
        cif1.cctrans = 1'b1;
        cif1.ccwrite = 1'b1;

        // wait another clock cycle for the memory controller to move to wb1
        @(posedge CLK); 
        cif1.daddr = address; 
        cif1.cctrans = 1'b0;
        #(1)
        // check to make sure correct routing of wb signals
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache1_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               data // dload
                               ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(data, // ramstore
                                address, // ramaddr
                                1, // ramWEN
                                0  // ramREN
                                );

        // wait for ram to give back access before checking
        wait(ccif.ramstate == ACCESS); 
        // wait one clock cycle to allow memory controller to move to wb2
        @(posedge CLK); 
        // Increment address by 4 that non-requesting cache supplies 
        cif1.daddr = address + 4; 

        #(1)
        // check to make sure correct routing of wb signals
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache1_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               data // dload
                               ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(data, // ramstore
                                address + 4, // ramaddr
                                1, // ramWEN
                                0  // ramREN
                                );

        // wait for ram to respond
        wait(ccif.ramstate == ACCESS); 
        // remove the inputs to the memory controller 
        // because the chosen cache request has been serviced
        deasert_inputs; 
        @(posedge CLK); 
        // make sure signals go back to their idle values 
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache1_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         0 // ccwait
                                         ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                            32'd0, // ramaddr
                                0, // ramWEN
                                0  // ramREN
                                );
      end 
      // else memory controller should go to ram for data 
      else begin
        // wait one clock cycle for the memory controller transfer into the grant cache stage
        @(posedge CLK); 
        // wait another clock cycle for the memory controller to latch coherence signals
        @(posedge CLK); 

        // check to make sure that the memory controller has provided the correct coherence signals to cache1
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache1_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                                32'd0, // ramaddr
                                0, // ramWEN
                                0  // ramREN
                                ); 

        // wait another clock cycle to mimic cache controller changing states 
        @(posedge CLK); 
        // tell memory controller that it should go to ram for data
        cif1.cctrans = 1'b1;
        cif1.ccwrite = 1'b0;

        // wait another clock cycle for the memory controller to move to ram wb1
        @(posedge CLK);  
        cif1.cctrans = 1'b0;
        #(1)
        // check to make sure correct routing of wb signals
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache1_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               data // dload
                               ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                                address, // ramaddr
                                0, // ramWEN
                                1  // ramREN
                                );

        // wait for ram to give back access before checking
        wait(ccif.ramstate == ACCESS); 
        // wait one clock cycle to allow memory controller to move to wb2
        @(posedge CLK); 
        // Increment address by 4 that non-requesting cache supplies 
        cif1.daddr = address + 4; 

        #(1)
        // check to make sure correct routing of wb signals
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache1_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               data // dload
                               ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                                address + 4, // ramaddr
                                0, // ramWEN
                                1  // ramREN
                                );

        // wait for ram to respond
        wait(ccif.ramstate == ACCESS); 
        // remove the inputs to the memory controller 
        // because the chosen cache request has been serviced
        deasert_inputs; 
        @(posedge CLK); 
        // make sure signals go back to their idle values 
        check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache1_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         0 // ccwait
                                         ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                          32'd0, // ramaddr
                              0, // ramWEN
                              0  // ramREN
                              );
      end 
    end 
  endtask

    // runs through a data read process 
  task data_read_process_cache1; 
    input word_t address;
    input logic non_requesting_cache_wb, 
                invalidate; 
    begin 
      // if a the non-requesting cache is supposed to do the wb 
      if ( non_requesting_cache_wb == 1) begin 
        // wait one clock cycle for the memory controller transfer into the grant cache stage
        @(posedge CLK); 
        // wait another clock cycle for the memory controller to latch coherence signals
        @(posedge CLK); 

        // check to make sure that the memory controller has provided the correct coherence signals to cache1
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache0_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                                32'd0, // ramaddr
                                0, // ramWEN
                                0  // ramREN
                                ); 

        // wait another clock cycle to mimic cache controller changing states 
        @(posedge CLK); 
        // tell memory controller that done transitioning states
        // and that it wants to do a write back
        cif0.cctrans = 1'b1;
        cif0.ccwrite = 1'b1;

        // wait another clock cycle for the memory controller to move to wb1
        @(posedge CLK); 
        cif0.daddr = address; 
        cif0.cctrans = 1'b0;
        #(1)
        // check to make sure correct routing of wb signals
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache0_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               data // dload
                               ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(data, // ramstore
                                address, // ramaddr
                                1, // ramWEN
                                0  // ramREN
                                );

        // wait for ram to give back access before checking
        wait(ccif.ramstate == ACCESS); 
        // wait one clock cycle to allow memory controller to move to wb2
        @(posedge CLK); 
        // Increment address by 4 that non-requesting cache supplies 
        cif0.daddr = address + 4; 

        #(1)
        // check to make sure correct routing of wb signals
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache0_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               data // dload
                               ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(data, // ramstore
                                address + 4, // ramaddr
                                1, // ramWEN
                                0  // ramREN
                                );

        // wait for ram to respond
        wait(ccif.ramstate == ACCESS); 
        // remove the inputs to the memory controller 
        // because the chosen cache request has been serviced
        deasert_inputs; 
        @(posedge CLK); 
        // make sure signals go back to their idle values 
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache0_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         0 // ccwait
                                         ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                            32'd0, // ramaddr
                                0, // ramWEN
                                0  // ramREN
                                );
      end 
      // else memory controller should go to ram for data 
      else begin
        // wait one clock cycle for the memory controller transfer into the grant cache stage
        @(posedge CLK); 
        // wait another clock cycle for the memory controller to latch coherence signals
        @(posedge CLK); 

        // check to make sure that the memory controller has provided the correct coherence signals to cache1
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache0_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                                32'd0, // ramaddr
                                0, // ramWEN
                                0  // ramREN
                                ); 

        // wait another clock cycle to mimic cache controller changing states 
        @(posedge CLK); 
        // tell memory controller that it should go to ram for data
        cif0.cctrans = 1'b1;
        cif0.ccwrite = 1'b0;

        // wait another clock cycle for the memory controller to move to ram wb1
        @(posedge CLK);  
        cif0.cctrans = 1'b0;
        #(1)
        // check to make sure correct routing of wb signals
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache0_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               data // dload
                               ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                                address, // ramaddr
                                0, // ramWEN
                                1  // ramREN
                                );

        // wait for ram to give back access before checking
        wait(ccif.ramstate == ACCESS); 
        // wait one clock cycle to allow memory controller to move to wb2
        @(posedge CLK); 
        // Increment address by 4 that non-requesting cache supplies 
        cif0.daddr = address + 4; 

        #(1)
        // check to make sure correct routing of wb signals
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache0_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         1 // ccwait
                                         ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               data // dload
                               ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                                address + 4, // ramaddr
                                0, // ramWEN
                                1  // ramREN
                                );

        // wait for ram to respond
        wait(ccif.ramstate == ACCESS); 
        // remove the inputs to the memory controller 
        // because the chosen cache request has been serviced
        deasert_inputs; 
        @(posedge CLK); 
        // make sure signals go back to their idle values 
        check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                             0, // ccinv
                                             0 // ccwait
                                             ); 
        check_cache0_coherence_outputs(address, // ccsnoopaddr
                                         invalidate, //ccinv
                                         0 // ccwait
                                         ); 
        check_cache1_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_cache0_outputs(1, // iwait 
                               1, // dwait
                               32'd0, // iload
                               32'd0 // dload
                               ); 
        check_ram_outputs(32'd0, // ramstore
                          32'd0, // ramaddr
                              0, // ramWEN
                              0  // ramREN
                              );
      end 
    end 
  endtask

  // runs through a instruction read process
  task instruction_read_process_cache0; 
    input word_t address; 
    begin 
      // wait one clock cycle to allow state machine to transfer out of idle
      @(posedge CLK); 
      // check to make sure that memory controller has provided the correct signals to ram 
      check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, // ccinv
                                         0 // ccwait
                                          ); 
      check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                     0, //ccinv
                                     0 // ccwait
                                     ); 
      check_cache1_outputs(1, // iwait 
                           1, // dwait
                       32'd0, // iload
                       32'd0 // dload
                           ); 
      check_ram_outputs(32'd0, // ramstore
                            address, // ramaddr
                            0, // ramWEN
                            1  // ramREN
                            ); 

      // wait for ram state to give access back 
      wait(ccif.ramstate == ACCESS);
      // check to make sure that the correct instruction value is loaded
      check_cache0_outputs(0, // iwait 
                           1, // dwait
                           data, // iload
                           32'd0 // dload
                           );  
      #(5)

      // deasert the inputs to memory controller
      deasert_inputs(); 
      // wait for a clock cycle for memory controller to go back to idle 
      @(posedge CLK); 
      // check to make sure that memory controler has taken all the signals away from ram
      check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, // ccinv
                                         0 // ccwait
                                          ); 
      check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, //ccinv
                                         0 // ccwait
                                         ); 
      check_cache0_outputs(1, // iwait 
                           1, // dwait
                        32'd0, // iload
                        32'd0 // dload
                            ); 
      check_cache1_outputs(1, // iwait 
                           1, // dwait
                       32'd0, // iload
                       32'd0 // dload
                           ); 
      check_ram_outputs(32'd0, // ramstore
                            32'd0, // ramaddr
                            0, // ramWEN
                            0  // ramREN
                            ); 
    end 
  endtask 

    // runs through a instruction read process
  task instruction_read_process_cache1; 
    input word_t address; 
    begin 
      // wait one clock cycle to allow state machine to transfer out of idle
      @(posedge CLK); 
      // check to make sure that memory controller has provided the correct signals to ram 
      check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, // ccinv
                                         0 // ccwait
                                          ); 
      check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                     0, //ccinv
                                     0 // ccwait
                                     ); 
      check_cache0_outputs(1, // iwait 
                           1, // dwait
                       32'd0, // iload
                       32'd0 // dload
                           ); 
      check_ram_outputs(32'd0, // ramstore
                            address, // ramaddr
                            0, // ramWEN
                            1  // ramREN
                            ); 

      // wait for ram state to give access back 
      wait(ccif.ramstate == ACCESS);
      // check to make sure that the correct instruction value is loaded
      check_cache1_outputs(0, // iwait 
                           1, // dwait
                           data, // iload
                           32'd0 // dload
                           );  
      #(5)

      // deasert the inputs to memory controller
      deasert_inputs(); 
      // wait for a clock cycle for memory controller to go back to idle 
      @(posedge CLK); 
      // check to make sure that memory controler has taken all the signals away from ram
      check_cache1_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, // ccinv
                                         0 // ccwait
                                          ); 
      check_cache0_coherence_outputs(32'd0, // ccsnoopaddr
                                         0, //ccinv
                                         0 // ccwait
                                         ); 
      check_cache1_outputs(1, // iwait 
                           1, // dwait
                        32'd0, // iload
                        32'd0 // dload
                            ); 
      check_cache0_outputs(1, // iwait 
                           1, // dwait
                       32'd0, // iload
                       32'd0 // dload
                           ); 
      check_ram_outputs(32'd0, // ramstore
                            32'd0, // ramaddr
                            0, // ramWEN
                            0  // ramREN
                            ); 
    end 
  endtask 

  // runs through a cache 0 request
  task run_cache0_request; 
    input request_type cache0_request_type; 
    input word_t address;
    input logic non_requesting_cache_wb, 
                invalidate;   
    begin 
      // check what type of request this is 
      casez(cache0_request_type)
        DATA_READ: data_read_process_cache0(address, non_requesting_cache_wb, invalidate); 
        DATA_WRITE: data_write_process_cache0(address); 
        INSTRUCTION_READ: instruction_read_process_cache0(address); 
      endcase
    end 
  endtask

  // runs through a cache 1 request
  task run_cache1_request; 
    input request_type cache1_request_type; 
    input word_t address; 
    input logic non_requesting_cache_wb, 
                invalidate; 
    begin 
      // check what type of request this is 
      casez(cache1_request_type)
        DATA_READ: data_read_process_cache1(address, non_requesting_cache_wb, invalidate); 
        DATA_WRITE: data_write_process_cache1(address); 
        INSTRUCTION_READ: instruction_read_process_cache1(address); 
      endcase
    end 
  endtask

  // task to perform a given test case
  task perform_test_case; 
    input logic cache0_request, 
                cache1_request, 
                non_requesting_cache_wb; 
    input request_type cache0_request_type, 
                       cache1_request_type; 
    input word_t address; 
    input logic invalidate; 
    begin 

      // for the given test case, apply the proper cache requests to the memory controller
      apply_cache_requests(cache0_request, 
                           cache1_request, 
                           cache0_request_type, 
                           cache1_request_type, 
                           address, 
                           invalidate
                           ); 

      // wait a little to allow inputs to settle 
      #(1)
      // if cache0 is a requestor 
      if (cache0_request == 1) begin 
        // Run through the service of cache0 request
        run_cache0_request(cache0_request_type, address, non_requesting_cache_wb, invalidate); 
      end 
      // else if cache0 is a requestor 
      else if (cache1_request == 1) begin 
        // run through the service of cache1 request
        run_cache1_request(cache1_request_type, address, non_requesting_cache_wb, invalidate); 
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

  // initialize inputs 
  nRST = 1'b1; 
  cif0.iREN = 1'b0; 
  cif0.dREN = 1'b0; 
  cif0.dWEN = 1'b0; 
  cif0.iaddr = 32'd0; 
  cif0.daddr = 32'd0;
  cif0.ccwrite = 1'b0; 
  cif0.cctrans = 1'b0; 
  cif0.dstore = 32'd0;  
  cif1.iREN = 1'b0; 
  cif1.dREN = 1'b0; 
  cif1.dWEN = 1'b0; 
  cif1.iaddr = 32'd0; 
  cif1.daddr = 32'd0;
  cif1.ccwrite = 1'b0; 
  cif1.cctrans = 1'b0; 
  cif1.dstore = 32'd0; 
  // initialize testbench signals
  test_case_num = 0; 
  test_description = "NULL";  
  data = 32'h13200006; 
  data2 = 32'h8D490000; 
  address = 32'h8; 

  /****************************************************************
  *
  *   
  * Test Case #1: Testing for cache0 request memory read and cache1 goes from M -> S
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Testing for cache0 request memory read and cache1 goes from M -> S."; 

  reset_dut();
  perform_test_case(1, // cache_0 request
                    0, // cache_1 request
                    1, // non_requesting_cache_wb
                    DATA_READ, // cache_0_request_type
                    NONE, // cache_1_request_type
                    address, // address to request from
                    0 // whether the non-requesting cache should be invalidated
                    );
  /****************************************************************
  *
  *   
  * Test Case #1: Testing for cache0 request memory read and cache1 goes from M -> I
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Testing for cache0 request memory read and cache1 goes from M -> I."; 

  reset_dut();
  perform_test_case(1, // cache_0 request
                    0, // cache_1 request
                    1, // non_requesting_cache_wb
                    DATA_READ, // cache_0_request_type
                    NONE, // cache_1_request_type
                    address, // address to request from
                    1 // whether the non-requesting cache should be invalidated
                    );

  /****************************************************************
  *
  *   
  * Test Case #2: Testing for cache0 request memory and gets it from ram
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Testing for cache0 request memory and gets it from ram and cache1 invalidates itself."; 

  reset_dut();
  perform_test_case(1, // cache_0 request
                    0, // cache_1 request
                    1, // non_requesting_cache_wb
                    DATA_READ, // cache_0_request_type
                    NONE, // cache_1_request_type
                    address, // address to request from
                    1 // whether the non-requesting cache should be invalidated
                    );

  /****************************************************************
  *
  *   
  * Test Case #3: Testing for cache0 write to ram request 
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Testing for cache0 write to ram request "; 

  reset_dut();
  perform_test_case(1, // cache_0 request
                    0, // cache_1 request
                    0, // non_requesting_cache_wb
                    DATA_WRITE, // cache_0_request_type
                    NONE, // cache_1_request_type
                    address, // address to request from
                    0 // whether the non-requesting cache should be invalidated
                    );

  /****************************************************************
  *
  *   
  * Test Case #4: Testing for cache0 to request an instruction read
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Testing for cache0 to request an instruction read"; 

  reset_dut();
  perform_test_case(1, // cache_0 request
                    0, // cache_1 request
                    0, // non_requesting_cache_wb
                    INSTRUCTION_READ, // cache_0_request_type
                    NONE, // cache_1_request_type
                    address, // address to request from
                    0 // whether the non-requesting cache should be invalidated
                    );


  /****************************************************************
  *
  *   
  * Test Case #5: Testing for cache1 request memory read and cache1 goes from M -> S
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Testing for cache1 request memory read and cache1 goes from M -> S."; 

  reset_dut();
  perform_test_case(0, // cache_0 request
                    1, // cache_1 request
                    1, // non_requesting_cache_wb
                    NONE, // cache_0_request_type
                    DATA_READ, // cache_1_request_type
                    address, // address to request from
                    0 // whether the non-requesting cache should be invalidated
                    );

  /****************************************************************
  *
  *   
  * Test Case #5: Testing for cache1 request memory read and cache1 goes from M -> I
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Testing for cache1 request memory read and cache1 goes from M -> I."; 

  reset_dut();
  perform_test_case(0, // cache_0 request
                    1, // cache_1 request
                    1, // non_requesting_cache_wb
                    NONE, // cache_0_request_type
                    DATA_READ, // cache_1_request_type
                    address, // address to request from
                    1 // whether the non-requesting cache should be invalidated
                    );
  /****************************************************************
  *
  *   
  * Test Case #6: Testing for cache1 request memory and gets it from ram
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Testing for cache1 request memory and gets it from ram and cache1 invalidates itself."; 

  reset_dut();
  perform_test_case(0, // cache_0 request
                    1, // cache_1 request
                    1, // non_requesting_cache_wb
                    NONE, // cache_0_request_type
                    DATA_READ, // cache_1_request_type
                    address, // address to request from
                    1 // whether the non-requesting cache should be invalidated
                    );

  /****************************************************************
  *
  *   
  * Test Case #7: Testing for cache1 write to ram request 
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Testing for cache1 write to ram request "; 

  reset_dut();
  perform_test_case(0, // cache_0 request
                    1, // cache_1 request
                    0, // non_requesting_cache_wb
                    NONE, // cache_0_request_type
                    DATA_WRITE, // cache_1_request_type
                    address, // address to request from
                    0 // whether the non-requesting cache should be invalidated
                    );

  /****************************************************************
  *
  *   
  * Test Case #8: Testing for cache1 to request an instruction read
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Testing for cache1 to request an instruction read"; 

  reset_dut();
  perform_test_case(0, // cache_0 request
                    1, // cache_1 request
                    0, // non_requesting_cache_wb
                    NONE, // cache_0_request_type
                    INSTRUCTION_READ, // cache_1_request_type
                    address, // address to request from
                    0 // whether the non-requesting cache should be invalidated
                    );

  /****************************************************************
  *
  *   
  * Test Case #9: Back to back instruction read request. Make sure that memory controller is fair.
  *
  *
  *****************************************************************/
  test_case_num = test_case_num + 1; 
  test_description = "Back to back instruction read request. Make sure that memory controller is fair."; 

  reset_dut();
  cif1.iREN = 1'b1; 
  perform_test_case(0, // cache_0 request
                    1, // cache_1 request
                    0, // non_requesting_cache_wb
                    NONE, // cache_0_request_type
                    INSTRUCTION_READ, // cache_1_request_type
                    address, // address to request from
                    0 // whether the non-requesting cache should be invalidated
                    );
  @(posedge CLK); 
  @(posedge CLK); 
  cif0.iREN = 1'b1; 
  perform_test_case(1, // cache_0 request
                    0, // cache_1 request
                    0, // non_requesting_cache_wb
                    INSTRUCTION_READ, // cache_0_request_type
                    NONE, // cache_1_request_type
                    address, // address to request from
                    0 // whether the non-requesting cache should be invalidated
                    );

  dump_memory();
  end

endprogram
