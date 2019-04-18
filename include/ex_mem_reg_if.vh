/*
  Cody Mann
  mann53@purdue.edu

  EX/MEM pipeline register interface
*/
`ifndef EX_MEM_REG_IF_VH
`define EX_MEM_REG_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg.vh"

interface ex_mem_reg_if;

  // import types
  import cpu_types_pkg::*;
  import data_path_muxs_pkg::*; 

  // inputs 
  logic WEN_ID_EX, enable_EX_MEM, flush_EX_MEM, iREN_ID_EX, dREN_ID_EX, dWEN_ID_EX, halt_ID_EX, zero, dhit; 
  reg_dest_mux_selection reg_dest_ID_EX; 
  aluop_t alu_op_ID_EX; 
  regbits_t Rt_ID_EX, Rd_ID_EX; 
  word_t result, data_store; 
  word_t branch_addr;
  logic datomic_ID_EX, datomic_EX_MEM; 

  // outputs
  word_t dmemaddr_EX_MEM, dmemstore_EX_MEM, result_EX_MEM; 
  logic WEN_EX_MEM, imemREN, dmemREN, dmemWEN, halt_EX_MEM; 
  reg_dest_mux_selection reg_dest_EX_MEM; 
  regbits_t Rt_EX_MEM, Rd_EX_MEM; 
  mem_to_reg_mux_selection mem_to_reg_ID_EX, mem_to_reg_EX_MEM; 
  word_t branch_addr_EX_MEM; 
  logic zero_EX_MEM; 

  // pass through for cpu tracker inputs 
  word_t imemaddr_ID_EX, next_imemaddr_ID_EX; 
  opcode_t opcode_ID_EX; 
  funct_t func_ID_EX; 
  word_t instruction_ID_EX; 
  logic [15:0] imm16_ID_EX; 
  word_t imm16_ext_ID_EX; 
  word_t rdat1_ID_EX;
  regbits_t Rs_ID_EX;  

  // cpu tracker outputs
  word_t imemaddr_EX_MEM, next_imemaddr_EX_MEM; 
  opcode_t opcode_EX_MEM; 
  funct_t func_EX_MEM; 
  word_t instruction_EX_MEM; 
  logic [15:0] imm16_EX_MEM; 
  word_t imm16_ext_EX_MEM;
  word_t rdat1_EX_MEM; 
  regbits_t Rs_EX_MEM; 

  // EX_MEM register module ports 
  modport ex_mem_reg (
    input WEN_ID_EX, reg_dest_ID_EX, alu_op_ID_EX, Rt_ID_EX, Rd_ID_EX, result, enable_EX_MEM, flush_EX_MEM, data_store, imemaddr_ID_EX, opcode_ID_EX, func_ID_EX, instruction_ID_EX, imm16_ID_EX, imm16_ext_ID_EX, 
    next_imemaddr_ID_EX, rdat1_ID_EX, Rs_ID_EX, mem_to_reg_ID_EX,
    branch_addr, zero, dhit, datomic_ID_EX, 
    output dmemaddr_EX_MEM, dmemstore_EX_MEM, result_EX_MEM, WEN_EX_MEM, reg_dest_EX_MEM, Rt_EX_MEM, Rd_EX_MEM, dREN_ID_EX, dWEN_ID_EX, iREN_ID_EX, halt_ID_EX, 
    imemaddr_EX_MEM, opcode_EX_MEM, func_EX_MEM, instruction_EX_MEM, imm16_EX_MEM, imm16_ext_EX_MEM, next_imemaddr_EX_MEM, rdat1_EX_MEM, Rs_EX_MEM, mem_to_reg_EX_MEM, 
    branch_addr_EX_MEM, zero_EX_MEM, dmemWEN, dmemREN, imemREN, datomic_EX_MEM
  );
endinterface
`endif //EX_MEM_REG_IF_VH


