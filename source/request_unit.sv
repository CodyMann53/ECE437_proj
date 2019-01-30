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
 	request_unit_if.ru ruif, 
 	); 

/********** Local variable definitions ***************************/
logic dWEN_reg, iREN_reg, dREN_reg; 

/********** Assign statements ***************************/

// If either ihit or dit is low, then tell the program counter to wait 
assign ru.pc_wait = (ru.ihit | ru.dhit) ? 1 : 0; 

// assign the registered values to memory request control signals 
assign ru.imemREN = iREN_reg; 
assign ru.dmemWEN = dWEN_reg; 
assign ru.dmemREN = dREN_reg; 

/********** Combinational Logic ***************************/

/********** Sequential Logic ***************************/
always_ff @(posedge CLK, negedge nRST) begin: ENABLE_SIGNALS_REG_LOGIC
	
	// if reset is brought low 
	if (nRST == 1'b0) begin 

		// reset all saved enalbe signals back to zero 
		dWEN_reg <= 1'b0; 
		dREN_reg <= 1'b0; 
		iREN_reg <= 1'b0;
	end 
	// no reset was applied 
	else begin 

		// save input enable signals into flip flops 
		dWEN_reg <= ruif.dWEN; 
		dREN_reg <= ruif.dREN; 
		iREN_reg <= ruif.iREN; 
	end 
end
endmodule

