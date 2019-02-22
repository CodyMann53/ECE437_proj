#Pipeline data hazard test that can be solved by forwarding 

#tell where to store this in memory 
org 0x0000

main:
	
	#set up registers 
	ori $10, $0, 10
	ori $11, $0, 5

	#hazard testing 
	sub $2, $10, $11
	sub $3, $2, $11

	#program done 
	halt

