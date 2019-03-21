/*
  Cody Mann
  mann53@purdue.edu

  hazard unit module  
*/

`include "cpu_types_pkg.vh"
`include "hazard_unit_if.vh"
`include "data_path_muxs_pkg.vh"

// import statements 
import cpu_types_pkg::*;
import data_path_muxs_pkg::*; 

module hazard_unit 
	(
 	hazard_unit_if huif 
 	); 
  
/********** Local variable definitions ***************************/	
logic load_data_haz_flag, control_haz_flag, move; 

/********** Combinational Logic ***************************/
always_comb begin: ADVANCE_LOGIC
	// set default value 
	move = 1'b1; 

	// if currently waiting on a dhit
	if (((huif.dmemWEN == 1) | (huif.dmemREN == 1)) & (huif.dhit == 0) ) begin 
		// then don't move the pipeline 
		move = 1'b0; 
	end 
	// else if there is no ihit  and dhit
	else if ( huif.ihit == 0) begin 
		// don't move pipeline along 
		move = 1'b0; 
	end
	// else if a halt is present in wb stage
	else if (huif.halt == 1) begin 
		move = 1'b0; 
	end 
end 

always_comb begin: CONTROL_HAZARD_DETECTION_LOGIC
	
	// set default value for the flag 
	control_haz_flag = 1'b0; 

	// if a BE and zero 
	if ((huif.opcode_EX_MEM == BEQ) & (huif.zero_EX_MEM == 0)) begin 
		// set the flag for control hazard 
		control_haz_flag = 1'b1; 
	end 
	// if BNE and not zero 
	else if ((huif.opcode_EX_MEM == BNE) & (huif.zero_EX_MEM == 1)) begin 
		// set the flag for control hazard 
		control_haz_flag = 1'b1; 
	end 
end 

always_comb begin: DATA_HAZARD_DETECTION_LOGIC
	// set a default value 
	load_data_haz_flag = 1'b0; 

	// If there is an occurance where loading value into register and then trying to use that value on next instruction
	if (((huif.Rt_ID_EX == huif.Rs_IF_ID) | (huif.Rt_ID_EX == huif.Rt_IF_ID)) & (huif.dREN_ID_EX == 1)) begin 
		// flag the load data hazard flag 
		load_data_haz_flag = 1'b1; 
	end 
end 

always_comb begin: PCSRC_ENABLE_AND_FLUSH_LOGIC
	// assign default values 
	huif.PCSrc = SEL_LOAD_NXT_INSTR; 
	huif.enable_IF_ID = move; 
	huif.enable_ID_EX = move; 
	huif.enable_EX_MEM = move; 
	huif.enable_MEM_WB = move; 
	huif.flush_IF_ID = 1'b0; 
	huif.flush_ID_EX = 1'b0; 
	huif.flush_EX_MEM = 1'b0;
	huif.flush_MEM_WB = 1'b0; 
	huif.enable_pc = move; 

	if (((huif.opcode_IF_ID == BEQ) | (huif.opcode_IF_ID == BNE)) & (move == 1'b1)) begin 
		huif.PCSrc = SEL_LOAD_BR_ADDR; 
		huif.flush_IF_ID = 1'b1; 
	end

	if ( (control_haz_flag == 1'b1) & (move == 1'b1)) begin 
		huif.PCSrc = SEL_LOAD_NXT_PC_EX_MEM; 
		huif.flush_IF_ID = 1'b1; 
		huif.flush_ID_EX = 1'b1; 
		huif.flush_EX_MEM = 1'b1; 
	end 
	// if a load hazard 
	else if ((load_data_haz_flag == 1'b1) & (move == 1'b1)) begin 
		// hold pc 
		huif.enable_pc = 1'b0; 
		// flush ID/EX
		huif.flush_ID_EX = 1'b1; 
		// hold IF/ID
		huif.enable_IF_ID = 1'b0; 
	end 

		// if a JAL or J instruction in IF/ID 
	if (((huif.opcode_IF_ID == JAL) | (huif.opcode_IF_ID == J)) & (control_haz_flag != 1'b1) & (move == 1'b1)) begin 
		// tell the program to go to the jump address in the next instruction
		huif.PCSrc = SEL_LOAD_JMP_ADDR; 
		huif.flush_IF_ID = 1'b1;  
	end 
	// If a JR instruction in the IF/ID
	else if (huif.opcode_IF_ID == RTYPE && huif.func_IF_ID == JR & (control_haz_flag != 1'b1) & (move == 1'b1)) begin 
		// tell the program counter to go to the return address which comes from the register 31 from register file 
		huif.PCSrc = SEL_LOAD_JR_ADDR; 
		huif.flush_IF_ID = 1'b1;
	end 
end
endmodule
