#Cody Mann
#mg278
#HW 1 

#1 (2.31)

#tell where to store this in memory 
org 0x0000

main:
	#initialize the stack pointer 
	ori $29, $0, 0xFFFC

	#set arguments for fib 
	ori $4, $0, 0x0800
	lw $4, 0($4)

	#jump and link to fib 
	jal fib

	#program done 
	halt

fib:

	#create space on stack for current frame (three word spaces)
	addi $29, $29, -12

	#store previous return location 
	sw $31, 4($29)

	#store current n value to stack 
	sw $16, 0($29)

	#if n is equal to zero
	beq $4, $0, if

	#if equal to 1 
	ori $8, $0, 1
	beq $4, $8, else_if

	#else continue recursion
	j else

	if: 

		#place 0 in return register and jump to return 
		or $2, $0, $0
		j return


	else_if: 

		#place 1 in return register and jump to return 
		ori $8, $0, 1
		or $2, $0, $8
		j return 

	else: 

		#copy argument to saved register $16
		or $16, $0, $4

		#subtract one from current argument value
		addi $4, $4, -1

		#jump to fib(n-1)
		jal fib

		#push the return value from first fib on to stack 
		sw $2, 8($29)

		#reset the current argument from saved register 
		or $4, $0, $16

		#subtract two from current argument value
		addi $4, $4, -2

		#jump to fib(n-1)
		jal fib

		#move first return value off of stack and into temporary 
		lw $8, 8($29)

		#add the two return values and place in return register 
		add $2, $2, $8  

	return: 

		#restore return location 
		lw $31, 4($29)

		#restore current value of n
		lw $16, 0($29)

		#pop frame off of stack
		addi $29, $29, 12

		#jump to return location
		jr $31

# A: 31 instructions needed to execute the c code for fibonacci.


n:
	org 0x0800
	cfw   7

#2 (2.42)

#A: yes, you can use the instruction b 7FFDB6D8 -> PC + 4 + 7FFDB6D8
