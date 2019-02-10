/*
  Cody Mann
  mann53@purdue.edu

  ID/EX pipeline register 
*/

`include "cpu_types_pkg.vh"
`include "id_ex_reg_if.vh"

import cpu_types_pkg::*;


module id_ex_reg
	(
	input CLK, nRST,
 	id_ex_reg_if id_ex_regif, 
 	); 

/********** Local type definitions ***************************/
  
/********** Local variable definitions ***************************/
regbits_t rt_reg, rt_nxt,  
opcode_t opcode_reg, opcode_nxt, func_reg, func_nxt; 
logic [15:0] imm16_reg, imm16_nxt; 

/********** Assign statements ***************************/

// assign the output signals to the register values 
assign if_id_regif.Rs_IF_ID = rs_reg; 
assign if_id_regif.Rt_IF_ID = rt_reg; 
assign if_id_regif.Rd_IF_ID = rd_reg; 
assign if_id_regif.opcode_IF_ID = opcode_reg; 
assign if_id_regif.func_IF_ID = func_reg; 

/********** Combination Logic Blocks ***************************/
always_comb begin: NXT_LOGIC

	// just assign section of instruction to thier respective latched values 
	rs_nxt = if_id_regif.instruction[25:21]; 
	rd_nxt = if_id_regif.instruction[15:11]; 
	rt_nxt = if_id_regif.instruction[20:16]; 
	imm16_nxt = if_id_regif.instruction[15:0]; 
	opcode_nxt = opcode_t'(if_id_regif.instruction[31:26]); 
	func_nxt = funct_t'(if_id_regif.instruction[5:0]); 
end 

/********** Sequential Logic Blocks ***************************/
always_ff @(posedge CLK, negedge nRST) begin: REG_LOGIC

	// if reset is brought low 
	if (nRST == 1'b0) begin 

		// reset the registers to zero 
		rs_reg <= 5'd0; 
		rt_reg <= 5'd0; 
		rd_reg <= 5'd0; 
		opcode_reg <= 6'd0; 
		func_nxt <= 6'd0;
		imm16_reg <= 16'd0;  
	end 
	// no reset applied 
	else begin 

		// set to their next state values 
		rs_reg <= rs_nxt; 
		rt_reg <= rt_nxt; 
		rd_reg <= rd_nxt; 
		opcode_reg <= opcode_nxt; 
		func_reg <= func_nxt; 
		imm16_reg <= imm16_nxt; 
	end
end 
endmodule