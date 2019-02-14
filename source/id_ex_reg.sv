/*
  Cody Mann
  mann53@purdue.edu

  ID/EX pipeline register 
*/

`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg.vh"
`include "id_ex_reg_if.vh"

import cpu_types_pkg::*;
import data_path_muxs_pkg::*; 


module id_ex_reg
	(
	input CLK, nRST,
 	id_ex_reg_if id_ex_regif, 
 	); 

/********** Local type definitions ***************************/
  
/********** Local variable definitions ***************************/

logic iREN_reg, iREN_nxt, 
	  dREN_reg, dREN_nxt, 
	  dWEN_reg, dWEN_nxt,
	  halt_reg, halt_nxt, 
	  WEN_reg, WEN_nxt; 
pc_mux_input_selection PCSrc_reg, PCSrc_nxt; 
reg_dest_mux_selection reg_dest_reg, reg_dest_nxt; 
aluop_t alu_op_reg, alu_op_nxt; 
regbits_t rt_reg, rt_nxt,
		  rd_reg, rd_nxt; 
alu_source_mux_selection ALUSrc_reg, ALUSrc_nxt; 
word_t rdat1_reg, rdat1_nxt, 
	   rdat2_reg, rdat2_nxt; 
logic [15:0] imm16_ext_reg, imm16_ext_nxt; 

// tracker needed signals 
word_t imemaddr_reg, imemaddr_nxt, 
	   next_imemaddr_reg, next_imemaddr_nxt; 
opcode_t opcode_reg, opcode_nxt; 
funct_t funct_reg, funct_nxt; 
word_t instruction_reg, instruction_nxt; 
logic [15:0] imm16_reg, imm16_nxt;

/********** Assign statements ***************************/

// assign the output signals to the register values 
assign id_ex_regif.iREN_ID_EX = iREN_reg; 
assign id_ex_regif.dREN_ID_EX = dREN_reg; 
assign id_ex_regif.dWEN_ID_EX = dWEN_reg; 
assign id_ex_regif.halt_ID_EX = halt_reg; 
assign id_ex_regif.WEN_ID_EX = WEN_reg; 
assign id_ex_regif.reg_dest_ID_EX = reg_dest_reg; 
assign id_ex_regif.alu_op_ID_EX = alu_op_reg; 
assign id_ex_regif.Rt_ID_EX = rt_reg; 
assign id_ex_regif.Rd_ID_EX = rd_reg; 
assign id_ex_regif.ALUsrc_ID_EX = ALUSrc_reg; 
assign id_ex_regif.rdat1_ID_EX = rdat1_reg; 
assign id_ex_regif.rdat2_ID_EX = rdat2_reg; 
assign id_ex_regif.imm16_ext_ID_EX = imm16_ext_reg; 

// pass through 
assign id_ex_regif.imemaddr_ID_EX = imemaddr_reg;
assign id_ex_regif.opcode_ID_EX = opcode_reg; 
assign id_ex_regif.func_ID_EX = funct_reg; 
assign id_ex_regif.instruction_ID_EX = instruction_reg; 
assign id_ex_regif.imm16_ID_EX = imm16_reg;
assign id_ex_regif.next_imemaddr_ID_EX = next_imemaddr_reg; 

