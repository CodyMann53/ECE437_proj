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

  // number of cpus for cc
  parameter CPUS = 1;

  logic CLK = 0, nRST;

  // clock generation block 
  always #(PERIOD/2) CLK++;

  // interface
    // coherence interface
  caches_if                 cif0();
  // cif1 will not be used, but ccif expects it as an input
  caches_if                 cif1();
  cache_control_if #(.CPUS(1))   ccif (cif0, cif1);
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
    .iload(ccif.iload), 
    .dload(ccif.dload),
    .iREN(cif0.iREN), 
    .dREN(cif0.dREN), 
    .dWEN(cif0.dWEN),
    .dstore(cif0.dstore),
    .iaddr(cif0.iaddr), 
    .daddr(cif0.daddr), 
    .ramload(ccif.ramload)
    ); 
endmodule

program test
  // import statements 
  import cpu_types_pkg::*; 
  // modports
  (
  input logic CLK, iwait, dwait,  
  input word_t iload, dload, ramload,
  output logic nRST, iREN, dREN, dWEN,
  output word_t dstore, iaddr, daddr
  ); 

  // variable definitions for test case description 
  int test_case_num; 
  string test_description; 

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

    end 
  endtask

  // task to read instruction from memory
  task read_instruction; 
    input word_t memory_address, test_data; 
    input string test_description; 
    begin 

      // get away from rising edge before applying inputs 
      @(negedge CLK); 

      // apply propper inputs to memory control for a read instruciton
      iREN = 1'b1; 
      iaddr = memory_address; 

      // wait a little to allow inputs to be applied before checking iwait 
      #(1)

      // wait unitl iwait is brought low 
      @(negedge iwait); 

      // wait a little bit to allow output to settle once access signal is shown 
      #(1)
      check_read(test_data, memory_address);

      // get away from rising edge before deasserting inputs 
      @(negedge CLK); 
      
      // deassert the inputs 
      iREN = 1'b0; 
      iaddr = 32'd0; 
    end 
  endtask

  // task to check data and instruction reads from ram (based on expected values)
  task check_read;
    input word_t expected_data, memory_location; 
    begin 

      // if expected data is not the same as ramload value
      if (expected_data != ramload) begin 

        // flag an error message to both the terminal and display window 
        //$monitor("Incorrect read from memroy location 0x%0h. Expected value = %0h Read value = %0h",
        //memory_location, expected_data, ramload); 
        $display("Time: %00gns Incorrect read from memroy location 0x%0h. Expected value = %0h Read value = %0h",
        $time, memory_location, expected_data, ramload); 
      end 
    end 
  endtask

  //initial block  
  initial begin

    // allocating space for test cases 

    // for test.loadstore.asm
    tb_test_cases = new[15]; 

    // for test.rtype.asm
    //tb_test_cases = new[29]; 

    // assigning test cases to array (for test.loadstore.asm)
    // array_element, test_name, memory_address, test_data, test_type 
    add_test(0, "Reading data back from memory 0x0.", 32'h0, 32'h340100F0, READ_INSTR); 
    add_test(1, "Reading data back from memory 0x4.", 32'h4, 32'h34020080, READ_INSTR); 
    add_test(2, "Reading data back from memory 0x8.", 32'h8, 32'h3C07DEAD, READ_INSTR); 
    add_test(3, "Reading data back from memory 0xc.", 32'hc, 32'h34E7BEEF, READ_INSTR); 
    add_test(4, "Reading data back from memory 0x10.", 32'h10, 32'h8C230000, READ_INSTR); 
    add_test(5, "Reading data back from memory 0x14.", 32'h14, 32'h8C240004, READ_INSTR); 
    add_test(6, "Reading data back from memory 0x18.", 32'h18, 32'h8C250008, READ_INSTR); 
    add_test(7, "Reading data back from memory 0x1c.", 32'h1c, 32'hAC430000, READ_INSTR); 
    add_test(8, "Reading data back from memory 0x20.", 32'h20, 32'hAC440004, READ_INSTR); 
    add_test(9, "Reading data back from memory 0x24.", 32'h24, 32'hAC450008, READ_INSTR); 
    add_test(10, "Reading data back from memory 0x28.", 32'h28, 32'hAC47000C, READ_INSTR); 
    add_test(11, "Reading data back from memory 0x2c.", 32'h2C, 32'hFFFFFFFF, READ_INSTR); 
    add_test(12, "Reading data back from memory 0xF0.", 32'hF0, 32'h00007337, READ_INSTR); 
    add_test(13, "Reading data back from memory 0xF4.", 32'hF4, 32'h00002701, READ_INSTR);
    add_test(14, "Reading data back from memory 0xF8.", 32'hF8, 32'h00001337, READ_INSTR);

    // assigning test cases to array (for test.rtype.asm)
    // array_element, test_name, memory_address, test_data, test_type 
    /*add_test(0, "Reading data back from memory 0x0.", 32'h0, 32'h3401D269, READ_INSTR); 
    add_test(1, "Reading data back from memory 0x4.", 32'h4, 32'h340237F1, READ_INSTR); 
    add_test(2, "Reading data back from memory 0x8.", 32'h8, 32'h34150080, READ_INSTR); 
    add_test(3, "Reading data back from memory 0xC.", 32'hc, 32'h341600F0, READ_INSTR); 
    add_test(4, "Reading data back from memory 0x10.", 32'h10, 32'h00221825, READ_INSTR); 
    add_test(5, "Reading data back from memory 0x14.", 32'h14, 32'h00222024, READ_INSTR); 
    add_test(6, "Reading data back from memory 0x18.", 32'h18, 32'h3025000F, READ_INSTR); 
    add_test(7, "Reading data back from memory 0x1C.", 32'h1c, 32'h00223021, READ_INSTR); 
    add_test(8, "Reading data back from memory 0x20.", 32'h20, 32'h24678740, READ_INSTR); 
    add_test(9, "Reading data back from memory 0x24.", 32'h24, 32'h00824023, READ_INSTR); 
    add_test(10, "Reading data back from memory 0x28.", 32'h28, 32'h00A24826, READ_INSTR); 
    add_test(11, "Reading data back from memory 0x2C.", 32'h2c, 32'h382AF33F, READ_INSTR); 
    add_test(12, "Reading data back from memory 0x30.", 32'h30, 32'h340E0004, READ_INSTR); 
    add_test(13, "Reading data back from memory 0x34.", 32'h34, 32'h01C15804, READ_INSTR);
    add_test(14, "Reading data back from memory 0x38.", 32'h38, 32'h340E0005, READ_INSTR);
    add_test(15, "Reading data back from memory 0x3C.", 32'h3c, 32'h01C16006, READ_INSTR); 
    add_test(16, "Reading data back from memory 0x40.", 32'h40, 32'h00226827, READ_INSTR); 
    add_test(17, "Reading data back from memory 0x44.", 32'h44, 32'hAECD0000, READ_INSTR); 
    add_test(18, "Reading data back from memory 0x48.", 32'h48, 32'hAEA30000, READ_INSTR); 
    add_test(19, "Reading data back from memory 0x4c.", 32'h4c, 32'hAEA40004, READ_INSTR); 
    add_test(20, "Reading data back from memory 0x50.", 32'h50, 32'hAEA50008, READ_INSTR); 
    add_test(21, "Reading data back from memory 0x54.", 32'h54, 32'hAEA6000C, READ_INSTR); 
    add_test(22, "Reading data back from memory 0x58.", 32'h58, 32'hAEA70010, READ_INSTR); 
    add_test(23, "Reading data back from memory 0x5c.", 32'h5c, 32'hAEA80014, READ_INSTR); 
    add_test(24, "Reading data back from memory 0x60.", 32'h60, 32'hAEA90018, READ_INSTR); 
    add_test(25, "Reading data back from memory 0x64.", 32'h64, 32'hAEAA001C, READ_INSTR); 
    add_test(26, "Reading data back from memory 0x68.", 32'h68, 32'hAEAB0020, READ_INSTR); 
    add_test(27, "Reading data back from memory 0x6c.", 32'h6c, 32'hAEAC0024, READ_INSTR);
    add_test(28, "Reading data back from memory 0x70.", 32'h70, 32'hFFFFFFFF, READ_INSTR);*/

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
                    tb_test_cases[i].test_data,
                    tb_test_cases[i].test_name
                  ); 
      end 
    end 
  end 
endprogram
