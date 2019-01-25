#Single cycle unit test for jump instructions (JAL, JR, J)

#tell where to store this in memory 
org 0x0000

main:

		
	#jump and link to func
	jal func

	andi $9, $9, 1
	

	#jump to return 
	j return


func:
	
	ori $9, $0, 3

	#jump to return address 
	jr $31

	ori $9, $0, 5

return: 

	halt 


