
  org 0x0000
  ori   $2, $0, 0x80
  lw    $3, 0 ($2)
  lw    $4, 4 ($2)
  addu  $5, $3, $4 // 5 r5 is now 1
  sw    $5, 8 ($2)
  addu  $2, $2, $8
  subu  $15, $15, $1

  jal test
  halt

test:
  beq $0, $15, done 
  sw $15, 0($2)
done:
  jr $31


org 0x80
start:
  cfw 0
  cfw 1

