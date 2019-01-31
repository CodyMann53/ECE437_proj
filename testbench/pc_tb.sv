/*
  Cody Mann
  mann53@purdue.edu

  program counter test bench
*/

/********************** Include statements *************************/
`include "pc_if.vh"
`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg.vh"

/********************** Import statements *************************/
import cpu_types_pkg::*;
import data_path_muxs_pkg::*; 

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module pc_tb;

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
  pc_if pcif(); 

    /********************** Port map definitions *************************/
  `ifndef MAPPED
    pc DUT(CLK, nRST, pcif);
  `else
    pc DUT(
    .\CLK (CLK),
    .\nRST (nRST),
    .\pcif.halt (pcif.halt), 
    .\pcif.pc_wait (pcif.pc_wait),
    .\pcif.imemaddr (pcif.imemaddr), 
    .\pcif.jr_addr (pcif.jr_addr), 
    .\pcif.load_addr (pcif.load_addr),
    .\pcif.PCSrc (pcif.PCSrc)
    );
  `endif

  /***************Assign statements ********************/


  /***************Program Calls********************/

  // test program
  test PROG (
    .CLK(CLK),
    .nRST(nRST),
    .pcif (pcif)
    );

endmodule

  /***************Program Definitions ********************/

program test
  // modports
  (
  pc_if pcif,
  input logic CLK,
  output logic nRST
  );

    /***************Program local variable definitions ********************/

  // variable definitions for test case description
  int test_case_num;
  string test_description;
  word_t expected_program_counter; 

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

  task check_pc; 
    input word_t expected_pc; 
    input string test_description; 
    begin 

      // if the expected pc does not match the actual pc
      if (expected_pc != pcif.imemaddr) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect program counter for test case: %s", $time, test_description); 
        $display("Expected imemaddr: %0h Actual imemaddr: %0h", expected_pc, pcif.imemaddr); 
        $monitor("Time: %00g ns Incorrect program counter for test case: %s", $time, test_description); 
        $monitor("Expected imemaddr: %0h Actual imemaddr: %0h", expected_pc, pcif.imemaddr); 
      end 
    end 
  endtask 

  task increment_instruction; 
    input int instr_number; 
    begin 

      // go given number of instructions serially
      repeat (instr_number) begin 
        @(posedge CLK); 
        expected_program_counter = expected_program_counter + 32'd4; 
      end 
    end 
  endtask

  /***************Initial Block ********************/
  initial begin

    // initialize all of the outputs to the memory controller (default values)
    nRST = 1'b1; 
    pcif.halt = 1'b0; 
    pcif.PCSrc = SEL_LOAD_NXT_INSTR; 
    pcif.load_addr = 26'd0; 
    pcif.pc_wait = 1'b0; 
    pcif.jr_addr = 32'd0; 
    pcif.load_imm = 16'd0; 


/******************* Test Case #1 *************************************************/
    test_description = "Have program counter increment to address 0x10"; 

    // apply propper inputs 
    pcif.PCSrc = SEL_LOAD_NXT_INSTR; 
    nRST = 1'b1; 
    pcif.halt = 1'b0; 
    pcif.PCSrc = SEL_LOAD_NXT_INSTR; 
    pcif.load_addr = 26'd0; 
    pcif.pc_wait = 1'b0; 
    pcif.jr_addr = 32'd0; 
    pcif.load_imm = 16'd0; 


    // reset the program counter back to address 0x0
    reset_dut; 

    // set up internal signals for checking 
    expected_program_counter = 32'h0; 

    // Wait 5 clock cycles to allow the program counter to increment
    increment_instruction(5); 

    // check the program counter value 
    check_pc(expected_program_counter, test_description); 

/******************* Test Case #2 *************************************************/
    test_description = "Checking for correct load of jr address value";

    // apply propper inputs 
    pcif.PCSrc = SEL_LOAD_NXT_INSTR; 
    nRST = 1'b1; 
    pcif.halt = 1'b0; 
    pcif.PCSrc = SEL_LOAD_NXT_INSTR; 
    pcif.load_addr = 26'd0; 
    pcif.pc_wait = 1'b0; 
    pcif.jr_addr = 32'd0;
    pcif.load_imm = 16'd0; 
    expected_program_counter = 32'd0; 

    // reset the device 
    reset_dut; 

    // move two instruction addresses
    increment_instruction(2); 

    // switch to jump instruction address input 
    @(negedge CLK); 
    pcif.jr_addr = 32'heeffff00;

    // update the expected program counter
    expected_program_counter = 32'heeffff00; 

    // switch the mux input 
    pcif.PCSrc = SEL_LOAD_JR_ADDR; 

    // let outputs changed based on new inputs 
    @(posedge CLK); 

    //check the program counter 
    check_pc(expected_program_counter, test_description); 

/******************* Test Case #3 *************************************************/
    test_description = "checking for correct operation of program counter branching"

        // apply propper inputs 
    pcif.PCSrc = SEL_LOAD_NXT_INSTR; 
    nRST = 1'b1; 
    pcif.halt = 1'b0; 
    pcif.PCSrc = SEL_LOAD_NXT_INSTR; 
    pcif.load_addr = 26'd0; 
    pcif.pc_wait = 1'b0; 
    pcif.jr_addr = 32'd0;
    pcif.load_imm = 16'd0; 
    expected_program_counter = 32'd0; 

    // reset the device 
    reset_dut; 

    // move two instruction addresses
    increment_instruction(2);

    



  end
endprogram