/********** Combination Logic Blocks ***************************/
always_comb begin: NXT_LOGIC

	// just assign section of instruction to thier respective latched values 
	iREN_nxt = iREN_reg; 
	dREN_nxt = dREN_reg; 
	dWEN_nxt = dWEN_reg; 
	halt_nxt = halt_reg; 
	WEN_nxt = WEN_reg; 
	reg_dest_nxt = reg_dest_reg; 
	alu_op_nxt = alu_op_reg; 
	rt_nxt = rt_reg; 
	rd_nxt = rd_reg; 
	ALUSrc_nxt = ALUSrc_reg;
	rdat1_nxt = rdat1_reg; 
	rdat2_nxt = rdat2_reg; 
	imm16_ext_nxt = imm16_ext_reg;  

	// cpu pass through signals 
	imemaddr_nxt = imemaddr_reg; 
	opcode_nxt = opcode_reg; 
	funct_nxt = funct_reg; 
	instruction_nxt = instruction_reg;
	imm16_nxt = imm16_reg; 
	next_imemaddr_nxt = next_imemaddr_reg; 

	if ((id_ex_regif.enable_ID_EX == 1'b1) & (id_ex_regif.flush_ID_EX == 1'b0)) begin 
		iREN_nxt = id_ex_regif.iREN; 
		dREN_nxt = id_ex_regif.dREN; 
		dWEN_nxt = id_ex_regif.dWEN; 
		halt_nxt = id_ex_regif.halt; 
		WEN_nxt = id_ex_regif.WEN; 
		reg_dest_nxt = id_ex_regif.reg_dest; 
		alu_op_nxt = id_ex_regif.alu_op; 
		rt_nxt = id_ex_regif.Rt_IF_ID; 
		rd_nxt = id_ex_regif.Rd_IF_ID; 
		ALUSrc_nxt = id_ex_regif.ALUsrc; 
		rdat1_nxt = id_ex_regif.rdat1; 
		rdat2_nxt id_ex_regif.rdat2; 
		imm16_ext_nxt = id_ex_regif.imm16_ext; 

		// cpu tracker signals 
		imemaddr_nxt = id_ex_regif.imemaddr_IF_ID; 
		opcode_nxt = id_ex_regif.opcode_IF_ID; 
		funct_nxt = id_ex_regif.func_IF_ID; 
		instruction_nxt = id_ex_regif.instruction_IF_ID; 
		imm16_nxt = id_ex_regif.imm16_IF_ID; 
		next_imemaddr_nxt = id_ex_regif.next_imemaddr_IF_ID; 
	end 
	else if (id_ex_regif.flush_ID_EX == 1'b1) begin 
		iREN_nxt = 1'b0; 
		dREN_nxt = 1'b0; 
		dWEN_nxt = 1'b0; 
		halt_nxt = 1'b0; 
		WEN_nxt = 1'b0; 
		nxt_dest_nxt = SEL_RD; 
		alu_op_nxt = ALU_ADD; 
		rt_nxt = 5'd0; 
		rd_nxt = 5'd0; 
		ALUSrc_nxt = SEL_REG_DATA;
		rdat1_nxt = 32'd0; 
		rdat2_nxt = 32'd0; 
		imm16_ext_nxt = 32'd0;

		// cpu tracker signals   
		imemaddr_nxt = 32'd0; 
		opcode_nxt = 6'd0; 
		funct_nxt = 6'd0; 
		instruction_nxt = 32'd0; 
		imm16_nxt = 16'd0; 
		next_imemaddr_nxt = 32'd0; 
	end 
end 

/********** Sequential Logic Blocks ***************************/
always_ff @(posedge CLK, negedge nRST) begin: REG_LOGIC

	// if reset is brought low 
	if (nRST == 1'b0) begin 

		// reset the registers to zero 
		iREN_reg <= 1'b0; 
		dREN_reg <= 1'b0; 
		dWEN_reg <= 1'b0; 
		halt_reg <= 1'b0; 
		WEN_reg <= 1'b0; 
		reg_dest_reg <= SEL_RD; 
		alu_op_reg <= ALU_ADD; 
		rt_reg <= 5'd0; 
		rd_reg <= 5'd0; 
		ALUSrc_reg <= SEL_REG_DATA;
		rdat1_reg <= 32'd0; 
		rdat2_reg <= 32'd0; 
		imm16_ext_reg <= 32'd0;  
		imemaddr_reg <= 32'd0; 

		// cpu tracker signals 
		imemaddr_reg <= 32'd0; 
		opcode_reg <= 6'd0; 
		funct_reg <= 6'd0; 
		instruction_reg <= 32'd0; 
		imm16_reg <= 16'd0; 
		next_imemaddr_reg <= 32'd0;

	end 
	// no reset applied 
	else begin 

		// set to their next state values 
		iREN_reg <= iREN_nxt; 
		dREN_reg <= dREN_nxt; 
		dWEN_reg <= dWEN_nxt; 
		halt_reg <= halt_nxt; 
		WEN_reg <= WEN_nxt; 
		reg_dest_reg <= reg_dest_nxt; 
		alu_op_reg <= alu_op_nxt; 
		rt_reg <= rt_nxt; 
		rd_reg <= rd_nxt; 
		ALUSrc_reg <= ALUSrc_nxt;
		rdat1_reg <= rdat1_nxt; 
		rdat2_reg <= rdat2_nxt; 
		imm16_ext_reg <= imm16_ext_nxt;  
		imemaddr_reg <= imemaddr_nxt; 

		// cpu tracker signals 
		imemaddr_reg <= imemaddr_nxt; 
		opcode_reg <= opcode_nxt; 
		funct_reg <= funct_nxt; 
		instruction_reg <= instruction_nxt; 
		imm16_reg <= imm16_nxt; 
		next_imemaddr_reg <= 32'd0; 
	end
end 
endmodule