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
# $s1 = place for popped values
# $s2 = current min
# $s3 = current max
# $s4 = running average
mainp0:
  push  $ra                 # save return address
  # Initialize number count to 0
  ori $s0, $zero, 0
  ori $s4, $zero, 0

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

        # Pop value off of the stack buffer
        jal pop_stack

        # Only grab the lower 16 bits
        andi $v0, $v0, 0x0000FFFF

        # If this is the first element being popped off
        bne $s0, $zero, continue

          # set it as min and max
          or $s2, $zero, $v0
          or $s3, $zero, $v0

        continue:

          # Moved popped value into saved register 1
          or $s1, $zero, $v0

          # UNLOCK
          ori $a0, $zero, lck1
          jal unlock

          # Update max
          or $a0, $zero, $s1
          or $a1, $zero, $s3
          jal max
          or $s3, $zero, $v0

          # Update min
          or $a0, $zero, $s1
          or $a1, $zero, $s2
          jal min
          or $s2, $zero, $v0

          # update running sum
          addu $s4, $s4, $s1

          # Update the number count 
          addiu $s0, $s0, 1

          j loop 

    # Else the buffer is empy
      else:
        # UNLOCK lck1
        ori $a0, $zero, lck1
        jal unlock

        # Go to loop 
        j loop

  exit:
    # 2.  Store min_res
    ori $t0, $zero, min_res
    sw $s2, 0($t0)

    # 3. store max_res
    ori $t0, $zero, max_res
    sw $s3, 0($t0)

    # 4. Calculate avg_res (shift logic
    ori $t0, $zero, 8
    srlv $s4, $t0, $s4

    # 5. Store the avg_res
    ori $t0, $zero, avg_res
    sw $s4, 0($t0)

    # pop off return address from stack and return
    pop   $ra
    jr    $ra
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
  # Initialize number count to 0
  ori $s0, $zero, 0

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

  exit2:
    # Return
    pop   $ra                 # get return address
    jr    $ra                 # return to caller
#----------------------------------------------------------
# Sub Routines
#----------------------------------------------------------

#-push_stack (a0=push_value)--------------------------
# Push argument a0 on to the top of stack and decrements stack pointer by 4
# Also will increase stack size by 1
push_stack:
  # Load in the stack pointer address
  ori $t0, $zero, stack_pointer
  lw $t1, 0($t0)

  # Decrement the stack pointer by 4
  addiu $t1, $t1, -4

  # Place arg0 at top of stack
  sw $a0, 0($t1)

  # store stack pointer back 
  sw $t1, 0($t0)

  # Load the value of stack size
  ori $t0, $zero, stack_size
  lw $t1, 0($t0)

  # Increment stack size by 1
  addiu $t1, $t1, 1

  # Store stack size back to memory and return
  sw $t1, 0($t0)
  jr $ra

#--------------------------------------------------

#-pop_stack (v0=pop_value)--------------------------
# Returns the value at top of the stack and increments the stack pointer by 4.
# Also will reduce the stack size by 1
pop_stack:
    # Load in stack pointer
    ori $t0, $zero, stack_pointer
    lw $t1, 0($t0)

    # place value at top of stack into return register 0
    lw $v0, 0($t1)

    # Increment the stack pointer by 4
    addiu $t1, $t1, 4

    # Store the stack pointer back
    sw $t1, 0($t0)

    # Load the value of stack size
    ori $t0, $zero, stack_size
    lw $t1, 0($t0)

    # Decrement stack size by 1
    addiu $t1, $t1, -1

    # store stack size back and return
    sw $t1, 0($t0)
    jr $ra
#--------------------------------------------------

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
org 0xc000
  lck1:
    cfw 0x0 # Start with unlocked
  stack_size:
    cfw 0x0                   # Buffer starts out empty
  stack_pointer:
    cfw 0x3ffc               # Set stack_buffer_pointer to the begining of the buffer's spot in memory
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



