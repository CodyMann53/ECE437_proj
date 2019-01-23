#Single cycle unit test for jump instructions (JAL, JR, J)

#tell where to store this in memory 
org 0x0000

main:
	
	#jump and link to func
	jal func

	#jump to return 
	j return

	#place 5 in register 8 (should not get here)
	ori $8, $0, 5

func:

	#place 10 in register 8 to know that jr worked correctly
	ori $8, $0, 10

	#jump to return address 
	jr $31

	# place 12 in register 8 (should not get here)
	ori $8, $0, 12

return: 

	#program done 
	halt