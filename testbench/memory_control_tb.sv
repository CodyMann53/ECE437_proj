/*
  Cody Mann
  mann53@purdue.edu

  memory control test bench
*/

// mapped needs this
`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  // parameter definitions 
  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock generation block 
  always #(PERIOD/2) CLK++;

  // interface
  cache_control_if ccif ();
  cpu_ram_if ramif (); 

  // DUT declarations 
  `ifndef MAPPED
    memory_control DUT_MEMORY_CONTROL(CLK, nRST, ccif);
    ram DUT_RAM(CLK, nRST, ramif); 
  `else
    memory_control DUT_MEMORY_CONTROL(
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
      .\ccif.ccsnoopaddr (ccif.ccsnoopaddr),
      .\nRST (nRST),
      .\CLK (CLK)
    );
    ram DUT_RAM(
      .\CLK (CLK),
      .\nRST (nRST), 
      .\ramaddr (ramif.ramaddr),
      .\ramstore (ramif.ramstore), 
      .\ramREN (ramif.ramREN), 
      .\ramWEN (ramif.ramWEN), 
      .\ramstate (ramif.ramstate), 
      .\ramload (ramif.ramload)
    );
  `endif

  // assign statements memory control -> ram 
  assign ramif.ramaddr = ccif.ramaddr; 
  assign ramif.ramREN = ccif.ramREN; 
  assign ramif.ramWEN = ccif.ramWEN; 
  assign ramif.ramstore = ccif.ramstore; 

  // assign statements ram -> memory control 
  assign ccif.ramload = ramif.ramload; 
  assign ccif.ramstate = ramif.ramstate; 

  // test program
  test PROG ( 
    .CLK(CLK),
    .nRST(nRST),
    .iwait(ccif.iwait), 
    .dwait(ccif.dwait), 
    .ramWEN(ccif.ramWEN), 
    .ramREN(ccif.ramREN), 
    .iload(ccif.iload), 
    .dload(ccif.dload),
    .ramaddr(ccif.ramaddr), 
    .ramstore(ccif.ramstore), 
    .iREN(ccif.iREN), 
    .dREN(ccif.dREN), 
    .dWEN(ccif.dWEN),
    .dstore(ccif.dstore),
    .iaddr(ccif.iaddr), 
    .daddr(ccif.daddr), 
    .ramload(ccif.ramload), 
    .ramstate(ccif.ramstate) 
    ); 
endmodule

program test
  // import statements 
  import cpu_types_pkg::*; 
  // modports
  (
  input logic CLK, iwait, dwait,  
  input word_t iload, dload,
  output logic nRST, iREN, dREN, dWEN, 
  output word_t dstore, iaddr, daddr
  ); 

  // variable definitions for test case description 
  int test_case_num = 0; 
  string test_description = "NULL"; 

  // parameter definitions  
  parameter PERIOD = 10;

  // enumeration definitions 
  typedef enum logic [1:0] {
    READ_INSTR = 2'd0, 
    READ_DATA = 2'd1, 
    WRITE_DATA = 2'd2
  } operation_command; 

  // test vector definitions 
  typedef struct{
    string test_name; 
    word_t memory_address; 
    word_t test_data; 
    operation_command test_type;  
  }  test_vector; 

  // declare the unpacted/dynamically sized test-vector array 
  test_vector tb_test_cases []; 

  // copy of memory for checking functionality of memory control 
  word_t [31:0] ram_copy; 

  /*************** task definitions *************************************/
  
  // toggles the reset line 
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

  // assigns an element in array of test vectors its information 
  task add_test; 
    input int array_element; 
    input string test_name; 
    input word_t memory_address, test_data; 
    input operation_command test_type; 
    begin 

      // pass value into array 
      tb_test_cases[array_element].test_name = test_name; 
      tb_test_cases[array_element].memory_address = memory_address; 
      tb_test_cases[array_element].test_data = test_data; 
      tb_test_cases[array_element].test_type = test_type; 
    end 
  endtask

  task check_data; 
    input word_t memory_address; 
    input word_t test_data; 
    input string test_description; 
    begin 

      // if the data returned is not what should be expected 
      if (test_data != ram_copy[memory_address]) begin 

        // send error message to both questasim and terminal 
        $monitor("Incorrect value for test case: %s.", test_description); 
        $monitor("Expected value: %0d. Produced value: %0d.", ram_copy[memory_address], test_data);
        $display("Time: @%00g ns, Incorrect value for test case: %s.", test_description); 
        $display("Expected value: %0d. Produced value: %0d.", ram_copy[memory_address], test_data); 
      end 
    end 
  endtask

  task write_data; 
    input word_t test_data, memory_address; 
    begin

      // getting away from rising edge before applying inputs 
      @(negedge CLK); 

      // apply propper inputs to memory control for writing data  
      dWEN = 1'b1; 
      daddr = memory_address;
      dstore = test_data; 

      // wait a little to allow inputs to be applied before checking dwait 
      #(0.5)

      // wait until dwait is brought back low 
      while (dwait == 1'b1) begin 
        // do nothing here (just waiting)
      end 

      // get away from rising edge before deasserting inputs 
      @(negedge CLK)

      // deasert the inputs 
      dWEN = 1'b0; 
      daddr = 32'd0; 
      dstore = 32'd0;

      // update the copy of ram based on what was just written 
      ram_copy[memory_address] = test_data;  
    end 
  endtask

  // task to read instruction from memory
  task read_instruction; 
    input word_t memory_address; 
    input string test_description; 
    begin 

      // get away from rising edge before applying inputs 
      @(negedge CLK); 

      // apply propper inputs to memory control for a read instruciton
      iREN = 1'b1; 
      iaddr = memory_address; 

      // wait a little to allow inputs to be applied before checking iwait 
      #(0.5)

      // wait until iwait is brought back low 
      while (iwait == 1'b1) begin 
        // do nothing here (just waiting)
      end 

      // check for expected instruction value
      check_data(memory_address, iload, test_description);

      // get away from rising edge before deasserting inputs 
      @(negedge CLK); 
      
      // deassert the inputs 
      iREN = 1'b0; 
      iaddr = 32'd0; 
    end 
  endtask

  //initial block  
  initial begin

    // allocating space for test cases 
    tb_test_cases = new[1]; 

    // assigning test cases to array 
    add_test(0, "writing data to memory", 32'd0, 32'd1, WRITE_DATA); 

    // initialize the copy of ram to all zero values 
    ram_copy = 'b0; 

    // initialize all of the outputs to the memory controller (default values)
    nRST = 1'b0; 
    iREN = 1'b0; 
    dREN = 1'b0; 
    dWEN = 1'b0; 
    dstore = 32'd0; 
    iaddr = 32'd0; 
    daddr = 32'd0; 

    // reset the devices under test 
    reset_dut(); 

    // loop through all of the test cases
    for (int i = 0; i < tb_test_cases.size(); i++) begin 

      // update the test number and description 
      test_case_num = i; 
      test_description = tb_test_cases[i].test_name; 

      // wait a little before applying next test 
      #(1)

      // if a write data test 
      if (tb_test_cases[i].test_type == WRITE_DATA) begin 

        // call write data task 
        write_data( tb_test_cases[i].test_data, 
                    tb_test_cases[i].memory_address
                  ); 
      end 
      // if a read instruction test 
      else if (tb_test_cases[i].test_type == READ_INSTR) begin 

        // call write data task 
        read_instruction( tb_test_cases[i].memory_address, 
                    tb_test_cases[i].test_name
                  ); 
      end 
    end 
  end 
endprogram
