#Single cycle unit test for halt functionality. Make sure that your processor truly halts

#tell where to store this in memory 
org 0x0000

main:
	
	ori $10, $0, 10

	#program done 
	halt

	ori $10, $0, 5

