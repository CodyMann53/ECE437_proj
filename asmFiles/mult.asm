#tell where to store this in memory 
org 0x0000

main:
	#initialize the stack pointer 
	addi $31, $0, 0xFFFC

	#push value on to the stack 
	addi $4, $0, 50
	jal push_stack

	halt

#multiply subroutine 
multiply: 

#push subroutine 
push_stack: 

	#decrement the stack pointer down by 4 
	addi $29, $29, -4

	#move passed in value to top of stack 
	sw $4, 0($29)

	#return from the subroutine 
	jr $31

#pop subroutine 
pop_stack: 

	#store the value at the top of the stack into return register 
	lw $2, 0($29)

	#increment the stack pointer up 
	addi $29, $29, 4

	#return from subroutine
	jr $31
	

