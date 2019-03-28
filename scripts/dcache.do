onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Test Info.} /dcache_tb/PROG/test_case_num
add wave -noupdate -expand -group {Test Info.} /dcache_tb/PROG/test_description
add wave -noupdate -expand -group {System Signals } /dcache_tb/CLK
add wave -noupdate -expand -group {System Signals } /dcache_tb/nRST
add wave -noupdate -expand -group {Data Path Side} -expand -group {Data Path Side} -radix hexadecimal /dcache_tb/DUT/dcif/halt
add wave -noupdate -expand -group {Data Path Side} -expand -group {Data Path Side} -radix hexadecimal /dcache_tb/DUT/dcif/dmemWEN
add wave -noupdate -expand -group {Data Path Side} -expand -group {Data Path Side} -radix hexadecimal /dcache_tb/DUT/dcif/dmemREN
add wave -noupdate -expand -group {Data Path Side} -expand -group {Data Path Side} -radix unsigned /dcache_tb/DUT/dcif/dmemaddr
add wave -noupdate -expand -group {Data Path Side} -expand -group {Data Path Side} -radix hexadecimal /dcache_tb/DUT/dcif/dmemstore
add wave -noupdate -expand -group {Data Path Side} -expand -group Outputs /dcache_tb/DUT/dcif/dhit
add wave -noupdate -expand -group {Data Path Side} -expand -group Outputs /dcache_tb/DUT/dcif/dmemload
add wave -noupdate -expand -group {Data Path Side} -expand -group Outputs /dcache_tb/DUT/dcif/flushed
add wave -noupdate -group {Memory Controller Side} -expand -group {Memory Controller Side} /dcache_tb/DUT/cif/dload
add wave -noupdate -group {Memory Controller Side} -expand -group {Memory Controller Side} /dcache_tb/DUT/cif/dwait
add wave -noupdate -group {Memory Controller Side} -expand -group Outputs /dcache_tb/DUT/cif/dWEN
add wave -noupdate -group {Memory Controller Side} -expand -group Outputs /dcache_tb/DUT/cif/dREN
add wave -noupdate -group {Memory Controller Side} -expand -group Outputs /dcache_tb/DUT/cif/daddr
add wave -noupdate -group {Memory Controller Side} -expand -group Outputs /dcache_tb/DUT/cif/dstore
add wave -noupdate -group {Internal dcache} /dcache_tb/DUT/tag
add wave -noupdate -group {Internal dcache} /dcache_tb/DUT/state
add wave -noupdate -group {Internal dcache} /dcache_tb/DUT/next_left_dirty
add wave -noupdate -group {Internal dcache} /dcache_tb/DUT/next_right_dirty
add wave -noupdate -group {Internal dcache} /dcache_tb/DUT/last_used
add wave -noupdate -group {Internal dcache} -radix unsigned -childformat {{{/dcache_tb/DUT/cbl[7]} -radix hexadecimal -childformat {{{/dcache_tb/DUT/cbl[7].left_tag} -radix unsigned} {{/dcache_tb/DUT/cbl[7].right_tag} -radix unsigned} {{/dcache_tb/DUT/cbl[7].left_dat0} -radix unsigned} {{/dcache_tb/DUT/cbl[7].right_dat0} -radix unsigned} {{/dcache_tb/DUT/cbl[7].left_dat1} -radix unsigned} {{/dcache_tb/DUT/cbl[7].right_dat1} -radix unsigned} {{/dcache_tb/DUT/cbl[7].left_dirty} -radix unsigned} {{/dcache_tb/DUT/cbl[7].right_dirty} -radix unsigned} {{/dcache_tb/DUT/cbl[7].left_valid} -radix unsigned} {{/dcache_tb/DUT/cbl[7].right_valid} -radix unsigned}}} {{/dcache_tb/DUT/cbl[6]} -radix hexadecimal} {{/dcache_tb/DUT/cbl[5]} -radix hexadecimal} {{/dcache_tb/DUT/cbl[4]} -radix hexadecimal -childformat {{{/dcache_tb/DUT/cbl[4].left_tag} -radix unsigned} {{/dcache_tb/DUT/cbl[4].right_tag} -radix unsigned} {{/dcache_tb/DUT/cbl[4].left_dat0} -radix unsigned} {{/dcache_tb/DUT/cbl[4].right_dat0} -radix unsigned} {{/dcache_tb/DUT/cbl[4].left_dat1} -radix unsigned} {{/dcache_tb/DUT/cbl[4].right_dat1} -radix unsigned} {{/dcache_tb/DUT/cbl[4].left_dirty} -radix unsigned} {{/dcache_tb/DUT/cbl[4].right_dirty} -radix unsigned} {{/dcache_tb/DUT/cbl[4].left_valid} -radix unsigned} {{/dcache_tb/DUT/cbl[4].right_valid} -radix unsigned}}} {{/dcache_tb/DUT/cbl[3]} -radix hexadecimal} {{/dcache_tb/DUT/cbl[2]} -radix hexadecimal} {{/dcache_tb/DUT/cbl[1]} -radix hexadecimal} {{/dcache_tb/DUT/cbl[0]} -radix hexadecimal}} -expand -subitemconfig {{/dcache_tb/DUT/cbl[7]} {-height 17 -radix hexadecimal -childformat {{{/dcache_tb/DUT/cbl[7].left_tag} -radix unsigned} {{/dcache_tb/DUT/cbl[7].right_tag} -radix unsigned} {{/dcache_tb/DUT/cbl[7].left_dat0} -radix unsigned} {{/dcache_tb/DUT/cbl[7].right_dat0} -radix unsigned} {{/dcache_tb/DUT/cbl[7].left_dat1} -radix unsigned} {{/dcache_tb/DUT/cbl[7].right_dat1} -radix unsigned} {{/dcache_tb/DUT/cbl[7].left_dirty} -radix unsigned} {{/dcache_tb/DUT/cbl[7].right_dirty} -radix unsigned} {{/dcache_tb/DUT/cbl[7].left_valid} -radix unsigned} {{/dcache_tb/DUT/cbl[7].right_valid} -radix unsigned}}} {/dcache_tb/DUT/cbl[7].left_tag} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[7].right_tag} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[7].left_dat0} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[7].right_dat0} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[7].left_dat1} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[7].right_dat1} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[7].left_dirty} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[7].right_dirty} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[7].left_valid} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[7].right_valid} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[6]} {-height 17 -radix hexadecimal} {/dcache_tb/DUT/cbl[5]} {-height 17 -radix hexadecimal} {/dcache_tb/DUT/cbl[4]} {-height 17 -radix hexadecimal -childformat {{{/dcache_tb/DUT/cbl[4].left_tag} -radix unsigned} {{/dcache_tb/DUT/cbl[4].right_tag} -radix unsigned} {{/dcache_tb/DUT/cbl[4].left_dat0} -radix unsigned} {{/dcache_tb/DUT/cbl[4].right_dat0} -radix unsigned} {{/dcache_tb/DUT/cbl[4].left_dat1} -radix unsigned} {{/dcache_tb/DUT/cbl[4].right_dat1} -radix unsigned} {{/dcache_tb/DUT/cbl[4].left_dirty} -radix unsigned} {{/dcache_tb/DUT/cbl[4].right_dirty} -radix unsigned} {{/dcache_tb/DUT/cbl[4].left_valid} -radix unsigned} {{/dcache_tb/DUT/cbl[4].right_valid} -radix unsigned}}} {/dcache_tb/DUT/cbl[4].left_tag} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[4].right_tag} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[4].left_dat0} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[4].right_dat0} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[4].left_dat1} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[4].right_dat1} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[4].left_dirty} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[4].right_dirty} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[4].left_valid} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[4].right_valid} {-height 17 -radix unsigned} {/dcache_tb/DUT/cbl[3]} {-height 17 -radix hexadecimal} {/dcache_tb/DUT/cbl[2]} {-height 17 -radix hexadecimal} {/dcache_tb/DUT/cbl[1]} {-height 17 -radix hexadecimal} {/dcache_tb/DUT/cbl[0]} {-height 17 -radix hexadecimal}} /dcache_tb/DUT/cbl
add wave -noupdate -expand -group {ram } /dcache_tb/ramif/ramREN
add wave -noupdate -expand -group {ram } /dcache_tb/ramif/ramWEN
add wave -noupdate -expand -group {ram } /dcache_tb/ramif/ramaddr
add wave -noupdate -expand -group {ram } /dcache_tb/ramif/ramstore
add wave -noupdate -expand -group {ram } /dcache_tb/ramif/ramload
add wave -noupdate -expand -group {ram } /dcache_tb/ramif/ramstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {241630 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 266
configure wave -valuecolwidth 221
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
WaveRestoreZoom {0 ps} {672344 ps}
