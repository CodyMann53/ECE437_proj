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
assign ruif.pc_wait = (ruif.ihit | ruif.dhit | halt_reg) ? 1'b1 : 1'b0; 

// route halt to cache interface 
assign ruif.halt_out = halt_reg; 

/********** Combinational Logic ***************************/

// comb block for controll memory data write request 
always_comb begin: ENABLE_LOGIC_DWEN
	
	// assign default values to the enable signals 
 
	ruif.dmemWEN = 1'b0; 

	if (halt_reg == 1'b1) begin 

		ruif.dmemWEN = 1'b0; 
	end 
	// if not requesting a data write 
	else if (dWEN_reg == 1'b0) begin 

		// just keep the memory data write request low 
		ruif.dmemWEN = 1'b0; 
	end
	// If requesting a data write and dhit is high 
	else if ((dWEN_reg == 1'b1) & (ruif.dhit == 1'b1)) begin 

		// dkeep memroy write request high 
		ruif.dmemWEN = 1'b1; 
	end 
	// if dhit goes low 
	else if ((dWEN_reg == 1'b1) & (ruif.dhit == 1'b0)) begin 

		// deasert the memory request data write 
		ruif.dmemWEN = 1'b0; 
	end 
end 

// comb block for crequesting memory data read request 
always_comb begin: ENABLE_LOGIC_DREN
	
	// assign default values to the enable signals
	ruif.dmemREN = 1'b0; 

	if (halt_reg == 1'b1) begin 

		ruif.dmemREN = 1'b0; 
	end 
	// if not requesting a data read
	else if (dREN_reg == 1'b0) begin 

		// just keep the memory data read request low 
		ruif.dmemREN = 1'b0; 
	end
	// If requesting a data read and dhit is high 
	else if ((dREN_reg == 1'b1) & (ruif.dhit == 1'b1)) begin 

		// dkeep memroy read request high 
		ruif.dmemREN = 1'b1; 
	end 
	// if dhit goes low 
	else if ((dREN_reg == 1'b1) & (ruif.dhit == 1'b0)) begin 

		// deasert the memory request data read 
		ruif.dmemREN = 1'b0; 
	end 
end 

// comb block for crequesting memory instruction read request 
always_comb begin: ENABLE_LOGIC_IREN
	
	// assign default values to the enable signals
	ruif.imemREN = 1'b0; 


	if (halt_reg == 1'b1) begin 

		ruif.imemREN = 1'b0; 
	end 
	// if not requesting an instruction read
	else if (iREN_reg == 1'b0) begin 

		// just keep the memory instruciton read request low 
		ruif.imemREN = 1'b0; 
	end
	// If requesting instruction read and ihit is high 
	else if ((iREN_reg == 1'b1) & (ruif.ihit == 1'b1)) begin 

		// dkeep memroy read request high 
		ruif.imemREN = 1'b1; 
	end 
	// if ihit goes low 
	else if ((iREN_reg == 1'b1) & (ruif.ihit == 1'b0)) begin 

		// deasert the memory request instruction  read 
		ruif.imemREN = 1'b0; 
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
		dWEN_reg <= ruif.dWEN; 
		dREN_reg <= ruif.dREN; 
		iREN_reg <= ruif.iREN;
		halt_reg <= ruif.halt;  
	end 
end
endmodule

