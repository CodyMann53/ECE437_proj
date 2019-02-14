/*
  Cody Mann
  mann53@purdue.edu

  IF/ID pipeline register 
*/

`include "cpu_types_pkg.vh"
`include "if_id_reg_if.vh"

import cpu_types_pkg::*;


module if_id_reg
	(
	input CLK, nRST,
 	if_id_reg_if if_id_regif, 
 	); 

/********** Local type definitions ***************************/
  
/********** Local variable definitions ***************************/
regbits_t rs_reg, rs_nxt, rt_reg, rt_nxt, rd_reg, rd_nxt; 
opcode_t opcode_reg, opcode_nxt, func_reg, func_nxt; 
logic [15:0] imm16_reg, imm16_nxt; 
word_t imemaddr_reg, imemaddr_nxt, instruction_reg, instruction_nxt;

// cpu tracker variables 
word_t next_imemaddr_reg, next_imemaddr_nxt;  

/********** Assign statements ***************************/

// assign the output signals to the register values 
assign if_id_regif.Rs_IF_ID = rs_reg; 
assign if_id_regif.Rt_IF_ID = rt_reg; 
assign if_id_regif.Rd_IF_ID = rd_reg; 
assign if_id_regif.opcode_IF_ID = opcode_reg; 
assign if_id_regif.func_IF_ID = func_reg; 
assign if_id_regif.imemaddr_IF_ID = imemaddr_reg; 
assign if_id_regif.instruction_IF_ID = instruction_reg; 
assign if_id_regif.imm16_IF_ID = imm16_reg; 

// cpu tracker signals 
assign if_id_regif.next_imemaddr_IF_ID = next_imemaddr_reg; 

/********** Combination Logic Blocks ***************************/
always_comb begin: NXT_LOGIC

	// just assign section of instruction to thier respective latched values 
	rs_nxt = rs_reg; 
	rd_nxt = rd_reg; 
	rt_nxt = rt_reg; 
	imm16_nxt = imm16_reg; 
	opcode_nxt = opcode_reg; 
	func_nxt = func_reg; 
	imemaddr_nxt = imemaddr_reg; 

	//cpu tracker signals 
	instruction_nxt = instruction_reg; 
	next_imemaddr_nxt = next_imemaddr_reg; 

	if ((if_id_regif.enable_IF_ID == 1'b1) & (if_id_regif.flush_IF_ID == 1'b0))begin 
		rs_nxt = if_id_regif.instruction[25:21]; 
		rd_nxt = if_id_regif.instruction[15:11]; 
		rt_nxt = if_id_regif.instruction[20:16]; 
		imm16_nxt = if_id_regif.instruction[15:0]; 
		opcode_nxt = opcode_t'(if_id_regif.instruction[31:26]); 
		func_nxt = funct_t'(if_id_regif.instruction[5:0]); 
		imemaddr_nxt = if_id_regif.imemaddr; 

		// cpu tracker signals 
		instruction_nxt = if_id_regif.instruction; 
		next_imemaddr_nxt = if_id_regif.next_imemaddr; 
	end 
	else if (if_id_regif.flush_IF_ID == 1'b1) begin 
		rs_nxt = 5'd0; 
		rd_nxt = 5'd0; 
		rt_nxt = 5'd0; 
		imm16_nxt = 16'd0; 
		opcode_nxt = RTYPE; 
		func_nxt = ADD; 
		imemaddr_nxt = 32'd0; 

		// cpu tracker signals 
		instruction_nxt = 32'd0; 
		next_imemaddr_nxt = 32'd0; 
	end 
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
		imemaddr_reg <= 32'd0; 

		// cpu tracker signals 
		instruction_reg <= 32'd0;
		next_imemaddr_reg <= 32'd0;  
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
		imemaddr_reg <= imemaddr_nxt;

		// cpu tracker signals  
		instruction_reg <= instruction_nxt; 
		next_imemaddr_reg <= next_imemaddr_nxt; 
	end
end 
endmodule