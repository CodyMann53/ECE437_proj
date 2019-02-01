/*
  Cody Mann
  mann53@purdue.edu

  control unit test bench
*/

/********************** Include statements *************************/
`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg.vh"

/********************** Import statements *************************/
import cpu_types_pkg::*; 
import data_path_muxs_pkg::*; 

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;

  /********************** Module variable definitions *************************/

  /********************** Clock generation *************************/

  /********************* enumberation definitions *****************/
  typedef enum logic [1:0]{
      J_TYPE = 2'd0, 
      I_TYPE = 2'd1, 
      R_TYPE = 2'd2
  } instruction_type; 

  /********************** Interface definitions *************************/
  control_unit_if cuif(); 

  /********************** Port map definitions *************************/
  `ifndef MAPPED
    control_unit DUT(cuif);
  `else
    request_unit DUT( 
    .\cuif.instruction (cuif.instruction), 
    .\cuif.equal (cuif.equal), 
    .\cuif.imm16 (cuif.imm16), 
    .\cuif.RegWr (cuif.RegWr), 
    .\cuif.reg_dest (cuif.reg_dest), 
    .\cuif.Rd (cuif.Rd), 
    .\cuif.Rs (cuif.Rs), 
    .\cuif.Rt (cuif.Rt),
    .\cuif.alu_op (cuif.alu_op), 
    .\cuif.ALUSrc (cuif.ALUSrc), 
    .\cuif.mem_to_reg (cuif.mem_to_reg), 
    .\cuif.iREN (cuif.iREN), 
    .\cuif.dWEN (cuif.dWEN), 
    .\cuif.dREN (cuif.dREN), 
    .\cuif.PCSrc (cuif.PCSrc), 
    .\cuif.load_addr (cuif.load_addr), 
    .\cuif.halt (cuif.halt)  
    );
  `endif

  /***************Assign statements ********************/


  /***************Program Calls********************/

  // test program
  test PROG (
    .cuif (cuif)
    );

endmodule

  /***************Program Definitions ********************/

