onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {test Info } -radix decimal /request_unit_tb/PROG/test_case_num
add wave -noupdate -expand -group {test Info } /request_unit_tb/PROG/test_description
add wave -noupdate -expand -group {system signals} /request_unit_tb/CLK
add wave -noupdate -expand -group {system signals} /request_unit_tb/nRST
add wave -noupdate -expand -group {request unit inputs} /request_unit_tb/ruif/iREN
add wave -noupdate -expand -group {request unit inputs} /request_unit_tb/ruif/dREN
add wave -noupdate -expand -group {request unit inputs} /request_unit_tb/ruif/dWEN
add wave -noupdate -expand -group {request unit inputs} /request_unit_tb/ruif/halt
add wave -noupdate -expand -group {request unit inputs} /request_unit_tb/ruif/ihit
add wave -noupdate -expand -group {request unit inputs} /request_unit_tb/ruif/dhit
add wave -noupdate -expand -group {rquest unit outputs} /request_unit_tb/ruif/imemREN
add wave -noupdate -expand -group {rquest unit outputs} /request_unit_tb/ruif/dmemWEN
add wave -noupdate -expand -group {rquest unit outputs} /request_unit_tb/ruif/dmemREN
add wave -noupdate -expand -group {rquest unit outputs} /request_unit_tb/ruif/pc_wait
add wave -noupdate -expand -group {rquest unit outputs} /request_unit_tb/ruif/halt_out
add wave -noupdate -expand -group ru_mem /request_unit_tb/DUT/halt_reg
add wave -noupdate -expand -group ru_mem /request_unit_tb/DUT/iREN_reg
add wave -noupdate -expand -group ru_mem /request_unit_tb/DUT/dWEN_reg
add wave -noupdate -expand -group ru_mem /request_unit_tb/DUT/dREN_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {397 ns} 0}
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
WaveRestoreZoom {278 ns} {552 ns}
