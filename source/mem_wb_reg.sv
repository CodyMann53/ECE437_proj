/*
  Cody Mann
  mann53@purdue.edu

  MEM/WB pipeline register 
*/

`include "cpu_types_pkg.vh"
`include "mem_wb_reg_if.vh"
`include "data_path_muxs_pkg.vh"

import cpu_types_pkg::*;
import data_path_muxs_pkg::*; 

module mem_wb_reg
	(
	input CLK, nRST,
 	mem_wb_reg_if mem_wb_regif 
 	); 

/********** Local type definitions ***************************/
  
/********** Local variable definitions ***************************/	
logic WEN_reg, WEN_nxt, 
	  halt_nxt, halt_reg; 
word_t result_reg, result_nxt, 
	   dmemload_reg, dmemload_nxt; 
reg_dest_mux_selection reg_dest_reg, reg_dest_nxt; 
regbits_t rt_reg, rt_nxt; 
regbits_t rd_reg, rd_nxt; 
mem_to_reg_mux_selection mem_to_reg_reg, mem_to_reg_nxt; 

// cpu tracker variables 
word_t imemaddr_reg, imemaddr_nxt, next_imemaddr_reg, next_imemaddr_nxt;
opcode_t opcode_reg, opcode_nxt; 
funct_t func_reg, func_nxt; 
word_t instruction_reg, instruction_nxt; 
logic [15:0] imm16_reg, imm16_nxt; 
word_t imm16_ext_reg, imm16_ext_nxt; 
word_t dmemstore_reg, dmemstore_nxt; 
word_t rdat1_reg, rdat1_nxt; 
regbits_t rs_reg, rs_nxt; 

/********** Assign statements ***************************/

// assign the output signals to the register values 
assign mem_wb_regif.WEN_MEM_WB = WEN_reg; 
assign mem_wb_regif.reg_dest_MEM_WB = reg_dest_reg; 
assign mem_wb_regif.mem_data_MEM_WB = dmemload_reg; 
assign mem_wb_regif.Rt_MEM_WB = rt_reg; 
assign mem_wb_regif.Rd_MEM_WB = rd_reg; 
assign mem_wb_regif.halt = halt_reg; 

// cpu tracker signals 
assign mem_wb_regif.imemaddr_MEM_WB = imemaddr_reg; 
assign mem_wb_regif.opcode_MEM_WB = opcode_reg; 
assign mem_wb_regif.func_MEM_WB = func_reg; 
assign mem_wb_regif.instruction_MEM_WB = instruction_reg; 
assign mem_wb_regif.imm16_MEM_WB = imm16_reg; 
assign mem_wb_regif.imm16_ext_MEM_WB = imm16_ext_reg; 
assign mem_wb_regif.dmemstore_MEM_WB = dmemstore_reg;
assign mem_wb_regif.next_imemaddr_MEM_WB = next_imemaddr_reg;  
assign mem_wb_regif.rdat1_MEM_WB = rdat1_reg; 
assign mem_wb_regif.result_MEM_WB = result_reg; 
assign mem_wb_regif.Rs_MEM_WB = rs_reg; 
assign mem_wb_regif.mem_to_reg_MEM_WB = mem_to_reg_reg; 

/********** Combination Logic Blocks ***************************/
always_comb begin: NXT_LOGIC

	// just assign section of instruction to thier respective latched values 
	WEN_nxt = WEN_reg; 
	result_nxt = result_reg; 
	reg_dest_nxt = reg_dest_reg; 
	rt_nxt = rt_reg; 
	rd_nxt = rd_reg; 
	dmemload_nxt = dmemload_reg;
	halt_nxt = halt_reg;  
	mem_to_reg_nxt = mem_to_reg_reg; 

	// cpu tracker signals 
	imemaddr_nxt = imemaddr_reg; 
	opcode_nxt = opcode_reg; 
	func_nxt = func_reg; 
	instruction_nxt = instruction_reg; 
	imm16_nxt = imm16_reg; 
	imm16_ext_nxt = imm16_ext_reg; 
	dmemstore_nxt = dmemstore_reg; 
	next_imemaddr_nxt = next_imemaddr_reg; 
	rdat1_nxt = rdat1_reg; 
	rs_nxt = rs_reg; 

	if ((mem_wb_regif.enable_MEM_WB == 1'b1) & (mem_wb_regif.flush_MEM_WB == 1'b0)) begin 
		WEN_nxt = mem_wb_regif.WEN_EX_MEM; 
		result_nxt = mem_wb_regif.result_EX_MEM; 
		reg_dest_nxt = mem_wb_regif.reg_dest_EX_MEM; 
		rt_nxt = mem_wb_regif.Rt_EX_MEM; 
		rd_nxt = mem_wb_regif.Rd_EX_MEM; 
		dmemload_nxt = mem_wb_regif.dmemload; 
		halt_nxt = mem_wb_regif.halt_EX_MEM; 
		mem_to_reg_nxt = mem_wb_regif.mem_to_reg_EX_MEM; 

		// cpu tracker signals 
		imemaddr_nxt = mem_wb_regif.imemaddr_EX_MEM; 
		opcode_nxt = mem_wb_regif.opcode_EX_MEM; 
		func_nxt = mem_wb_regif.func_EX_MEM; 
		instruction_nxt = mem_wb_regif.instruction_EX_MEM; 
		imm16_nxt = mem_wb_regif.imm16_EX_MEM; 
		imm16_ext_nxt = mem_wb_regif.imm16_ext_EX_MEM; 
		dmemstore_nxt = mem_wb_regif.dmemstore_EX_MEM; 
		next_imemaddr_nxt = mem_wb_regif.next_imemaddr_EX_MEM; 
		rdat1_nxt = mem_wb_regif.rdat1_EX_MEM; 
		rs_nxt = mem_wb_regif.Rs_EX_MEM; 
	end 
	else if (mem_wb_regif.flush_MEM_WB == 1'b1) begin 
		WEN_nxt = 1'b0; 
		result_nxt = 32'd0; 
		reg_dest_nxt = SEL_RD; 
		//rt_nxt = 5'd0; 
		//rd_nxt = 5'd0; 
		dmemload_nxt = 32'd0; 
		halt_nxt = 1'b0; 
		mem_to_reg_nxt = SEL_RESULT; 

		// cpu tracker signals 
		imemaddr_nxt = 32'd0; 
		opcode_nxt = RTYPE; 
		func_nxt = ADD; 
		instruction_nxt = 32'd0; 
		imm16_nxt = 16'd0; 
		imm16_ext_nxt = 32'd0; 
		dmemstore_nxt = 32'd0; 
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
		result_reg <= 32'd0; 
		reg_dest_reg <= SEL_RD; 
		rt_reg <= 5'd0; 
		rd_reg <= 5'd0; 
		dmemload_reg <= 32'd0;
		halt_reg <= 1'b0;  
		mem_to_reg_reg <= SEL_RESULT; 

		// cpu tracker signals 
		imemaddr_reg <= 32'd0; 
		opcode_reg <= RTYPE; 
		func_reg <= ADD; 
		instruction_reg <= 32'd0; 
		imm16_reg <= 16'd0; 
		imm16_ext_reg <= 32'd0; 
		dmemstore_reg <= 32'd0; 
		next_imemaddr_reg <= 32'd0; 
		rdat1_reg <= 32'd0; 
		rs_reg <= 5'd0; 

	end 
	// no reset applied 
	else begin 

		// set to their next state values 
		WEN_reg <= WEN_nxt; 
		result_reg <= result_nxt; 
		reg_dest_reg <= reg_dest_nxt; 
		rt_reg <= rt_nxt; 
		rd_reg <= rd_nxt; 
		dmemload_reg <= dmemload_nxt; 
		halt_reg <= halt_nxt; 
		mem_to_reg_reg <= mem_to_reg_nxt; 

		// cpu tracker signals 
		imemaddr_reg <= imemaddr_nxt; 
		opcode_reg <= opcode_nxt; 
		func_reg <= func_nxt; 
		instruction_reg <= instruction_nxt; 
		imm16_reg <= imm16_nxt; 
		imm16_ext_reg <= imm16_ext_nxt; 
		dmemstore_reg <= dmemstore_nxt; 
		next_imemaddr_reg <= next_imemaddr_nxt;
		rdat1_reg <= rdat1_nxt; 
		rs_reg <= rs_nxt; 
	end
end 
endmodule
