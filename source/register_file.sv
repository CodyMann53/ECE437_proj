/*
  Cody Mann
  mann53@purdue.edu

  register file 
*/

module rf(input logic CLK, nRST, register_file_if.rf rfif); 

// array to hold all of the register memory. 32 word locations
logic [31:0] [31:0] registers, registers_next; 

// values to define outputs for rdata lines 
logic [31:0] rdata_out1, rdata_out2; 

// combination block for determining registers
always_comb begin: DECODER 

	// assigning default values to prevent latches (all values stay the same )
	registers_next = registers;

	// memory location 0 is always zero  
	registers_next[0] = 'b0; 

	// assign the rdata lines to zero as default
	rdata_out1 = 'b0; 
	rdata_out2 = 'b0; 

	// if writing and not to the zero memory location 
	if ( (rfif.WEN = 1'b1) & (rfif.wsel != 32'd0) ) begin 

		// update the register that wsel is pointing to and set its value to write data
		registers_next[rfif.wsel] = rfif.wdat
	end 
	// reading
	else begin

		// set rdata lines to what rsel are requesting 
		rdata_out1 = registers[rfif.rsel1]; 
		rdata_out2 = registers[rfif.rsel2]; 
	end 
end 

always_ff (@posedge CLK, @negedge nRST) begin: REGISTER_MEMORY_LOGIC

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


