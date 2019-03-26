/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/


<<<<<<< HEAD
// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
=======
module caches (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
  caches_if cif
);

  // icache
  //icache  ICACHE(dcif, cif);
  // dcache
  //dcache  DCACHE(dcif, cif);

// cpu types
`include "cpu_types_pkg.vh"


import cpu_types_pkg::*; 

module caches (
  input logic CLK, nRST,
  datapath_cache_if dcif,
  caches_if cif
);

  word_t instr;
  word_t daddr;

  // icache and dcache definitions
  icache  ICACHE(CLK, nRST, dcif.icache, cif.icache);
  dcache  DCACHE(CLK, nRST, dcif.dcache, cif.dcache);

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
  
  //singlecycle
  assign dcif.ihit = (dcif.imemREN) ? ~cif.iwait : 0;
  assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~cif.dwait : 0;
  assign dcif.imemload = cif.iload;
  assign dcif.dmemload = cif.dload;


  assign cif.iREN = dcif.imemREN;
  assign cif.dREN = dcif.dmemREN;
  assign cif.dWEN = dcif.dmemWEN;
  assign cif.dstore = dcif.dmemstore;
  assign cif.iaddr = dcif.imemaddr;
  assign cif.daddr = dcif.dmemaddr;

endmodule
