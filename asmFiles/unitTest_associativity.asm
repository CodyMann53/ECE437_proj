org 0x0000

  ori   $2, $2, start
  ori   $5, $5, other
  ori   $7, $7, next
  lw    $3, 0 ($2)
  lw    $4, 0 ($5)
  lw    $6, 0 ($7)
  lw    $8, 0 ($5)
  lw    $9, 0 ($2)
  halt

org 0x80
start:
  cfw 2
  cfw 3

org 0xA0
other:
   cfw 8

org 0xC0
next:
   cfw 10
