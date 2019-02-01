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
    .\ruif.halt (ruif.halt)  
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
    end 
  endtask 

  task request_instruction;
    begin 

      // get away from rising edge 
      @(negedge CLK); 

      // apply proper signals for requesting a read instruction
      ruif.iREN = 1'b1; 
      ruif.ihit = 1'b1; 

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

  task give_instruction; 
    begin 

      // get away from rising edged to bring ihit low 
      @(negedge CLK); 
      ruif.ihit = 1'b0;
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
     

/******************* Test Case #1 *************************************************/
    test_description = "Apply an instruction read with no data request. "; 
    test_case_num = 0; 

    // reset the program counter back to address 0x0
    reset_dut;

    request_instruction; 

    // check the outputs to make sure the imemREN and pc_wait is high 
    check_outputs(1'b1, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b1, //pc_wait
                  test_description
                  ); 

    // provide some latency
    latency(1); 

    give_instruction; 

    // wait some time to allow outputs settle 
    #(1)
    // check to make sure that imemREN went low 
    check_outputs(1'b0, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b0, //pc_wait
                  test_description
                  ); 


/******************* Test Case #1 *************************************************/
    test_description = "Apply an instruction read and data read at same time "; 
    test_case_num = test_case_num + 1; 

    // reset the program counter back to address 0x0
    reset_dut;

    // On the negative edge of the clock, 
    @(negedge CLK); 

    // apply the iREN and dREN signal 
    ruif.iREN = 1'b1; 
    ruif.ihit = 1'b1; 
    ruif.dREN = 1'b1; 
    ruif.dhit = 1'b1; 

    // wait a clock cycle
    @(posedge CLK); 
    @(posedge CLK)

    // check the outputs 
    check_outputs(1'b1, // imemREN
                  1'b0, // dmemWEN
                  1'b1, // dmemREN
                  1'b1, //pc_wait
                  test_description
                  ); 

    // get away from rising edged to bring dhit low 
    @(negedge CLK); 
    ruif.dhit = 1'b0; 

    // wait some time to allow outputs settle 
    #(1)

    // check to make that dREN got brought low 
    check_outputs(1'b1, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b1, //pc_wait
                  test_description
                  ); 

    // get away from rising edge to bring ihit low 
    @(negedge CLK); 
    ruif.ihit = 1'b0; 

    // wait a little before checking outpus 
    #(1)

    // check to make that dREN got brought low 
    check_outputs(1'b0, // imemREN
                  1'b0, // dmemWEN
                  1'b0, // dmemREN
                  1'b0, //pc_wait
                  test_description
                  ); 

 end
endprogram
