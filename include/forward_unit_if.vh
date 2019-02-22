`ifndef FORWARD_UNIT_IF_VH
`define FORWARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"
`include "forward_unit_if.vh"
`include "data_path_muxs_pkg.vh"

import cpu_types_pkg::*; 
import data_path_muxs_pkg::*; 

interface forward_unit_if;

   regbits_t reg_wr_mem, reg_wr_wb, rs, rt;
   opcode_t opcode_ID_EX;
   logic [1:0] porta_sel, portb_sel;
   reg_dest_mux_selection reg_dest_ID_EX; 

   modport fu (
      input reg_wr_mem, reg_wr_wb, rs, rt, opcode_ID_EX, reg_dest_ID_EX, 
      output porta_sel, portb_sel
   );

   modport tb (
      output reg_wr_mem, reg_wr_wb, rs, rt, opcode_ID_EX, reg_dest_ID_EX, 
      input porta_sel, portb_sel  
   );

endinterface

`endif
