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
  logic WEN_EX_MEM, enable_MEM_WB, flush_MEM_WB; 
  reg_dest_mux_selection reg_dest_EX_MEM; 
  regbits_t Rt_EX_MEM, Rd_EX_MEM;

  // outputs 
  logic WEN_MEM_WB; 
  reg_dest_mux_selection reg_dest_MEM_WB; 
  word_t mem_data_MEM_WB; 
  regbits_t Rt_MEM_WB, Rd_MEM_WB;  

  // EX_MEM register module ports 
  modport ex_mem_reg (
    input result_EX_MEM, dmemload, WEN_EX_MEM, reg_dest_EX_MEM, Rt_EX_MEM, Rd_EX_MEM, enable_MEM_WB, flush_MEM_WB, 
    output WEN_MEM_WB, reg_dest_MEM_WB, mem_data_MEM_WB, Rt_MEM_WB, Rd_MEM_WB
  );
endinterface
`endif //MEM_WB_REG_IF_VH
