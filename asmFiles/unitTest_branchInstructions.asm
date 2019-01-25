#Single cycle unit test for branch instructions (BEQ, BNE)

#tell where to store this in memory 
org 0x0000

main:

	#load 2 into register $8 and $9
	ori $8, $0, 2
	ori $9, $0, 2

	#if equal then jump to branch equal 
	beq $8, $9, branch_eq

	#jump to return (shouldn't make it here)
	j return

branch_neq:

	#place 4 into register 8 to know that program ran correctly 
	ori $8, $0, 8
	
	#jump to return (This is where it should jump to end program)
	j return 

return: 
	
	#program done 
	halt

branch_eq:

	#load different values into register $8 and $9
	ori $8, $0, 3
	ori $9, $0, 2

	#if equal then jump to branch equal 
	bne $8, $9, branch_neq

	#jump to return (shouldn't make it here)
	j return
