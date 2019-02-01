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
  typedef struct {
    string test_name; 
    logic iREN; 
    logic dREN; 
    logic dWEN; 
    logic ihit; 
    logic dhit; 
    logic halt;
    logic expected_imemREN;
    logic expected_dmemWEN; 
    logic expected_dmemREN; 
    logic expected_pc_wait; 
    int latency; 
  } test_vector; 

  test_vector tb_test_cases []; 

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

  task add_case;
    input int test_num; 
    input string test_name; 
    input logic iREN; 
    input logic dREN; 
    input logic dWEN; 
    input logic ihit; 
    input logic dhit; 
    input logic halt;
    input logic expected_imemREN;
    input logic expected_dmemWEN; 
    input logic expected_dmemREN; 
    input logic expected_pc_wait; 
    input int latency;
    begin 
      tb_test_cases[test_num].test_name = test_name;
      tb_test_cases[test_num].iREN = iREN; 
      tb_test_cases[test_num].dREN = dREN; 
      tb_test_cases[test_num].dWEN = dWEN; 
      tb_test_cases[test_num].ihit = ihit; 
      tb_test_cases[test_num].dhit = dhit; 
      tb_test_cases[test_num].halt = halt; 
      tb_test_cases[test_num].expected_imemREN = expected_imemREN; 
      tb_test_cases[test_num].expected_dmemWEN = expected_dmemWEN; 
      tb_test_cases[test_num].expected_dmemREN = expected_dmemREN; 
      tb_test_cases[test_num].expected_pc_wait = expected_pc_wait;
      tb_test_cases[test_num].latency = latency;
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

    // allocate test case number
    tb_test_cases = new[6]; 

    // adding test cases 
    add_case(0, // test number 
      "Requesting only a read instruction", // test description 
      1'b1, // iREN
      1'b0, // dREN
      1'b0, // dWEN
      1'b1, // ihit
      1'b0, // dhit
      1'b0, // halt
      1'b1, // expected_imemREN
      1'b0, //expected_dmemWEN
      1'b0,  // expected_dmemREN
      1'b1, // expected_pc_wait
      1);  // latency (number of clock cycles to hold inputs )

    add_case(1, // test number 
      "Requesting an instruction read and data write", // test description 
      1'b1, // iREN
      1'b0, // dREN
      1'b1, // dWEN
      1'b1, // ihit
      1'b1, // dhit
      1'b0, // halt
      1'b1, // expected_imemREN
      1'b1, //expected_dmemWEN
      1'b0,  // expected_dmemREN
      1'b1, // expected_pc_wait
      1);  // latency (number of clock cycles to hold inputs )

    add_case(2, // test number 
      "Requesting nothing", // test description 
      1'b0, // iREN
      1'b0, // dREN
      1'b0, // dWEN
      1'b0, // ihit
      1'b0, // dhit
      1'b0, // halt
      1'b0, // expected_imemREN
      1'b0, //expected_dmemWEN
      1'b0,  // expected_dmemREN
      1'b0, // expected_pc_wait
      1);  // latency (number of clock cycles to hold inputs )

    add_case(3, // test number 
      "Requesting an instruction read and data read", // test description 
      1'b1, // iREN
      1'b1, // dREN
      1'b0, // dWEN
      1'b1, // ihit
      1'b1, // dhit
      1'b0, // halt
      1'b1, // expected_imemREN
      1'b0, //expected_dmemWEN
      1'b1,  // expected_dmemREN
      1'b1, // expected_pc_wait
      1);  // latency (number of clock cycles to hold inputs )

    add_case(4, // test number 
      "Requesting nothing and sending a halt", // test description 
      1'b0, // iREN
      1'b0, // dREN
      1'b0, // dWEN
      1'b0, // ihit
      1'b0, // dhit
      1'b1, // halt
      1'b0, // expected_imemREN
      1'b0, //expected_dmemWEN
      1'b0,  // expected_dmemREN
      1'b1, // expected_pc_wait
      1);  // latency (number of clock cycles to hold inputs )

    add_case(5, // test number 
      "Requesting an instruction read and data read", // test description 
      1'b1, // iREN
      1'b1, // dREN
      1'b0, // dWEN
      1'b1, // ihit
      1'b1, // dhit
      1'b0, // halt
      1'b1, // expected_imemREN
      1'b0, //expected_dmemWEN
      1'b1,  // expected_dmemREN
      1'b1, // expected_pc_wait
      1);  // latency (number of clock cycles to hold inputs )
     

/******************* Test Case #1 *************************************************/
    test_description = "Not running "; 
    test_case_num = 0; 

    // reset the program counter back to address 0x0
    reset_dut; 

    // loop through all of the testcases
    for (int i = 0; i < tb_test_cases.size(); i++) begin 

      test_case_num = test_case_num + 1; 
      test_description = tb_test_cases[i].test_name; 

      // get away from rising edge before applying inputs 
      @(negedge CLK); 

      // apply the signals 
      ruif.iREN = tb_test_cases[i].iREN; 
      ruif.dREN = tb_test_cases[i].dREN; 
      ruif.dWEN = tb_test_cases[i].dWEN; 
      ruif.ihit = tb_test_cases[i].ihit; 
      ruif.dhit = tb_test_cases[i].dhit; 
      ruif.halt = tb_test_cases[i].halt; 

      // wait some number of clock cycles 
      repeat (tb_test_cases[i].latency) begin 
        @(posedge CLK);
      end 

      // check the outputs 
      check_outputs(tb_test_cases[i].expected_imemREN, tb_test_cases[i].expected_dmemWEN,
                    tb_test_cases[i].expected_dmemREN, 
                    tb_test_cases[i].expected_pc_wait, 
                    tb_test_cases[i].test_name); 

    end 

  end
endprogram
