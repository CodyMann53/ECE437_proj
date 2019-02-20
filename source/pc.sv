/*
  Cody Mann
  mann53@purdue.edu

  pc (program counter) 
*/

`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg.vh"
`include "pc_if.vh"

import cpu_types_pkg::*; 
import data_path_muxs_pkg::*; 

module pc 
	(
	input logic CLK,
 	nRST,
 	pc_if.pc pcif
 	); 

 parameter PC_INIT = 32'd0; 

/********** Local variable definitions ***************************/
word_t program_counter_reg, program_counter_nxt; 

/********** Assign statements ***************************/

// assigning the instructin address output to the program counter
assign pcif.imemaddr = program_counter_reg; 

/********** Combinational Logic ***************************/
always_comb begin NXT_STATE_LOGIC:

	// default value 
	program_counter_nxt = program_counter_reg; 

	if ( (pcif.ihit == 1'b1) & (pcif.enable_pc == 1'b1)) begin 
		program_counter_nxt = pcif.next_pc; 
	end 
end 

/********** Sequential Logic ***************************/
always_ff @(posedge CLK, negedge nRST) begin: PC_REGISTER
	
	// if reset is brought low 
	if (nRST == 1'b0) begin 

		// reset the program counter back to zero 
		program_counter_reg <= PC_INIT; 
	end 
	// no reset was applied 
	else begin 

		// update to the next program counter 
		program_counter_reg <= program_counter_nxt; 
	end 
end
endmodule

