/*
  Cody Mann
  mann53@purdue.edu

  Arithmetic Logic Unit 
*/

`include "cpu_types_pkg.vh"
`include "register_file_if.vh"

module alu 
	import cpu_types_pkg::*;
	(alu_if.rf aluif); 

/********** variable declarations **************/
// used for extending one bit to make it easier for checking overflow
logic [WORD_W:0] result_OF;  


// assign result output to the first 32 bits of result_OF
assign aluif.result = result_OF[WORD_W-1:0]; 

// assign negative flag to second to last bit of result overflow 
assign aluif.negative = result_OF[WORD_W-1]; 

// assign the zero flag to one if all bits are 0 
assign aluif.zero = (result_OF[WORD_W-1:0] & 32'hFFFF) ? 1'b0 : 1'b1; 

/****************** Comb blocks ********************/
always_comb begin

	// set default values for result and overflow to prevent latches 
	result_OF = 33'd0; 
	aluif.overflow = 1'b0; 


	casez (aluif.alu_op)
	    
		ALU_SLL: result_OF =  port_b << port_a[4:0];
	    ALU_SRL: result_OF = port_b >> port_a[4:0]; 
	    ALU_ADD: result_OF = port_b + port_a; aluif.overflow = result_OF[WORD_W]; 
	    ALU_SUB: result_OF = port_a - port_b; aluif.overflow = result_OF[WORD_W];
	    ALU_AND: result_OF = port_a & port_b; 
	    ALU_OR:  result_OF = port_a | port_b; 
	    ALU_XOR: result_OF = port_a ^ port_b; 
	    ALU_NOR: result_OF = port_a ~| port_bl 
	    ALU_SLT: begin 

	    			if (port_a < port_b) begin 
	    				result_OF = 33'd1; 
	    			end 
	    			else begin 
	    				result_OF = 33'd0; 
	    			end 
	    		end 
	    ALU_SLTU: begin

	    			if (port_a < port_b) begin 
	    				result_OF = 33'd1; 
	    			end 
	    			else begin 
	    				result_OF = 33'd0; 
	    			end 	    	
	    		end 
	    default:
	endcase
end
endmodule // alu module end