program test
  // modports
  (
  control_unit_if cuif
  );

  /***************Program local variable definitions ********************/

  // variable definitions for test case description
  int test_case_num;
  string test_description;

  /***************Test Vector Definitions ********************/

  // expected values vector
  typedef struct {
    logic [15:0] imm16; 
    logic RegWr, iREN, dWEN, dREN; 
    reg_dest_mux_selection reg_dest; 
    logic [4:0] Rd, Rs, Rt, alu_op; 
    alu_source_mux_selection ALUSrc; 
    mem_to_reg_mux_selection mem_to_reg; 
    pc_mux_input_selection PCSrc;
  } expected_values_vector; 

  expected_values_vector tb_exp_values []; 

  task add_expected_values; 
    input int test_num; 
    input logic [15:0] exp_imm16; 
    input logic exp_RegWr, exp_iREN, exp_dWEN, exp_dREN; 
    input reg_dest_mux_selection exp_reg_dest; 
    input logic [4:0] exp_Rd, exp_Rs, exp_Rt, exp_alu_op; 
    input alu_source_mux_selection exp_ALUSrc; 
    input mem_to_reg_mux_selection exp_mem_to_reg;
    input pc_mux_input_selection exp_PCSrc;  
    begin 
      tb_exp_values[test_num].imm16 = exp_imm16; 
      tb_exp_values[test_num].RegWr = exp_RegWr; 
      tb_exp_values[test_num].iREN = exp_iREN; 
      tb_exp_values[test_num].dWEN = exp_dWEN; 
      tb_exp_values[test_num].dREN = exp_dREN; 
      tb_exp_values[test_num].reg_dest = exp_reg_dest; 
      tb_exp_values[test_num].Rd = exp_Rd; 
      tb_exp_values[test_num].Rs = exp_Rs; 
      tb_exp_values[test_num].Rt = exp_Rt; 
      tb_exp_values[test_num].ALUSrc = exp_ALUSrc; 
      tb_exp_values[test_num].mem_to_reg = exp_mem_to_reg; 
      tb_exp_values[test_num].PCSrc = exp_PCSrc;
    end 
  endtask

  // J_type structs
  typedef struct {
    string test_name; 
    j_t instruction; 
    logic equal; 
  } test_vector_jtype; 

  test_vector_jtype tb_test_cases_jtype []; 

  task add_case_jtype;
    input int test_num;
    input opcode_t op; 
    input string test_name; 
    input logic [ADDR_W-1:0] address; 
    input logic equal; 
    begin 
      tb_test_cases_jtype[test_num].test_name = test_name;
      tb_test_cases_jtype[test_num].instruction.addr = address; 
      tb_test_cases_jtype[test_name].equal = equal;
      tb_test_cases_jtype[test_name].instruction.opcode = op; 
    end 
  endtask

  task check_outputs; 
    input string test_name;
    input logic [15:0] imm16; 
    input logic RegWr, iREN, dWEN, dREN; 
    input reg_dest_mux_selection reg_dest; 
    input logic [4:0] Rd, Rs, Rt, alu_op; 
    input alu_source_mux_selection ALUSrc; 
    input mem_to_reg_mux_selection mem_to_reg; 
    input pc_mux_input_selection PCSrc;   
    begin 
      if (imm16 != cuif.imm16) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect imemREN for test case: %s", $time, test_name); 
        $display("Expected imemREN: %d Actual imemREN: %d", imm16, cuif.imm16); 
        $monitor("Time: %00g ns Incorrect imemREN for test case: %s", $time, test_name); 
        $monitor("Expected imemREN: %0d Actual imemREN: %0d", imm16, cuif.imm16); 
      end

      if (RegWr != cuif.RegWr) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect imemREN for test case: %s", $time, test_name); 
        $display("Expected imemREN: %d Actual RegWr: %d", RegWr, cuif.RegWr); 
        $monitor("Time: %00g ns Incorrect RegWr for test case: %s", $time, test_name); 
        $monitor("Expected RegWr: %0d Actual RegWr: %0d", RegWr, cuif.RegWr); 
      end

      if (iREN != cuif.iREN) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect iREN for test case: %s", $time, test_name); 
        $display("Expected iREN: %d Actual iREN: %d", iREN, cuif.iREN); 
        $monitor("Time: %00g ns Incorrect iREN for test case: %s", $time, test_name); 
        $monitor("Expected iREN: %0d Actual iREN: %0d", iREN, cuif.iREN); 
      end

      if (dWEN != cuif.dWEN) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect dWEN for test case: %s", $time, test_name); 
        $display("Expected dWEN: %d Actual dWEN: %d", dWEN, cuif.dWEN); 
        $monitor("Time: %00g ns Incorrect dWEN for test case: %s", $time, test_name); 
        $monitor("Expected dWEN: %0d Actual dWEN: %0d", dWEN, cuif.dWEN); 
      end

      if (dREN != cuif.dREN) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect dREN for test case: %s", $time, test_name); 
        $display("Expected dREN: %d Actual dREN: %d", dREN, cuif.dREN); 
        $monitor("Time: %00g ns Incorrect dREN for test case: %s", $time, test_name); 
        $monitor("Expected dREN: %0d Actual dREN: %0d", dREN, cuif.dREN); 
      end

      if (reg_dest != cuif.reg_dest) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect reg_dest for test case: %s", $time, test_name); 
        $display("Expected reg_dest: %d Actual reg_dest: %d", reg_dest, cuif.reg_dest); 
        $monitor("Time: %00g ns Incorrect reg_dest for test case: %s", $time, test_name); 
        $monitor("Expected reg_dest: %0d Actual reg_dest: %0d", reg_dest, cuif.reg_dest); 
      end

      if (Rd != cuif.Rd) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect Rd for test case: %s", $time, test_name); 
        $display("Expected Rd: %d Actual Rd: %d", Rd, cuif.Rd); 
        $monitor("Time: %00g ns Incorrect Rd for test case: %s", $time, test_name); 
        $monitor("Expected Rd: %0d Actual Rd: %0d", Rd, cuif.Rd); 
      end

      if (Rs != cuif.Rs) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect Rs for test case: %s", $time, test_name); 
        $display("Expected Rs: %d Actual Rs: %d", Rs, cuif.Rs); 
        $monitor("Time: %00g ns Incorrect Rs for test case: %s", $time, test_name); 
        $monitor("Expected Rs: %0d Actual Rs: %0d", Rs, cuif.Rs); 
      end

      if (Rt != cuif.Rt) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect Rt for test case: %s", $time, test_name); 
        $display("Expected Rt: %d Actual Rt: %d", Rt, cuif.Rt); 
        $monitor("Time: %00g ns Incorrect Rt for test case: %s", $time, test_name); 
        $monitor("Expected Rt: %0d Actual Rt: %0d", Rt, cuif.Rt); 
      end

      if (alu_op != cuif.alu_op) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect alu_op for test case: %s", $time, test_name); 
        $display("Expected alu_op: %d Actual alu_op: %d", alu_op, cuif.alu_op); 
        $monitor("Time: %00g ns Incorrect alu_op for test case: %s", $time, test_name); 
        $monitor("Expected alu_op: %0d Actual alu_op: %0d", alu_op, cuif.alu_op); 
      end

      if (ALUSrc != cuif.ALUSrc) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect ALU_Src for test case: %s", $time, test_name); 
        $display("Expected ALU_Src: %d Actual ALU_Src: %d", ALUSrc, cuif.ALUSrc); 
        $monitor("Time: %00g ns Incorrect ALU_Src for test case: %s", $time, test_name); 
        $monitor("Expected ALU_Src: %0d Actual ALU_Src: %0d", ALUSrc, cuif.ALUSrc); 
      end

      if (mem_to_reg != cuif.mem_to_reg) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect mem_to_reg for test case: %s", $time, test_name); 
        $display("Expected mem_to_reg: %d Actual mem_to_reg: %d", mem_to_reg, cuif.mem_to_reg); 
        $monitor("Time: %00g ns Incorrect mem_to_reg for test case: %s", $time, test_name); 
        $monitor("Expected mem_to_reg: %0d Actual mem_to_reg: %0d", mem_to_reg, cuif.mem_to_reg); 
      end

      if (PCSrc != cuif.PCSrc) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect PCSrc for test case: %s", $time, test_name); 
        $display("Expected PCSrc: %d Actual PCSrc: %d", PCSrc, cuif.PCSrc); 
        $monitor("Time: %00g ns Incorrect PCSrc for test case: %s", $time, test_name); 
        $monitor("Expected PCSrc: %0d Actual imemREN: %0d", PCSrc, cuif.PCSrc); 
      end
    end 
  endtask 

  /***************Initial Block ********************/
  initial begin

    // initialize all inputs to zero 
    cuif.instruction = 32'd0; 
    cuif.equal = 1'b0; 

    // allocate test case number
    tb_test_cases_jtype = new[1]; 
    tb_exp_values = new[1]; 


    // adding test cases 
    add_case_jtype(0, J, "J command", 26'hFFFF, 1'b0); 
    add_expected_values(0, // test number
                        16'd0, // imm16
                        1'b0, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        5'd0, //Rd
                        5'd0, // Rs
                        5'b0, //Rt
                        1'b1, //alu_up
                        SEL_REG_DATA, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_ADDR// PCSrc
                        ); 




