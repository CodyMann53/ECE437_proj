/*
    Cody Mann
    mann53@purdue.edu

    Created to use descriptive signals when selecting mux signals within data path.
  
*/
`ifndef DATA_PATH_MUXS_PKG_VH
`define DATA_PATH_MUXS_PKG_VH
package data_path_muxs_pkg;

/********************************** Mux select line types *******************************/
  typedef enum logic [2:0] {

    SEL_LOAD_ADDR = 3'd0, 
    SEL_LOAD_JR_ADR = 3'd1, 
    SEL_LOAD_IMM16 = 3'd2, 
    SEL_LOAD_NXT_INSTR = 3'd3

  } pc_mux_input_selection;

endpackage
`endif //DATA_PATH_MUXS_PKG_VH