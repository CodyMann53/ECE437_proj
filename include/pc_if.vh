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

  logic     ihit; 
  word_t    imemaddr, jr_addr, next_imemaddr;
  logic [25:0] jmp_addr; 
  logic [15:0] br_addr; 
  pc_mux_input_selection PCSrc; 

  // program counter ports 
  modport pc (
    input   PCSrc, ihit, jr_addr, br_addr, jmp_addr,  
    output  imemaddr, next_imemaddr
  );

  // program counter tb
  modport tb (
    input   imemaddr, next_imemaddr
    output  PCSrc, ihit, jr_addr, br_addr, jmp_addr 
  );
endinterface

`endif //PC_IF_VH
