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
    logic extend; 
    logic halt; 
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
    input logic extend; 
    input logic halt; 
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
      tb_exp_values[test_num].extend = extend;
      tb_exp_values[test_num].halt = halt;
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
      tb_test_cases_jtype[test_num].equal = equal;
      tb_test_cases_jtype[test_num].instruction.opcode = op; 
    end 
  endtask

  // itype structs 
  typedef struct {
    string test_name; 
    i_t instruction; 
    logic equal; 
  } test_vector_itype; 

  test_vector_itype tb_test_cases_itype[]; 

  task add_case_itype; 
    input int test_num; 
    input opcode_t op; 
    input string test_name; 
    input regbits_t rs; 
    input regbits_t rt; 
    input logic [IMM_W-1:0] imm; 
    input logic equal; 
    begin 
      tb_test_cases_itype[test_num].test_name = test_name;
      tb_test_cases_itype[test_num].instruction.rs = rs; 
      tb_test_cases_itype[test_num].instruction.rt = rt; 
      tb_test_cases_itype[test_num].instruction.imm = imm; 
      tb_test_cases_itype[test_num].equal = equal;
      tb_test_cases_itype[test_num].instruction.opcode = op;       
    end 
  endtask    

  // rtype structs 
  type struct {
    string tes_name; 
    r_t instruction; 
    logic equal; 
  }test_vector_rtype;

  test_vector_rtype tb_test_cases_rtype[]

  task add_case_rtype;
    input int test_num;
    input string test_name;  
    input opcode_t op; 
    input regbits_t rs; 
    input regbits_t rt; 
    input regbits_t rd; 
    input logic [SHAM_W-1:0] shamt; 
    input funct_t funct;
    input logic equal; 
    begin 
      tb_test_cases_itype[test_num].test_name = test_name;
      tb_test_cases_itype[test_num].instruction.rs = rs; 
      tb_test_cases_itype[test_num].instruction.rt = rt; 
      tb_test_cases_itype[test_num].instruction.rd = rd; 
      tb_test_cases_itype[test_num].instruction.shamt = shamt; 
      tb_test_cases_itype[test_num].equal = equal;
      tb_test_cases_itype[test_num].instruction.funct = funct; 
      tb_test_cases_itype[test_num].instruction.opcode = op;       
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
    input logic extend, halt;    
    begin 
      if (imm16 != cuif.imm16) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect imm16 for test case: %s", $time, test_name); 
        $display("Expected imm16: %d Actual imm16: %d", imm16, cuif.imm16); 
      end

      if (RegWr != cuif.RegWr) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect RegWr for test case: %s", $time, test_name); 
        $display("Expected Regwr: %d Actual RegWr: %d", RegWr, cuif.RegWr); 
      end

      if (iREN != cuif.iREN) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect iREN for test case: %s", $time, test_name); 
        $display("Expected iREN: %d Actual iREN: %d", iREN, cuif.iREN); 
      end

      if (dWEN != cuif.dWEN) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect dWEN for test case: %s", $time, test_name); 
        $display("Expected dWEN: %d Actual dWEN: %d", dWEN, cuif.dWEN);  
      end

      if (dREN != cuif.dREN) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect dREN for test case: %s", $time, test_name); 
        $display("Expected dREN: %d Actual dREN: %d", dREN, cuif.dREN);  
      end

      if (reg_dest != cuif.reg_dest) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect reg_dest for test case: %s", $time, test_name); 
        $display("Expected reg_dest: %d Actual reg_dest: %d", reg_dest, cuif.reg_dest);  
      end

      if (Rd != cuif.Rd) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect Rd for test case: %s", $time, test_name); 
        $display("Expected Rd: %d Actual Rd: %d", Rd, cuif.Rd); 
      end

      if (Rs != cuif.Rs) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect Rs for test case: %s", $time, test_name); 
        $display("Expected Rs: %d Actual Rs: %d", Rs, cuif.Rs); 
      end

      if (Rt != cuif.Rt) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect Rt for test case: %s", $time, test_name); 
        $display("Expected Rt: %d Actual Rt: %d", Rt, cuif.Rt); 
      end

      if (alu_op != cuif.alu_op) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect alu_op for test case: %s", $time, test_name); 
        $display("Expected alu_op: %d Actual alu_op: %d", alu_op, cuif.alu_op); 
      end

      if (ALUSrc != cuif.ALUSrc) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect ALU_Src for test case: %s", $time, test_name); 
        $display("Expected ALU_Src: %d Actual ALU_Src: %d", ALUSrc, cuif.ALUSrc); 
      end

      if (mem_to_reg != cuif.mem_to_reg) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect mem_to_reg for test case: %s", $time, test_name); 
        $display("Expected mem_to_reg: %d Actual mem_to_reg: %d", mem_to_reg, cuif.mem_to_reg); 
      end

      if (PCSrc != cuif.PCSrc) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect PCSrc for test case: %s", $time, test_name); 
        $display("Expected PCSrc: %d Actual PCSrc: %d", PCSrc, cuif.PCSrc);  
      end

      if (extend != cuif.extend) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect extend for test case: %s", $time, test_name); 
        $display("Expected extend: %d Actual extend: %d", extend, cuif.extend); 
      end

      if (halt != cuif.halt) begin 

        // throw an error flag to the display 
        $display("Time: %00g ns Incorrect halt for test case: %s", $time, test_name); 
        $display("Expected halt: %d Actual halt: %d", halt, cuif.halt); 
      end
    end 
  endtask 

  /***************Initial Block ********************/
  initial begin

    // initialize all inputs to zero 
    cuif.instruction = 32'd0; 
    cuif.equal = 1'b0; 

    // allocate test case number for j type
    tb_test_cases_jtype = new[2];

    // allocate test case number for i type 
    tb_test_cases_itype = new[15]; 

    // allocate test case number for r type
    tb_test_cases_rtype = new[]

    // allocate test case number for total test cases  
    tb_exp_values = new[17];

    // adding test cases for J-types
    add_case_jtype(0, J, "J command", 26'hFFFF, 1'b0); 
    add_expected_values(0, // test number
                        tb_test_cases_jtype[1].instruction[15:0], // imm16
                        1'b0, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_jtype[0].instruction[15:11], //Rd
                        tb_test_cases_jtype[0].instruction[25:21], // Rs
                        tb_test_cases_jtype[0].instruction[20:16], //Rt
                        ALU_ADD, //alu_op
                        SEL_REG_DATA, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_ADDR, // PCSrc
                        1'b0, // extend
                        1'b0 // halt 
                        ); 

    add_case_jtype(1, JAL, "JAL command", 26'hFFFF, 1'b0); 
    add_expected_values(1, // test number
                        tb_test_cases_jtype[1].instruction[15:0], // imm16
                        1'b1, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_jtype[1].instruction[15:11], //Rd
                        tb_test_cases_jtype[1].instruction[25:21], // Rs
                        tb_test_cases_jtype[1].instruction[20:16], //Rt
                        ALU_ADD, //alu_op
                        SEL_REG_DATA, //ALUSrc
                        SEL_NPC, //mem_to_reg
                        SEL_LOAD_ADDR,// PCSrc
                        1'b0, // extend
                        1'b0 // halt
                        ); 

    // adding test cases for i-types
    // BEQ not equal 
    add_case_itype(0, // test num
                   BEQ, // opcode
                   "Testing for BEQ not equal", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b0 // equal
                   );  
    add_expected_values(2, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b0, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_SUB, //alu_op
                        SEL_REG_DATA, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b0, // extend
                        1'b0 // halt 
                        );   

    // BEQ equal 
    add_case_itype(1, // test num
                   BEQ, // opcode
                   "Testing for BEQ equal", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b1 // equal
                   );  
    add_expected_values(3, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b0, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_SUB, //alu_op
                        SEL_REG_DATA, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_IMM16, // PCSrc
                        1'b0, // extend
                        1'b0 // halt 
                        ); 

    // BNEQ not equal 
    add_case_itype(2, // test num
                   BNE, // opcode
                   "Testing for BNE not equal", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b0 // equal
                   );  
    add_expected_values(4, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b0, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_SUB, //alu_op
                        SEL_REG_DATA, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_IMM16, // PCSrc
                        1'b0, // extend
                        1'b0 // halt 
                        ); 

    // BNEQ equal 
    add_case_itype(3, // test num
                   BNE, // opcode
                   "Testing for BNE equal", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b1 // equal
                   ); 
    add_expected_values(5, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b0, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_SUB, //alu_op
                        SEL_REG_DATA, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b0, // extend
                        1'b0 // halt 
                        ); 

    // ADDI
    add_case_itype(4, // test num
                   ADDI, // opcode
                   "Testing for ADDI", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b0 // equal
                   );  
    add_expected_values(6, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b1, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_ADD, //alu_op
                        SEL_IMM16, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b1, // extend
                        1'b0 // halt 
                        ); 

    // ADDIU
    add_case_itype(5, // test num
                   ADDIU, // opcode
                   "Testing for ADDIU", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b1 // equal
                   );  
    add_expected_values(7, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b1, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_ADD, //alu_op
                        SEL_IMM16, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b1, // extend
                        1'b0 // halt 
                        ); 

    // SLTI
    add_case_itype(6, // test num
                   SLTI, // opcode
                   "Testing for SLTI", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b0 // equal
                   );  
    add_expected_values(8, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b1, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_SLT, //alu_op
                        SEL_REG_DATA, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b1, // extend
                        1'b0 // halt 
                        ); 

    // SLTIU
    add_case_itype(7, // test num
                   SLTIU, // opcode
                   "Testing SLTIU", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b0 // equal
                   );  
    add_expected_values(9, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b1, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_SLTU, //alu_op
                        SEL_REG_DATA, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b1, // extend
                        1'b0 // halt 
                        ); 

    // ANDI
    add_case_itype(8, // test num
                   ANDI, // opcode
                   "Testing for ANDI", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b0 // equal
                   );  
    add_expected_values(10, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b1, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_AND, //alu_op
                        SEL_IMM16, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b1, // extend
                        1'b0 // halt 
                        ); 

    // ORI
    add_case_itype(9, // test num
                   ORI, // opcode
                   "Testing for ORI", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b0 // equal
                   );  
    add_expected_values(11, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b1, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_OR, //alu_op
                        SEL_IMM16, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b0, // extend
                        1'b0 // halt 
                        ); 

    // XORI
    add_case_itype(10, // test num
                   XORI, // opcode
                   "Testing for XORI", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b0 // equal
                   );  
    add_expected_values(12, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b1, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_XOR, //alu_op
                        SEL_IMM16, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b1, // extend
                        1'b0 // halt 
                        ); 

    // LUI
    add_case_itype(11, // test num
                   LUI, // opcode
                   "Testing for LUI", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b1 // equal
                   );  
    add_expected_values(13, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b1, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b1, //dREN
                        SEL_RT, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_ADD, //alu_op
                        SEL_REG_DATA, //ALUSrc
                        SEL_IMM16_TO_UPPER_32, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b0, // extend
                        1'b0 // halt 
                        ); 

    // LW
    add_case_itype(12, // test num
                   LW, // opcode
                   "Testing for LW", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b1 // equal
                   );  
    add_expected_values(14, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b1, //Regwr
                        1'b1, //iREN
                        1'b0, //dWEN
                        1'b1, //dREN
                        SEL_RT, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_ADD, //alu_op
                        SEL_IMM16, //ALUSrc
                        SEL_DLOAD, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b1, // extend
                        1'b0 // halt 
                        ); 

    // SW
    add_case_itype(13, // test num
                   SW, // opcode
                   "Testing for SW", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b1 // equal
                   );  
    add_expected_values(15, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b0, //Regwr
                        1'b1, //iREN
                        1'b1, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_ADD, //alu_op
                        SEL_IMM16, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b1, // extend
                        1'b0 // halt 
                        ); 

    // HALT
    add_case_itype(14, // test num
                   HALT, // opcode
                   "Testing for HALT", // test description
                   5'd3, // rs
                   5'd4, // rt
                   16'd24, // imm16, 
                   1'b0 // equal
                   );  
    add_expected_values(16, // test number
                        tb_test_cases_itype[0].instruction[15:0], // imm16
                        1'b0, //Regwr
                        1'b0, //iREN
                        1'b0, //dWEN
                        1'b0, //dREN
                        SEL_RD, //reg_dest
                        tb_test_cases_itype[0].instruction[15:11], //Rd
                        tb_test_cases_itype[0].instruction[25:21], // Rs
                        tb_test_cases_itype[0].instruction[20:16], //Rt
                        ALU_ADD, //alu_op
                        SEL_REG_DATA, //ALUSrc
                        SEL_RESULT, //mem_to_reg
                        SEL_LOAD_NXT_INSTR, // PCSrc
                        1'b0, // extend
                        1'b1 // halt 
                        ); 


