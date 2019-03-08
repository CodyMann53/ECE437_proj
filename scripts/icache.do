onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /icache_tb/CLK
add wave -noupdate /icache_tb/nRST
add wave -noupdate -expand -group {Datapath Cache} /icache_tb/DUT/dcif/halt
add wave -noupdate -expand -group {Datapath Cache} /icache_tb/DUT/dcif/ihit
add wave -noupdate -expand -group {Datapath Cache} /icache_tb/DUT/dcif/imemREN
add wave -noupdate -expand -group {Datapath Cache} /icache_tb/DUT/dcif/imemload
add wave -noupdate -expand -group {Datapath Cache} /icache_tb/DUT/dcif/imemaddr
add wave -noupdate -expand -group {Datapath Cache} /icache_tb/DUT/state_reg
add wave -noupdate -expand -group Caches /icache_tb/DUT/cif/iwait
add wave -noupdate -expand -group Caches /icache_tb/DUT/cif/iREN
add wave -noupdate -expand -group Caches /icache_tb/DUT/cif/iload
add wave -noupdate -expand -group Caches /icache_tb/DUT/cif/iaddr
add wave -noupdate -expand -group ICache -radix hexadecimal /icache_tb/DUT/cache_mem_reg
add wave -noupdate -expand -group ICache -radix hexadecimal /icache_tb/DUT/frame
add wave -noupdate -expand -group ICache -radix hexadecimal /icache_tb/DUT/wen
add wave -noupdate -expand -group ICache -radix hexadecimal /icache_tb/DUT/hit
add wave -noupdate -expand -group {Cache Controller} /icache_tb/ccif/iwait
add wave -noupdate -expand -group {Cache Controller} /icache_tb/ccif/iREN
add wave -noupdate -expand -group {Cache Controller} /icache_tb/ccif/iload
add wave -noupdate -expand -group {Cache Controller} /icache_tb/ccif/iaddr
add wave -noupdate -expand -group {Cache Controller} /icache_tb/ccif/ramREN
add wave -noupdate -expand -group Ram /icache_tb/ramif/ramREN
add wave -noupdate -expand -group Ram /icache_tb/RAM/ramif/ramWEN
add wave -noupdate -expand -group Ram /icache_tb/ramif/ramaddr
add wave -noupdate -expand -group Ram /icache_tb/ramif/ramload
add wave -noupdate -expand -group Ram /icache_tb/ramif/ramstate
add wave -noupdate -expand -group {memory controller} /icache_tb/cif0/iwait
add wave -noupdate -expand -group {memory controller} /icache_tb/cif0/iREN
add wave -noupdate -expand -group {memory controller} /icache_tb/cif0/iload
add wave -noupdate -expand -group {memory controller} /icache_tb/cif0/dload
add wave -noupdate -expand -group {memory controller} /icache_tb/cif0/iaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {54511 ps} 0}
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
WaveRestoreZoom {50409 ps} {151229 ps}
