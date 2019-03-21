/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor. This is pipeline version.
*/

// data path interface
`include "datapath_cache_if.vh"

// inner component interfaces
`include "control_unit_if.vh"
`include "alu_if.vh"
`include "request_unit_if.vh"
`include "register_file_if.vh"
`include "pc_if.vh"

// register file interfaces 
`include "if_id_reg_if.vh"
`include "id_ex_reg_if.vh"
`include "ex_mem_reg_if.vh"
`include "mem_wb_reg_if.vh"
`include "hazard_unit_if.vh"
`include "forward_unit_if.vh"

// control signals for mux's 
`include "data_path_muxs_pkg.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"
 

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;
  import data_path_muxs_pkg::*;

  // pc init
  parameter PC_INIT = 0;

/************************** interface definitions ***************************/
alu_if aluif(); 
alu ALU (aluif); 

control_unit_if cuif(); 
control_unit CONTROL (cuif); 

register_file_if rfif(); 
register_file REGISTER (CLK, nRST, rfif); 

pc_if pcif(); 
pc PC (CLK, nRST, pcif); 

// pipeline registers 
if_id_reg_if if_id_regif(); 
if_id_reg IF_ID(CLK, nRST, if_id_regif); 

id_ex_reg_if id_ex_regif(); 
id_ex_reg ID_EX(CLK, nRST, id_ex_regif);

ex_mem_reg_if ex_mem_regif(); 
ex_mem_reg EX_MEM(CLK, nRST, ex_mem_regif); 

mem_wb_reg_if mem_wb_regif(); 
mem_wb_reg MEM_WB(CLK, nRST, mem_wb_regif);  

hazard_unit_if huif(); 
hazard_unit HAZ_UNIT(huif.hu); 

forward_unit_if fuif();
forward_unit FU(fuif);

/************************** Locac Variable definitions ***************************/
word_t imm16_ext, port_b, wdat, data_store, d_s;
regbits_t wsel, fu_reg_dest_EX_MEM, fu_reg_dest_MEM_WB; 
word_t next_imemaddr, jmp_addr, next_pc; 
logic [27:0] jmp_addr_shifted;
word_t br_imm, branch_addr, jmp_return_addr; 
word_t alu_mux_a, alu_mux_b;

/************************** glue logic ***************************/

// IF section 
// program counter inputs
assign pcif.next_pc = next_pc; 
assign pcif.ihit = dpif.ihit; 
assign pcif.enable_pc = huif.enable_pc;

// IF/ID register inputs 
assign if_id_regif.instruction = dpif.imemload; 
assign if_id_regif.enable_IF_ID = huif.enable_IF_ID; 
assign if_id_regif.flush_IF_ID = huif.flush_IF_ID; 
assign if_id_regif.imemaddr = pcif.imemaddr; 
assign if_id_regif.next_imemaddr = next_imemaddr; 

// ID stage
// control unit inputs 
assign cuif.opcode_IF_ID = if_id_regif.opcode_IF_ID; 
assign cuif.func_IF_ID = if_id_regif.func_IF_ID; 

// register file inputs
assign rfif.WEN = mem_wb_regif.WEN_MEM_WB; 
assign rfif.wsel = wsel; 
assign rfif.wdat = wdat; 
assign rfif.rsel2 = if_id_regif.Rt_IF_ID; 

// ID/EX register inputs 
assign id_ex_regif.enable_ID_EX = huif.enable_ID_EX; 
assign id_ex_regif.flush_ID_EX = huif.flush_ID_EX; 
assign id_ex_regif.iREN = cuif.iREN; 
assign id_ex_regif.dREN = cuif.dREN; 
assign id_ex_regif.dWEN = cuif.dWEN; 
assign id_ex_regif.ALUSrc = cuif.ALUSrc; 
assign id_ex_regif.PCSrc = cuif.PCSrc;
assign id_ex_regif.WEN = cuif.WEN; 
assign id_ex_regif.alu_op = cuif.alu_op;
assign id_ex_regif.halt = cuif.halt; 
assign id_ex_regif.reg_dest = cuif.reg_dest; 
assign id_ex_regif.Rd_IF_ID = if_id_regif.Rd_IF_ID; 
assign id_ex_regif.Rt_IF_ID = if_id_regif.Rt_IF_ID;
assign id_ex_regif.rdat1 = rfif.rdat1; 
assign id_ex_regif.rdat2 = rfif.rdat2; 
assign id_ex_regif.imm16_ext = imm16_ext; 
assign id_ex_regif.mem_to_reg = cuif.mem_to_reg; 

// ID/EX register inputs for cpu tracker 
assign id_ex_regif.imemaddr_IF_ID = if_id_regif.imemaddr_IF_ID; 
assign id_ex_regif.opcode_IF_ID = if_id_regif.opcode_IF_ID; 
assign id_ex_regif.func_IF_ID = funct_t'(if_id_regif.func_IF_ID); //'
assign id_ex_regif.instruction_IF_ID = if_id_regif.instruction_IF_ID; 
assign id_ex_regif.imm16_IF_ID = if_id_regif.imm16_IF_ID; 

assign id_ex_regif.next_imemaddr_IF_ID = if_id_regif.next_imemaddr_IF_ID; 
assign id_ex_regif.Rs_IF_ID = if_id_regif.Rs_IF_ID; 
assign id_ex_regif.extend = cuif.extend; 

// EX stage
// alu inputs
assign aluif.port_b = alu_mux_b; 
assign aluif.port_a = alu_mux_a; 
assign aluif.alu_op = id_ex_regif.alu_op_ID_EX; 

// EX/MEM register inputs 
assign ex_mem_regif.enable_EX_MEM = huif.enable_EX_MEM;  
assign ex_mem_regif.flush_EX_MEM = huif.flush_EX_MEM; 
assign ex_mem_regif.WEN_ID_EX = id_ex_regif.WEN_ID_EX; 
assign ex_mem_regif.reg_dest_ID_EX = id_ex_regif.reg_dest_ID_EX; 
assign ex_mem_regif.alu_op_ID_EX = id_ex_regif.alu_op_ID_EX; 
assign ex_mem_regif.Rt_ID_EX = id_ex_regif.Rt_ID_EX; 
assign ex_mem_regif.Rd_ID_EX = id_ex_regif.Rd_ID_EX; 
assign ex_mem_regif.result = aluif.result;
assign ex_mem_regif.iREN_ID_EX = id_ex_regif.iREN_ID_EX; 
assign ex_mem_regif.dREN_ID_EX = id_ex_regif.dREN_ID_EX; 
assign ex_mem_regif.dWEN_ID_EX = id_ex_regif.dWEN_ID_EX; 
assign ex_mem_regif.halt_ID_EX = id_ex_regif.halt_ID_EX;  
assign ex_mem_regif.rdat1_ID_EX = id_ex_regif.rdat1_ID_EX; 
assign ex_mem_regif.mem_to_reg_ID_EX = id_ex_regif.mem_to_reg_ID_EX; 
assign ex_mem_regif.data_store = d_s; 
assign ex_mem_regif.branch_addr = branch_addr; 

// EX/MEM register inputs for cpu tracker 
assign ex_mem_regif.imemaddr_ID_EX = id_ex_regif.imemaddr_ID_EX; 
assign ex_mem_regif.opcode_ID_EX = id_ex_regif.opcode_ID_EX; 
assign ex_mem_regif.func_ID_EX = id_ex_regif.func_ID_EX; 
assign ex_mem_regif.instruction_ID_EX = id_ex_regif.instruction_ID_EX; 
assign ex_mem_regif.imm16_ID_EX = id_ex_regif.imm16_ID_EX; 
assign ex_mem_regif.imm16_ext_ID_EX = id_ex_regif.imm16_ext_ID_EX; 
assign ex_mem_regif.next_imemaddr_ID_EX = id_ex_regif.next_imemaddr_ID_EX; 
assign ex_mem_regif.Rs_ID_EX = id_ex_regif.Rs_ID_EX;
assign ex_mem_regif.zero = aluif.zero;  
assign ex_mem_regif.dhit = dpif.dhit; 

// MEM state
// data_path to cache signals 
assign dpif.imemaddr = pcif.imemaddr; 
assign dpif.imemREN = ex_mem_regif.imemREN; 
assign dpif.dmemWEN = ex_mem_regif.dmemWEN; 
assign dpif.dmemREN = ex_mem_regif.dmemREN; 
assign dpif.dmemaddr = ex_mem_regif.dmemaddr_EX_MEM; 
assign dpif.dmemstore = ex_mem_regif.dmemstore_EX_MEM; 
assign dpif.halt = mem_wb_regif.halt; 

// MEM/WB register inputs 
assign mem_wb_regif.enable_MEM_WB = huif.enable_MEM_WB; 
assign mem_wb_regif.flush_MEM_WB = huif.flush_MEM_WB; 
assign mem_wb_regif.result_EX_MEM = ex_mem_regif.result_EX_MEM; 
assign mem_wb_regif.WEN_EX_MEM = ex_mem_regif.WEN_EX_MEM; 
assign mem_wb_regif.reg_dest_EX_MEM = ex_mem_regif.reg_dest_EX_MEM; 
assign mem_wb_regif.Rt_EX_MEM = ex_mem_regif.Rt_EX_MEM; 
assign mem_wb_regif.Rd_EX_MEM = ex_mem_regif.Rd_EX_MEM; 
assign mem_wb_regif.dmemload = dpif.dmemload;  
assign mem_wb_regif.halt_EX_MEM = ex_mem_regif.halt_EX_MEM; 
assign mem_wb_regif.mem_to_reg_EX_MEM = ex_mem_regif.mem_to_reg_EX_MEM; 
assign mem_wb_regif.dhit = dpif.dhit; 

// MEM/WB register inputs for cpu tracker signals 
assign mem_wb_regif.imemaddr_EX_MEM = ex_mem_regif.imemaddr_EX_MEM; 
assign mem_wb_regif.opcode_EX_MEM = ex_mem_regif.opcode_EX_MEM; 
assign mem_wb_regif.func_EX_MEM = ex_mem_regif.func_EX_MEM; 
assign mem_wb_regif.instruction_EX_MEM = ex_mem_regif.instruction_EX_MEM; 
assign mem_wb_regif.imm16_EX_MEM = ex_mem_regif.imm16_EX_MEM; 
assign mem_wb_regif.imm16_ext_EX_MEM = ex_mem_regif.imm16_ext_EX_MEM; 
assign mem_wb_regif.dmemstore_EX_MEM = ex_mem_regif.dmemstore_EX_MEM; 
assign mem_wb_regif.next_imemaddr_EX_MEM = ex_mem_regif.next_imemaddr_EX_MEM; 
assign mem_wb_regif.rdat1_EX_MEM = ex_mem_regif.rdat1_EX_MEM; 
assign mem_wb_regif.Rs_EX_MEM = ex_mem_regif.Rs_EX_MEM; 

// Foward unit signals
assign fuif.rs = id_ex_regif.Rs_ID_EX;
assign fuif.rt = id_ex_regif.Rt_ID_EX;
assign fuif.reg_wr_mem = fu_reg_dest_EX_MEM;
assign fuif.reg_wr_wb = fu_reg_dest_MEM_WB;
assign fuif.reg_dest_ID_EX = id_ex_regif.reg_dest_ID_EX; 
assign fuif.opcode_ID_EX = id_ex_regif.opcode_ID_EX; 
assign fuif.opcode_EX_MEM = ex_mem_regif.opcode_EX_MEM; 
assign fuif.opcode_MEM_WB = mem_wb_regif.opcode_MEM_WB; 
assign fuif.WEN_EX_MEM = ex_mem_regif.WEN_EX_MEM; 
assign fuif.WEN_MEM_WB = mem_wb_regif.WEN_MEM_WB; 

// pipeline controller inputs 
assign huif.dhit = dpif.dhit; 
assign huif.ihit = dpif.ihit; 
assign huif.zero_EX_MEM = ex_mem_regif.zero_EX_MEM; 
assign huif.dREN_ID_EX = id_ex_regif.dREN_ID_EX; 
assign huif.Rt_ID_EX = id_ex_regif.Rt_ID_EX; 
assign huif.Rs_IF_ID = if_id_regif.Rs_IF_ID; 
assign huif.Rt_IF_ID = if_id_regif.Rt_IF_ID; 
assign huif.func_IF_ID = if_id_regif.func_IF_ID; 
assign huif.opcode_IF_ID = if_id_regif.opcode_IF_ID; 
assign huif.opcode_EX_MEM = opcode_t'(ex_mem_regif.opcode_EX_MEM); //' 
assign huif.dmemWEN = ex_mem_regif.dmemWEN; 
assign huif.dmemREN = ex_mem_regif.dmemREN; 
assign huif.halt = mem_wb_regif.halt; 

/************************** Mux logic ***************************/

// This mux directs which input should go to the alu portb 
always_comb begin: MUX_1
  
  // set default value to prevent latches 
  port_b = 32'd0; 

  casez (id_ex_regif.ALUSrc_ID_EX)
    SEL_REG_DATA: port_b = id_ex_regif.rdat2_ID_EX;  
    SEL_IMM16: port_b = id_ex_regif.imm16_ext_ID_EX; 
  endcase
end 

// This mux directs which input goes into the write select port of register file 
always_comb begin: MUX_2

  // assign default value to prevent latches
  wsel = 5'b0; 

  // case statement for control signal 
  casez (mem_wb_regif.reg_dest_MEM_WB)
    SEL_RD: wsel = mem_wb_regif.Rd_MEM_WB;  
    SEL_RT:  wsel = mem_wb_regif.Rt_MEM_WB;  
    SEL_RETURN_REGISTER: wsel = 5'd31; 
  endcase
end 

// This mux directs which result value should get written back to register file
always_comb begin: MUX_3
  
  // set default values
  wdat = 32'd0; 

  // case statement based off of the mem_to_reg value 
  casez (mem_wb_regif.mem_to_reg_MEM_WB)

    SEL_RESULT: wdat = mem_wb_regif.result_MEM_WB; 
    SEL_DLOAD: wdat = mem_wb_regif.mem_data_MEM_WB;
    SEL_NPC: wdat = mem_wb_regif.next_imemaddr_MEM_WB; 
  endcase
end 

// This is used to determine which value goes to data store in the EX/MEM register 
always_comb begin: MUX_4
  
  // defalut value 
  data_store = id_ex_regif.rdat2_ID_EX; 

  casez (id_ex_regif.extend_ID_EX)
    2'd2: data_store = port_b; 
  endcase
end 

// mux to determine which value is the next program counter input 
always_comb begin: MUX_5
  
  // set default value 
  next_pc = next_imemaddr; 

  casez (huif.PCSrc)
    SEL_LOAD_JMP_ADDR: next_pc = jmp_addr;  
    SEL_LOAD_JR_ADDR: next_pc = jmp_return_addr; 
    SEL_LOAD_NXT_INSTR: next_pc = next_imemaddr; 
    SEL_LOAD_BR_ADDR: next_pc = branch_addr; 
    SEL_LOAD_NXT_PC_EX_MEM: next_pc = ex_mem_regif.next_imemaddr_EX_MEM;  
  endcase
end

// mux to determine which value gets stored to memory (forward value or register file value)
always_comb begin: MUX_6
  // default value
  d_s = data_store; 

  casez(fuif.mux6_sel) 
    2'd1: d_s = ex_mem_regif.result_EX_MEM; 
    2'd2: d_s = wdat; 
  endcase
end 

// mux to determine which value is used as rs 
always_comb begin: RSEL_1_LOGIC
  
  // set default value 
  rfif.rsel1 = if_id_regif.Rs_IF_ID; 

  // if the instruction is an RTYPE and func is JR
  if ((if_id_regif.opcode_IF_ID == RTYPE) & (if_id_regif.func_IF_ID == JR)) begin 

    // set to the register that saved the function return address 
    rfif.rsel1 = 5'd31; 
  end 
end  

/************************** Extender and other data manipulation logic ***************************/
always_comb begin: EXTENDER
  
  // set default value to prevent latches
  imm16_ext = 32'd0; 

  // case statement for control signal 
  casez (cuif.extend) 
    2'd0: imm16_ext = {16'h0, if_id_regif.imm16_IF_ID};  
    2'd1: if (if_id_regif.imm16_IF_ID[15] == 1'b0) begin 

            imm16_ext = {16'h0, if_id_regif.imm16_IF_ID}; 
          end 
          else begin 
            imm16_ext = {16'hffff, if_id_regif.imm16_IF_ID}; 
          end
    2'd2: imm16_ext = {if_id_regif.imm16_IF_ID, 16'd0}; 
  endcase
end 

assign jmp_addr = {next_imemaddr[31:28], jmp_addr_shifted}; 


/************************** Shift logic ***************************/
assign jmp_addr_shifted = {if_id_regif.instruction_IF_ID[25:0], 2'b00}; 
assign br_imm = imm16_ext << 2; 


/************************* Adder logic ***************************/
assign next_imemaddr = pcif.imemaddr + 32'd4; 
assign branch_addr = if_id_regif.next_imemaddr_IF_ID + br_imm; 

/************************ Jump Return ****************************/ 
always_comb begin: RETURN_ADDR_LOGIC
   if (id_ex_regif.opcode_ID_EX == JAL)
   begin
      jmp_return_addr = id_ex_regif.next_imemaddr_ID_EX;
   end
   else if (ex_mem_regif.opcode_EX_MEM == JAL)
   begin
      jmp_return_addr = ex_mem_regif.next_imemaddr_EX_MEM;
   end
   else if (mem_wb_regif.opcode_MEM_WB == JAL)
   begin
      jmp_return_addr = mem_wb_regif.next_imemaddr_MEM_WB;
   end
   else
   begin
      jmp_return_addr = rfif.rdat1;
   end
end 

/************************ ALU_MUX_A ****************************/ 
always_comb begin: ALU_MUX_A
   if(fuif.porta_sel == 2'b00)
   begin
      alu_mux_a = id_ex_regif.rdat1_ID_EX;
   end
   else if(fuif.porta_sel == 2'b01)
   begin
      alu_mux_a = ex_mem_regif.result_EX_MEM;
   end
   else if(fuif.porta_sel == 2'b10)
   begin
      alu_mux_a = wdat;
   end
   else
   begin
      alu_mux_a = id_ex_regif.rdat1_ID_EX;
   end
end

/************************ ALU_MUX_B ****************************/ 
always_comb begin: ALU_MUX_B
   if(fuif.portb_sel == 2'b00)
   begin
      alu_mux_b = port_b;
   end
   else if(fuif.portb_sel == 2'b01)
   begin
      alu_mux_b = ex_mem_regif.result_EX_MEM;
   end
   else if(fuif.portb_sel == 2'b10)
   begin
      alu_mux_b = wdat;
   end
   else
   begin
      alu_mux_b = port_b;
   end
end

/****************** FORWARD_UNIT_SIGNALS **********************/ 
always_comb begin: FU_SIGS
   casez(ex_mem_regif.reg_dest_EX_MEM)
      SEL_RD: fu_reg_dest_EX_MEM = ex_mem_regif.Rd_EX_MEM;
      SEL_RT: fu_reg_dest_EX_MEM = ex_mem_regif.Rt_EX_MEM;
      SEL_RETURN_REGISTER: fu_reg_dest_EX_MEM = 5'b11111;
   endcase

   casez(mem_wb_regif.reg_dest_MEM_WB)
      SEL_RD: fu_reg_dest_MEM_WB = mem_wb_regif.Rd_MEM_WB;
      SEL_RT: fu_reg_dest_MEM_WB = mem_wb_regif.Rt_MEM_WB;
      SEL_RETURN_REGISTER: fu_reg_dest_MEM_WB = 5'b11111;
   endcase
end

endmodule
