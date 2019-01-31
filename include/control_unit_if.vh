/*
  Cody Mann
  mann53@purdue.edu

  control unit interface
*/
`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;
  import data_path_muxs_pkg::*; 

  logic RegWr, extend, equal, iREN, dWEN, dREN, halt; 
  mem_to_reg_mux_selection mem_to_reg; 
  reg_dest_mux_selection reg_dest; 
  regbits_t Rd, Rt, Rs; 
  aluop_t alu_op; 
  alu_source_mux_selection ALUSrc
  word_t instruction, load_addr;
  pc_mux_input_selection PCSrc; 
  logic [IMM_W - 1:0] imm16; 

  // control unit ports
  modport cu (
    input instruction, equal,
    output imm16, RegWr, reg_dest, Rd, Rs, Rt, alu_op, ALUSrc, mem_to_reg, iREN, dWEN, dREN, 
    PCSrc, load_addr, halt
  );

  // testbench ports
  modport tb (
    output instruction, equal,
    input imm16, RegWr, reg_dest, Rd, Rs, Rt, alu_op, ALUSrc, mem_to_reg, iREN, dWEN, dREN, 
    PCSrc, load_addr, halt
  );

endinterface

`endif //CONTROL_UNIT_IF_VH
