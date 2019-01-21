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
        // if a read data request 
        else if ((ccif.dREN == 1'b1) & (ccif.dWEN == 1'b0)) begin

          // go to the read data state 
          nxt_state = READ_DATA;  
        end 
        // if a write data request
        else if ((ccif.dREN == 1'b0) & (ccif.dWEN == 1'b1)) begin 

          // go the the write data state 
          nxt_state = WRITE_DATA
        end 
      end
      READ_INSTR: begin

        // if ram is busy
        if ((ccif.ramstate) == BUSY) begin 

          // stay in current state 
          nxt_state = state; 
        end
        // ir ram had data ready
        else if ((ccif.ramstate) == ACCESS) begin 

          // move the the grab instruction state 
          nxt_state = GRAB_INSTR; 
        end 
      end 
      GRAB_INSTR: nxt_state = IDLE; 
      WRITE_DATA: begin 

        // if ram is busy
        if ((ccif.ramstate) == BUSY) begin 

          // stay in current state 
          nxt_state = state; 
        end
        // ir ram is ready
        else if ((ccif.ramstate) == ACCESS) begin 

          // move the the send data state 
          nxt_state = SEND_DATA; 
        end 
      end 
      SEND_DATA: nxt_state = IDLE; 
      READ_DATA: begin 
        // if ram is busy
        if ((ccif.ramstate) == BUSY) begin 

          // stay in current state 
          nxt_state = state; 
        end
        // ir ram is ready
        else if ((ccif.ramstate) == ACCESS) begin 

          // move the the grab data state 
          nxt_state = GRAB_DATA; 
        end 
      end 
      GRAB_DATA: nxt_state = IDLE; 
    endcase
  end 

  // always comb block to determine outputs based on current state
  always_comb begin: STATE_OUTPUT_LOGIC

    // assign default values for outputs to cache/datapath 
    ccif.iload = 32'd0; 
    ccif.iwait = 1'b0; 
    ccif.dwait = 1'd0; 
    ccif.dload = 32'd0; 

    // assign default values for outputs to ram
    ccif.ramaddr = 32'd0; 
    ccif.ramREN = 1'b0; 
    ccif.ramWEN = 1'b0; 
    ccif.ramstore = 1'b0; 

    // find what state currently in 
    casez (state)

      IDLE: // do nothing (keep all default values)

      // reading data from ram 
      READ_INSTR: begin 

        // set outputs to cache/datapath
        ccif.iwait = 1'b1; 

        // set outputs to ram 
        ccif.ramaddr = ccif.iaddr; 
        ccif.ramREN = 1'b1; 
      end 
      GRAB_INSTR: begin 

        // set outputs to cache/datapath
        ccif.iwait = 1'b1; 
        ccif.iload = ccif.ramload; 

        // set outputs to ram 
        ccif.ramaddr = ccif.iaddr; 
        ccif.ramREN = 1'b1; 
      end 

      // reading data from ram 
      READ_DATA: begin 

        // set the outputs to cache/datapath 
        ccif.dwait = 1'b1; 

        // set the outputs to ram 
        ccif.ramaddr = ccif.daddr; 
        ccif.ramREN = 1'b1; 
      end 
      GRAB_DATA: begin 

        // set the outputs to cache/datapath 
        ccif.dwait = 1'b1; 
        ccif.dload = ccif.ramload; 

        // set outputs to ram 
        ccif.ramaddr = ccif.daddr; 
        ccif.ramREN = 1'b1; 
      end 

      // writing data to ram 
      WRITE_DATA: begin 

        // set the outputs to cache/datapath
        ccif.dwait = 1'b1; 

        // set outputs to ram 
        ccif.ramaddr = ccif.daddr; 
        ccif.ramWEN = 1'b1; 
      end 
      SEND_DATA: begin 

        // set the outputs to cache/datapath 
        ccif.dwait = 1'b1; 
        ccif.dload = ccif.ramload; 

        // set outputs to ram 
        ccif.ramaddr = ccif.daddr; 
        ccif.ramWEN = 1'b1; 
      end 
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
