#Pipeline control hazard test 

# ADD: bne, j, jl, jr

#tell where to store this in memory 
org 0x0000

main:
	
	#set up registers 
	ori $10, $0, 10
	ori $11, $0, 10

	beq $10, $11, correct
	ori $10, $0, 2

correct: 

	#program done 
	halt
