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
    .port_b(aluif.port_b)); 

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
  logic test_num = 0; 
  string test_description = "";

  // declare the unpacted/dynamically sized test-vector array 
  test_vector tb_test_cases []; 

  // task definitions 
  task check_outputs; 
    input word_t expected_result; 
    input logic     expected_overflow,
                    expected_zero, 
                    expected_negative; 
    input string test_name;   
    begin 

      // checking result 
      if (expected_result != result) begin 

        // display error message
        $monitor("Time: @%00g ns,  Error in result for test case %s. Expected_result =  %0d ", 
                  $time, test_name, expected_result); 
                // display error message
        $display("Time: @%00g ns,  Error in result for test case %s. Expected_result =  %0d ", 
                  $time, test_name, expected_result); 
      end 

      // checking overflow
      if (expected_overflow != overflow) begin 

        // display error message
        $monitor("Time: @%00g ns,  Error in overflow for test case %s. expected_overflow =  %0d ", 
                  $time, test_name, expected_overflow); 
                // display error message
        $display("Time: @%00g ns,  Error in overflow for test case %s. expected_overflow =  %0d ", 
                  $time, test_name, expected_overflow); 
      end 

      // checking zero
      if (expected_zero != zero) begin 

        // display error message
        $monitor("Time: @%00g ns,  Error in zero for test case %s. expected_zero = %0d ", 
                  $time, test_name, expected_zero); 

        // display error message
        $display("Time: @%00g ns,  Error in zero for test case %s. expected_zero = %0d ", 
                  $time, test_name, expected_zero); 
      end 

      // checking negative
      if (expected_negative != negative) begin 

        // display error message
        $monitor("Time: @%00g ns,  Error in negative for test case %s. expected_negative = %0d ", 
                  $time, test_name, expected_negative); 
                // display error message
        $display("Time: @%00g ns,  Error in negative for test case %s. expected_negative = %0d ", 
                  $time, test_name, expected_negative); 
      end 
    end 
  endtask

  //initial block  
  initial begin

    // Creating the test vecotr array 
    tb_test_cases = new[1]; 

    // First Test Case 
    tb_test_cases[0].test_name = "Logical Shift Left"; 
    tb_test_cases[0].op = ALU_SLL; 
    tb_test_cases[0].port_a = 32'd3; 
    tb_test_cases[0].port_b = 32'd5; 
    tb_test_cases[0].expected_result = 32'd40; 
    tb_test_cases[0].expected_overflow = 1'b0; 
    tb_test_cases[0].expected_negative = 1'b0; 
    tb_test_cases[0].expected_zero = 1'b0; 

    // loop through all of the registers
    for (int i = 0; i < tb_test_cases.size(); i++) begin 

      // update the test number and description 
      test_num = i; 
      test_description = tb_test_cases[i].test_name; 

      // apply the inputs 
      port_a = tb_test_cases[i].port_a; 
      port_b = tb_test_cases[i].port_b; 
      alu_op = tb_test_cases[i].op; 

      // wait a little to allow outputs to settle
      #(1)

      // check the outputs 
      check_outputs(tb_test_cases[i].expected_result, 
                    tb_test_cases[i].expected_overflow, 
                    tb_test_cases[i].expected_negative, 
                    tb_test_cases[i].expected_zero, 
                    tb_test_cases[i].test_name); 

    end 
  end 
endprogram
