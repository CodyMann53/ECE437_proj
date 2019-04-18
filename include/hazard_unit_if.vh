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
  logic ihit, 
        dhit, 
        zero_EX_MEM, 
        dREN_ID_EX, 
        dmemREN, 
        dmemWEN,
        halt; 
  opcode_t  opcode_IF_ID, 
            opcode_ID_EX, 
            opcode_EX_MEM;
  funct_t func_IF_ID; 
  regbits_t Rt_ID_EX, 
            Rs_IF_ID, 
            Rt_IF_ID; 

  // outputs 
  logic enable_IF_ID, 
        flush_IF_ID, 
        enable_ID_EX, 
        flush_ID_EX, 
        enable_EX_MEM, 
        flush_EX_MEM, 
        enable_MEM_WB, 
        flush_MEM_WB, 
        enable_pc;
  pc_mux_input_selection PCSrc; 

  // hazard unit module ports 
  modport hu(
    input ihit, 
          dhit, 
          zero_EX_MEM, 
          dREN_ID_EX, 
          opcode_EX_MEM, 
          opcode_IF_ID,  
          opcode_ID_EX, 
          func_IF_ID, 
          halt, 
          Rt_ID_EX, 
          Rs_IF_ID, 
          Rt_IF_ID, 
          dmemWEN, 
          dmemREN,  
    output  enable_IF_ID, 
            flush_IF_ID, 
            enable_ID_EX, 
            flush_ID_EX, 
            enable_EX_MEM, 
            flush_EX_MEM, 
            enable_MEM_WB, 
            flush_MEM_WB, 
            PCSrc, 
            enable_pc
  );

  // testbench unit module ports 
  modport tb(
    output  enable_IF_ID, 
            flush_IF_ID, 
            enable_ID_EX, 
            flush_ID_EX, 
            enable_EX_MEM, 
            flush_EX_MEM, 
            enable_MEM_WB, 
            flush_MEM_WB, 
            PCSrc, 
            enable_pc,
    input ihit, 
          dhit, 
          zero_EX_MEM, 
          dREN_ID_EX, 
          opcode_EX_MEM, 
          opcode_IF_ID, 
          func_IF_ID, 
          halt, 
          Rt_ID_EX, 
          Rs_IF_ID, 
          Rt_IF_ID, 
          dmemWEN, 
          dmemREN  
  );
endinterface
`endif //HAZARD_UNIT_IF_VH
