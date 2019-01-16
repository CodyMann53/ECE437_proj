#tell where to store this in memory 
org 0x0000

main:
	#initialize the stack pointer 
	addi $31, $0, 0xFFFC

	#push 1 on to the stack 
	addi $4, $0, 1
	jal push_stack 

	#push 4 on to the stack 
	addi $4, $0, 5
	jal push_stack

	#multiply the top two elements of the stack
	jal multiply_proced

	#push 2 on to the stack 
	addi $4, $0, 5
	jal push_stack


	#pop result into register $2
	jal pop_stack

	halt

# takes the two top elements of the stack and places the product in stack location as first operand 
multiply_proced:
	
	#save return address into $17
	or $17, $0, $31

	#call multiply procedure because two operands should already be on stack 
	jal multiply

	#push return value on top of stack 
	or $4, $0, $2
	jal push_stack

	#move return address for multiply procedure back to the return addr reg
	or $31, $0, $17

	#return 
	jr $31

#multiply subroutine ($8 = op1, $9 = op2, $2 = result), $9 is what determines number of times to add.
multiply:	

	# before popping values, save return address for multiply in $0 
	add $16, $0, $31
	
	#pop both values off of stack into $2
	jal pop_stack 
	add $8, $0, $2

	#pop value off of stack into $2
	jal pop_stack 
	add $9, $0, $2

	#move saved return address for multiply back into the return address register
	add $31, $0, $16

	#initialize $2 = 0
	add $2, $0, $0

	#if $9 == 0 -> Exit 
	beq $9, $0, Exit

	#if $8 == 0 -> Exit 
	beq $8, $0, Exit 

	Loop:

		# $2 = $2 + $8
		add $2, $2, $8

		# $9 = $9 + (-1)
		addi $9, $9, -1

		#if not equal to 0 then jump to loop 
		bne $9, $0, Loop   

	Exit: 

	#return from the subroutine 
	jr $31

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

	

