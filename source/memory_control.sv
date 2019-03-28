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

  typedef enum logic[3:0] {
   IDLE, GRANT_D, GRANT_I, RAM_WB1, RAM_WB2, CACHE_WB1, CACHE_WB2, WB1_RAM, WB2_RAM
  } state_t;

  state_t state, next_state;

  logic bus_access, next_bus_access;

/**************************** comb blocks ***********************************/  
/*
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
*/

  always_ff @(posedge CLK or negedge nRST)
  begin
     if(nRST == 0)
     begin
        state <= IDLE;
        bus_access <= 0;
     end
     else
     begin
        state <= next_state;
        bus_access <= next_bus_access;
     end
  end

  always_comb begin: BUS_CONTROLLER_FSM
    next_state = state;
    next_bus_access = bus_access;
    casez(state)
      IDLE : 
      begin
        if(ccif.dWEN[0] == 1 || ccif.dWEN[1] == 1)
        begin
          next_state = WB1_RAM;
          if(ccif.dWEN[0] == 1 && ccif.dWEN[1] == 1)
          begin
            if(bus_access == 0)
            begin
              next_bus_access = 1;
            end
            else
            begin
              next_bus_access = 0;
            end
          end
          else if(ccif.dWEN[0] == 1)
          begin
            next_bus_access = 0;
          end
          else
          begin
            next_bus_access = 1;
          end
        end
        else if(ccif.dREN[0] == 1 || ccif.dREN[1] == 1)
        begin
          next_state = GRANT_D;
          if(ccif.dREN[0] == 1 && ccif.dREN[1] == 1)
          begin
            if(bus_access == 0)
            begin
              next_bus_access = 1;
            end
            else
            begin
              next_bus_access = 0;
            end
          end
          else if(ccif.dREN[0] == 1)
          begin
            next_bus_access = 0;
          end
          else
          begin
            next_bus_access = 1;
          end
        end
        else if(ccif.iREN[0] == 1 || ccif.iREN[1] == 1)
        begin
          next_state = GRANT_I;
          if(ccif.iREN[0] == 1 && ccif.iREN[1] == 1)
          begin
            if(bus_access == 0)
            begin
              next_bus_access = 1;
            end
            else
            begin
              next_bus_access = 0;
            end
          end
          else if(ccif.iREN[0] == 1)
          begin
            next_bus_access = 0;
          end
          else
          begin
            next_bus_access = 1;
          end
        end
      end
      GRANT_D : 
      begin
        if(bus_access == 0)
        begin
          if(ccif.cctrans[1] == 1 && ccif.ccwrite[1] == 1)
          begin
            next_state = CACHE_WB1;
          end
          else if(ccif.cctrans[1] == 1 && ccif.ccwrite[1] == 0)
          begin
            next_state = RAM_WB1;
          end
        end
        else
        begin
          if(ccif.cctrans[0] == 1 && ccif.ccwrite[0] == 1)
          begin
            next_state = CACHE_WB1;
          end
          else if(ccif.cctrans[0] == 1 && ccif.ccwrite[0] == 0)
          begin
            next_state = RAM_WB1;
          end
        end
      end
      GRANT_I : 
      begin
        if(ccif.ramstate == ACCESS) 
        begin
          next_state = IDLE;
        end
      end
      RAM_WB1 : 
      begin
        if(ccif.ramstate == ACCESS) 
        begin
          next_state = RAM_WB2;
        end        
      end
      RAM_WB2 : 
      begin
        if(ccif.ramstate == ACCESS) 
        begin
          next_state = IDLE;
        end 
      end
      CACHE_WB1 : 
      begin
        if(ccif.ramstate == ACCESS) 
        begin
          next_state = CACHE_WB2;
        end 
      end
      CACHE_WB2 : 
      begin
        if(ccif.ramstate == ACCESS) 
        begin
          next_state = IDLE;
        end 
      end
      WB1_RAM : 
      begin
        if(ccif.ramstate == ACCESS) 
        begin
          next_state = WB2_RAM;
        end 
      end
      WB2_RAN :
      begin
        if(ccif.ramstate == ACCESS) 
        begin
          next_state = IDLE;
        end 
      end
    endcase
  end

  always_comb : OUTPUT_LOGIC
  begin
    ccif.iwait[0]       = 1;
    ccif.iwait[1]       = 1;
    ccif.dwait[0]       = 1;
    ccif.dwait[1]       = 1;
    ccif.iload[0]       = 0;
    ccif.iload[1]       = 0;
    ccif.dload[0]       = 0;
    ccif.dload[1]       = 0;
    ccif.ramstore       = 0;
    ccif.ramaddr        = 0;
    ccif.ramWEN         = 0;
    ccif.ramREN         = 0;
    ccif.ccwait[0]      = 0;
    ccif.ccwait[1]      = 0;
    ccif.ccinv[0]       = 0;
    ccif.ccinv[1]       = 0;
    ccif.ccsnoopaddr[0] = 0;
    ccif.ccsnoopaddr[1] = 0;

    casez(state)
      GRANT_D : 
      begin
        if(bus_access == 0)
        begin
          ccif.ccwait[1] = 1;
          ccif.ccsnoopaddr[1] = ccif.daddr[0];
          ccif.ccinv[1] = ccif.ccwrite[0];
        end
        else
        begin
          ccif.ccwait[0] = 1;
          ccif.ccsnoopaddr[0] = ccif.daddr[1];
          ccif.ccinv[0] = ccif.ccwrite[1];
        end
      end
      GRANT_I : 
      begin
        ccif.ramREN = 1;
        if(bus_access == 0)
        begin
          ccif.ramaddr = ccif.iaddr[0];
          ccif.iload[0] = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            ccif.iwait[0] = 0;
          end
          else
          begin
            ccif.iwait[0] = 1;
          end
        end
        else
        begin
          ccif.ramaddr = ccif.iaddr[1];
          ccif.iload[1] = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            ccif.iwait[1] = 0;
          end
          else
          begin
            ccif.iwait[1] = 1;
          end
        end      
      end
      RAM_WB1 : 
      begin
        ccif.ramREN = 1
        if(bus_access == 0)
        begin
          ccif.ccwait[1] = 1;
          ccif.ramaddr = ccif.daddr[0];
          ccif.dload[0] = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            ccif.dwait[0] = 0;
          end
          else
          begin
            ccif.dwait[0] = 1;
          end
        end
        else
        begin
          ccif.ccwait[0] = 1;
          ccif.ramaddr = ccif.daddr[1];
          ccif.dload[1] = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            ccif.dwait[1] = 0;
          end
          else
          begin
            ccif.dwait[1] = 1;
          end
        end      
      end
      RAM_WB2 : 
      begin
        ccif.ramREN = 1
        if(bus_access == 0)
        begin
          ccif.ccwait[1] = 1;
          ccif.ramaddr = ccif.daddr[0];
          ccif.dload[0] = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            ccif.dwait[0] = 0;
          end
          else
          begin
            ccif.dwait[0] = 1;
          end
        end
        else
        begin
          ccif.ccwait[0] = 1;
          ccif.ramaddr = ccif.daddr[1];
          ccif.dload[1] = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            ccif.dwait[1] = 0;
          end
          else
          begin
            ccif.dwait[1] = 1;
          end
        end         
      end
      CACHE_WB1 : 
      begin
        ccif.ramWEN = 1;
        if(bus_access == 0)
        begin
          ccif.ccwait[1] = 1;
          ccif.dload[0] = ccif.dstore[1];
          ccif.raddr = ccif.daddr[1];
          ccif.ramstore = ccif.dstore[1];
          if(ccif.ramstate == ACCESS)
          begin
            ccif.dwait[0] = 0;
          end
          else
          begin
            ccif.dwait[0] = 1;
          end        
        end
        else
        begin
          ccif.ccwait[0] = 1;
          ccif.dload[1] = ccif.dstore[0];
          ccif.raddr = ccif.daddr[0];
          ccif.ramstore = ccif.dstore[0];
          if(ccif.ramstate == ACCESS)
          begin
            ccif.dwait[1] = 0;
          end
          else
          begin
            ccif.dwait[1] = 1;
          end  
        end
      end
      CACHE_WB2 : 
      begin
        ccif.ramWEN = 1;
        if(bus_access == 0)
        begin
          ccif.ccwait[1] = 1;
          ccif.dload[0] = ccif.dstore[1];
          ccif.raddr = ccif.daddr[1];
          ccif.ramstore = ccif.dstore[1];
          if(ccif.ramstate == ACCESS)
          begin
            ccif.dwait[0] = 0;
          end
          else
          begin
            ccif.dwait[0] = 1;
          end        
        end
        else
        begin
          ccif.ccwait[0] = 1;
          ccif.dload[1] = ccif.dstore[0];
          ccif.raddr = ccif.daddr[0];
          ccif.ramstore = ccif.dstore[0];
          if(ccif.ramstate == ACCESS)
          begin
            ccif.dwait[1] = 0;
          end
          else
          begin
            ccif.dwait[1] = 1;
          end  
        end      
      end
      WB1_RAM : 
      begin
        ccif.ramWEN = 1;
        if(bus_access == 0)
        begin
          ccif.ramaddr = ccif.iaddr[0];
          ccif.iload[0] = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            ccif.iwait[0] = 0;
          end
          else
          begin
            ccif.iwait[0] = 1;
          end  
        end
        else
        begin
          ccif.ramaddr = ccif.iaddr[1];
          ccif.iload[1] = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            ccif.iwait[1] = 0;
          end
          else
          begin
            ccif.iwait[1] = 1;
          end     
        end
      end
      WB2_RAM : 
      begin
        ccif.ramWEN = 1;
        if(bus_access == 0)
        begin
          ccif.ramaddr = ccif.iaddr[0];
          ccif.iload[0] = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            ccif.iwait[0] = 0;
          end
          else
          begin
            ccif.iwait[0] = 1;
          end  
        end
        else
        begin
          ccif.ramaddr = ccif.iaddr[1];
          ccif.iload[1] = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            ccif.iwait[1] = 0;
          end
          else
          begin
            ccif.iwait[1] = 1;
          end     
        end      
      end
    endcase
  end 

endmodule
