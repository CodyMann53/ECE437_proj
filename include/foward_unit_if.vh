`ifndef FORWARD_UNIT_IF_VH
`define FORWARD_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface forward_unit_if;

  // import types
  import cpu_types_pkg::*;

   regbits_t reg_wr_mem, reg_wr_wb, rs, rt;
   logic [1:0] porta_sel, port_b_sel, mux6_sel;
   logic wen_ex_mem, wen_mem_wb; 

   modport fu (
      input reg_wr_mem, reg_wr_wb, rs, rt, wen_mem_wb, wen_ex_mem,
      output porta_sel, portb_sel, mux6_sel
   );

   modport tb (
      output reg_wr_mem, reg_wr_wb, rs, rt, wen_ex_mem, wen_mem_wb,
      input porta_sel, portb_sel, mux6_sel
   );

endinterface
`endif