/******************* Running through test cases*************************************************/
    test_description = "Not running "; 
    test_case_num = 0; 


    // loop through all of the testcases
    for (int i = 0; i < tb_exp_values.size(); i++) begin 

      test_case_num = test_case_num + 1; 
      test_description = tb_test_cases_jtype[i].test_name; 

      // apply the signals 
      cuif.instruction[31:26] = tb_test_cases_jtype[i].instruction.opcode; 
      cuif.instruction[25:0] = tb_test_cases_jtype[i].instruction.addr; 
      cuif.equal = tb_test_cases_jtype[i].equal; 

    // wait a little before checking outputs 
    #(1)
    check_outputs(test_description,
                  tb_exp_values[i].imm16,
                  tb_exp_values[i].RegWr,
                  tb_exp_values[i].iREN, 
                  tb_exp_values[i].dWEN, 
                  tb_exp_values[i].dREN,
                  tb_exp_values[i].reg_dest,
                  tb_exp_values[i].Rd, 
                  tb_exp_values[i].Rs,
                  tb_exp_values[i].Rt, 
                  tb_exp_values[i].alu_op, 
                  tb_exp_values[i].ALUSrc,
                  tb_exp_values[i].mem_to_reg, 
                  tb_exp_values[i].PCSrc
                  );

    end 
  end
endprogram
