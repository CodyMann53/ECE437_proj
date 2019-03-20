/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/


// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*; 

module caches (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
  caches_if cif
);

  word_t instr;
  word_t daddr;

  // icache and dcache definitions
  icache  ICACHE(CLK, nRST, dcif, cif);
  dcache  DCACHE(CLK, nRST, dcif, cif);

  // single cycle instr saver (for memory ops)
  always_ff @(posedge CLK)
  begin
    if (!nRST)
    begin
      instr <= '0;
      daddr <= '0;
    end
    else
    if (dcif.ihit)
    begin
      instr <= cif.iload;
      daddr <= dcif.dmemaddr;
    end
  end
endmodule
