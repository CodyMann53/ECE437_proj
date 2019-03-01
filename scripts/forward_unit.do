onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Test Info} -radix unsigned /forward_unit_tb/PROG/test_case_num
add wave -noupdate -expand -group {Test Info} /forward_unit_tb/PROG/test_description
add wave -noupdate -expand -group Inputs -radix unsigned /forward_unit_tb/fuif/reg_wr_mem
add wave -noupdate -expand -group Inputs -radix unsigned /forward_unit_tb/fuif/reg_wr_wb
add wave -noupdate -expand -group Inputs -radix unsigned /forward_unit_tb/fuif/rs
add wave -noupdate -expand -group Inputs -radix unsigned /forward_unit_tb/fuif/rt
add wave -noupdate -expand -group Inputs -radix unsigned /forward_unit_tb/fuif/reg_dest_ID_EX
<<<<<<< HEAD
add wave -noupdate -expand -group Inputs /forward_unit_tb/fuif/opcode_ID_EX
add wave -noupdate -expand -group Outputs -radix unsigned /forward_unit_tb/fuif/porta_sel
add wave -noupdate -expand -group Outputs -radix unsigned /forward_unit_tb/fuif/portb_sel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28 ns} 0}
=======
add wave -noupdate -expand -group Inputs /forward_unit_tb/DUT/fuif/opcode_ID_EX
add wave -noupdate -expand -group Outputs -radix unsigned /forward_unit_tb/fuif/porta_sel
add wave -noupdate -expand -group Outputs -radix unsigned /forward_unit_tb/fuif/portb_sel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24 ns} 0}
>>>>>>> 3154118084e482d81edba231b4c94a2fb3db2b64
quietly wave cursor active 1
configure wave -namecolwidth 274
configure wave -valuecolwidth 192
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
<<<<<<< HEAD
WaveRestoreZoom {0 ns} {116 ns}
=======
WaveRestoreZoom {0 ns} {131 ns}
>>>>>>> 3154118084e482d81edba231b4c94a2fb3db2b64