/******************* Running through test cases*************************************************/
    test_description = "Not running "; 
    test_case_num = 0; 

    // loop through all of j type instruction test cases
    for (int i = 0; i < tb_test_cases_jtype.size(); i++) begin 

      test_case_num = test_case_num + 1; 
      test_description = tb_test_cases_jtype[i].test_name; 

      // apply the signals 
      cuif.instruction = tb_test_cases_jtype[i].instruction; 
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
                  tb_exp_values[i].PCSrc,
                  tb_exp_values[i].extend, 
                  tb_exp_values[i].halt
                  );

    end 

    // loop through all of i type instruction test cases
    for (int i = 0; i < tb_test_cases_itype.size(); i++) begin 

      test_case_num = test_case_num + 1; 
      test_description = tb_test_cases_itype[i].test_name; 

      // apply the signals 
      cuif.instruction = tb_test_cases_itype[i].instruction; 
      cuif.equal = tb_test_cases_itype[i].equal; 

      // wait a little before checking outputs 
      #(1)
      check_outputs(test_description,
                  tb_exp_values[i + tb_test_cases_jtype.size() ].imm16,
                  tb_exp_values[i + tb_test_cases_jtype.size()].RegWr,
                  tb_exp_values[i + tb_test_cases_jtype.size()].iREN, 
                  tb_exp_values[i + tb_test_cases_jtype.size()].dWEN, 
                  tb_exp_values[i + tb_test_cases_jtype.size()].dREN,
                  tb_exp_values[i + tb_test_cases_jtype.size()].reg_dest,
                  tb_exp_values[i + tb_test_cases_jtype.size()].Rd, 
                  tb_exp_values[i + tb_test_cases_jtype.size()].Rs,
                  tb_exp_values[i + tb_test_cases_jtype.size()].Rt, 
                  tb_exp_values[i + tb_test_cases_jtype.size()].alu_op, 
                  tb_exp_values[i + tb_test_cases_jtype.size()].ALUSrc,
                  tb_exp_values[i + tb_test_cases_jtype.size()].mem_to_reg, 
                  tb_exp_values[i + tb_test_cases_jtype.size()].PCSrc,
                  tb_exp_values[i + tb_test_cases_jtype.size()].extend, 
                  tb_exp_values[i + tb_test_cases_jtype.size() ].halt
                  );

    end 
  end
endprogram
