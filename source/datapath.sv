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
`include "pipeline_controller_if.vh"

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

request_unit_if ruif(); 
request_unit REQUEST (CLK, nRST, ruif);

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

pipeline_controller_if pipeline_controllerif(); 
pipeline_controller PIP_CONT(pipeline_controllerif); 

/************************** Locac Variable definitions ***************************/
word_t imm16_ext, portb;
regbits_t wsel; 

/************************** glue logic ***************************/

// IF section 
// program counter inputs
assign pcif.PCSrc = id_ex_regif.PCSrc_ID_EX; 
assign pcif.br_addr =  32'd0;
assign pcif.jmp_addr = 28'd0; 
assign pcif.jr_addr = 32'd0; 
assign pcif.ihit = dpif.ihit; 

// IF/ID register inputs 
assign if_id_regif.instruction = dpif.imemload; 
assign if_id_regif.enable_IF_ID = pipeline_controllerif.enable_IF_ID; 
assign if_id_regif.flush_IF_ID = pipeline_controllerif.flush_IF_ID; 
assign if_id_regif.imemaddr = pcif. imemaddr; 
assign if_id_regif.next_imemaddr = pcif.next_imemaddr; 

// ID stage
// control unit inputs 
assign cuif.opcode_IF_ID = if_id_regif.opcode_IF_ID; 
assign cuif.func_IF_ID = if_id_regif.func_IF_ID; 

// register file inputs
assign rfif.WEN = mem_wb_regif.WEN_MEM_WB; 
assign rfif.wsel = wsel; 
assign rfif.wdat = mem_wb_regif.mem_data_MEM_WB; 
assign rfif.rsel2 = mem_wb_regif.Rt_MEM_WB; 
assign rfif.rsel1 = mem_wb_regif.Rd_MEM_WB; 

// ID/EX register inputs 
assign id_ex_regif.enable_ID_EX = pipeline_controllerif.enable_ID_EX; 
assign id_ex_regif.flush_ID_EX = pipeline_controllerif.flush_ID_EX; 
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

// ID/EX register inputs for cpu tracker 
assign id_ex_regif.imemaddr_IF_ID = if_id_regif.imemaddr_IF_ID; 
assign id_ex_regif.opcode_IF_ID = if_id_regif.opcode_IF_ID; 
assign id_ex_regif.func_IF_ID = if_id_regif.func_IF_ID; 
assign id_ex_regif.instruction_IF_ID = if_id_regif.instruction_IF_ID; 
assign id_ex_regif.imm16_IF_ID = if_id_regif.imm16_IF_ID; 
assign id_ex_regif.next_imemaddr_IF_ID = if_id_regif.next_imemaddr_IF_ID; 

// EX stage
// alu inputs
assign aluif.port_b = port_b; 
assign aluif.port_a = id_ex_regif.rdat1_ID_EX; 
assign aluif.alu_op = id_ex_regif.alu_op_ID_EX; 

// EX/MEM register inputs 
assign ex_mem_regif.enable_EX_MEM = pipeline_controllerif.enable_EX_MEM;  
assign ex_mem_regif.flush_EX_MEM = pipeline_controllerif.flush_EX_MEM; 
assign ex_mem_regif.WEN_ID_EX = id_ex_regif.WEN_ID_EX; 
assign ex_mem_regif.reg_dest_ID_EX = id_ex_regif.reg_dest_ID_EX; 
assign ex_mem_regif.alu_op_ID_EX = id_ex_regif.alu_op_ID_EX; 
assign ex_mem_regif.Rt_ID_EX = id_ex_regif.Rt_ID_EX; 
assign ex_mem_regif.Rd_ID_EX = id_ex_regif.Rd_ID_EX; 
assign ex_mem_regif.rdat2_ID_EX = id_ex_regif.rdat2_ID_EX; 
assign ex_mem_regif.result = aluif.result;
assign ex_mem_regif.iREN_ID_EX = id_ex_regif.iREN_ID_EX; 
assign ex_mem_regif.dREN_ID_EX = id_ex_regif.dREN_ID_EX; 
assign ex_mem_regif.dWEN_ID_EX = id_ex_regif.dWEN_ID_EX; 
assign ex_mem_regif.halt_ID_EX = id_ex_regif.halt_ID_EX;  

// EX/MEM register inputs for cpu tracker 
assign ex_mem_regif.imemaddr_ID_EX = id_ex_regif.imemaddr_ID_EX; 
assign ex_mem_regif.opcode_ID_EX = id_ex_regif.opcode_ID_EX; 
assign ex_mem_regif.func_ID_EX = id_ex_regif.func_ID_EX; 
assign ex_mem_regif.instruction_ID_EX = id_ex_regif.instruction_ID_EX; 
assign ex_mem_regif.imm16_ID_EX = id_ex_regif.imm16_ID_EX; 
assign ex_mem_regif.imm16_ext_ID_EX = id_ex_regif.imm16_ext_ID_EX; 
assign ex_mem_regif.next_imemaddr_ID_EX = id_ex_regif.next_imemaddr_ID_EX; 

// MEM state
// data_path to cache signals 
assign dpif.imemaddr = pcif.imemaddr; 
assign dpif.imemREN = ex_mem_regif.imemREN; 
assign dpif.dmemWEN = ex_mem_regif.dmemWEN; 
assign dpif.dmemREN = ex_mem_regif.dmemREN; 
assign dpif.dmemaddr = ex_mem_regif.dmemaddr_EX_MEM; 
assign dpif.dmemstore = ex_mem_regif.dmemstore_EX_MEM; 

// MEM/WB register inputs 
assign mem_wb_regif.enable_MEM_WB = pipeline_controllerif.enable_MEM_WB; 
assign mem_wb_regif.flush_MEM_WB = pipeline_controllerif.flush_MEM_WB; 
assign mem_wb_regif.result_EX_MEM = ex_mem_regif.result_EX_MEM; 
assign mem_wb_regif.WEN_EX_MEM = ex_mem_regif.WEN_EX_MEM; 
assign mem_wb_regif.reg_dest_EX_MEM = ex_mem_regif.reg_dest_EX_MEM; 
assign mem_wb_regif.Rt_EX_MEM = ex_mem_regif.Rt_EX_MEM; 
assign mem_wb_regif.Rd_EX_MEM = ex_mem_regif.Rd_EX_MEM; 
assign mem_wb_regif.dmemload = dpif.dmemload; 
assign mem_wb_regif.halt_EX_MEM = ex_mem_regif.halt_EX_MEM; 

// MEM/WB register inputs for cpu tracker signals 
assign mem_wb_regif.imemaddr_EX_MEM = ex_mem_regif.imemaddr_EX_MEM; 
assign mem_wb_regif.opcode_EX_MEM = ex_mem_regif.opcode_EX_MEM; 
assign mem_wb_regif.func_EX_MEM = ex_mem_regif.func_EX_MEM; 
assign mem_wb_regif.instruction_EX_MEM = ex_mem_regif.instruction_EX_MEM; 
assign mem_wb_regif.imm16_EX_MEM = ex_mem_regif.imm16_EX_MEM; 
assign mem_wb_regif.imm16_ext_EX_MEM = ex_mem_regif.imm16_ext_EX_MEM; 
assign mem_wb_regif.dmemstore_EX_MEM = ex_mem_regif.dmemstore_EX_MEM; 
assign mem_wb_regif.next_imemaddr_EX_MEM = ex_mem_regif.imemaddr_EX_MEM; 

// pipeline controller inputs 
assign pipeline_controllerif.dhit = dpif.dhit; 
assign pipeline_controllerif.ihit = dpif.ihit; 

/************************** shift left logic ***************************/


/************************** Mux logic ***************************/

// This mux directs which input should go to the alu portb 
always_comb begin: MUX_1
  
  // set default value to prevent latches 
  portb = 32'd0; 

  casez (id_ex_regif.ALUSrc_ID_EX)
    SEL_REG_DATA: portb = id_ex_regif.rdat2_ID_EX;  
    SEL_IMM16: portb = id_ex_regif.imm16_ext_ID_EX; 
  endcase
end 

// This mux directs which input goes into the write select port of register file 
always_comb begin: MUX_2

  // assign default value to prevent latches
  wsel = 5'b0; 

  // case statement for control signal 
  casez (mem_wb_regif.reg_dest_MEM_WB)
    SEL_RD: wsel = mem_wb_regif.Rd_MEM_WB;  
    SEL_RT:  wsel = mem_wb_regif.reg_dest_MEM_WB;  
  endcase
end 

/************************** Extender logic ***************************/
always_comb begin: EXTENDER
  
  // set default value to prevent latches
  imm16_ext = 32'd0; 

  // case statement for control signal 
  casez (cuif.extend) 
    1'b0: imm16_ext = {16'h0, cuif.imm16};  
    1'b1: if (cuif.imm16[15] == 1'b0) begin 

            imm16_ext = {16'h0, cuif.imm16}; 
          end 
          else begin 
            imm16_ext = {16'hffff, cuif.imm16}; 
          end 
  endcase
end 
endmodule
