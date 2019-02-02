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

  logic     halt, pc_wait; 
  word_t    imemaddr, jr_addr, next_imemaddr;
  logic [25:0] load_addr; 
  logic [15:0] load_imm; 
  pc_mux_input_selection PCSrc; 

  // program counter ports 
  modport pc (
    input   load_addr, PCSrc, halt, pc_wait, jr_addr, load_imm,
    output  imemaddr, next_imemaddr
  );

  // program counter tb
  modport tb (
    input   imemaddr, next_imemaddr,
    output  load_addr, PCSrc, halt, pc_wait, jr_addr, load_imm
  );
endinterface

`endif //PC_IF_VH
