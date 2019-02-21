`ifndef FORWARD_UNIT_IF_VH
`define FORWARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

interface forward_unit_if;

   regbits_t reg_wr_mem, reg_wr_wb, rs, rt;
   logic [1:0] porta_sel, portb_sel;

   modport fu (
      input reg_wr_mem, reg_wr_wb, rs, rt,
      output porta_sel, portb_sel
   );

   modport tb (
      output reg_wr_mem, reg_wr_wb, rs, rt,
      input porta_sel, portb_sel      
   );

endinterface

`endif
