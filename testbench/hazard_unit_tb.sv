/*
  Mitchell Keeney
  mkeeney@purdue.edu

  hazard unit test bench
*/

/********************** Include statements *************************/
`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"
`include "data_path_muxs_pkg.vh"

/********************** Import statements *************************/
import cpu_types_pkg::*; 
import data_path_muxs_pkg::*; 

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

  /********************** Interface definitions *************************/
  hazard_unit_if huif(); 

  /********************** Port map definitions *************************/
  `ifndef MAPPED
    hazard_unit DUT(huif);
  `else
    request_unit DUT( 
    .\huif.ihit (huif.ihit), 
    .\huif.zer_EX_MEM (huif.zero_EX_MEM), 
    .\huif.dREN_ID_EX (dREN_ID_EX), 
    .\huif.opcode_EX_MEM (huif.opcode_EX_MEM), 
    .\huif.dREN_ID_EX (huif.dREN_ID_EX), 
    .\huif.opcode_EX_MEM (huif.opcode_EX_MEM), 
    .\huif.opcode_IF_ID (huif.opcode_IF_ID), 
    .\huif.func_EX_MEM (huif.func_EX_MEM),
    .\huif.func_IF_ID (huif.func_IF_ID), 
    .\huif.Rt_ID_EX (huif.Rt_ID_EX), 
    .\huif.Rs_IF_ID (huif.Rs_IF_ID), 
    .\huif.Rt_IF_ID (huif.Rt_IF_ID), 
    .\huif.enable_IF_ID (huif.enable_IF_ID), 
    .\huif.flush_IF_ID (huif.flush_IF_ID), 
    .\huif.enable_ID_EX (huif.enable_ID_EX), 
    .\huif.flush_ID_EX (huif.flush_ID_EX), 
    .\huif.enable_EX_MEM (huif.enable_EX_MEM)  
    .\huif.flush_EX_MEM (huif.flush_EX_MEM)
    .\huif.enable_MEM_WB (huif.enable_MEM_WB)
    .\huif.flush_MEM_WB (huif.flush_MEM_WB)
    .\huif.PCSrc (huif.PCSrc)
    );
  `endif

  /***************Assign statements ********************/


  /***************Program Calls********************/

  // test program
  test PROG (huif);

endmodule

  /***************Program Definitions ********************/

program test
  // modports
  (
  hazard_unit_if hutb
  );

initial begin
   static int test_case = 1;
   static int test_fails = 0;
   hutb.opcode_EX_MEM = RTYPE;
   hutb.zero_EX_MEM = 0;
   hutb.Rt_ID_EX = 0;
   hutb.Rs_IF_ID = 0;
   hutb.opcode_IF_ID = RTYPE;
   hutb.func_IF_ID = SLLV;
   hutb.func_EX_MEM = SLLV;
   hutb.Rt_IF_ID = 0;
   hutb.ihit = 0;
   hutb.dhit = 0;
   hutb.dREN_ID_EX = 0;
   
   // TEST 1
   #(5ns)
   hutb.opcode_EX_MEM = BEQ;
   hutb.zero_EX_MEM = 1'b1;
   #(5ns)
   assert(hutb.flush_IF_ID == 1'b1 && hutb.flush_ID_EX == 1'b1 && hutb.flush_EX_MEM == 1'b0 && huif.PCSrc == SEL_LOAD_BR_ADDR)
      $display("Test case %d passed", test_case);
   else
   begin
      $display("Error with BEQ and zero");
      test_fails += 1;
   end
   test_case += 1;

   // TEST 2
   #(5ns)
   hutb.opcode_EX_MEM = BNE;
   hutb.zero_EX_MEM = 1'b0;
   #(5ns)
   assert(hutb.flush_IF_ID == 1'b1 && hutb.flush_ID_EX == 1'b1 && hutb.flush_EX_MEM == 1'b0 && huif.PCSrc == SEL_LOAD_BR_ADDR)
      $display("Test case %d passed", test_case);
   else
   begin
      $display("Error with BNE and not zero");
      test_fails += 1;
   end
   test_case += 1;

   // TEST 3
   #(5ns)
   hutb.Rt_ID_EX = 5'b10101;
   hutb.Rs_IF_ID = 5'b10101;
   hutb.dREN_ID_EX = 1'b1;
   #(5ns)
   assert(hutb.enable_pc == 1'b0 && hutb.flush_ID_EX == 1'b1 && huif.enable_IF_ID == 1'b0)
      $display("Test case %d passed", test_case);
   else
   begin
      $display("Error with Load Reg Hazard");
      test_fails += 1;
   end
   test_case += 1;

   // TEST 4
   #(5ns)
   hutb.Rt_ID_EX = 5'b10101;
   hutb.Rt_IF_ID = 5'b10101;
   hutb.dREN_ID_EX = 1'b1;
   hutb.Rs_IF_ID = 5'b10000;
   #(5ns)
   assert(hutb.enable_pc == 1'b0 && hutb.flush_ID_EX == 1'b1 && huif.enable_IF_ID == 1'b0)
      $display("Test case %d passed", test_case);
   else
   begin
      $display("Error with Load Reg Hazard");
      test_fails += 1;
   end
   test_case += 1; 

   hutb.dREN_ID_EX = 1'b0; 

   // TEST 5
   #(5ns)
   hutb.opcode_IF_ID = JAL;
   #(5ns)
   assert(hutb.PCSrc == SEL_LOAD_JMP_ADDR)
      $display("Test case %d passed", test_case);
   else
   begin
      $display("Error with JAL instruction in IF/ID");
      test_fails += 1;
   end
   test_case += 1; 

   // TEST 6
   #(5ns)
   hutb.opcode_IF_ID = J;
   #(5ns)
   assert(hutb.PCSrc == SEL_LOAD_JMP_ADDR)
      $display("Test case %d passed", test_case);
   else
   begin
      $display("Error with J instruction in IF/ID");
      test_fails += 1;
   end
   test_case += 1; 

   // TEST 7
   #(5ns)
   hutb.opcode_IF_ID = RTYPE;
   hutb.func_IF_ID = JR;
   #(5ns)
   assert(hutb.PCSrc == SEL_LOAD_JR_ADDR)
      $display("Test case %d passed", test_case);
   else
   begin
      $display("Error with JR instruction in IF/ID");
      test_fails += 1;
   end
   test_case += 1; 

   #(5ns)
   hutb.opcode_EX_MEM = HALT;
   hutb.zero_EX_MEM = '1;
   hutb.Rt_ID_EX = '1;
   hutb.Rs_IF_ID = '1;
   hutb.opcode_IF_ID = HALT;
   hutb.func_IF_ID = SLTU;
   hutb.func_EX_MEM = SLTU;
   hutb.Rt_IF_ID = '1;
   hutb.ihit = '1;
   hutb.dhit = '1;
   hutb.dREN_ID_EX = '1;

   #(5ns)
   hutb.opcode_EX_MEM = RTYPE;
   hutb.zero_EX_MEM = 0;
   hutb.Rt_ID_EX = 0;
   hutb.Rs_IF_ID = 0;
   hutb.opcode_IF_ID = RTYPE;
   hutb.func_IF_ID = SLLV;
   hutb.func_EX_MEM = SLLV;
   hutb.Rt_IF_ID = 0;
   hutb.ihit = 0;
   hutb.dhit = 0;
   hutb.dREN_ID_EX = 0;

   if(test_fails == 0)
      $display("All test cases passed");
   else
      $display("%d test cases failed", test_fails);

end

endprogram































