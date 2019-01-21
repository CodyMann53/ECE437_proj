#Single cycle unit test for halt functionality. Make sure that your processor truly halts

#tell where to store this in memory 
org 0x0000

main:
	
	#load 2 into register 8
	ori $8, $0, 2

	#load 2 into register 9
	ori $9, $0, 2

	#add register 8 and 9 and place result into 8
	add $8, $8, $9
	
	#program done 
	halt

