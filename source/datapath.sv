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
`include "alu_if.vh"
`include "request_unit_if.vh"
`include "register_file_if.vh"

// control signals for mux's 
`include "data_path_muxs_pkg.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*; 
import data_path_muxs_pkg::*; 

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

/************************** Locac Variable definitions ***************************/
word_t imm16_ext, port_b, wdat; 
regbits_t wsel; 

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

// alu inputs
assign aluif.port_b = port_b; 
assign aluif.port_a = rfif.rdat1; 
assign aluif.alu_op = cuif.alu_op; 

// register file inputs
assign rfif.WEN = cuif.RegWr; 
assign rfif.wsel = wsel; 
assign rfif.wdat = wdat; 
assign rfif.rsel2 = cuif.Rt; 
assign rfif.rsel1 = cuif.Rs; 

// data_path to cache signals 
assign dpif.imemaddr = pcif.imemaddr; 
assign dpif.imemREN = ruif.imemREN; 
assign dpif.dmemWEN = ruif.dmemWEN; 
assign dpif.dmemREN = ruif.dmemREN; 
assign dpif.halt = ruif.halt_out; 
assign dpif.dmemaddr = aluif.result; 
assign dpif.dmemstore = rfif.rdat2; 

/************************** Mux logic ***************************/

// This mux directs which input goes into the alu port b
always_comb begin: MUX_1
  
  // assign default value to prevent latches 
  port_b = 32'd0; 

  // case statement for control signals 
  casez (cuif.ALUSrc)
    SEL_REG_DATA: port_b = rfif.rdat2; 
    SEL_IMM16: port_b = imm16_ext; 
  endcase
end

// This mux directs which input goes into the write select port of register file 
always_comb begin: MUX_2

  // assign default value to prevent latches
  wsel = 5'b0; 

  // case statement for control signal 
  casez (cuif.reg_dest)
    SEL_RD: wsel = cuif.Rd;  
    SEL_RT:  wsel = cuif.Rt;  
  endcase
end 

// This mux directs which value gets sent to the wdat port of register file
always_comb begin: MUX_3
  
  // default values to prevent latches 
  wdat = 32'd0; 

  // control signal selection 
  casez (cuif.mem_to_reg)
    SEL_RESULT: wdat = aluif.result; 
    SEL_NPC: wdat = pcif.imemaddr; 
    SEL_DLOAD: wdat = dpif.dmemload;  
    SEL_IMM16_TO_UPPER_32: wdat = {cuif.imm16,16'b0}; 
  endcase
end 
/************************** Extender logic ***************************/

always_comb begin: EXTENDER_TO_ALU
  
  // set default value to prevent latches
  imm16_ext = 32'd0; 

  // case statement for control signal 
  casez (cuif.extend) 
    1'b0: imm16_ext = {16'h0, cuif.imm16};  
    1'b1: imm16_ext = {16'hffff, cuif.imm16}; 
  endcase
end 
endmodule
