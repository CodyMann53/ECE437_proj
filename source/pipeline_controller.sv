/*
  Cody Mann
  mann53@purdue.edu

  pipeline controller module  
*/

`include "cpu_types_pkg.vh"
`include "pipeline_controller_if.vh"

import cpu_types_pkg::*;
import data_path_muxs_pkg::*; 

module pipeline_controller
	(
	input CLK, nRST,
 	pipeline_controller_if pipeline_controllerif, 
 	); 

/********** Local type definitions ***************************/
  
/********** Local variable definitions ***************************/	
logic iREN_reg, iREN_nxt, dREN_reg, dREN_nxt, dWEN_reg, dWEN_nxt. halt_reg, halt_nxt;

/********** Assign statements ***************************/

// assign the output signals to the register values 
assign pipeline_controllerif.halt = halt_reg; 
assign pipeline_controllerif.dmemREN = dREN_reg; 
assign pipeline_controllerif.dmemWEN = dWEN_reg; 
assign pipeline_controllerif.imemREN = iREN_reg; 

/********** Combination Logic Blocks ***************************/
always_comb begin: ENABLE_LOGIC_DWEN

	// just assign section of instruction to thier respective latched values 
	dWEN_nxt = dWEN_reg; 

	if (halt_reg == 1'b1) begin 
		dWEN_nxt = 1'b0; 
	end 
	else if (pipeline_controllerif.dWEN_ID_EX == 1'b0) begin 
		dWEN_nxt = 1'b0; 
	end 
	else if ((pipeline_controllerif.dWEN_ID_EX == 1'b1) & (pipeline_controllerif.ihit == 1'b1)begin 
		dWEN_nxt = 1'b1; 
	end 
	else if (pipeline_controllerif.dhit == 1'b1)begin 
		dWEN_nxt = 1'b0; 
	end 
end 

always_comb begin: ENABLE_LOGIC_DREN

	// just assign section of instruction to thier respective latched values 
	dREN_nxt = dREN_reg; 

	if (halt_reg == 1'b1) begin 
		dREN_nxt = 1'b0; 
	end 
	else if (pipeline_controllerif.dREN_ID_EX == 1'b0) begin 
		dREN_nxt = 1'b0; 
	end 
	else if ((pipeline_controllerif.dREN_ID_EX == 1'b1) & (pipeline_controllerif.ihit == 1'b1)begin 
		dREN_nxt = 1'b1; 
	end 
	else if (pipeline_controllerif.dhit == 1'b1)begin 
		dREN_nxt = 1'b0; 
	end 
end 


/********** Sequential Logic Blocks ***************************/
always_ff @(posedge CLK, negedge nRST) begin: REG_LOGIC

	// if reset is brought low 
	if (nRST == 1'b0) begin 
		dREN_reg <= 1'b0; 
		dWEN_reg <= 1'b0; 
		iREN_reg <= 1'b0; 
		halt_reg <= 1'b0; 
	end 
	// no reset applied 
	else begin 
		dREN_reg <= dREN_nxt; 
		dWEN_reg <= dWEN_nxt; 
		iREN_reg <= iREN_nxt; 
		halt_reg <= pipeline_controllerif.halt_ID_EX; 
	end
end 
endmodule
