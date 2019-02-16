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

  logic WEN, iREN, dWEN, dREN, halt; 
  logic [1:0] extend; 
  mem_to_reg_mux_selection mem_to_reg; 
  reg_dest_mux_selection reg_dest;  
  aluop_t alu_op; 
  alu_source_mux_selection ALUSrc; 
  pc_mux_input_selection PCSrc; 
  logic [5:0] opcode_IF_ID, func_IF_ID;
  logic [15:0] imm16;  

  // control unit ports
  modport cu (
    input  opcode_IF_ID, func_IF_ID,
    output WEN, reg_dest, alu_op, ALUSrc, mem_to_reg, iREN, dWEN, dREN, 
    PCSrc, halt, extend, imm16
  );
endinterface
`endif //CONTROL_UNIT_IF_VH
