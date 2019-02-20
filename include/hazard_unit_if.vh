/*
  Cody Mann
  mann53@purdue.edu

  hazard unit interface 
*/
`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg.vh"

// import types
import cpu_types_pkg::*; 
import data_path_muxs_pkg::*; 

interface hazard_unit_if;

  // inputs
  logic ihit, dhit; 

  // outputs 
  logic enable_IF_ID, flush_IF_ID, 
        enable_ID_EX, flush_ID_EX, 
        enable_EX_MEM, flush_EX_MEM, 
        enable_MEM_WB, flush_MEM_WB;

  pc_mux_input_selection PCSrc; 
  


  // hazard unit module ports 
  modport hazard_unit (
    input ihit, dhit, 
    output enable_IF_ID, flush_IF_ID, 
        enable_ID_EX, flush_ID_EX, 
        enable_EX_MEM, flush_EX_MEM, 
        enable_MEM_WB, flush_MEM_WB, PCSrc
  );
endinterface
`endif //HAZARD_UNIT_IF_VH
