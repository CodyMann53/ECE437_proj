/*
  Cody Mann
  mann53@purdue.edu

  control unit
*/

`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"

module control_unit
	import cpu_types_pkg::*;
	(
 	control_unit_if.cu cuif, 
 	); 

/********** Local type definitions ***************************/
  
 typedef enum logic [1:0] {
    I_TYPE = 2'd0, 
    J_TYPE = 2'd1, 
    R_TYPE = 2'd2
  } instr_type;

/********** Local variable definitions ***************************/
instr_type op_code_type; 

// variables for breaking instruction apart
opcode_t op_code; // 6 bits wide
logic [REG_W -1: 0] rs, rt, rd; // 5 bits wide
logic [FUNC_W -1: 0] funct; // 6 bits wide
logic [IMM_W -1: 0] imm_16; // 16 bits wide
logic [25:0] address; 


/********** Assign statements ***************************/

// break up the instruction into its respective data sections
assign op_code = instruction[32:27];
assign funct = instruction[5:0]; 
assign rd = instruction[16:12]; 
assign rt = instruction[21:17];
assign rs = instruction[26:22]; 
assign imm_16 = instruction[15:0]; 
assign address = instruction[25:0]; 

// control signal logic equations 


/********** Combination Logic Blocks ***************************/

// combination logic for determinining type of instruction
always_comb begin: INSTRUCTION_TYPE_LOGIC

	// assign default value to prevent latches 
	op_code_type = I_TYPE; 

	// if op code is all zeros 
	if ( (cu.instruction[32:27] & 6'b111111) == 6'd000000) begin 

		// instruction is R_type 
		op_code_type = R_type; 
	end 
	// if the top 4 bits are zero
	else if ( (cu.instruction[32:29] & 4'b1111) == 4'b0000) begin 

		// instruction is J_type 
		op_code_type = J_type; 
	end 
	// else the instruction is a I_TYPE 
	else begin 

		op_code_type = I_TYPE; 
	end
end 
	
endmodule
