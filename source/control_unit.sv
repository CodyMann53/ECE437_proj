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
assign op_code = cuif.instruction[32:27];
assign funct = cuif.instruction[5:0]; 
assign rd = cuif.instruction[16:12]; 
assign rt = cuif.instruction[21:17];
assign rs = cuif.instruction[26:22]; 
assign imm_16 = cuif.instruction[15:0]; 
assign address = cuif.instruction[25:0]; 

// control signal logic equations 
assign cuif.iREN = (op_code != HALT) ? 1 : 0; 
assign cuif.dWEN = (op_code == SW) ? 1 : 0; 
assign cuif.dREN = ((op_code == LUI) | (op_code == LW)) ? 1 : 0; 
assign cuif.RegWr = ((op_code == JR) | (op_code == J) | (op_code == SW) | (op_code == BNE)
						| (op_code == BEQ) | (op_code == JR)) ? 0 : 1; 
assign cuif.halt = (op_code == HALT) ? 1 : 0; 

/********** Combination Logic Blocks ***************************/

// combination logic for determinining type of instruction
always_comb begin: INSTRUCTION_TYPE_LOGIC

	// assign default value to prevent latches 
	op_code_type = I_TYPE; 

	// if op code is all zeros 
	if ( (cuif.instruction[32:27] & 6'b111111) == 6'd000000) begin 

		// instruction is R_type 
		op_code_type = R_type; 
	end 
	// if the top 4 bits are zero
	else if ( (cuif.instruction[32:29] & 4'b1111) == 4'b0000) begin 

		// instruction is J_type 
		op_code_type = J_type; 
	end 
	// else the instruction is a I_TYPE 
	else begin 

		op_code_type = I_TYPE; 
	end
end 

// mux control signal combination logic 
always_comb begin: MUX_CONTROL_SIGNAL_LOGIC
end 
	
// alu operation control logic block 
always_comb begin: ALU_OPERATION_SIGNAL_LOGIC
end 

endmodule
