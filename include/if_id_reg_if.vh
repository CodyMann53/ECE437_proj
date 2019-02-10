/*
  Cody Mann
  mann53@purdue.edu

  IF/ID pipeline register interface
*/
`ifndef IF_ID_REG_IF_VH
`define IF_ID_REG_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface if_id_reg_if;

  // import types
  import cpu_types_pkg::*;

  word_t instruction; 
  regbits_t Rs_IF_ID, Rt_IF_ID, Rd_IF_ID; 
  opcode_t opcode_IF_ID, func_IF_ID; 
  logic [15:0] imm16_IF_ID; 

  // IF/ID register module ports 
  modport if_id_reg (
    input   instruction, 
    output  Rs_IF_ID, Rt_IF_ID, Rd_IF_ID, opcode_IF_ID, func_IF_ID, imm16_IF_ID
  );
endinterface
`endif //IF_ID_REG_IF_VH
