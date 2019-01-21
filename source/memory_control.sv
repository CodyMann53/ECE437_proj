/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;


  // defining states for state machine 
  typedef enum logic [2:0] {

    IDLE = 3'd0, 

    // instruction states  
    READ_INSTR = 3'd1,
    GRAB_INSTR = 3'd2, 

    // data states 
    WRITE_DATA = 3'd3, 
    SEND_DATA = 3'd4, 
    READ_DATA = 3'd5, 
    GRAB_DATA = 3'd6
  } control_state; 

  // define variables for state and next state 
  control_state state, nxt_state; 

  // always comb block to determine next state 
  always_comb begin: NXT_STATE_LOGIC

    // set to keep same state as default value to prevent latches 
    nxt_state = state; 

    // determine which state currently in 
    casez (state)

      IDLE: begin 

        // if a read instruciton request is present with no data request 
        if ((ccif.iREN == 1'b1) & (ccif.dREN == 1'b0) & (ccif.dWEN == 1'b0)) begin 

          // move to read instruction state 
          nxt_state = READ_INSTR; 
        end 
      end
      READ_INSTR: begin

         
      end 
      GRAB_INSTR: nxt_state = IDLE; 
      WRITE_DATA: begin 
      end 
      SEND_DATA: nxt_state = IDLE; 
      READ_DATA: 
      GRAB_DATA: nxt_state = IDLE; 
    endcase




  end 

  // flip flop to hold the state memory 
  always_ff @(posedge CLK, negedge nRST) begin: STATE_REG

    // if reset is brought low 
    if (nRST == 1'b0) begin 

      // reset state back to idle 
      state = IDLE; 
    end 
    // no reset was applided 
    else begin 

      // update state to its next state 
      state = nxt_state; 
    end 
  end 
endmodule
