
  org 0x0000

  ori   $2, $2, start
  lw    $3, 0 ($2)
  lw    $4, 8 ($2)
  addu  $5, $3, $4
  sw    $5, 8 ($2)
  addu  $2, $2, $8
  subu  $15, $15, $1
  halt


org 0x80
start:
  cfw 2
  cfw 3
  cfw 4
