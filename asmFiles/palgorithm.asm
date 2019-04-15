#------------------------------------------
# Author: Cody Mann 
# Date: 4/15/2019
#------------------------------------------
#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000              # first processor p0
  ori   $sp, $zero, 0x6ffc  # stack initialization
  jal   mainp0              # go to program
  halt

# Main function for processor 0----------------------------
# $s0 = number count
mainp0:
  push  $ra                 # save return address
  # Initialize the number count to 0
  ori $s0, $zero, $zero 

  # 1. While number_count_p0 < 256, then keep on processing data 
  loop: 
    # If number count is equal to 256 then exit 
    ori $t0, $zero, 256
    beq $s0, $t0, exit
      # LOCK lck1
      ori $a0, $zero, lck1
      jal lock
      # Load in stack size
      ori $t0, $zero, stack_size
      lw $t1, 0($t0)
      # If the buffer is empty then jump to else block
      beq $t1, $zero, else
        # Pop value off of the stack buffer             <------------------  LEFT OFF HERE
        # Decrement the stack buffer size by 1
        # UNLOCK
        # Update max
        # Update min 
        # update running sum
    # Else the buffer is empy 
      else:
        # UNLOCK lck1
        ori $a0, $zero, lck1
        unlock


  exit:
    # 2.  Store min_res 
    # 3. store max_res 
    # 4. Calculate avg_res
    # 5. Store the avg_res

  pop   $ra                 # get return address
  jr    $ra                 # return to caller
#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1
  ori   $sp, $zero, 0xaffc  # stack initialization 
  jal   mainp1              # go to program
  halt
# main function for processor 1-----------------------------
# $s0 = number count
mainp1:
  push  $ra                 # save return address

  # 1. While the number_count_p1 is less than 256
    # LOCK 
    # Load in buffer size
    # if the stack size is less than 10
      # Calculate random nummber based on prev 
      # save the current random number
      # push current random number on to stack 
      # Increase the stack size by one
      # increment the number_count_p1 by 1
      UNLOCK
    # Else the stack was full
      UNLOCK



  pop   $ra                 # get return address
  jr    $ra                 # return to caller
#----------------------------------------------------------
# Sub Routines
#----------------------------------------------------------

#-lock (a0=lock address)--------------------------
# returns when lock is available
lock:
  aquire:
    ll    $t0, 0($a0)         # load lock location
    bne   $t0, $0, aquire     # wait on lock to be open
    addiu $t0, $t0, 1
    sc    $t0, 0($a0)
    beq   $t0, $0, lock       # if sc failed retry
    jr    $ra
#--------------------------------------------------

#-unlock (a0=lock address)------------------------
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra
#--------------------------------------------------

#-max (a0=a,a1=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
  maxrtn:
    pop   $a1
    pop   $a0
    pop   $ra
    jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
  minrtn:
    pop   $a1
    pop   $a0
    pop   $ra
    jr    $ra
#--------------------------------------------------

# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)
#------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

  l1:
    slt $t4, $t2, $t3
    beq $t4, $zero, l2

    ori $t5, $0, 31
    srlv $t4, $t5, $a0
    ori $t5, $0, 1
    sllv $a0, $t5, $a0
    beq $t4, $0, l3
    xor $a0, $a0, $t1
    l3:
    addiu $t2, $t2, 1
    j l1
  l2:
    or $v0, $a0, $0
    jr $ra
#------------------------------------------------------
#----------------------------------------------------------
# Shared variables (use ll/sc)
#----------------------------------------------------------
org 0x4000
  lck1:
    cfw 0x0 # Start with unlocked
  stack_size:
    cfw 0x0                   # Buffer starts out empty
  stack_pointer:
    cfw 0x3ffc                # Set stack_buffer_pointer to the begining of the buffer's spot in memory
#----------------------------------------------------------
# Processor0 variables
#----------------------------------------------------------
  min_res:
    cfw 0x0
  max_res:
    cfw 0x0
  avg_res:
    cfw 0x0
#----------------------------------------------------------
# Processor1 variables
#----------------------------------------------------------
  rand_prev:
    cfw 0x500 # This variable is used as the seed to start out
