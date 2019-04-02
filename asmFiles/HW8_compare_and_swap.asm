# Start at memory location 0x0
org 0x0

# Pass 0 into function argument register 0
ori $a0, $0, 0
# Pass 1 into function argument register 1
ori $a1, $0, 1
# Jump and link to compare and swap routine
jal compare_and_swap 
halt

compare_and_swap:
	# Load the lock memory address into temporary register 5
	ori $t5, $0, 0x100
	# Do a load and link of lock value into temporary register 0
	ll $t0, 0($t5)

	# If the lock value is not equal to function argument 0 (still locked) -> then just return 
	bne $a0, $t0, return
		# Set the lock to the value of function argument 1
		sc $a1, 0($t5)
		# Retry if atomicity failure
		beq $a1, $0, compare_and_swap

	return:
		# The previous lock value will be in return register 0
		or $v0, $0, $t0
		jr $ra

org 0x100
lock_val:
	cfw 0


