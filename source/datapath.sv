/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

// inner component interfaces
`include "control_unit_if.vh"
`include "alu_if"
`include "request_unit_if.vh"
`include "register_file_if.vh"

// control signals for mux's 
`include "data_path_muxs_pkg.hv"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

/************************** interface definitions ***************************/
alu_if aluif(); 
control_unit_if cuif(); 
request_unit_if ruif(); 
register_file_if rfif(); 
pc_if pcif(); 

/************************** glue logic ***************************/

// program counter inputs
assign pcif.PCSrc = cuif.PCSrc; 
assign pcif.load_imm = cuif.imm16; 
assign pcif.load_addr = cuif.load_addr; 
assign pcif.jr_addr = rfif.rdat1; 
assign pcif.pc_wait = ruif.pc_wait; 

// control unit inputs 
assign cuif.instruction = dpif.imemload; 
assign cuif.equal = aluif.zero; 

// request unit inputs 
assign ruif.iREN = cuif.iREN; 
assign ruif.dREN = cuif.dREN;
assign ruif.dWEN = cuif.dWEN; 
assign ruif.halt = cuif.halt; 
assign ruif.ihit = dpif.ihit; 
assign ruif.dhit = dpif.dhit; 

// alu input logic


// data_path to cache signals 
assign dpif.imemaddr = pcif.imemaddr; 





endmodule
