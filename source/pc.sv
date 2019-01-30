/*
  Cody Mann
  mann53@purdue.edu

  pc (program counter) 
*/

`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg"
`include "pc_if.vh"

module pc 
	import cpu_types_pkg::*;
	import data_path_muxs_pkg::*; 
	(
	input logic CLK,
 	nRST,
 	pc_if.pc pcif
 	); 

 parameter PC_INIT = 32'd0; 

/********** Local variable definitions ***************************/
word_t next_program_counter, program_counter, pc_incr_4, pc_incr4_plus_imm16; 
logic program_wait; 

/********** Assign statements ***************************/
assign pcif.imemaddr = program_counter; 

// internal wait signal based on various inputs 
assign program_wait = (pcif.pc_wait | pcif.halt); 

/********** Combinational Logic ***************************/

always_comb begin: PC_NEXT_LOGIC

	// set default values to prevent latches (just stay at same value)
	next_program_counter = program_counter; 

	// If not requested to wait 
	if (program_wait != 1'b1) begin

		// Choose next program counter based off of program source
		casez (pcif.PCSrc) 
			SEL_LOAD_ADDR:next_program_counter = program_counter + 4 + (pcif.load_addr << 2); 
			SEL_LOAD_JR_ADDR:next_program_counter = program_counter + 4 + (pcif.jr_addr << 2); 
			SEL_LOAD_NXT_INSTR:next_program_counter = program_counter + 4; 
		endcase 
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

