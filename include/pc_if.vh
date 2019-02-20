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

interface pc_if;
  // import types
  import cpu_types_pkg::*;
  import data_path_muxs_pkg::*; 

  word_t next_pc, imemaddr;
  logic ihit;  

  // program counter ports 
  modport pc (
    input ihit, next_pc, 
    output imemaddr
  );

endinterface
`endif //PC_IF_VH
