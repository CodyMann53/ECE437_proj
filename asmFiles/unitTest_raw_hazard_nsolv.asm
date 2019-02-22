#Pipeline data hazard test that can't  be solved by forwarding 

#tell where to store this in memory 
org 0x0000

main:
	
	#set up registers 
	ori $10, $0, 10
	ori $12, $0, 0x0804

	#hazard testing 
	lw $11, 0($12)
	sub $2, $10, $11

	#program done 
	halt





CurrentMonth:
	org 0x0804
	cfw 5
