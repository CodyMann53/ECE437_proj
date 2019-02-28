`ifndef FORWARD_UNIT_IF_VH
`define FORWARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"
`include "forward_unit_if.vh"
`include "data_path_muxs_pkg.vh"

import cpu_types_pkg::*; 
import data_path_muxs_pkg::*; 

interface forward_unit_if;

   regbits_t reg_wr_mem, reg_wr_wb, rs, rt;
   opcode_t opcode_ID_EX, opcode_EX_MEM, opcode_MEM_WB;
   logic [1:0] porta_sel, portb_sel, mux6_sel;
   logic WEN_EX_MEM, WEN_MEM_WB; 
   reg_dest_mux_selection reg_dest_ID_EX; 

   modport fu (
      input reg_wr_mem, reg_wr_wb, rs, rt, opcode_ID_EX, reg_dest_ID_EX, WEN_EX_MEM, WEN_MEM_WB, opcode_EX_MEM,
      output porta_sel, portb_sel, mux6_sel
   );

   modport tb (
      output reg_wr_mem, reg_wr_wb, rs, rt, opcode_ID_EX, reg_dest_ID_EX, WEN_EX_MEM, WEN_MEM_WB, opcode_EX_MEM,
      input porta_sel, portb_sel, mux6_sel 
   );

endinterface
`endif
