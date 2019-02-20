/*
  Cody Mann
  mann53@purdue.edu

  hazard unit module  
*/

`include "cpu_types_pkg.vh"
`include "hazard_unit_if.vh"
`include "data_path_muxs_pkg.vh"

import cpu_types_pkg::*;
import data_path_muxs_pkg::*; 

module hazard_unit 
	(
 	hazard_unit_if huif 
 	); 

/********** Local type definitions ***************************/
  
/********** Local variable definitions ***************************/	

/********** Assign statements ***************************/
assign huif.PCSrc = SEL_LOAD_NXT_INSTR; 
assign huif.enable_IF_ID = huif.ihit; 
assign huif.enable_ID_EX = huif.ihit; 
assign huif.enable_EX_MEM = (huif.ihit | huif.dhit); 
assign huif.enable_MEM_WB = (huif.ihit | huif.dhit); 

assign huif.flush_IF_ID = 1'b0; 
assign huif.flush_ID_EX = 1'b0; 
assign huif.flush_EX_MEM = huif.dhit; 
assign huif.flush_MEM_WB = 1'b0; 
assign huif.enable_pc = 1'b1; 

endmodule
