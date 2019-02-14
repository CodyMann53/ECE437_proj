/*
  Cody Mann
  mann53@purdue.edu

  MEM/WB pipeline register interface
*/
`ifndef MEM_WB_REG_IF_VH
`define MEM_WB_REG_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg.vh"

interface mem_wb_reg_if;

  // import types
  import cpu_types_pkg::*;
  import data_path_muxs_pkg::*; 

  // inputs
  word_t result_EX_MEM, dmemload; 
  logic WEN_EX_MEM, enable_MEM_WB, flush_MEM_WB, halt_EX_MEM; 
  reg_dest_mux_selection reg_dest_EX_MEM; 
  regbits_t Rt_EX_MEM, Rd_EX_MEM;

  // outputs 
  logic WEN_MEM_WB, halt; 
  reg_dest_mux_selection reg_dest_MEM_WB; 
  word_t mem_data_MEM_WB; 
  regbits_t Rt_MEM_WB, Rd_MEM_WB;  

  // cpu tracker inputs 
  word_t imemaddr_EX_MEM, next_imemaddr_EX_MEM; 
  opcode_t opcode_EX_MEM; 
  funct_t func_EX_MEM; 
  word_t instruction_EX_MEM; 
  logic [15:0] imm16_EX_MEM; 
  word_t imm16_ext_EX_MEM; 
  logic dmemstore_EX_MEM; 
  regbits_t rdat1_EX_MEM; 

  // cpu tracker outputs 
  word_t imemaddr_MEM_WB, next_imemaddr_MEM_WB; 
  opcode_t opcode_MEM_WB; 
  funct_t func_MEM_WB; 
  word_t instruction_MEM_WB; 
  logic [15:0] imm16_MEM_WB; 
  word_t imm16_ext_MEM_WB; 
  logic dmemstore_MEM_WB; 
  regbits_t rdat1_MEM_WB;
  word_t result_MEM_WB;  

  // EX_MEM register module ports 
  modport ex_mem_reg (
    input result_EX_MEM, dmemload, WEN_EX_MEM, reg_dest_EX_MEM, Rt_EX_MEM, Rd_EX_MEM, enable_MEM_WB, flush_MEM_WB, halt_EX_MEM, imemaddr_EX_MEM, opcode_EX_MEM, func_EX_MEM, instruction_EX_MEM,
    imm16_EX_MEM, imm16_ext_EX_MEM, dmemstore_EX_MEM, next_imemaddr_EX_MEM, rdat1_EX_MEM,
    output WEN_MEM_WB, reg_dest_MEM_WB, mem_data_MEM_WB, Rt_MEM_WB, Rd_MEM_WB, halt, imemaddr_MEM_WB, opcode_MEM_WB, func_MEM_WB, instruction_MEM_WB, 
    imm16_MEM_WB, imm16_ext_MEM_WB, dmemstore_MEM_WB, next_imemaddr_MEM_WB, rdat1_MEM_WB, result_MEM_WB
  );
endinterface
`endif //MEM_WB_REG_IF_VH
