/*
  Cody Mann
  mann53@purdue.edu

  This is the instruction cache and its controller.
*/


// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

// imports 
import cpu_types_pkg::*; 

module icache (
  input logic CLK, nRST,
  datapath_cache_if.icache dcif,
  caches_if cif
);

/********** Type definitions ***************************/
  // States for icache controller
  typedef enum logic{
    IDLE = 1'b0, 
    REQUEST = 1'b1
  }state; 


/********** Local variable definitions ***************************/
icache_frame [15:0] cache_mem_nxt, cache_mem_reg;  
icachef_t frame; 
logic wen; 
state state_reg, state_nxt; 
logic hit; 

/********** Assign statements ***************************/
assign dcif.ihit = hit; 
assign dcif.imemload = cache_mem_reg[frame.idx].data; 
assign cif.iaddr = dcif.imemaddr; 
assign frame = icachef_t'(dcif.imemaddr); //'

/********** Combinational Logic ***************************/
always_comb begin: CACHE_MEMORY_NEXT_STATE
  // set default value 
  cache_mem_nxt = cache_mem_reg; 

  // if writing
  if (wen == 1'b1) begin 
    cache_mem_nxt[frame.idx].data = cif.iload; 
    cache_mem_nxt[frame.idx].tag = frame.tag; 
    cache_mem_nxt[frame.idx].valid = 1'b1; 
  end 
end 

always_comb begin: CACHE_MEMORY_OUTPUT_LOGIC
  // set default value 
  hit = 1'b0; 

  // if reading 
  if (wen == 1'b0) begin 

    // if the tags are the same and data block is valid 
    if ((frame.tag == cache_mem_reg[frame.idx].tag) & (cache_mem_reg[frame.idx].valid == 1'b1)) begin 
      // set hit to 1
      hit = 1'b1; 
    end 
  end 
end 

always_comb begin: CONTROLLER_FSM_NXT_STATE_LOGIC 
  // set default value
  state_nxt = state_reg; 

  // if in IDLE state
  casez (state_reg) 
    IDLE: begin 
            // no read is being requested or a read is requested but no hit 
            if ((dcif.imemREN == 0) | ((dcif.imemREN == 1) & (hit == 1'b1))) begin 
              state_nxt = IDLE; 
            end 
            // reading but no hit was present 
            else if ((dcif.imemREN == 1) & (hit == 1'b0)) begin 
              state_nxt = REQUEST; 
            end 
          end 
    REQUEST: state_nxt = (cif.iwait == 1'b1) ? REQUEST : IDLE; 
  endcase 
end 

always_comb begin: CONTROLLER_OUTPUT_LOGIC
  // set default values 
  cif.iREN = 1'b0; 
  wen = 1'b0; 

  casez(state_reg) 
    REQUEST:  begin 
                cif.iREN = 1'b1;
                wen = ~cif.iwait; 
              end  
  endcase
end 

/********** Sequential Logic ***************************/
always_ff @(posedge CLK, negedge nRST) begin: CACHE_MEMORY_REGISTER
  
  // if reset is brought low 
  if (nRST == 1'b0) begin 
    // set tags, valid bits, and data back to zero
    cache_mem_reg <= 'b0; 
  end 
  // no reset was applied 
  else begin 
    // update data, tags, and valid bits 
    cache_mem_reg <= cache_mem_nxt; 
  end 
end

always_ff @(posedge CLK, negedge nRST) begin: CONTROLLER_FSM_REGISTER
  
  // if reset is brought low 
  if (nRST == 1'b0) begin 
    state_reg <= IDLE; 
  end 
  // no reset was applied 
  else begin 
    state_reg <= state_nxt; 
  end 
end
endmodule
