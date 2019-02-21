/*
  Cody Mann
  mann53@purdue.edu

  forwarding unit test bench
*/

/********************** Include statements *************************/
`include "forward_unit_if.vh"
`include "cpu_types_pkg.vh"

/********************** Import statements *************************/
import cpu_types_pkg::*; 

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module forwarding_unit_tb;

  /********************** Module variable definitions *************************/

  /********************** Clock generation *************************/

  /********************* enumberation definitions *****************/

  /********************** Interface definitions *************************/
  forwarding_unit_if fuif(); 

  /********************** Port map definitions *************************/
  `ifndef MAPPED
    forwarding_unit DUT(fuif);
  `else
    request_unit DUT( 
    .\fuif.reg_wr_mem(fuif.reg_wr_mem),
    .\fuif.reg_wr_wb(fuif.reg_wr_wb), 
    .\fuif.rs (fuif.rs), 
    .\fuif.rt (fuif.rt), 
    .\fuif.porta_sel (fuif.porta_sel), 
    .\fuif.portb_sel (fuif.portb_sel)
    );
  `endif
  /***************Assign statements ********************/

  /***************Program Calls********************/
  // test program
  test PROG (
    .fuif (fuif)
    );

endmodule

  /***************Program Definitions ********************/
program test
  // modports
  (
  forwarding_unit_if fuif
  );

  /***************Program local variable definitions ********************/
  // variable definitions for test case description
  int test_case_num;
  string test_description;

  /***************Test Vector Definitions ********************/
  // expected values vector
  typedef struct {
    string      test_description; 
    regbits_t   rs, 
                rt, 
                reg_wr_mem, 
                reg_wr_wb; 
    logic [1:0] exp_porta_sel,  
                exp_portb_sel; 
  } tb_testcase_vector; 

  tb_testcase_vector tb_testcases []; 

  /***************Task Definitions ********************/

  // adds a test case to the array of test cases 
  task add_testcase; 
    input             test_num; 
    input string      test_description; 
    input regbits_t   rs, 
                      rt, 
                      reg_wr_mem, 
                      reg_wr_wb;
    input logic [1:0] exp_porta_sel, 
                      exp_portb_sel;  
    begin 
      tb_testcases[test_num].test_description = test_description; 
      tb_testcases[test_num].rs = rs; 
      tb_testcases[test_num].rt = rt; 
      tb_testcases[test_num].reg_wr_mem = reg_wr_mem; 
      tb_testcases[test_num].reg_wr_wb = reg_wr_wb; 
      tb_testcases[test_num].exp_porta_sel = exp_porta_sel; 
      tb_testcases[test_num].exp_portb_sel = exp_portb_sel; 
    end 
  endtask

  // checks the outputs of the forwarding unit for correctness and will flag an error message if they are not 
  task check_outputs; 
    input string test_description; 
    input logic [1:0] exp_porta_sel, 
                      exp_portb_sel; 
    begin 
      // checking porta
      if ( exp_porta_sel != fuif.porta_sel) begin 
        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect porta_sel for test case: %s", $time, test_description); 
        $display("Expected porta_sel: %d Actual porta_sel: %d", exp_porta_sel, fuif.porta_sel); 
      end

      // checking portb
      if ( exp_portb_sel != fuif.portb_sel) begin 
        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect portb_sel for test case: %s", $time, test_description); 
        $display("Expected portb_sel: %d Actual portb_sel: %d", exp_portb_sel, fuif.portb_sel); 
      end
    end 
  endtask 

  /***************Initial Block ********************/
  initial begin
    // allocate test cases 
    tb_testcases = new[1];

    // adding test cases for J-types
    add_testcase(0, // test_num
                "Testing for correct forwaring from mem stage into porta.", // test_description
                5'd1, // rs
                5'd2, // rt
                5'd1, // reg_wr_mem
                5'd4, // reg_wr_wb
                2'd1, // exp_porta_sel 
                2'd0, // exp_portb_sel 
                );  

/******************* Running through test cases*************************************************/
    test_description = "Not running "; 
    test_case_num = 0; 

    // loop through all of j type instruction test cases
    for (int i = 0; i < tb_testcases.size(); i++) begin 

      test_case_num = test_case_num + 1; 
      test_description = tb_testcases[i].test_description; 

      // apply the signals 
      fuif.reg_wr_mem = tb_testcases[i].reg_wr_mem; 
      fuif.reg_wr_wb = tb_testcases[i].reg_wr_wb; 
      fuif.rs = tb_testcases[i].rs; 
      fuif.rt = tb_testcases[i].rt; 

      // wait a little before checking outputs 
      #(10)
      check_outputs(test_description, tb_testcases[i].exp_porta_sel, tb_testcases[i].exp_portb_sel);
    end 
  end
endprogram
