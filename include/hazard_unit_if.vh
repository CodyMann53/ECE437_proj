/*
  Cody Mann
  mann53@purdue.edu

  hazard unit interface 
*/
`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;

  // import types
  import cpu_types_pkg::*; 

  // inputs
  logic ihit, dhit; 

  // outputs 
  logic enable_IF_ID, flush_IF_ID, 
        enable_ID_EX, flush_ID_EX, 
        enable_EX_MEM, flush_EX_MEM, 
        enable_MEM_WB, flush_MEM_WB;


  // hazard unit module ports 
  modport hazard_unit (
    input ihit, dhit, 
    output enable_IF_ID, flush_IF_ID, 
        enable_ID_EX, flush_ID_EX, 
        enable_EX_MEM, flush_EX_MEM, 
        enable_MEM_WB, flush_MEM_WB
  );
endinterface
`endif //HAZARD_UNIT_IF_VH
