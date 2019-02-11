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
 	mem_wb_reg_if mem_wb_regif, 
 	); 

/********** Local type definitions ***************************/
  
/********** Local variable definitions ***************************/	
logic WEN_reg, WEN_nxt; 
word_t result_reg, result_nxt, 
	   dmemload_reg, dmemload_nxt; 
reg_dest_mux_selection reg_dest_reg, reg_dest_nxt; 
regbits_t rt_reg, rt_nxt; 
regbits_t rd_reg, rd_nxt; 

/********** Assign statements ***************************/

// assign the output signals to the register values 
assign mem_wb_regif.WEN_MEM_WB = WEN_reg; 
assign mem_wb_regif.reg_dest_MEM_WB = reg_dest_reg; 
assign mem_wb_regif.mem_data_MEM_WB = dmemload_reg; 
assign mem_wb_regif.Rt_MEM_WB = rt_reg; 
assign mem_wb_regif.Rd_MEM_WB = rd_reg; 

/********** Combination Logic Blocks ***************************/
always_comb begin: NXT_LOGIC

	// just assign section of instruction to thier respective latched values 
	WEN_nxt = WEN_reg; 
	result_nxt = result_reg; 
	reg_dest_nxt = reg_dest_reg; 
	rt_nxt = rt_reg; 
	rd_nxt = rd_reg; 
	dmemload_nxt = dmemload_reg; 

	if ((mem_wb_regif.enable_MEM_WB == 1'b1) & (mem_wb_regif.flush_MEM_WB == 1'b0)) begin 
		WEN_nxt = mem_wb_regif.WEN_EX_MEM; 
		result_nxt = mem_wb_regif.result_EX_MEM; 
		reg_dest_nxt = mem_wb_regif.reg_dest_EX_MEM; 
		rt_nxt = mem_wb_regif.Rt_EX_MEM; 
		rd_nxt = mem_wb_regif.Rd_EX_MEM; 
		dmemload_nxt = mem_wb_regif.dmemload; 
	end 
	else if (mem_wb_regif.flush_MEM_WB == 1'b1) begin 
		WEN_nxt = 1'b0; 
		result_nxt = 32'd0; 
		reg_dest_nxt = SEL_RD; 
		rt_nxt = 5'd0; 
		rd_nxt = 5'd0; 
		dmemload_nxt = 32'd0; 
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
	end
end 
endmodule
