org 0x0000

   ori   $2, $2, start
   ori   $3, $0, 10
branch:
   addi  $3, $3, -1
   sw    $3, 0 ($2)
   bne   $3, $0, branch
   halt

org 0x80
start:
  cfw 2
