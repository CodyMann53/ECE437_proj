/*
  Cody Mann
  mann53@purdue.edu

  Arithmetic Logic Unit Interface interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;

  // import types
  import cpu_types_pkg::*;

  // declaring signals 
  word_t  port_a, port_b, result;
  aluop_t alu_op; 
  logic negative, overflow, zero;  

  // alu file ports
  modport alu (
    input   port_a, port_b, alu_op,
    output  negative, result, overflow, zero 
  );

  // alu test bench file ports
  modport tb (
    input  negative, result, overflow, zero,
    output   port_a, port_b, alu_op
  );

endinterface

`endif //ALU_IF_VH

