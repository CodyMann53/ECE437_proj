/*
    Cody Mann
    mann53@purdue.edu

    Created to use descriptive signals when selecting mux signals within data path.
  
*/
`ifndef DATA_PATH_MUXS_PKG_VH
`define DATA_PATH_MUXS_PKG_VH
package data_path_muxs_pkg;

  // word width and size
  
// opcodes
  // opcode type
  typedef enum logic [OP_W-1:0] {
    // rtype - use funct
    RTYPE   = 6'b000000,

  } opcode_t;

endpackage
`endif //DATA_PATH_MUXS_PKG_VH