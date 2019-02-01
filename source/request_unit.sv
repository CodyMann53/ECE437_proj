/*
  Cody Mann
  mann53@purdue.edu

  pc (program counter) 
*/

`include "cpu_types_pkg.vh"
`include "pc_if.vh"


module request_unit
	import cpu_types_pkg::*;
	(
	input logic CLK,
 	nRST,
 	request_unit_if ruif
 	); 

/********** Local variable definitions ***************************/
logic dWEN_reg, iREN_reg, dREN_reg, halt_reg; 

/********** Assign statements ***************************/

// If either ihit or dit is low, then tell the program counter to wait 
assign ruif.pc_wait = (ruif.ihit | ruif.dhit | halt_reg) ? 1 : 0; 

// assign the registered values to memory request control signals 
assign ruif.imemREN = iREN_reg; 
assign ruif.dmemWEN = dWEN_reg; 
assign ruif.dmemREN = dREN_reg; 

/********** Combinational Logic ***************************/

/********** Sequential Logic ***************************/
always_ff @(posedge CLK, negedge nRST) begin: ENABLE_SIGNALS_REG_LOGIC
	
	// if reset is brought low 
	if (nRST == 1'b0) begin 

		// reset all saved enalbe signals back to zero 
		dWEN_reg <= 1'b0; 
		dREN_reg <= 1'b0; 
		iREN_reg <= 1'b0;
		halt_reg <= 1'b0; 
	end 
	// no reset was applied 
	else begin 

		// save input enable signals into flip flops 
		dWEN_reg <= ruif.dWEN; 
		dREN_reg <= ruif.dREN; 
		iREN_reg <= ruif.iREN;
		halt_reg <= ruif.halt;  
	end 
end
endmodule

