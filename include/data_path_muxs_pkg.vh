/*
    Cody Mann
    mann53@purdue.edu

    Created to use descriptive signals when selecting mux signals within data path.
  
*/
`ifndef DATA_PATH_MUXS_PKG_VH
`define DATA_PATH_MUXS_PKG_VH
package data_path_muxs_pkg;

/********************************** Mux select line types *******************************/
  
  // mux select signal that decides which signal gets stored as next program counter
  typedef enum logic [1:0] {

    SEL_LOAD_JMP_ADDR = 2'd0, 
    SEL_LOAD_JR_ADDR = 2'd1, 
    SEL_LOAD_NXT_INSTR = 2'd2, 
    SEL_LOAD_BR_ADDR = 2'd3

  } pc_mux_input_selection;

  // mux select signals that directs which signals gets stored to register
  typedef enum logic [1:0] {

    SEL_RESULT = 2'd0, 
    SEL_NPC = 2'd1, 
    SEL_DLOAD = 2'd2, 
    SEL_IMM16_TO_UPPER_32 = 2'd3
  } mem_to_reg_mux_selection; 

  // mux select signal that decides which signal gets directed to the ALU port b
  typedef enum logic {

    SEL_REG_DATA = 1'b0, 
    SEL_IMM16 = 1'b1
  } alu_source_mux_selection; 

  // mux that selects which register value from instruction is set as
  // the destination source when writing result back to register 
  typedef enum logic [1:0] {
    SEL_RD = 2'd0, 
    SEL_RT = 2'd1, 
    SEL_RETURN_REGISTER = 2'd2; 
  }reg_dest_mux_selection; 

endpackage
`endif //DATA_PATH_MUXS_PKG_VH