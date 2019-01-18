/*
  Cody Mann
  mann53@purdue.edu

  Arithmetic Logic Unit 
*/

`include "cpu_types_pkg.vh"
`include "alu_if.vh"

module alu 
	import cpu_types_pkg::*;
	(alu_if.alu aluif); 

/********** variable declarations **************/
// assign negative flag to second to last bit of result overflow 
assign aluif.negative = aluif.result[WORD_W-1]; 

// assign the zero flag to one if all bits are 0 
assign aluif.zero = (aluif.result[WORD_W-1:0] & 32'hFFFFFFFF) ? 1'b0 : 1'b1; 

/****************** Comb blocks ********************/
always_comb begin 
		
		// set default value to prevent latches
		aluif.overflow = 1'b0; 

		// if operation is an add
		if (aluif.alu_op == ALU_ADD ) begin 

			// if porta and port b are the same sign 
			if (aluif.port_a[WORD_W-1] == aluif.port_b[WORD_W-1]) begin 

				// check to see if the result sign changed after operation 
				if (aluif.result[WORD_W-1] == ~(aluif.port_b[WORD_W-1])) begin 

					// set an overflow 
					aluif.overflow = 1'b1; 
				end 
			end 
		end

		// if operation is an add
		if (aluif.alu_op == ALU_SUB) begin 

			// if porta and port b are the same sign 
			if (aluif.port_a[WORD_W-1] != aluif.port_b[WORD_W-1]) begin 

				// check to see if the result sign did no chang after operation 
				if (aluif.result[WORD_W-1] == aluif.port_b[WORD_W-1])  begin 

					// set an overflow 
					aluif.overflow = 1'b1; 
				end 
			end 
		end
end 

always_comb begin

	// set default values for result and overflow to prevent latches 
	aluif.result = 32'd0; 


	casez (aluif.alu_op)
	    
		ALU_SLL: 	aluif.result =  aluif.port_b << aluif.port_a[4:0];
	    ALU_SRL: 	aluif.result = aluif.port_b >> aluif.port_a[4:0]; 
	    ALU_ADD: 	aluif.result = $signed(aluif.port_b) + $signed(aluif.port_a);
	    ALU_SUB:	aluif.result = $signed(aluif.port_a) - $signed(aluif.port_b); 
	    ALU_AND: 	aluif.result = aluif.port_a & aluif.port_b; 
	    ALU_OR:  	aluif.result = aluif.port_a | aluif.port_b; 
	    ALU_XOR: 	aluif.result = aluif.port_a ^ aluif.port_b; 
	    ALU_NOR: 	aluif.result = ~(aluif.port_a | aluif.port_b); 
	    ALU_SLT: 	begin 
		    			if ( $signed(aluif.port_a) < $signed(aluif.port_b)) begin 
		    				aluif.result = 32'd1; 
		    			end 
		    			else begin 
		    				aluif.result = 32'd0; 
		    			end 
	    			end 
	    ALU_SLTU: 	begin
		    			if (aluif.port_a < aluif.port_b) begin 
		    				aluif.result = 32'd1; 
		    			end 
		    			else begin 
		    				aluif.result = 32'd0; 
		    			end 	    	
	    			end 
	endcase
end
endmodule // alu module end


