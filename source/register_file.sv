/*
  Cody Mann
  mann53@purdue.edu

  register file 
*/

`include "cpu_types_pkg.vh"
`include "register_file_if.vh"

module register_file 
	import cpu_types_pkg::*;
	(
	input logic CLK,
 	nRST, 
 	register_file_if.rf rfif); 



// array to hold all of the register memory. 32 word locations
word_t [31:0] registers, registers_next; 

// values to define outputs for rdata lines 
word_t rdata_out1, rdata_out2; 

// creating data flow assignments for the read data busses 
assign rfif.rdat1 = rdata_out1; 
assign rfif.rdat2 = rdata_out2; 

// combination block for determining registers
always_comb begin: DECODER 

	// assigning default values to prevent latches (all values stay the same )
	registers_next = registers;

	// memory location 0 is always zero  
	registers_next[0] = 'b0; 

	// if writing and not to the zero memory location 
	if ( (rfif.WEN == 1'b1) & (rfif.wsel != 5'd0) ) begin 

		// update the register that wsel is pointing to and set its value to write data
		registers_next[rfif.wsel] = rfif.wdat;
	end 

	// always keep the thre register read lines to what the read select address are. This should 
	// not interfere with writing at all
	rdata_out1 = registers[rfif.rsel1]; 
	rdata_out2 = registers[rfif.rsel2]; 

end 

always_ff @(posedge CLK, negedge nRST) begin: REGISTER_MEMORY_LOGIC

	// if reset is brought low 
	if (nRST == 1'b0) begin 

		// reset all values to zero 
		registers ='b0;
	end 
	// no reset was applied 
	else begin 

		// update registers 
		registers = registers_next; 
	end  
end 
endmodule


