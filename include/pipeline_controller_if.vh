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
  logic iREN_ID_EX, dREN_ID_EX, dWEN_ID_EX, halt_ID_EX, ihit, dhit; 

  // outputs 
  logic enable_IF_ID, flush_IF_ID, 
        enable_ID_EX, flush_ID_EX, 
        enable_EX_MEM, flush_EX_MEM, 
        enable_MEM_WB, flush_MEM_WB, 
        imemREN, dmemREN, 
        dmemWEN, halt;


  // pipeline controller module ports 
  modport pipeline_controller (
    input iREN_ID_EX, dREN_ID_EX, dWEN_ID_EX, halt_ID_EX, ihit, dhit, 
    output enable_IF_ID, flush_IF_ID, 
        enable_ID_EX, flush_ID_EX, 
        enable_EX_MEM, flush_EX_MEM, 
        enable_MEM_WB, flush_MEM_WB, 
        imemREN, dmemREN, 
        dmemWEN, halt
  );
endinterface
`endif //PIPELINE_CONTROLLER_IF_VH
