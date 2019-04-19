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

  ori $s0, $zero, res
  ori $a0, $zero, 500
  ori $a1, $zero, 600
  jal min
  sw $v0, 0($s0)

  pop   $ra                 # get return address
  jr    $ra                 # return to caller
l1:
  cfw 0x0


#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1
  ori   $sp, $zero, 0x7ffc  # stack
  jal   mainp1              # go to program
  halt

# main function does something ugly but demonstrates beautifully
mainp1:
  push  $ra                 # save return address

  loop2:

    # If number count is equal to 256 then exit
    ori $t0, $zero, 256
    beq $s0, $t0, exit2

      # LOCK lck1
      ori $a0, $zero, lck1
      jal lock

      # Load in stack size
      ori $t0, $zero, stack_size
      lw $t1, 0($t0)

      # If the buffer is full (10 elements exist) then jump to else block
      ori $t3, $zero, 10
      beq $t1, $t3, else2

        # Load in previous random number and generate a random number
        ori $t0, $zero, rand_prev
        lw $a0, 0($t0) 
        jal crc32

        # save generated random number
        ori $t0, $zero, rand_prev
        sw $v0, 0($t0)

        # push generated random number to stack 
        or $a0, $zero, $v0
        jal push_stack

        # increment count number by 1
        addiu $s0, $s0, 1

    # Else the buffer is empy
      else2:
        # UNLOCK lck1
        ori $a0, $zero, lck1
        jal unlock

        # Go to loop2
        j loop2
  
  pop   $ra                 # get return address
  jr    $ra                 # return to caller

  #-max (a0=a,a1=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  sltu   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
  maxrtn:
    pop   $a1
    pop   $a0
    pop   $ra
    nop
    nop
    jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  sltu   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
  minrtn:
    pop   $a1
    pop   $a0
    pop   $ra
    nop
    nop
    jr    $ra

res:
  cfw 1
  cfw 2
  cfw 3
  cfw 4



  

  
