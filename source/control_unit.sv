/*
  Cody Mann
  mann53@purdue.edu

  control unit
*/

`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"
`include "data_path_muxs_pkg.vh"

	import cpu_types_pkg::*;
	import data_path_muxs_pkg::*; 

module control_unit
	(
 	control_unit_if cuif
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

/********** Assign statements ***************************/

// break up the instruction into its respective data sections  

// control signal logic equations 
assign cuif.dWEN = (opcode_t'(cuif.opcode_IF_ID) == SW) ? 1'b1 : 1'b0; 
assign cuif.dREN = ((cuif.opcode_IF_ID == LUI) | (cuif.opcode_IF_ID == LW)) ? 1'b1 : 1'b0; 
assign cuif.WEN = ((cuif.opcode_IF_ID == J) | (cuif.opcode_IF_ID == SW) | (cuif.opcode_IF_ID == BNE) | (cuif.opcode_IF_ID == BEQ) | ( (cuif.opcode_IF_ID == RTYPE) & (cuif.func_IF_ID == JR) ) | (cuif.opcode_IF_ID == HALT)) ? 1'b0 : 1'b1; 

/********** Combination Logic Blocks ***************************/

// mux control signal logic for program counter source
always_comb begin: MUX_PC_SRC
	
	// assign default values to prevent latches 
	cuif.PCSrc = SEL_LOAD_NXT_INSTR; 
end 

// mux control signal combination logic 
always_comb begin: MUX_MEM_TO_REG
	
	// assign default values to prevent latches
	cuif.mem_to_reg = SEL_RESULT;

	// if opcode is instruction that requires data from memroy to load 
	if (cuif.opcode_IF_ID == LW) begin 

		cuif.mem_to_reg = SEL_DLOAD; 
	end 
	// else just send the result back to register file 
	else begin 

		cuif.mem_to_reg = SEL_RESULT; 
	end 
end 

// mux control signal logic for alu source
always_comb begin: MUX_ALU_SRC

	// assign default values to prevent latches 
	cuif.ALUSrc = SEL_REG_DATA; 

	// if certain cases where immediate value should be selected 
	if ((cuif.opcode_IF_ID == ADDIU) | (cuif.opcode_IF_ID == ADDI) | (cuif.opcode_IF_ID == ANDI)
		| (cuif.opcode_IF_ID == LW) | (cuif.opcode_IF_ID == ORI) | (cuif.opcode_IF_ID == SW) 
		| (cuif.opcode_IF_ID == XORI) | (cuif.opcode_IF_ID == LUI)) begin 
		cuif.ALUSrc = SEL_IMM16; 
	end 
	else begin 

		cuif.ALUSrc = SEL_REG_DATA; 
	end 
end
// mux control signal logic for selecting between rd and rt for register destination
always_comb begin: MUX_REG_DEST
	
	// assign default values to prevent latches 
	cuif.reg_dest = SEL_RD; 

	// If loading values from memory
	if ((cuif.opcode_IF_ID == LUI) | (cuif.opcode_IF_ID == LW) | (cuif.opcode_IF_ID == ORI) |
		(cuif.opcode_IF_ID == SLTI) |
		(cuif.opcode_IF_ID == SLTI) | 
		(cuif.opcode_IF_ID == SLTIU) | 
		(cuif.opcode_IF_ID == XORI) |
		(cuif.opcode_IF_ID == ANDI) |
		(cuif.opcode_IF_ID == ADDI) |
		(cuif.opcode_IF_ID == ADDIU) | 
		(cuif.opcode_IF_ID == SW)) begin 

		// destination should be RT
		cuif.reg_dest = SEL_RT; 
	end 
	else begin 

		cuif.reg_dest = SEL_RD; 
	end 
end 
// alu operation control logic block 
always_comb begin: ALU_OPERATION_SIGNAL_LOGIC
	
	// assign defalut value for alu operation logic signal 
	cuif.alu_op = ALU_ADD; 

	// If the instruction type is an Rtype  
	if (op_code_type == R_TYPE) begin 

		// will need to look at the cuif.func_IF_IDion component of instruction
		casez (cuif.func_IF_ID)

			SLLV: 	cuif.alu_op = ALU_SLL; 
			SRLV: 	cuif.alu_op = ALU_SRL; 
			ADD: 	cuif.alu_op = ALU_ADD; 
			ADDU:	cuif.alu_op = ALU_ADD;  
			SUB:	cuif.alu_op = ALU_SUB; 
			SUBU:	cuif.alu_op = ALU_SUB; 
			AND:	cuif.alu_op = ALU_AND; 
			OR:		cuif.alu_op = ALU_OR; 
			XOR:	cuif.alu_op = ALU_XOR; 
			NOR:	cuif.alu_op = ALU_NOR; 
			SLT:	cuif.alu_op = ALU_SLT;
			SLTU:	cuif.alu_op = ALU_SLTU; 
		endcase
	// else will look at the opcode 
	end 
	else begin 

		casez (cuif.opcode_IF_ID)

			BEQ:	cuif.alu_op = ALU_SUB; 
			BNE:	cuif.alu_op = ALU_SUB; 
			ADDI:	cuif.alu_op = ALU_ADD; 
			ADDIU:	cuif.alu_op = ALU_ADD; 
			SLTI:	cuif.alu_op = ALU_SLT; 
			SLTIU:	cuif.alu_op = ALU_SLTU; 
			ANDI:	cuif.alu_op = ALU_AND; 
			ORI:	cuif.alu_op = ALU_OR; 
			XORI:	cuif.alu_op = ALU_XOR; 
			SW:		cuif.alu_op = ALU_ADD; 
		endcase
	end 
end 

always_comb begin: HALT_LOGIC
	
	// default value will be zero 
	cuif.halt = 1'b0; 

	if (cuif.opcode_IF_ID == HALT) begin 

		cuif.halt = 1'b1; 
	end 
end 

always_comb begin: IREN_LOGIC  
	
	cuif.iREN = 1'b1; 

	/*if (cuif.opcode_IF_ID == HALT) begin 

		cuif.iREN = 1'b0; 
	end*/
end 

// extend logic 
always_comb begin: EXTEND_LOGIC

	// default value
	cuif.extend = 2'd0; 

	casez (cuif.opcode_IF_ID)
		ADDIU: cuif.extend = 2'd1; 
		ADDI: cuif.extend = 2'd1; 
		LW: cuif.extend = 2'd1; 
		BEQ: cuif.extend = 2'd1; 
		BNE: cuif.extend = 2'd1; 
		SLTI: cuif.extend = 2'd1; 
		SLTIU: cuif.extend = 2'd1; 
		SW: cuif.extend = 2'd1; 
		LUI: cuif.extend = 2'd2; 
	endcase
end 
endmodule
