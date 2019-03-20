onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Test Info} -radix decimal /control_unit_tb/PROG/test_case_num
add wave -noupdate -expand -group {Test Info} /control_unit_tb/PROG/test_description
add wave -noupdate /control_unit_tb/cuif/RegWr
add wave -noupdate -expand -group Inputs /control_unit_tb/cuif/instruction
add wave -noupdate -expand -group Inputs /control_unit_tb/cuif/equal
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/extend
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/iREN
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/dWEN
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/dREN
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/halt
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/mem_to_reg
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/reg_dest
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/ALUSrc
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/alu_op
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/Rd
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/Rt
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/Rs
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/load_addr
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/PCSrc
add wave -noupdate -expand -group Outputs /control_unit_tb/cuif/imm16
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
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
WaveRestoreZoom {0 ns} {2 ns}
