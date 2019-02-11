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
 	ex_mem_reg_if ex_mem_regif, 
 	); 

/********** Local type definitions ***************************/
  
/********** Local variable definitions ***************************/	

logic iREN_reg, iREN_nxt, 
      dREN_reg, dREN_nxt, 
      dWEN_reg, dWEN_nxt, 
      halt_reg, halt_nxt, 
      WEN_reg, WEN_nxt; 

reg_dest_mux_selection reg_dest_reg, reg_dest_nxt; 
aluop_t alu_op_reg, alu_op_nxt; 
regbits_t rt_reg, rt_nxt, 
		  rd_reg, rd_nxt; 
word_t result_reg, result_nxt,
	   rdat2_reg, rdat2_nxt; 

/********** Assign statements ***************************/

// assign the output signals to the register values 
assign ex_mem_regif.dmemaddr_EX_MEM = result_reg; 
assign ex_mem_regif.dmemstore_EX_MEM = rdat2_reg; 
assign ex_mem_regif.result_EX_MEM = result_reg; 
assign ex_mem_regif.WEN_EX_MEM = WEN_reg; 
assign ex_mem_regif.reg_dest_EX_MEM = reg_dest_reg; 
assign ex_mem_regif.Rt_EX_MEM = rt_reg; 
assign ex_mem_regif.Rd_EX_MEM = rd_reg; 

/********** Combination Logic Blocks ***************************/
always_comb begin: NXT_LOGIC

	// just assign section of instruction to thier respective latched values 
	reg_dest_nxt = reg_dest_reg; 
	alu_op_nxt = alu_op_reg; 
	rt_nxt = rt_reg; 
	rd_nxt = rd_reg; 
	result_nxt = result_reg; 
	rdat2_nxt = rdat2_reg; 

	if ((ex_mem_regif.enable_EX_MEM == 1'b1) & (ex_mem_regif.flush_EX_MEM == 1'b0)) begin 
		WEN_nxt = ex_mem_regif.WEN_ID_EX; 
		reg_dest_nxt = ex_mem_regif.reg_dest_ID_EX; 
		alu_op_nxt = ex_mem_regif.alu_op_ID_EX; 
		rt_nxt = ex_mem_regif.Rt_ID_EX; 
		rd_nxt = ex_mem_regif.Rd_ID_EX; 
		result_nxt = ex_mem_regif.result; 
		rdat2_nxt = ex_mem_regif.rdat2; 
	end 
	else if (ex_mem_regif.flush_EX_MEM == 1'b1) begin 
		halt_nxt = 1'b0; 
		WEN_nxt = 1'b0;  
		reg_dest_nxt = SEL_RD; 
		alu_op_nxt = ALU_ADD; 
		rt_nxt = 5'd0; 
		rd_nxt = 5'd0; 
		result_nxt = 32'd0; 
		rdat2_nxt = 32'd0; 
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
		rdat2_reg <= 32'd0;
		result_reg <= 32'd0;  
	end 
	// no reset applied 
	else begin 

		// set to their next state values 
		WEN_reg <= WEN_nxt; 
		reg_dest_reg <= reg_dest_nxt; 
		alu_op_reg <= alu_op_nxt; 
		rt_reg <= rt_nxt; 
		rd_reg <= rd_nxt; 
		rdat2_reg <= rdat2_nxt;
		result_reg <= result_nxt;   
	end
end 
endmodule
