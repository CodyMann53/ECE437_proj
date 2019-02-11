/*
  Cody Mann
  mann53@purdue.edu

  ID/EX pipeline register interface
*/
`ifndef ID_EX_REG_IF_VH
`define ID_EX_REG_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg.vh"

interface id_ex_reg_if;

  // import types
  import cpu_types_pkg::*;
  import data_path_muxs_pkg::*; 

  logic iREN, iREN_ID_EX, 
  dREN, dREN_ID_EX, 
  dWEN, dWEN_ID_EX, 
  halt, halt_ID_EX, 
  WEN, WEN_ID_EX, enable_ID_EX, flush_ID_EX; 
  pc_mux_input_selection PCSrc, PCSrc_ID_EX; 
  aluop_t alu_op, alu_op_ID_EX; 
  reg_dest_mux_selection reg_dest, reg_dest_ID_EX; 
  alu_source_mux_selection ALUSrc, ALUSrc_ID_EX; 
  regbits_t Rt_IF_ID, Rd_IF_ID
  word_t rdat1, rdat2; 
  word_t imm16_ext; 
  word_t imm16_ext_ID_EX, rdat2_ID_EX, rdat1_ID_EX; 
  regbits_t Rs_IF_ID, Rt_IF_ID, Rd_IF_ID, Rt_ID_EX, Rd_ID_EX; 
  opcode_t opcode_IF_ID, func_IF_ID; 
  logic [15:0] imm16_IF_ID; 

  // IF/ID register module ports 
  modport id_ex_reg (
    input   iREN, dWEN, dREN, ALUSrc, PCSrc, WEN, alu_op, halt, reg_dest, Rt_IF_ID, Rd_IF_ID, rdat1, rdat2, imm16_ext, enable_ID_EX, flush_ID_EX,
    output  iREN_ID_EX, dREN_ID_EX, dWEN_ID_EX, PCSrc_ID_EX, halt_ID_EX, WEN_ID_EX, reg_dest_ID_EX, alu_op_ID_EX, Rt_ID_EX, Rd_ID_EX, 
    ALUSrc_ID_EX, rdat1_ID_EX, rdat2_ID_EX, imm16_ext_ID_EX
  );
endinterface
`endif //ID_EX_REG_IF_VH
