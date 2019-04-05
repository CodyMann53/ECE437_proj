onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {System Signals } -radix hexadecimal /system_tb/CLK
add wave -noupdate -group {System Signals } -radix hexadecimal /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP0/CLK
add wave -noupdate /system_tb/DUT/CPU/DP0/nRST
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/imm16_ext
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/port_b
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/wdat
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/data_store
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/d_s
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/wsel
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/fu_reg_dest_EX_MEM
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/fu_reg_dest_MEM_WB
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/next_imemaddr
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/jmp_addr
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/next_pc
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/jmp_addr_shifted
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/br_imm
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/branch_addr
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/jmp_return_addr
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/alu_mux_a
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/alu_mux_b
add wave -noupdate -group DataPath0 /system_tb/DUT/CPU/DP0/dmemload_reg
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/flushed
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/iload
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/dload
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/ccwrite
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/cctrans
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/ccinv
add wave -noupdate -expand -group {Dcache0 Internal } /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate -expand -group {Dcache0 Internal } /system_tb/DUT/CPU/CM0/DCACHE/last_state
add wave -noupdate -expand -group {Dcache0 Internal } /system_tb/DUT/CPU/CM0/DCACHE/tag_snoop
add wave -noupdate -expand -group {Dcache0 Internal } /system_tb/DUT/CPU/CM0/DCACHE/ccsnoopaddr
add wave -noupdate -expand -group {Dcache0 Internal } /system_tb/DUT/CPU/CM0/DCACHE/next_state
add wave -noupdate -expand -group {Dcache0 Internal } -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/cbl[1]} -expand} /system_tb/DUT/CPU/CM0/DCACHE/cbl
add wave -noupdate -expand -group {Dcache0 Internal } /system_tb/DUT/CPU/CM0/DCACHE/ccinv
add wave -noupdate -expand -group {Dcache0 Internal } /system_tb/DUT/CPU/CM0/DCACHE/dmemREN
add wave -noupdate -expand -group {Dcache0 Internal } /system_tb/DUT/CPU/CM0/DCACHE/dmemWEN
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/opcode_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/func_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/Rd_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/Rd_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/Rs_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/Rs_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/Rt_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/Rt_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/WEN_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/WEN_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/alu_op_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/branch_addr
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/branch_addr_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/dREN_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/dWEN_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/data_store
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/dhit
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/dmemREN
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/dmemWEN
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/dmemaddr_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/dmemstore_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/enable_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/flush_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/func_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/halt_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/halt_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/iREN_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/imemREN
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/imemaddr_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/imemaddr_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/imm16_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/imm16_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/imm16_ext_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/imm16_ext_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/instruction_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/instruction_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/mem_to_reg_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/mem_to_reg_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/next_imemaddr_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/next_imemaddr_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/opcode_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/rdat1_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/rdat1_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/reg_dest_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/reg_dest_ID_EX
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/result
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/result_EX_MEM
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/zero
add wave -noupdate -group {DataPath0 EX/MEM Register} /system_tb/DUT/CPU/DP0/ex_mem_regif/zero_EX_MEM
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/wsel
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/wdat
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/port_b
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/next_pc
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/next_imemaddr
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/nRST
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/jmp_return_addr
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/jmp_addr_shifted
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/jmp_addr
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/imm16_ext
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/fu_reg_dest_MEM_WB
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/fu_reg_dest_EX_MEM
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/dmemload_reg
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/data_store
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/d_s
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/branch_addr
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/br_imm
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/alu_mux_b
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/alu_mux_a
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/PC_INIT
add wave -noupdate -group DataPath1 /system_tb/DUT/CPU/DP1/CLK
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemaddr
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/ihit
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/halt
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/flushed
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemaddr
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemWEN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dhit
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iREN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dREN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dWEN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iload
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dload
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dstore
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iaddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/daddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccinv
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccwrite
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/cctrans
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccsnoopaddr
add wave -noupdate -expand -group {Dcache1 Internal} /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate -expand -group {Dcache1 Internal} /system_tb/DUT/CPU/CM1/DCACHE/last_used
add wave -noupdate -expand -group {Dcache1 Internal} /system_tb/DUT/CPU/CM1/DCACHE/next_state
add wave -noupdate -expand -group {Dcache1 Internal} -expand -subitemconfig {{/system_tb/DUT/CPU/CM1/DCACHE/cbl[1]} -expand} /system_tb/DUT/CPU/CM1/DCACHE/cbl
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/Rd_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/Rd_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/Rs_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/Rs_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/Rt_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/Rt_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/WEN_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/WEN_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/alu_op_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/branch_addr
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/branch_addr_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/dREN_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/dWEN_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/data_store
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/dhit
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/dmemREN
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/dmemWEN
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/dmemaddr_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/dmemstore_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/enable_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/flush_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/func_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/func_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/halt_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/halt_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/iREN_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/imemREN
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/imemaddr_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/imemaddr_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/imm16_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/imm16_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/imm16_ext_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/imm16_ext_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/instruction_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/instruction_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/mem_to_reg_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/mem_to_reg_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/next_imemaddr_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/next_imemaddr_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/opcode_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/opcode_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/rdat1_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/rdat1_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/reg_dest_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/reg_dest_ID_EX
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/result
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/result_EX_MEM
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/zero
add wave -noupdate -group {DataPath1 EX/MEM Register} /system_tb/DUT/CPU/DP1/ex_mem_regif/zero_EX_MEM
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/CPUS
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/ccinv
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/ccsnoopaddr
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/cctrans
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/ccwait
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/ccwrite
add wave -noupdate -group {Memory Controller} -expand /system_tb/DUT/CPU/CC/ccif/dREN
add wave -noupdate -group {Memory Controller} -expand /system_tb/DUT/CPU/CC/ccif/dWEN
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/daddr
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/dload
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/dstore
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/dwait
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/iREN
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/iaddr
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/iload
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/iwait
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/ramREN
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/ramWEN
add wave -noupdate -group {Memory Controller} -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/CC/ccif/ramaddr[31]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[30]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[29]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[28]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[27]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[26]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[25]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[24]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[23]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[22]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[21]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[20]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[19]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[18]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[17]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[16]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[15]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[14]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[13]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[12]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[11]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[10]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[9]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[8]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[7]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[6]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[5]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[4]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[3]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[2]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[1]} -radix hexadecimal} {{/system_tb/DUT/CPU/CC/ccif/ramaddr[0]} -radix hexadecimal}} -subitemconfig {{/system_tb/DUT/CPU/CC/ccif/ramaddr[31]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[30]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[29]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[28]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[27]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[26]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[25]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[24]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[23]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[22]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[21]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[20]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[19]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[18]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[17]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[16]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[15]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[14]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[13]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[12]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[11]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[10]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[9]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[8]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[7]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[6]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[5]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[4]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[3]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[2]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[1]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CC/ccif/ramaddr[0]} {-height 17 -radix hexadecimal}} /system_tb/DUT/CPU/CC/ccif/ramaddr
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/ramload
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/ramstate
add wave -noupdate -group {Memory Controller} /system_tb/DUT/CPU/CC/ccif/ramstore
add wave -noupdate -group {Ram Interface} /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -group {Ram Interface} /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -group {Ram Interface} /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -group {Ram Interface} /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate -group {Ram Interface} /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -group {Ram Interface} /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -group {Ram Interface} /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -group {Ram Interface} -radix hexadecimal /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -group {Ram Interface} /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -group {Ram Interface} /system_tb/DUT/RAM/ramif/ramstore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {2406233 ps} 1} {{Cursor 2} {4400000 ps} 1} {{Cursor 3} {2318358 ps} 0}
quietly wave cursor active 3
configure wave -namecolwidth 274
configure wave -valuecolwidth 147
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1140636 ps} {3765636 ps}
