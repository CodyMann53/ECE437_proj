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

# Main function for processor 0
mainp0:
  push  $ra                 # save return address

  # 1. CODE TO CONSTANTLY BE PULLING DATA OFF THE BUFFER AND UPDATE MIN, MAX, AND RUNNING SUM (FINISH AFTER 256 RANDOM NUMBERS)
  # USE ONLY LOWER 16 BITS FOR THIS.
  # 2. CALCULATE THE AVERAGE AND THEN STORE AVERAGE, MIN, AND MAX 

  pop   $ra                 # get return address
  jr    $ra                 # return to caller

#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1
  ori   $sp, $zero, 0xaffc  # stack initialization 
  jal   mainp1              # go to program
  halt

# main function for processor 1
mainp1:
  push  $ra                 # save return address

  # 1. CODE TO CONSTANTLY GENERATE A RANDOM NUMBER AND THEN STORE IT INTO THE STACK BUFFER IF NOT FULL (FINISH WHEN 256 RANDOM NUMBERS ARE CREATED)

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
# SHARED VARIABLES REGION (USE LL/SC)
#----------------------------------------------------------
org 0x4000
  lck1:
    cfw 0x0 # Start with unlocked
  stack_buffer_size:
    cfw 0x0                   # Buffer starts out empty
  stack_buffer_pointer:
    cfw 0x3ffc                # Set stack_buffer_pointer to the begining of the buffer's spot in memory
  min_res:
    cfw 0x0
  max_res:
    cfw 0x0
  avg_res:
    cfw 0x0


