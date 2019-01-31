/*
  Cody Mann
  mann53@purdue.edu

  control unit
*/

`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"
`include "data_path_muxs_pkg.vh"

module control_unit
	import cpu_types_pkg::*;
	import data_path_muxs_pkg::*; 
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
assign cuif.extend = ((op_code == ADDIU) | (op_code == ADDI) 
						| (op_code == ANDI) 
						| (op_code == LW)
						| (op_code == SLTI)
						| (op_code == SLTIU) 
						| (op_code == SW)
						| (op_code == XORI)
						| (op_code == )) ? 1 : 0; 

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
always_comb begin: MUX_MEM_TO_REG
	
	// assign default values to prevent latches
	cuif.mem_to_reg = SEL_RESULT;

	// if opcode is instruction that requires New program counter 
	if (op_code == JAL) begin 

		cuif.mem_to_reg = SEL_NPC; 
	end 
	// if opcode is instruction that requires data from memroy to load 
	else if (op_code == LW) begin 

		cuif.mem_to_reg = SEL_DLOAD; 
	end 
	// if opcode that requires imm 16 to be loaded to upper 32 bits 
	else if (op_code == LULI) begin 

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
	if ((op_code == ADDIU) | (op_code == ADDI) | (op_code == ANDI)
		| (op_code == LW) | (op_code == ORI) | (op_code == SW) 
		| (op_code == XORI) ) begin 
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
	if ((op_code == BEQ) & (cuif.equal == 1'b1)) begin 

		cuif.PCSrc = SEL_LOAD_ADDR; 
	end 
	// if opcode is bneq and equal is zero 
	else if ( (op_code == BNE) & (cuif.equal == 1'b0)) begin 

		cuif.PCSrc = SEL_LOAD_ADDR; 
	end
	else if ((op_code == J) | (op_code == JAL)) begin 

		cuif.PCSrc = SEL_LOAD_ADDR; 
	end
	// opcode that required pc source to be jump address
	else if (op_code == JR) begin 

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
	if ((op_code == LUI) | (op_code == LW)) begin 

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
	else begin 

		casez (op_code)

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
endmodule
