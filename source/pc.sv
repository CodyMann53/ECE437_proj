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
word_t next_program_counter, program_counter, pc_incr_4; 

/********** Assign statements ***************************/

// assigning the instructin address output to the program counter
assign pcif.imemaddr = program_counter; 
assign pcif.next_imemaddr = next_program_counter; 

// program counter + 4
assign pc_incr_4 = program_counter + 4; 

/********** Combinational Logic ***************************/

always_comb begin: PC_NEXT_LOGIC

	// set default values to prevent latches (just stay at same value)
	next_program_counter = program_counter; 

	// If not requested to wait 
	if (pcif.ihit == 1'b1) begin

		// Choose next program counter based off of program source
		casez (pcif.PCSrc) 
			SEL_LOAD_BR_ADDR:next_program_counter = program_counter + 4 + pcif.br_addr; 
			SEL_LOAD_JR_ADDR:next_program_counter = pcif.jr_addr; 
			SEL_LOAD_NXT_INSTR:next_program_counter = program_counter + 4; 
			SEL_LOAD_JMP_ADDR: next_program_counter = {pc_incr_4[31:28],pcif.jmp_addr};  
		endcase 
	end 
end 

/********** Sequential Logic ***************************/
always_ff @(posedge CLK, negedge nRST) begin: PC_REGISTER
	
	// if reset is brought low 
	if (nRST == 1'b0) begin 

		// reset the program counter back to zero 
		program_counter <= PC_INIT; 
	end 
	// no reset was applied 
	else begin 

		// update to the next program counter 
		program_counter <= next_program_counter; 
	end 
end
endmodule

