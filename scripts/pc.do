onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Test Case Info } /pc_tb/PROG/test_case_num
add wave -noupdate -expand -group {Test Case Info } /pc_tb/PROG/test_description
add wave -noupdate -expand -group {System Signals} /pc_tb/CLK
add wave -noupdate -expand -group {System Signals} /pc_tb/nRST
add wave -noupdate /pc_tb/pcif/halt
add wave -noupdate -expand -group {Program Counter Inputs} /pc_tb/pcif/pc_wait
add wave -noupdate -expand -group {Program Counter Inputs} -radix hexadecimal /pc_tb/pcif/jr_addr
add wave -noupdate -expand -group {Program Counter Inputs} -radix hexadecimal /pc_tb/pcif/load_addr
add wave -noupdate -expand -group {Program Counter Inputs} /pc_tb/pcif/PCSrc
add wave -noupdate -expand -group {Program Counter Inputs} -radix hexadecimal /pc_tb/pcif/load_imm
add wave -noupdate -expand -group {Program Counter Outputs } -radix hexadecimal /pc_tb/pcif/imemaddr
add wave -noupdate -expand -group {Expected Values} -radix hexadecimal /pc_tb/PROG/expected_program_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {141 ns} 0}
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
WaveRestoreZoom {69 ns} {221 ns}
