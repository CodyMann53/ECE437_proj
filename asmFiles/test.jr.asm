org 0x000
ori $s0, $0, var
jal subroutine
halt

subroutine:
push $ra
ori $ra, $0, trap
pop $ra
jr $ra

trap:
ori $t0, $0, 0xDEADBEEF
sw 	$t0, 0($s0)
halt

org 0x200
halt

org 0x1000
var: 
cfw 1
