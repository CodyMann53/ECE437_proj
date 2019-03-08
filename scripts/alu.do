onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Test Info } -radix decimal /alu_tb/PROG/test_num
add wave -noupdate -expand -group {Test Info } /alu_tb/PROG/test_description
add wave -noupdate -expand -group Inputs /alu_tb/PROG/alu_op
add wave -noupdate -expand -group Inputs -radix decimal /alu_tb/PROG/port_a
add wave -noupdate -expand -group Inputs -radix decimal /alu_tb/PROG/port_b
add wave -noupdate -expand -group Outputs -radix decimal /alu_tb/PROG/negative
add wave -noupdate -expand -group Outputs -radix decimal /alu_tb/PROG/overflow
add wave -noupdate -expand -group Outputs -radix decimal /alu_tb/PROG/zero
add wave -noupdate -expand -group Outputs -radix decimal /alu_tb/PROG/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ns} {859 ns}
