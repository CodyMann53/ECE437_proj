/*
  Cody Mann
  mann53@purdue.edu

  request unit test bench
*/

/********************** Include statements *************************/
`include "request_unit_if.vh"
`include "cpu_types_pkg.vh"

/********************** Import statements *************************/
import cpu_types_pkg::*; 

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module request_unit_tb;

  /********************** Module variable definitions *************************/
  // parameter definitions
  parameter PERIOD = 10;

  // number of cpus for cc
  parameter CPUS = 1;

  logic CLK = 0, nRST;

  /********************** Clock generation *************************/

  // clock generation block
  always #(PERIOD/2) CLK++;

  /********************** Interface definitions *************************/
  request_unit_if ruif(); 

    /********************** Port map definitions *************************/
  `ifndef MAPPED
    request_unit DUT(CLK, nRST, ruif);
  `else
    request_unit DUT(
    .\CLK (CLK),
    .\nRST (nRST), 
    .\ruif.iREN (ruif.iREN),
    .\ruif.dREN (ruif.dREN), 
    .\ruif.dWEN (ruif.dWEN), 
    .\ruif.pc_wait (ruif.pc_wait),
    .\ruif.ihit (ruif.ihit),
    .\ruif.dhit (ruif.dhit), 
    .\ruif.imemREN  (ruif.imemREN), 
    .\ruif.dmemREN (ruif.dmemREN), 
    .\ruif.dmemWEN (ruif.dmemWEN), 
    .\ruif.halt (ruif.halt), 
    .\ruif.halt_out (ruif.halt_out)
    );
  `endif

  /***************Assign statements ********************/


  /***************Program Calls********************/

  // test program
  test PROG (
    .CLK(CLK),
    .nRST(nRST),
    .ruif (ruif)
    );

endmodule

  /***************Program Definitions ********************/

program test
  // modports
  (
  request_unit_if ruif,
  input logic CLK,
  output logic nRST
  );

    /***************Program local variable definitions ********************/

  // variable definitions for test case description
  int test_case_num;
  string test_description;

  // parameter definitions
  parameter PERIOD = 10;

  /***************Test Vector Definitions ********************/

  /*************** task definitions *************************************/
  // task definitions 
  task reset_dut; 
    begin 

      // get away from posedge of clock 
      @(negedge CLK); 

      ruif.iREN = 1'b0; 
      ruif.dREN = 1'b0; 
      ruif.dWEN = 1'b0; 
      ruif.ihit = 1'b0; 
      ruif.dhit = 1'b0; 
      ruif.halt = 1'b0; 

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

  task check_outputs; 
    input logic imemREN, dmemWEN, dmemREN, pc_wait; 
    input string test_name; 
    input logic halt_out; 
    begin 
      if (imemREN != ruif.imemREN) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect imemREN for test case: %s", $time, test_name); 
        $display("Expected imemREN: %d Actual imemREN: %d", imemREN, ruif.imemREN); 
        $monitor("Time: %00g ns Incorrect imemREN for test case: %s", $time, test_name); 
        $monitor("Expected imemREN: %0d Actual imemREN: %0d", imemREN, ruif.imemREN); 
      end

      if (dmemREN != ruif.dmemREN) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect dmemREN for test case: %s", $time, test_name); 
        $display("Expected dmemREN: %0d Actual dmemREN: %0d", dmemREN, ruif.dmemREN); 
        $monitor("Time: %00g ns Incorrect dmemREN for test case: %s", $time, test_name); 
        $monitor("Expected dmemREN: %0d Actual dmemREN: %0d", dmemREN, ruif.dmemREN); 
      end

      if (dmemWEN != ruif.dmemWEN) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect dmemWEN for test case: %s", $time, test_name); 
        $display("Expected dmemWEN: %0d Actual dmemWEN: %0d", dmemWEN, ruif.dmemWEN); 
        $monitor("Time: %00g ns Incorrect dmemWEN for test case: %s", $time, test_name); 
        $monitor("Expected dmemWEN: %0d Actual dmemWEN: %0d", dmemWEN, ruif.dmemWEN); 
      end

      if (pc_wait != ruif.pc_wait) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect pc_wait for test case: %s", $time, test_name); 
        $display("Expected pc_wait: %0d Actual pc_wait: %0d", pc_wait, ruif.pc_wait); 
        $monitor("Time: %00g ns Incorrect pc_wait for test case: %s", $time, test_name); 
        $monitor("Expected pc_wait: %0d Actual pc_wait: %0d", pc_wait, ruif.pc_wait); 
      end

      if (halt_out != ruif.halt_out) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect halt_out for test case: %s", $time, test_name); 
        $display("Expected halt_out: %0d Actual halt_out: %0d", halt_out, ruif.halt_out); 
        $monitor("Time: %00g ns Incorrect halt_out for test case: %s", $time, test_name); 
        $monitor("Expected halt_out: %0d Actual halt_out: %0d", halt_out, ruif.halt_out); 
      end
    end 
  endtask 

  task request_memory;
    input logic iREN, dREN, dWEN; 
    begin 

      // get away from rising edge 
      @(negedge CLK); 

      // apply proper request signals 
      ruif.iREN = iREN; 
      ruif.ihit = iREN;
      ruif.dREN = dREN; 
      ruif.dWEN = dWEN;  
      ruif.dhit = (dREN | dWEN); 

      // wait a clock cycle
      @(posedge CLK); 
    end 
  endtask

  task latency; 
    input int cycles; 
    begin 
      repeat (cycles) begin 
        @(posedge CLK); 
      end 
    end 
  endtask

  task memory_response;
    input logic ihit, dhit;  
    begin 

      // get away from rising edged to bring ihit low 
      @(negedge CLK); 
      ruif.ihit = ihit;
      ruif.dhit = dhit; 
    end 
  endtask

  /***************Initial Block ********************/
  initial begin

    // initialize all outputs to the request unit to zero. 
    nRST = 1'b1; 
    ruif.iREN = 1'b0; 
    ruif.dREN = 1'b0; 
    ruif.dWEN = 1'b0; 
    ruif.ihit = 1'b0; 
    ruif.dhit = 1'b0; 
    ruif.halt = 1'b0; 
     

/******************* Test Case #0 *************************************************/
    test_description = "Apply an instruction read with no data request. "; 
    test_case_num = 0; 

    // reset
    reset_dut;

    // ask memory for instruction
                  //iREN, dREN, dWEN
    request_memory(1'b1, 1'b0, 1'b0); 

    // check the outputs to make sure the imemREN and pc_wait is high 
    check_outputs(1'b1, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b1, //pc_wait
                  test_description, 
                  1'b0);  // halt_out
                  

    // provide some latency
    latency(1); 

    // memory signals data is ready  
                  // ihit, dhit
    memory_response(1'b0, 1'b0); 

    // wait some time to allow outputs settle 
    #(1)
    // check to make sure that imemREN went low 
    check_outputs(1'b0, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b0, //pc_wait
                  test_description, 
                  1'b0 // halt_out 
                  ); 


/******************* Test Case #1 *************************************************/
    test_description = "Apply an instruction read and data read at same time "; 
    test_case_num = test_case_num + 1; 

    // reset the reques unit 
    reset_dut; 

    // ask memory for a data and instruction value 
                  //iREN, dREN, dWEN
    request_memory(1'b1, 1'b1, 1'b0);

    #(1)
    check_outputs(1'b1, // imemREN
                  1'b0, // dmemWEN
                  1'b1, // dmemREN
                  1'b1, //pc_wait
                  test_description, 
                  1'b0 // halt_out
                  ); 

    latency(1); 

        // memory signals data is ready  
                  // ihit, dhit
    memory_response(1'b1, 1'b0); 

    #(1)
    check_outputs(1'b1, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b1, //pc_wait
                  test_description, 
                  1'b0 // halt_out
                  ); 

    latency(1);

    // memory signals instruction is ready  
                  // ihit, dhit
    memory_response(1'b0, 1'b0); 

    #(1)
    check_outputs(1'b0, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b0, //pc_wait
                  test_description, 
                  1'b0 // halt_out
                  ); 

    /******************* Test Case #2 *************************************************/
    test_description = "Apply an instruction read and data write at same time "; 
    test_case_num = test_case_num + 1; 

    // reset the reques unit 
    reset_dut; 

    // ask memory for a data write and instruction value 
                  //iREN, dREN, dWEN
    request_memory(1'b1, 1'b0, 1'b1);

    #(1)
    check_outputs(1'b1, // imemREN
                  1'b1, // dmemWEN
                  1'b0, // dmemREN
                  1'b1, //pc_wait
                  test_description, 
                  1'b0 // halt_out
                  ); 

    latency(1); 

        // memory signals data is ready  
                  // ihit, dhit
    memory_response(1'b1, 1'b0); 

    #(1)
    check_outputs(1'b1, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b1, //pc_wait
                  test_description, 
                  1'b0 // halt_out
                  ); 

    latency(1);

    // memory signals instruction is ready  
                  // ihit, dhit
    memory_response(1'b0, 1'b0); 

    #(1)
    check_outputs(1'b0, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b0, //pc_wait
                  test_description, 
                  1'b0 // halt_out
                  ); 

/******************* Test Case #3 *************************************************/
    test_description = "Apply a data read request only . "; 
    test_case_num = test_case_num + 1; 

    // reset
    reset_dut;

    // ask memory for data
                  //iREN, dREN, dWEN
    request_memory(1'b0, 1'b1, 1'b0); 

    check_outputs(1'b0, // imemREN
                  1'b0, // dmemWEN
                  1'b1, // dmemREN
                  1'b1, //pc_wait
                  test_description, 
                  1'b0 // halt_out
                  ); 

    // provide some latency
    latency(1); 

    // memory signals data is ready  
                  // ihit, dhit
    memory_response(1'b0, 1'b0); 

    // wait some time to allow outputs settle 
    #(1)
    check_outputs(1'b0, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b0, //pc_wait
                  test_description,
                  1'b0 // halt_out
                  ); 

    /******************* Test Case #4 *************************************************/
    test_description = "Apply a data write request only . "; 
    test_case_num = test_case_num + 1; 

    // reset
    reset_dut;

    // ask memory for data
                  //iREN, dREN, dWEN
    request_memory(1'b0, 1'b0, 1'b1); 
 
    check_outputs(1'b0, // imemREN
                  1'b1, // dmemWEN
                  1'b0, // dmemREN
                  1'b1, //pc_wait
                  test_description, 
                  1'b0 // halt_out
                  ); 

    // provide some latency
    latency(4); 

    // memory signals data is ready  
                  // ihit, dhit
    memory_response(1'b0, 1'b0); 

    // wait some time to allow outputs settle 
    #(1)
    check_outputs(1'b0, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b0, //pc_wait
                  test_description, 
                  1'b0 // halt_out
                  ); 

  /******************* Test Case #5 *************************************************/
    test_description = "Making sure that the request unit halts when told to"; 
    test_case_num = test_case_num + 1; 

    // reset
    reset_dut;

    // ask memory for data
                  //iREN, dREN, dWEN

    request_memory(1'b1, 1'b1, 1'b0); 

    @(negedge CLK); 
    ruif.halt = 1'b1; 

    latency(1); 

    #(1)
    check_outputs(1'b0, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b1, //pc_wait
                  test_description, 
                  1'b1 // halt_out
                  ); 

 


 end
endprogram
