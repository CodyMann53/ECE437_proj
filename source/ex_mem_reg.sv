/*
  Cody Mann
  mann53@purdue.edu

  EX/MEM pipeline register 
*/

`include "cpu_types_pkg.vh"
`include "ex_mem_reg_if.vh"
`include "data_path_muxs_pkg.vh"

import cpu_types_pkg::*;
import data_path_muxs_pkg::*; 


module ex_mem_reg
	(
	input CLK, nRST,
 	ex_mem_reg_if ex_mem_regif 
 	); 

/********** Local type definitions ***************************/
  
/********** Local variable definitions ***************************/	

logic iREN_reg, iREN_nxt, 
      dREN_reg, dREN_nxt, 
      dWEN_reg, dWEN_nxt, 
      halt_reg, halt_nxt, 
      WEN_reg, WEN_nxt, 
      zero_reg, zero_nxt; 

reg_dest_mux_selection reg_dest_reg, reg_dest_nxt; 
aluop_t alu_op_reg, alu_op_nxt; 
regbits_t rt_reg, rt_nxt, 
		  rd_reg, rd_nxt; 
word_t result_reg, result_nxt,
	   data_store_reg, data_store_nxt; 
mem_to_reg_mux_selection mem_to_reg_reg, mem_to_reg_nxt; 
word_t branch_addr_reg, branch_addr_nxt; 

// cpu tracker variables 
word_t imemaddr_reg, imemaddr_nxt, next_imemaddr_reg, next_imemaddr_nxt; 
opcode_t opcode_reg, opcode_nxt;
funct_t func_reg, func_nxt; 
word_t instruction_reg, instruction_nxt; 
logic [15:0] imm16_reg, imm16_nxt; 
word_t imm16_ext_reg, imm16_ext_nxt; 
word_t rdat1_reg, rdat1_nxt; 
regbits_t rs_reg, rs_nxt; 

/********** Assign statements ***************************/

// assign the output signals to the register values 
assign ex_mem_regif.dmemaddr_EX_MEM = result_reg; 
assign ex_mem_regif.dmemstore_EX_MEM = data_store_reg; 
assign ex_mem_regif.result_EX_MEM = result_reg; 
assign ex_mem_regif.WEN_EX_MEM = WEN_reg; 
assign ex_mem_regif.reg_dest_EX_MEM = reg_dest_reg; 
assign ex_mem_regif.Rt_EX_MEM = rt_reg; 
assign ex_mem_regif.Rd_EX_MEM = rd_reg; 
assign ex_mem_regif.imemREN = iREN_reg;
assign ex_mem_regif.dmemREN = dREN_reg; 
assign ex_mem_regif.dmemWEN = dWEN_reg; 
assign ex_mem_regif.halt_EX_MEM = halt_reg;
assign ex_mem_regif.branch_addr_EX_MEM = branch_addr_reg; 

// cpu tracker variables 
assign ex_mem_regif.imemaddr_EX_MEM = imemaddr_reg; 
assign ex_mem_regif.opcode_EX_MEM = opcode_reg; 
assign ex_mem_regif.func_EX_MEM = func_reg; 
assign ex_mem_regif.imm16_EX_MEM = imm16_reg; 
assign ex_mem_regif.imm16_ext_EX_MEM = imm16_ext_reg; 
assign ex_mem_regif.next_imemaddr_EX_MEM = next_imemaddr_reg; 
assign ex_mem_regif.rdat1_EX_MEM = rdat1_reg; 
assign ex_mem_regif.Rs_EX_MEM = rs_reg; 
assign ex_mem_regif.instruction_EX_MEM = instruction_reg; 
assign ex_mem_regif.mem_to_reg_EX_MEM = mem_to_reg_reg; 
assign ex_mem_regif.zero_EX_MEM = zero_reg; 

/********** Combination Logic Blocks ***************************/
always_comb begin: NXT_LOGIC

	// just assign section of instruction to thier respective latched values 
	reg_dest_nxt = reg_dest_reg; 
	alu_op_nxt = alu_op_reg; 
	rt_nxt = rt_reg; 
	rd_nxt = rd_reg; 
	result_nxt = result_reg; 
	data_store_nxt = data_store_reg; 
	halt_nxt = halt_reg; 
	iREN_nxt = iREN_reg; 
	dREN_nxt = dREN_reg; 
	dWEN_nxt = dWEN_reg; 
	mem_to_reg_nxt = mem_to_reg_reg; 
	branch_addr_nxt = branch_addr_reg; 
	zero_nxt = zero_reg; 

	// cpu tracker signals 
	imemaddr_nxt = imemaddr_reg; 
	opcode_nxt = opcode_reg; 
	func_nxt = func_reg; 
	imm16_nxt = imm16_reg; 
	imm16_ext_nxt = imm16_ext_reg; 
	next_imemaddr_nxt = next_imemaddr_reg; 
	rdat1_nxt = rdat1_reg;
	rs_nxt = rs_reg;  
	WEN_nxt = WEN_reg; 
	instruction_nxt = instruction_reg; 

	if (ex_mem_regif.enable_EX_MEM == 1) begin 
		dREN_nxt = ex_mem_regif.dREN_ID_EX; 
		dWEN_nxt = ex_mem_regif.dWEN_ID_EX; 
	end 
	else if (ex_mem_regif.dhit == 1) begin 
		dREN_nxt = 1'b0; 
		dWEN_nxt = 1'b0;
	end 

	if ((ex_mem_regif.enable_EX_MEM == 1'b1) & (ex_mem_regif.flush_EX_MEM == 1'b0)) begin 
		WEN_nxt = ex_mem_regif.WEN_ID_EX; 
		reg_dest_nxt = ex_mem_regif.reg_dest_ID_EX; 
		alu_op_nxt = ex_mem_regif.alu_op_ID_EX; 
		rt_nxt = ex_mem_regif.Rt_ID_EX; 
		rd_nxt = ex_mem_regif.Rd_ID_EX; 
		result_nxt = ex_mem_regif.result; 
		data_store_nxt = ex_mem_regif.data_store; 
		halt_nxt = ex_mem_regif.halt_ID_EX; 
		iREN_nxt = ex_mem_regif.iREN_ID_EX; 
		mem_to_reg_nxt = ex_mem_regif.mem_to_reg_ID_EX; 
		branch_addr_nxt = ex_mem_regif.branch_addr; 
		zero_nxt = ex_mem_regif.zero; 

		// cpu tracker signals 
		imemaddr_nxt = ex_mem_regif.imemaddr_ID_EX; 
		opcode_nxt = ex_mem_regif.opcode_ID_EX; 
		func_nxt = ex_mem_regif.func_ID_EX; 
		instruction_nxt = ex_mem_regif.instruction_ID_EX; 
		imm16_nxt = ex_mem_regif.imm16_ID_EX; 
		imm16_ext_nxt = ex_mem_regif.imm16_ext_ID_EX; 
		next_imemaddr_nxt = ex_mem_regif.next_imemaddr_ID_EX; 
		rdat1_nxt = ex_mem_regif.rdat1_ID_EX; 
		rs_nxt = ex_mem_regif.Rs_ID_EX; 
	end 
	else if (ex_mem_regif.flush_EX_MEM == 1'b1) begin 
		halt_nxt = 1'b0; 
		WEN_nxt = 1'b0;  
		reg_dest_nxt = SEL_RD; 
		alu_op_nxt = ALU_ADD; 
		//rt_nxt = 5'd0; 
		//rd_nxt = 5'd0; 
		result_nxt = 32'd0; 
		data_store_nxt = 32'd0;
		halt_nxt = 1'b0; 
		iREN_nxt = 1'b1; 
		mem_to_reg_nxt = SEL_RESULT; 
		branch_addr_nxt = 32'd0; 
		zero_nxt = 1'b0; 

		// cpu tracker signals 
		imemaddr_nxt = 32'd0; 
		opcode_nxt = RTYPE; 
		func_nxt = ADD; 
		instruction_nxt = 32'd0; 
		imm16_nxt = 16'd0; 
		imm16_ext_nxt = 32'd0; 
		next_imemaddr_nxt = 32'd0; 
		rdat1_nxt = 32'd0; 
		//rs_nxt = 5'd0; 
	end 
end 

/********** Sequential Logic Blocks ***************************/
always_ff @(posedge CLK, negedge nRST) begin: REG_LOGIC

	// if reset is brought low 
	if (nRST == 1'b0) begin 

		// reset the registers to zero 
		WEN_reg <= 1'b0; 
		reg_dest_reg <= SEL_RD; 
		alu_op_reg <= ALU_ADD; 
		rt_reg <= 5'd0; 
		rd_reg <= 5'd0; 
		data_store_reg <= 32'd0;
		result_reg <= 32'd0;  
		halt_reg <= 1'b0; 
		iREN_reg <= 1'b1; 
		dREN_reg <= 1'b0; 
		dWEN_reg <= 1'b0; 
		mem_to_reg_reg <= SEL_RESULT; 
		branch_addr_reg <= 32'd0; 
		zero_reg <= 1'b0; 

		// cpu tracker signals 
		imemaddr_reg <= 32'd0; 
		opcode_reg <= RTYPE; 
		func_reg <= ADD; 
		instruction_reg <= 32'd0; 
		imm16_reg <= 16'd0; 
		imm16_ext_reg <= 32'd0;
		next_imemaddr_reg <= 32'd0; 
		rdat1_reg <= 32'd0; 
		rs_reg <= 5'd0; 
	end 
	// no reset applied 
	else begin 

		// set to their next state values 
		WEN_reg <= WEN_nxt; 
		reg_dest_reg <= reg_dest_nxt; 
		alu_op_reg <= alu_op_nxt; 
		rt_reg <= rt_nxt; 
		rd_reg <= rd_nxt; 
		data_store_reg <= data_store_nxt;
		result_reg <= result_nxt;
		halt_reg <= halt_nxt; 
		iREN_reg <= iREN_nxt; 
		dREN_reg <= dREN_nxt; 
		dWEN_reg <= dWEN_nxt;  
		mem_to_reg_reg <= mem_to_reg_nxt; 
		branch_addr_reg <= branch_addr_nxt; 
		zero_reg <= zero_nxt; 

		// cpu tracker signals 
		imemaddr_reg <= imemaddr_nxt; 
		opcode_reg <= opcode_nxt; 
		func_reg <= func_nxt; 
		instruction_reg <= instruction_nxt; 
		imm16_reg <= imm16_nxt; 
		imm16_ext_reg <= imm16_ext_nxt; 
		next_imemaddr_reg <= next_imemaddr_nxt;  
		rdat1_reg <= rdat1_nxt; 
		rs_reg <= rs_nxt; 
	end
end 
endmodule
