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
  logic WEN_ID_EX, enable_EX_MEM, flush_EX_MEM; 
  reg_dest_mux_selection reg_dest_ID_EX; 
  aluop_t alu_op_ID_EX; 
  regbits_t Rt_ID_EX, Rd_ID_EX; 
  word_t result, rdat2; 

  // outputs
  word_t dmemaddr_EX_MEM, dmemstore_EX_MEM, result_EX_MEM; 
  logic WEN_EX_MEM; 
  reg_dest_mux_selection reg_dest_EX_MEM; 
  regbits_t Rt_EX_MEM, Rd_EX_MEM; 

  // EX_MEM register module ports 
  modport ex_mem_reg (
    input WEN_ID_EX, reg_dest_ID_EX, alu_op_ID_EX, Rt_ID_EX, Rd_ID_EX, result, enable_EX_MEM, flush_EX_MEM, rdat2, 
    output dmemaddr_EX_MEM, dmemstore_EX_MEM, result_EX_MEM, WEN_EX_MEM, reg_dest_EX_MEM, Rt_EX_MEM, Rd_EX_MEM
  );
endinterface
`endif //EX_MEM_REG_IF_VH


