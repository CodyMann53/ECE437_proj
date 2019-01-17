/*
  Cody Mann
  mann53@purdue.edu

  alu test bench
*/

// mapped needs this
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

  // parameter definitions 
  parameter PERIOD = 10;

  // interface
  alu_if aluif ();

  // DUT
  `ifndef MAPPED
    alu DUT(aluif);
  `else
    alu DUT(
      .\alu.port_a (aluif.port_b),
      .\alu.port_b(aluif.port_b), 
      .\alu.alu_op(aluif.alu_op), 
      .\alu.result(aluif.result), 
      .\alu.negative(aluif.negative), 
      .\alu.overflow(aluif.overflow), 
      .\alu.zero(aluif.zero)
    );
  `endif

  // test program
  test PROG ( 
    .negative(aluif.negative), 
    .overflow(aluif.overflow), 
    .zero(aluif.zero), 
    .result(aluif.result), 
    .alu_op(aluif.alu_op), 
    .port_a(aluif.port_a), 
    .port_b(aluif.port_b); 

endmodule

program test
  // import statements 
  import cpu_types_pkg::*; 
  (
    input logic negative, overflow, zero, 
    input word_t result,  
    output aluop_t alu_op, 
    output word_t port_a, port_b
  ); 

  // parameter definitions  
  parameter PERIOD = 10;

  // Test vector definitions 
  typedef struct{
    string test_name; 
    aluop_t op; 
    word_t port_a; 
    word_t port_b; 
    word_t expected_result; 
    logic expected_overflow; 
    logic expected_negative; 
    logic expected_zero; 
  } test_vector; 

  // variable definitions for test case description 
  int test_case_num = 0; 
  string test_description = "NULL"; 

  // declare the unpacted/dynamically sized test-vector array 
  test_vector tb_test_cases []; 

  //initial block  
  initial begin

    // Creating the test vecotr array 
    tb_test_cases = new[1]; 

    // First Test Case 
    tb_test_cases[0].op = ALU_SLL; 
    tb_test_cases[0].port_a = 32'd5; 
    tb_test_cases[0].port_b = 32'd3; 
    tb_test_cases[0].expected_result = 32'd40; 
    tb_test_cases[0].expected_overflow = 1'b0; 
    tb_test_cases[0].expected_negative = 1'b0; 
    tb_test_cases[0].expected_zero = 1'b0; 

    

    test_description = "Testing asynchronous reset";
    // reset the register file 
    reset_dut();

    // loop through all of the registers
    for (int i = 0; i < REGISTER_SIZE; i++) begin 


      end 
      // not location 0
      else begin 


      end 
  end 
endprogram
