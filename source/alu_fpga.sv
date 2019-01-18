/*
  Cody Mann
  mann53@purdue.edu

  alu fpga wrapper
*/

// includes
`include "cpu_types_pkg.vh"
`include "alu_if.vh"

module alu_fpga 
  import cpu_types_pkg::*; 
  (
  input logic [3:0] KEY,
  input logic [17:0] SW,
  output logic [3:0] HEX0,
  output logic [3:0] HEX1,
  output logic [3:0] HEX2,
  output logic [3:0] HEX3,
  output logic [3:0] HEX4, 
  output logic HEX5, 
  output logic HEX6, 
  output logic HEX7
  );

// interfaces
alu_if aluif();

// alu
alu ALU(aluif); 

// variable definitions 
logic [16:0] reg_b, reg_b_next; 

// ALU hardware assignments 
assign aluif.port_a = {15'b0, SW[16:0]};
assign aluif.port_b = {15'b0, reg_b}; 
assign aluif.alu_op[0] = ~KEY[0]; // keys are active low
assign aluif.alu_op[1] = ~KEY[1]; // keys are active low
assign aluif.alu_op[2] = ~KEY[2]; // keys are active low
assign aluif.alu_op[3] = ~KEY[3]; // keys are active low

  always_comb
  begin
    unique casez (aluif.result[3:0])
      'h0: HEX0 = 4'd0;
      'h1: HEX0 = 4'd1;
      'h2: HEX0 = 4'd2;
      'h3: HEX0 = 4'd3;
      'h4: HEX0 = 4'd4;
      'h5: HEX0 = 4'd5;
      'h6: HEX0 = 4'd6;
      'h7: HEX0 = 4'd7;
      'h8: HEX0 = 4'd8;
      'h9: HEX0 = 4'd9;
      'ha: HEX0 = 4'd10;
      'hb: HEX0 = 4'd11;
      'hc: HEX0 = 4'd12;
      'hd: HEX0 = 4'd13;
      'he: HEX0 = 4'd14;
      'hf: HEX0 = 4'd15;
    endcase
  end

    always_comb
  begin
    unique casez (aluif.result[7:4])
      'h0: HEX1 = 4'd0;
      'h1: HEX1 = 4'd1;
      'h2: HEX1 = 4'd2;
      'h3: HEX1 = 4'd3;
      'h4: HEX1 = 4'd4;
      'h5: HEX1 = 4'd5;
      'h6: HEX1 = 4'd6;
      'h7: HEX1 = 4'd7;
      'h8: HEX1 = 4'd8;
      'h9: HEX1 = 4'd9;
      'ha: HEX1 = 4'd10;
      'hb: HEX1 = 4'd11;
      'hc: HEX1 = 4'd12;
      'hd: HEX1 = 4'd13;
      'he: HEX1 = 4'd14;
      'hf: HEX1 = 4'd15;
    endcase
  end

  always_comb
  begin
    unique casez (aluif.result[11:8])
      'h0: HEX2 = 4'd0;
      'h1: HEX2 = 4'd1;
      'h2: HEX2 = 4'd2;
      'h3: HEX2 = 4'd3;
      'h4: HEX2 = 4'd4;
      'h5: HEX2 = 4'd5;
      'h6: HEX2 = 4'd6;
      'h7: HEX2 = 4'd7;
      'h8: HEX2 = 4'd8;
      'h9: HEX2 = 4'd9;
      'ha: HEX2 = 4'd10;
      'hb: HEX2 = 4'd11;
      'hc: HEX2 = 4'd12;
      'hd: HEX2 = 4'd13;
      'he: HEX2 = 4'd14;
      'hf: HEX2 = 4'd15;
    endcase
  end

  always_comb
  begin
    unique casez (aluif.result[15:12])
      'h0: HEX3 = 4'd0;
      'h1: HEX3 = 4'd1;
      'h2: HEX3 = 4'd2;
      'h3: HEX3 = 4'd3;
      'h4: HEX3 = 4'd4;
      'h5: HEX3 = 4'd5;
      'h6: HEX3 = 4'd6;
      'h7: HEX3 = 4'd7;
      'h8: HEX3 = 4'd8;
      'h9: HEX3 = 4'd9;
      'ha: HEX3 = 4'd10;
      'hb: HEX3 = 4'd11;
      'hc: HEX3 = 4'd12;
      'hd: HEX3 = 4'd13;
      'he: HEX3 = 4'd14;
      'hf: HEX3 = 4'd15;
    endcase
  end

always_comb
  begin
    unique casez (aluif.result[19:16])
      'h0: HEX4 = 4'd0;
      'h1: HEX4 = 4'd1;
      'h2: HEX4 = 4'd2;
      'h3: HEX4 = 4'd3;
      'h4: HEX4 = 4'd4;
      'h5: HEX4 = 4'd5;
      'h6: HEX4 = 4'd6;
      'h7: HEX4 = 4'd7;
      'h8: HEX4 = 4'd8;
      'h9: HEX4 = 4'd9;
      'ha: HEX4 = 4'd10;
      'hb: HEX4 = 4'd11;
      'hc: HEX4 = 4'd12;
      'hd: HEX4 = 4'd13;
      'he: HEX4 = 4'd14;
      'hf: HEX4 = 4'd15;
    endcase
  end

always_comb
  begin
    unique casez (aluif.zero)
      'h0: HEX5 = 1'b0;
      'h1: HEX5 = 1'b1; 
    endcase
  end

always_comb
  begin
    unique casez (aluif.negative)
      'h0: HEX6 = 1'b0;
      'h1: HEX6 = 1'b1; 
    endcase
  end


always_comb
  begin
    unique casez (aluif.overflow)
      'h0: HEX7 = 1'b0;
      'h1: HEX7 = 1'b1; 
    endcase
  end

// comb blocks 
always_comb begin: REGISTER_B_NEXT_STATE; 

  // assigning to default value to prevent latches 
  reg_b_next = reg_b; 
    
  if (SW[17] == 1'b1) begin 

   // assigned switche 0 -16 to the register
   reg_b_next = SW[16:0]; 
  end 
end 

// register blocks 
always_ff begin: REGISTER_B
  
  reg_b <= reg_b_next; 
end 
endmodule
