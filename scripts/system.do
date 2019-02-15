onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {System Signals } -radix hexadecimal /system_tb/CLK
add wave -noupdate -expand -group {System Signals } -radix hexadecimal /system_tb/nRST
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/WEN
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/extend
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/iREN
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/dWEN
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/dREN
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/reg_dest
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/alu_op
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/ALUSrc
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/PCSrc
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/opcode_IF_ID
add wave -noupdate -expand -group {Control Unit } -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/DP/cuif/func_IF_ID[5]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/cuif/func_IF_ID[4]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/cuif/func_IF_ID[3]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/cuif/func_IF_ID[2]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/cuif/func_IF_ID[1]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/cuif/func_IF_ID[0]} -radix hexadecimal}} -subitemconfig {{/system_tb/DUT/CPU/DP/cuif/func_IF_ID[5]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/cuif/func_IF_ID[4]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/cuif/func_IF_ID[3]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/cuif/func_IF_ID[2]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/cuif/func_IF_ID[1]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/cuif/func_IF_ID[0]} {-height 17 -radix hexadecimal}} /system_tb/DUT/CPU/DP/cuif/func_IF_ID
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/port_a
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/port_b
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/result
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/alu_op
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/negative
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/overflow
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/zero
add wave -noupdate -expand -group {Data Path Ports} -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -expand -group {Data Path Ports} -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -expand -group {Data Path Ports} -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -expand -group {Data Path Ports} -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -expand -group {Data Path Ports} -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -expand -group {Data Path Ports} -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -expand -group {Data Path Ports} -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -expand -group {Data Path Ports} -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -expand -group {Data Path Ports} -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -expand -group {Data Path Ports} -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -expand -group {Data Path Ports} -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -expand -group {Register File } /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -expand -group {Register File } /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -expand -group {Register File } /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -expand -group {Register File } /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -expand -group {Register File } /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -expand -group {Register File } /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -expand -group {Register File } /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -expand -group {Program Counter} /system_tb/DUT/CPU/DP/pcif/ihit
add wave -noupdate -expand -group {Program Counter} /system_tb/DUT/CPU/DP/pcif/imemaddr
add wave -noupdate -expand -group {Program Counter} /system_tb/DUT/CPU/DP/pcif/jr_addr
add wave -noupdate -expand -group {Program Counter} /system_tb/DUT/CPU/DP/pcif/next_imemaddr
add wave -noupdate -expand -group {Program Counter} /system_tb/DUT/CPU/DP/pcif/jmp_addr
add wave -noupdate -expand -group {Program Counter} /system_tb/DUT/CPU/DP/pcif/br_addr
add wave -noupdate -expand -group {Program Counter} /system_tb/DUT/CPU/DP/pcif/PCSrc
add wave -noupdate -group {Pipeline Controller} /system_tb/DUT/CPU/DP/pipeline_controllerif/ihit
add wave -noupdate -group {Pipeline Controller} /system_tb/DUT/CPU/DP/pipeline_controllerif/dhit
add wave -noupdate -group {Pipeline Controller} /system_tb/DUT/CPU/DP/pipeline_controllerif/enable_IF_ID
add wave -noupdate -group {Pipeline Controller} /system_tb/DUT/CPU/DP/pipeline_controllerif/flush_IF_ID
add wave -noupdate -group {Pipeline Controller} /system_tb/DUT/CPU/DP/pipeline_controllerif/enable_ID_EX
add wave -noupdate -group {Pipeline Controller} /system_tb/DUT/CPU/DP/pipeline_controllerif/flush_ID_EX
add wave -noupdate -group {Pipeline Controller} /system_tb/DUT/CPU/DP/pipeline_controllerif/enable_EX_MEM
add wave -noupdate -group {Pipeline Controller} /system_tb/DUT/CPU/DP/pipeline_controllerif/flush_EX_MEM
add wave -noupdate -group {Pipeline Controller} /system_tb/DUT/CPU/DP/pipeline_controllerif/enable_MEM_WB
add wave -noupdate -group {Pipeline Controller} /system_tb/DUT/CPU/DP/pipeline_controllerif/flush_MEM_WB
add wave -noupdate -expand -group {Memory Controller } -radix hexadecimal /system_tb/DUT/CPU/CM/dcif/halt
add wave -noupdate -expand -group {Memory Controller } -radix hexadecimal /system_tb/DUT/CPU/CM/dcif/ihit
add wave -noupdate -expand -group {Memory Controller } -radix hexadecimal /system_tb/DUT/CPU/CM/dcif/imemREN
add wave -noupdate -expand -group {Memory Controller } -radix hexadecimal /system_tb/DUT/CPU/CM/dcif/imemload
add wave -noupdate -expand -group {Memory Controller } -radix hexadecimal /system_tb/DUT/CPU/CM/dcif/imemaddr
add wave -noupdate -expand -group {Memory Controller } -radix hexadecimal /system_tb/DUT/CPU/CM/dcif/dhit
add wave -noupdate -expand -group {Memory Controller } -radix hexadecimal /system_tb/DUT/CPU/CM/dcif/dmemREN
add wave -noupdate -expand -group {Memory Controller } -radix hexadecimal /system_tb/DUT/CPU/CM/dcif/dmemWEN
add wave -noupdate -expand -group {Memory Controller } -radix hexadecimal /system_tb/DUT/CPU/CM/dcif/dmemload
add wave -noupdate -expand -group {Memory Controller } -radix hexadecimal /system_tb/DUT/CPU/CM/dcif/dmemstore
add wave -noupdate -expand -group {Memory Controller } -radix hexadecimal /system_tb/DUT/CPU/CM/dcif/dmemaddr
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/instruction
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/imemaddr
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/imemaddr_IF_ID
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/Rs_IF_ID
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/Rt_IF_ID
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/Rd_IF_ID
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/opcode_IF_ID
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/func_IF_ID
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/imm16_IF_ID
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/enable_IF_ID
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/flush_IF_ID
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/instruction_IF_ID
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/next_imemaddr
add wave -noupdate -group IF_ID_Register /system_tb/DUT/CPU/DP/if_id_regif/next_imemaddr_IF_ID
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/iREN
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/iREN_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/dREN
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/dREN_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/dWEN
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/dWEN_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/halt
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/halt_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/WEN
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/WEN_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/enable_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/flush_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/PCSrc
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/PCSrc_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/alu_op
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/alu_op_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/reg_dest
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/reg_dest_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/ALUSrc
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/ALUSrc_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/Rt_IF_ID
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/Rd_IF_ID
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/rdat1
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/rdat2
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/imm16_ext
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/imm16_ext_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/rdat2_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/rdat1_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/Rs_IF_ID
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/Rt_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/Rd_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/Rs_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/imm16_IF_ID
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/opcode_IF_ID
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/opcode_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/func_IF_ID
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/func_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/instruction_IF_ID
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/instruction_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/imm16_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/imemaddr_IF_ID
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/imemaddr_ID_EX
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/next_imemaddr_IF_ID
add wave -noupdate -group ID_EX_Register /system_tb/DUT/CPU/DP/id_ex_regif/next_imemaddr_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/WEN_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/enable_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/flush_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/iREN_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/dREN_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/dWEN_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/halt_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/reg_dest_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/alu_op_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/Rt_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/Rd_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/result
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/rdat2
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/dmemaddr_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/dmemstore_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/result_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/WEN_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/imemREN
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/dmemREN
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/dmemWEN
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/halt_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/reg_dest_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/Rt_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/Rd_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/imemaddr_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/next_imemaddr_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/opcode_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/func_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/instruction_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/imm16_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/imm16_ext_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/rdat1_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/Rs_ID_EX
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/imemaddr_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/next_imemaddr_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/opcode_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/func_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/instruction_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/imm16_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/imm16_ext_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/rdat1_EX_MEM
add wave -noupdate -group EX_MEM_Register /system_tb/DUT/CPU/DP/ex_mem_regif/Rs_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/result_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/dmemload
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/WEN_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/enable_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/flush_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/halt_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/reg_dest_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/Rt_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/Rd_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/WEN_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/halt
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/reg_dest_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/mem_data_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/Rt_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/Rd_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/imemaddr_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/next_imemaddr_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/opcode_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/func_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/instruction_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/imm16_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/imm16_ext_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/dmemstore_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/rdat1_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/Rs_EX_MEM
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/imemaddr_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/next_imemaddr_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/opcode_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/func_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/instruction_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/imm16_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/imm16_ext_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/dmemstore_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/rdat1_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/result_MEM_WB
add wave -noupdate -group MEM_WB_Register /system_tb/DUT/CPU/DP/mem_wb_regif/Rs_MEM_WB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20308 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {343736 ps}
