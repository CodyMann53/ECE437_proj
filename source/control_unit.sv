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
opcode_t op_code_internal; // 6 bits wide
logic [REG_W -1: 0] rs, rt, rd; // 5 bits wide
funct_t funct; // 6 bits wide
logic [IMM_W -1: 0] imm_16; // 16 bits wide
logic [25:0] address; 


/********** Assign statements ***************************/

// break up the instruction into its respective data sections
assign op_code_internal = opcode_t'(cuif.instruction[31:26]);
assign funct = funct_t'(cuif.instruction[5:0]); 
assign rd = cuif.instruction[15:11]; 
assign rt = cuif.instruction[20:16];
assign rs = cuif.instruction[25:21]; 
assign imm_16 = cuif.instruction[15:0]; 
assign address = cuif.instruction[25:0]; 

// control signal logic equations 
assign cuif.iREN = (op_code_internal != HALT) ? 1'b1 : 1'b0; 
assign cuif.dWEN = (opcode_t'(op_code_internal) == SW) ? 1'b1 : 1'b0; 
assign cuif.dREN = ((op_code_internal == LUI) | (op_code_internal == LW)) ? 1'b1 : 1'b0; 
assign cuif.RegWr = ((op_code_internal == J) | (op_code_internal == SW) | (op_code_internal == BNE) | (op_code_internal == BEQ) | (op_code_internal == RTYPE) & (funct == JR)) ? 1'b0 : 1'b1; 
assign cuif.halt = (op_code_internal == HALT) ? 1'b1 : 1'b0; 
assign cuif.extend = ((op_code_internal == ADDIU) | (op_code_internal == ADDI) | (op_code_internal == ANDI) | (op_code_internal == LW) 
	| (op_code_internal == SLTI) | (op_code_internal == SLTIU) | (op_code_internal == SW) | (op_code_internal == XORI) ) ? 1'b1 : 1'b0; 

// directing parts of instruction to output ports 
assign cuif.load_addr = address; 
assign cuif.imm16 = imm_16; 
assign cuif.Rd = rd; 
assign cuif.Rt = rt; 
assign cuif.Rs = rs; 

/********** Combination Logic Blocks ***************************/

// combination logic for determinining type of instruction
always_comb begin: INSTRUCTION_TYPE_LOGIC

	// assign default value to prevent latches 
	op_code_type = I_TYPE; 

	// if op code is all zeros 
	if ( (cuif.instruction[31:26] & 6'b111111) == 6'd0) begin 

		// instruction is R_type 
		op_code_type = R_TYPE; 
	end 
	// if the top 4 bits are zero
	else if ( (cuif.instruction[31:28] & 4'b1111) == 4'b0) begin 

		// instruction is J_type 
		op_code_type = J_TYPE; 
	end 
	// else the instruction is a I_TYPE 
	else begin 

		op_code_type = I_TYPE; 
	end
end 

// mux control signal combination logic 
always_comb begin: MUX_MEM_TO_REG
	
	// assign default values to prevent latches
	cuif.mem_to_reg = SEL_RESULT;

	// if opcode is instruction that requires New program counter 
	if (op_code_internal == JAL) begin 

		cuif.mem_to_reg = SEL_NPC; 
	end 
	// if opcode is instruction that requires data from memroy to load 
	else if (op_code_internal == LW) begin 

		cuif.mem_to_reg = SEL_DLOAD; 
	end 
	// if opcode that requires imm 16 to be loaded to upper 32 bits 
	else if (op_code_internal == LUI) begin 

		cuif.mem_to_reg = SEL_IMM16_TO_UPPER_32; 
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
	if ((op_code_internal == ADDIU) | (op_code_internal == ADDI) | (op_code_internal == ANDI)
		| (op_code_internal == LW) | (op_code_internal == ORI) | (op_code_internal == SW) 
		| (op_code_internal == XORI) ) begin 
		cuif.ALUSrc = SEL_IMM16; 
	end 
	else begin 

		cuif.ALUSrc = SEL_REG_DATA; 
	end 
end

// mux control signal logic for program counter source
always_comb begin: MUX_PC_SRC
	
	// assign default values to prevent latches 
	cuif.PCSrc = SEL_LOAD_ADDR; 

	// opcode is bequal and equal is one  
	if ( (op_code_internal == BEQ) & (cuif.equal == 1'b1) ) begin 

		cuif.PCSrc = SEL_LOAD_IMM16; 
	end 
	// if opcode is bneq and equal is zero 
	else if ( (op_code_internal == BNE) & (cuif.equal == 1'b0)) begin 

		cuif.PCSrc = SEL_LOAD_IMM16; 
	end
	else if ( (op_code_internal == J) | (op_code_internal == JAL)) begin 

		cuif.PCSrc = SEL_LOAD_ADDR; 
	end
	// opcode that required pc source to be jump address
	else if ((op_code_internal == RTYPE) & (funct == JR)) begin 

		cuif.PCSrc = SEL_LOAD_JR_ADDR; 
	end 
	// pc should just be next instruction 
	else begin 

		cuif.PCSrc = SEL_LOAD_NXT_INSTR; 
	end 
end 
	
// mux control signal logic for selecting between rd and rt for register destination
always_comb begin: MUX_REG_DEST
	
	// assign default values to prevent latches 
	cuif.reg_dest = SEL_RD; 

	// If loading values from memory
	if ((op_code_internal == LUI) | (op_code_internal == LW)) begin 

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

		// will need to look at the function component of instruction
		casez (funct)

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

		casez (op_code_internal)

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
endmodule
