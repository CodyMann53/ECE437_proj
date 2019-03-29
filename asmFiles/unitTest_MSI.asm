org 0x0000
  ori $2, $0, load_values
  sw $0, 4($2)
  lw $3, 0($2)
  addi $3, $3, 1
  sw $3, 0($2) # moving from both shared to modified in this processor and invalid in the other processor
  ori $5, $0, 1
  sw $5, 4($2)

wait_p1_1:
  lw $4, 8($2)
  beq $4, $0, wait_p1_1

  sw $0, 4($2)
  lw $3, 0($2) # moving from invalid in this processor to shared and from modified in the other processor to shared
  ori $5, $0, 1
  sw $5, 4($2)
  halt  


org 0x0200
  ori $2, $0, load_values
  sw $0, 8($2)
  lw $3, 0($2)

wait_p0_1:
  lw $4, 4($2)
  beq $4, $0, wait_p0_1

  addi $3, $3, 1
  sw $3, 0($2) # moving from invalid in this processor to modified and from modified in the other processor to invalid
  ori $5, $0, 1
  sw $5, 8($2)

wait_p0_2:
  lw $4, 4($2)
  beq $4, $0, wait_p0_2
  halt

load_values:
  org 0x0800
  cfw 1
