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
        //$monitor("Time: %00g ns Incorrect program counter for test case: %s", $time, test_description); 
        //$monitor("Expected imemaddr: %0h Actual imemaddr: %0h", expected_pc, pcif.imemaddr); 
      end 
    end 
  endtask 

  task increment_instruction; 
    input int instr_number; 
    begin 

      // get away from rising edge 
      @(negedge CLK); 

      // set the pc source to increment serially 
      pcif.PCSrc = SEL_LOAD_NXT_INSTR; 

      // go given number of instructions serially
      repeat (instr_number) begin 
        @(posedge CLK); 
        expected_program_counter = expected_program_counter + 32'd4; 
      end 
    end 
  endtask

  task jr_instruction; 
    input [31:0] address; 
    begin 

    // switch to jump instruction address input 
    @(negedge CLK); 
    pcif.jr_addr = 32'heeffff00;

    // update the expected program counter
    expected_program_counter = address; 

    // switch the mux input 
    pcif.PCSrc = SEL_LOAD_JR_ADDR; 

    // let outputs changed based on new inputs 
    @(posedge CLK); 
    end
  endtask

  task jump_instruction; 
    input logic [25:0] address; 
    begin 

      // switch to branch address instruction 
      @(negedge CLK); 
      pcif.load_addr = address;

      // add four to the expected program counter 
      expected_program_counter = expected_program_counter + 4; 

      // updated the expected_program counter 
      expected_program_counter = {expected_program_counter[31:28], pcif.load_addr, 2'b00}; 

      // switch the pc source selection to address from jump instruction 
      pcif.PCSrc = SEL_LOAD_ADDR; 

      // let outputs change
      @(posedge CLK); 
    end 
  endtask

  task branch_instruction; 
    input [15:0] address; 
    begin 

      // switch to branch address instruction 
      @(negedge CLK); 
      pcif.load_imm = address;

      // updated the expected_program counter 
      expected_program_counter = expected_program_counter + 4 + {16'hFFFF, pcif.load_imm, 2'b00}; 

      // switch the pc source selection 
      pcif.PCSrc = SEL_LOAD_IMM16; 

      // let outputs change
      @(posedge CLK);
    end 
  endtask

  // tells the program counter to stop running
  task pc_wait; 
    begin 

      // get away from neg edge to apply inputs 
      @(negedge CLK); 

      // set pcwait to high 
      pcif.pc_wait = 1'b1; 

      // allow inputs to be executed 
      @(posedge CLK); 
    end
  endtask

  // tells the program counter to start operating again 
  task pc_run; 
    begin 

      // get away from neg edge to apply inputs 
      @(negedge CLK); 

      // set pcwait to high 
      pcif.pc_wait = 1'b0; 

      // allow inputs to be executed 
      @(posedge CLK); 
    end
  endtask

  /***************Initial Block ********************/
  initial begin

    // initialize all of the outputs to the memory controller (default values)
    nRST = 1'b1; 
    pcif.PCSrc = SEL_LOAD_NXT_INSTR; 
    pcif.load_addr = 26'd0; 
    pcif.pc_wait = 1'b0; 
    pcif.jr_addr = 32'd0; 
    pcif.load_imm = 16'd0; 
    expected_program_counter = 32'h0; 


/******************* Test Case #1 *************************************************/
    test_description = "Have program counter increment to address 0x10"; 
    test_case_num = 0; 

    // reset the program counter back to address 0x0
    reset_dut; 

    // a clock cycle is not accounted for going between reset dut and increment. 
    @(posedge CLK); 
    expected_program_counter = expected_program_counter + 4;

    // Wait 5 clock cycles to allow the program counter to increment
    increment_instruction(5); 

    // check the program counter value 
    check_pc(expected_program_counter, test_description); 

/******************* Test Case #2 *************************************************/
    test_description = "Checking for correct load of jr address value";
    test_case_num = test_case_num + 1; 

    // jump to address
    jr_instruction(32'heeffff00); 

    //check the program counter 
    check_pc(expected_program_counter, test_description); 

/******************* Test Case #3 *************************************************/
    test_description = "checking for correct operation of program counter branching";
    test_case_num = test_case_num + 1; 

    // branch to specified memory
    branch_instruction(16'h190); 

    // check the program counter 
    check_pc(expected_program_counter, test_description); 

/******************* Test Case #4 *************************************************/
    test_description = "checking for correct operation of jumping to memory address and then single increment";
    test_case_num = test_case_num + 1; 

    jump_instruction(26'h52ff61);

    // check the program counter 
    check_pc(expected_program_counter, test_description);

/******************* Test Case #5 *************************************************/
    test_description = "checking another jump operation";
    test_case_num = test_case_num + 1; 

    jump_instruction(26'h45F33);

    // check the program counter 
    check_pc(expected_program_counter, test_description);


/******************* Test Case #6 *************************************************/
    test_description = "Increment for two instructions and then make sure the pc halts when it requested.";
    test_case_num = test_case_num + 1; 

    increment_instruction(2); 

    // check the program counter 
    check_pc(expected_program_counter, test_description);

    // halt the program counter 
    pc_wait; 

    // check program counter again 
    check_pc(expected_program_counter, test_description); 








  end
endprogram
