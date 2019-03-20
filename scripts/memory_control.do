onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Test Info} -radix unsigned /memory_control_tb/PROG/test_case_num
add wave -noupdate -expand -group {Test Info} -radix unsigned /memory_control_tb/PROG/test_description
add wave -noupdate -expand -group {System Signals} -radix unsigned /memory_control_tb/CLK
add wave -noupdate -expand -group {System Signals} -radix unsigned /memory_control_tb/nRST
add wave -noupdate -expand -group {DataPath Inputs} -radix unsigned /memory_control_tb/ccif/iREN
add wave -noupdate -expand -group {DataPath Inputs} -radix unsigned /memory_control_tb/ccif/dREN
add wave -noupdate -expand -group {DataPath Inputs} -radix unsigned /memory_control_tb/ccif/dWEN
add wave -noupdate -expand -group {DataPath Inputs} -radix hexadecimal /memory_control_tb/ccif/dstore
add wave -noupdate -expand -group {DataPath Inputs} -radix hexadecimal /memory_control_tb/ccif/iaddr
add wave -noupdate -expand -group {DataPath Inputs} -radix hexadecimal /memory_control_tb/ccif/daddr
add wave -noupdate -expand -group {Ram Inputs} -radix unsigned /memory_control_tb/ccif/ramstate
add wave -noupdate -expand -group {Ram Inputs} -radix hexadecimal /memory_control_tb/ccif/ramload
add wave -noupdate -expand -group {Datapath Outputs} -radix unsigned /memory_control_tb/ccif/iwait
add wave -noupdate -expand -group {Datapath Outputs} -radix unsigned /memory_control_tb/ccif/dwait
add wave -noupdate -expand -group {Datapath Outputs} -color Red -radix hexadecimal -childformat {{{/memory_control_tb/ccif/iload[0]} -radix unsigned}} -subitemconfig {{/memory_control_tb/ccif/iload[0]} {-color Red -height 17 -radix unsigned}} /memory_control_tb/ccif/iload
add wave -noupdate -expand -group {Datapath Outputs} -color Red -radix hexadecimal /memory_control_tb/ccif/dload
add wave -noupdate -expand -group {Ram Outputs} -radix unsigned /memory_control_tb/ccif/ramWEN
add wave -noupdate -expand -group {Ram Outputs} -radix unsigned /memory_control_tb/ccif/ramREN
add wave -noupdate -expand -group {Ram Outputs} -color Magenta -radix hexadecimal /memory_control_tb/ccif/ramaddr
add wave -noupdate -expand -group {Ram Outputs} -radix hexadecimal /memory_control_tb/ccif/ramstore
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramREN
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramWEN
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramaddr
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramstore
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramload
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramstate
add wave -noupdate /memory_control_tb/RAM/altsyncram_component/wren_a
add wave -noupdate /memory_control_tb/RAM/altsyncram_component/data_a
add wave -noupdate /memory_control_tb/RAM/altsyncram_component/q_a
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1647361 ps} 0}
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
WaveRestoreZoom {1518092 ps} {1682156 ps}
