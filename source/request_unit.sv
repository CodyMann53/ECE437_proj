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
logic dWEN_reg, iREN_reg, dREN_reg, halt_reg, dWEN_reg_nxt, iREN_reg_nxt, dREN_reg_nxt; 

/********** Assign statements ***************************/

// route halt to cache interface 
assign ruif.halt_out = (halt_reg); 

assign ruif.imemREN =  iREN_reg; 

// output assign statements 
assign ruif.dmemWEN = dWEN_reg; 
assign ruif.dmemREN = dREN_reg; 

/********** Combinational Logic ***************************/


// comb block for controll memory data write request 
always_comb begin: ENABLE_LOGIC_DWEN
	
	// assign default values to the enable signals 
 
	dWEN_reg_nxt = dWEN_reg; 

	if (halt_reg == 1'b1) begin 

		dWEN_reg_nxt = 1'b0; 
	end 
	// if not requesting a data write 
	else if (ruif.dWEN == 1'b0) begin 

		// just keep the memory data write request low 
		dWEN_reg_nxt = 1'b0; 
	end
	else if ((ruif.dWEN == 1'b1) &(ruif.ihit == 1'b1)) begin 

		// dkeep memroy write request high 
		dWEN_reg_nxt = 1'b1; 
	end 
	// if dhit goes low 
	else if (ruif.dhit == 1'b1) begin 

		// deasert the memory request data write 
		dWEN_reg_nxt = 1'b0; 
	end 
end 

// comb block for crequesting memory data read request 
always_comb begin: ENABLE_LOGIC_DREN
	
	// assign default values to the enable signals
	dREN_reg_nxt = dREN_reg; 

	if (halt_reg == 1'b1) begin 

		dREN_reg_nxt = 1'b0; 
	end 
	// if not requesting a data read
	else if (ruif.dREN == 1'b0) begin 

		// just keep the memory data read request low 
		dREN_reg_nxt = 1'b0; 
	end
	else if ((ruif.dREN == 1'b1) & (ruif.ihit == 1'b1)) begin 

		// dkeep memroy read request high 
		dREN_reg_nxt = 1'b1; 
	end 
	// if dhit goes low 
	else if (ruif.dhit == 1'b1) begin 

		// deasert the memory request data read 
		dREN_reg_nxt = 1'b0; 
	end 
end 

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
		dWEN_reg <= dWEN_reg_nxt; 
		dREN_reg <= dREN_reg_nxt; 
		iREN_reg <= ruif.iREN;
		halt_reg <= ruif.halt;  
	end 
end
endmodule

