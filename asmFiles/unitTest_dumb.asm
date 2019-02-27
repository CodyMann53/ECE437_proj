
  org 0x0000
  ori   $t9, $0, 12
  ori $10, $0, 0x80

  is_inner:
  beq   $t9, $0, is_inner_end
  lw    $9, 0($10)
  slt   $13, $0, $t9
  beq    $13, $0,  is_inner_end
  sw     $9, 0($10)
  addiu $t9, $t9, -4
  j     is_inner

  is_inner_end:
    halt 

org 0x80
start:
  cfw 0

