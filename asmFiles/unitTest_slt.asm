#------------------------------------------
# Originally Test and Set example by Eric Villasenor
# Modified to be LL and SC example by Yue Du
#------------------------------------------

#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000              # first processor p0
  ori   $sp, $zero, 0x3ffc  # stack
  jal   mainp0              # go to program
  halt

# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra

# main function does something ugly but demonstrates beautifully
mainp0:
  push  $ra                 # save return address
  ori $a0, $zero, l1
  jal lock 

  # simple set less than 
  ori $t0, $zero, 9
  ori $t1, $zero, 10
  slt $t3, $t0, $t1
  ori $t0, $zero, res
  sw $t3, 0($t0)
  ori $a0, $zero, l1
  #jal unlock 

  pop   $ra                 # get return address
  jr    $ra                 # return to caller
l1:
  cfw 0x0



res:
  cfw 0x0                   # end result should be 2

