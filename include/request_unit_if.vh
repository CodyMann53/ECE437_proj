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

  logic iREN, dREN, dWEN, pc_wait, ihit, dhit, imemREN, dmemWEN, dmemREN

  // program counter ports 
  modport ru (
    input   iREN, dREN, dWEN, ihit, dhit,
    output  imemREN, dmemWEN, dmemREN, pc_wait
  );

  // program counter tb
  modport tb (
    input   imemaddr,
    output  load_addr, PCSrc, halt, pc_wait, jr_addr
  );
endinterface

`endif //PC_IF_VH
