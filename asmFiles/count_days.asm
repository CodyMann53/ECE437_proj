#tell where to store this in memory 
org 0x0000

main:
	#initialize the stack pointer 
	addi $31, $0, 0xFFFC

	#$8 = current day
	ori $8, $0, CurrentDay

	#$9 = Current month 
	ori $9, $0, CurrentMonth

	#$9 = Current Month - 1 
	addi $9, $9, -1

	#push 30 on to the stack 
	addi $4, $0, 30
	jal push_stack 

	#push (Current Month -1) on to the stack)
	add $4, $0, $9

	#Top of stack (CurrentMont -1 ) * 30 
	jal multiply_proced

	#pop result off of stack to $9 = (CurrentMont -1 ) * 30
	jal pop_stack 
	or $9, $0, $2

	#push 365 on to the stack 
	addi $4, $0, 365
	jal push_stack 

	#move current year to $10 
	ori $10, $0, CurrentYear
	
	#$10 = currentyear - 2000
	addi $10, $10, -2000

	#push $10 to top of stack 
	or $4, $0, $10
	jal push_stack

	#call multiply 
	jal multiply_proced

	#pop result off of stack $10 = 365 * (CurrentYear - 2000)
	jal pop_stack 
	or $10, $0, $2

	#add $9 = $9 + $10
	add $9, $9, $10

	#add $4 = $9 + $8
	add $4, $9, $8


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


CurrentDay:
	org 0x0800
	cfw   15

CurrentMonth:
	org 0x0804
	cfw 1

CurrentYear:
	org 0x0808
	cfw 2019


	

