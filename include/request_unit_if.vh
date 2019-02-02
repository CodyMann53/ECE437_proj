/*
  Cody Mann
  mann53@purdue.edu

  request unit interface
*/
`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface request_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic iREN, dREN, dWEN, pc_wait, ihit, dhit, imemREN, dmemWEN, dmemREN, halt, halt_out; 

  // request unit interface ports 
  modport ru (
    input   iREN, dREN, dWEN, ihit, dhit, halt,
    output  imemREN, dmemWEN, dmemREN, pc_wait, halt_out
  );

    // request unit interface ports 
  modport tb (
    input  imemREN, dmemWEN, dmemREN, pc_wait, halt_out,
    output   iREN, dREN, dWEN, ihit, dhit, halt
  );


endinterface
`endif //REQUEST_UNIT_IF_VH
