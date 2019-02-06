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

  logic     pc_wait; 
  word_t    imemaddr, jr_addr;
  logic [25:0] jmp_addr; 
  logic [15:0] br_addr; 
  pc_mux_input_selection PCSrc; 

  // program counter ports 
  modport pc (
    input   PCSrc, pc_wait, jr_addr, br_addr, jmp_addr,  
    output  imemaddr
  );

  // program counter tb
  modport tb (
    input   imemaddr,
    output  PCSrc, pc_wait, jr_addr, br_addr, jmp_addr 
  );
endinterface

`endif //PC_IF_VH
