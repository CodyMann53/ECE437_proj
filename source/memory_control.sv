/*
  Cody Mann
  mann53@purdue.edu

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;

/**************************** comb blocks ***********************************/  

  always_comb begin:  OUTPUT_LOGIC

    // set default outputs

    // datapath/cache outputs
    ccif.iwait = 1'b1; 
    ccif.dwait = 1'b1; 
    ccif.iload = 32'd0; 
    ccif.dload = 32'd0;  

    // ram outputs 
    ccif.ramstore = 32'd0; 
    ccif.ramaddr = 32'd0; 
    ccif.ramWEN = 1'b0; 
    ccif.ramREN = 1'b0; 

        // if requesting a data read or write (should always have precedence)
    if ((ccif.dREN == 1'b1) | (ccif.dWEN == 1'b1)) begin 

        // route the data address requestion location regardless of a read or write to ram 
        ccif.ramaddr = ccif.daddr; 

        // if a data read 
        if (ccif.dREN == 1'b1) begin 

          // tell ram that a data read is occuring 
          ccif.ramREN = 1'b1; 

          // rout ramload to data path dload 
          ccif.dload = ccif.ramload; 
        end 
        
        // else a data write is occuring 
        else begin 

          // tell ram that a data write is occuring 
          ccif.ramWEN = 1'b1; 

          // rout dstore to ram store 
          ccif.ramstore = ccif.dstore; 
        end  

        // if ram state is busy 
        if ( ccif.ramstate == ACCESS) begin 

          // keep dwaccit high 
          ccif.dwait = 1'b0;
        end 
    end 

    // if only requesting only instruction read 
    else if ((ccif.iREN == 1'b1) & (ccif.dREN == 1'b0) & (ccif.dWEN == 1'b0)) begin 

      // tell ram that a instruction read is occuring 
      ccif.ramREN = 1'b1; 

      // route the instruction address location request to ram 
      ccif.ramaddr = ccif.iaddr; 

      // if ram state is busy 
      if (ccif.ramstate == ACCESS) begin 

        // keep iwait high
        ccif.iwait = 1'b0; 
        ccif.iload = ccif.ramload;
      end 
    end 


  end 
endmodule
