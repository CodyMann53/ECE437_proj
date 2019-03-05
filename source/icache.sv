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
  datapath_cache_if.cache dcif,
  caches_if cif
);

/********** Type definitions ***************************/
  // States for icache controller
  typedef enum logic [1:0] {
    IDLE = 2'd0, 
    REQUEST = 2'd1, 
    LOAD = 2'd2
  }state; 

  parameter NUM_BLOCKS = 16

/********** Local variable definitions ***************************/
icache_frame [NUM_BLOCKS-1:0] cache_mem_nxt, cache_mem_reg;  
logic [IIDX_W-1:0] index; 
logic [ITAG_W-1:0] tag; 
logic wen; 
state state_reg, state_nxt; 
logic hit; 

/********** Assign statements ***************************/
assign tag = dcif.imemaddr[ITAG_W-1+IIDX_W+IBLK_W+IBYT_W-1:IIDX_W+IBLK_W+IBYT_W]; 
assign index = dcif.imemaddr[IIDX_W-1:IBYT_W+IBLK_W]; 
assign dcif.ihit = hit; 
assign dcif.imemload = cache_mem_reg.data; 
assign cif.iaddr = dcif.imemaddr; 

/********** Combinational Logic ***************************/
always_comb begin: CACHE_MEMORY_NEXT_STATE
  // set default value 
  cache_mem_nxt = cache_mem_reg; 

  // if writing
  if (wen == 1'b1) begin 
    cache_mem_nxt[index].data = cif.iload; 
    cache_mem_nxt[index].tag = tag; 
    cache_mem_nxt[index].valid = 1'b1; 
  end 
end 

always_comb begin: CACHE_MEMORY_OUTPUT_LOGIC
  // set default value 
  hit = 1'b0; 

  // if reading 
  if (wen = 1'b0) begin 

    // if the tags are the same and data block is valid 
    if ((tag == cache_mem_reg[index].tag) & (cache_mem_reg[index].valid == 1'b1)) begin 
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
    REQUEST: (dcif.iwait == 1) ? state_nxt = REQUEST : state_nxt = LOAD; 
    LOAD: state_nxt = IDLE; 
  endcase 
end 

always_comb begin: CONTROLLER_OUTPUT_LOGIC
  // set default values 
  cif.iREN = 1'b0; 
  wen = 1'b0; 

  casez(state_reg) 
    REQUEST:  begin 
                cif.iREN = 1'b1;
              end  
    LOAD: begin 
            cif.iREN = 1'b1
            wen = 1'b1; 
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
    cache_mem_reg <= cache_mem_nxt
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
