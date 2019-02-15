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
 	pipeline_controller_if pipeline_controllerif 
 	); 

/********** Local type definitions ***************************/
  
/********** Local variable definitions ***************************/	

/********** Assign statements ***************************/
assign pipeline_controllerif.enable_IF_ID = pipeline_controllerif.ihit; 
assign pipeline_controllerif.enable_ID_EX = pipeline_controllerif.ihit; 
assign pipeline_controllerif.enable_EX_MEM = (pipeline_controllerif.ihit | pipeline_controllerif.dhit); 
assign pipeline_controllerif.enable_MEM_WB = (pipeline_controllerif.ihit | pipeline_controllerif.dhit); 

assign pipeline_controllerif.flush_IF_ID = 1'b0; 
assign pipeline_controllerif.flush_ID_EX = 1'b0; 
assign pipeline_controllerif.flush_EX_MEM = pipeline_controllerif.dhit; 
assign pipeline_controllerif.flush_MEM_WB = 1'b0; 

endmodule
