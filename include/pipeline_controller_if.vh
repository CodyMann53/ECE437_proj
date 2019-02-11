/*
  Cody Mann
  mann53@purdue.edu

  pipeline controller interface 
*/
`ifndef PIPELINE_CONTROLLER_IF_VH
`define PIPELINE_CONTROLLER_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pipeline_controller_if;

  // import types
  import cpu_types_pkg::*; 

  // inputs
  logic ihit, dhit; 

  // outputs 
  logic enable_IF_ID, flush_IF_ID, 
        enable_ID_EX, flush_ID_EX, 
        enable_EX_MEM, flush_EX_MEM, 
        enable_MEM_WB, flush_MEM_WB;


  // pipeline controller module ports 
  modport pipeline_controller (
    input ihit, dhit, 
    output enable_IF_ID, flush_IF_ID, 
        enable_ID_EX, flush_ID_EX, 
        enable_EX_MEM, flush_EX_MEM, 
        enable_MEM_WB, flush_MEM_WB, 
  );
endinterface
`endif //PIPELINE_CONTROLLER_IF_VH
