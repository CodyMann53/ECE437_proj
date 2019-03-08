onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Test Info} -radix decimal /register_file_tb/PROG/test_case_num
add wave -noupdate -expand -group {Test Info} /register_file_tb/PROG/test_description
add wave -noupdate -expand -group Inputs -radix unsigned /register_file_tb/PROG/CLK
add wave -noupdate -expand -group Inputs -radix unsigned /register_file_tb/nRST
add wave -noupdate -expand -group Inputs -radix unsigned /register_file_tb/PROG/WEN
add wave -noupdate -expand -group Inputs -radix unsigned /register_file_tb/PROG/wsel
add wave -noupdate -expand -group Inputs -radix unsigned /register_file_tb/PROG/rsel1
add wave -noupdate -expand -group Inputs -radix unsigned /register_file_tb/PROG/rsel2
add wave -noupdate -expand -group Inputs -radix unsigned /register_file_tb/PROG/wdat
add wave -noupdate -expand -group Outputs -radix unsigned /register_file_tb/PROG/rdat1
add wave -noupdate -expand -group Outputs -radix unsigned /register_file_tb/PROG/rdat2
add wave -noupdate -expand -group DUT_Internal -radix unsigned /register_file_tb/DUT/registers
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {321 ns} 0}
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
WaveRestoreZoom {0 ns} {1377 ns}
