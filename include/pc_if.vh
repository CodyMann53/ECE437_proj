/*
  Cody Mann
  mann53@purdue.edu

  pc (program counter) interface
*/
`ifndef PC_IF_VH
`define PC_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg.vh"

// import types
import cpu_types_pkg::*;
import data_path_muxs_pkg::*; 

interface pc_if;
  // inputs
  word_t  next_pc, 
          imemaddr;
  logic enable_pc;  

  // program counter ports 
  modport pc (
    input  next_pc, enable_pc,
    output imemaddr
  );

  // testbench counter ports 
  modport tb (
    input imemaddr,
    output  next_pc, enable_pc
  );
endinterface
`endif //PC_IF_VH
