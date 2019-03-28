onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Test Info} -radix unsigned /memory_control_tb/PROG/test_case_num
add wave -noupdate -expand -group {Test Info} -radix unsigned /memory_control_tb/PROG/test_description
add wave -noupdate -expand -group {System Signals} -radix unsigned /memory_control_tb/CLK
add wave -noupdate -expand -group {DataPath Inputs} -radix unsigned /memory_control_tb/ccif/iREN
add wave -noupdate -expand -group {DataPath Inputs} -radix unsigned -childformat {{{/memory_control_tb/ccif/dREN[1]} -radix unsigned} {{/memory_control_tb/ccif/dREN[0]} -radix unsigned}} -expand -subitemconfig {{/memory_control_tb/ccif/dREN[1]} {-height 17 -radix unsigned} {/memory_control_tb/ccif/dREN[0]} {-height 17 -radix unsigned}} /memory_control_tb/ccif/dREN
add wave -noupdate -expand -group {DataPath Inputs} -radix unsigned -childformat {{{/memory_control_tb/ccif/dWEN[1]} -radix unsigned} {{/memory_control_tb/ccif/dWEN[0]} -radix unsigned}} -subitemconfig {{/memory_control_tb/ccif/dWEN[1]} {-height 17 -radix unsigned} {/memory_control_tb/ccif/dWEN[0]} {-height 17 -radix unsigned}} /memory_control_tb/ccif/dWEN
add wave -noupdate -expand -group {DataPath Inputs} -radix hexadecimal /memory_control_tb/ccif/dstore
add wave -noupdate -expand -group {DataPath Inputs} -radix hexadecimal /memory_control_tb/ccif/iaddr
add wave -noupdate -expand -group {DataPath Inputs} -radix hexadecimal -childformat {{{/memory_control_tb/ccif/daddr[1]} -radix hexadecimal} {{/memory_control_tb/ccif/daddr[0]} -radix hexadecimal}} -expand -subitemconfig {{/memory_control_tb/ccif/daddr[1]} {-height 17 -radix hexadecimal} {/memory_control_tb/ccif/daddr[0]} {-height 17 -radix hexadecimal}} /memory_control_tb/ccif/daddr
add wave -noupdate -expand -group {DataPath Inputs} -radix unsigned /memory_control_tb/nRST
add wave -noupdate -group {Ram Inputs} -radix unsigned /memory_control_tb/ccif/ramstate
add wave -noupdate -group {Ram Inputs} -radix hexadecimal /memory_control_tb/ccif/ramload
add wave -noupdate -expand -group {Datapath Outputs} -radix unsigned /memory_control_tb/ccif/iwait
add wave -noupdate -expand -group {Datapath Outputs} -radix unsigned /memory_control_tb/ccif/dwait
add wave -noupdate -expand -group {Datapath Outputs} -color Red -radix hexadecimal -childformat {{{/memory_control_tb/ccif/iload[1]} -radix hexadecimal} {{/memory_control_tb/ccif/iload[0]} -radix unsigned}} -subitemconfig {{/memory_control_tb/ccif/iload[1]} {-color Red -height 17 -radix hexadecimal} {/memory_control_tb/ccif/iload[0]} {-color Red -height 17 -radix unsigned}} /memory_control_tb/ccif/iload
add wave -noupdate -expand -group {Datapath Outputs} -color Red -radix hexadecimal /memory_control_tb/ccif/dload
add wave -noupdate -group {Ram Outputs} -radix unsigned /memory_control_tb/ccif/ramWEN
add wave -noupdate -group {Ram Outputs} -radix unsigned /memory_control_tb/ccif/ramREN
add wave -noupdate -group {Ram Outputs} -color Magenta -radix hexadecimal /memory_control_tb/ccif/ramaddr
add wave -noupdate -group {Ram Outputs} -radix hexadecimal /memory_control_tb/ccif/ramstore
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramREN
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramWEN
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramaddr
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramstore
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramload
add wave -noupdate -group ramif /memory_control_tb/RAM/ramif/ramstate
add wave -noupdate -expand -group {Memory Controller} /memory_control_tb/DUT/state
add wave -noupdate -expand -group {Memory Controller} /memory_control_tb/DUT/next_state
add wave -noupdate -expand -group {Memory Controller} /memory_control_tb/DUT/next_bus_access
add wave -noupdate -expand -group {Memory Controller} /memory_control_tb/DUT/nRST
add wave -noupdate -expand -group {Memory Controller} /memory_control_tb/DUT/bus_access
add wave -noupdate -expand -group {Coherence Signals } -expand -group {Coherence Signals } /memory_control_tb/ccif/ccwrite
add wave -noupdate -expand -group {Coherence Signals } -expand -group {Coherence Signals } /memory_control_tb/ccif/cctrans
add wave -noupdate -expand -group {Coherence Signals } -expand -group Outputs /memory_control_tb/ccif/ccwait
add wave -noupdate -expand -group {Coherence Signals } -expand -group Outputs -radix hexadecimal -childformat {{{/memory_control_tb/ccif/ccsnoopaddr[1]} -radix hexadecimal} {{/memory_control_tb/ccif/ccsnoopaddr[0]} -radix hexadecimal}} -expand -subitemconfig {{/memory_control_tb/ccif/ccsnoopaddr[1]} {-radix hexadecimal} {/memory_control_tb/ccif/ccsnoopaddr[0]} {-radix hexadecimal}} /memory_control_tb/ccif/ccsnoopaddr
add wave -noupdate -expand -group {Coherence Signals } -expand -group Outputs /memory_control_tb/ccif/ccinv
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {45000 ps} 1}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 346
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
WaveRestoreZoom {0 ps} {623976 ps}
