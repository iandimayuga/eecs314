.data

length_prompt:
  .asciiz "Length of (sorted) array: "

input_prompt:
  .asciiz "th value: "

search_prompt:
  .asciiz "Value to search: "

found_prompt:
  .asciiz "Found at index "

notfound_prompt:
  .asciiz "Not found in array."

.text

search: # (array, value, left, right), $v0 = index or -1 if not found
  addi $sp, $sp, -12 # allocate 3 words on stack: ra, left, right
  sw $ra, 0($sp) # push return address
  sw $a2, 4($sp) # push left parameter
  sw $a3, 8($sp) # push right parameter

  slt $t0, $a3, $a2 # test if right < left
  beq $t0, $zero, search_partition # if right >= left skip to partition step

  # otherwise if right < left return -1
  addi $v0, $zero, -1 # set return value
  j search_return

  search_partition:
    # calculate middle index
    add $t0, $a2, $a3
    srl $t0, $t0, 1 # divide by 2 for average
    sll $t1, $t0, 2 # multiply by 4 for word alignment
    add $t1, $t1, $a0 # calculate actual memory address of middle index

    lw $t2, ($t1) # access middle index

    # if not equal to value, go to recursive search
    bne $t2, $a1, search_recursive

    # otherwise, return the index
    add $v0, $zero, $t0
    j search_return

  search_recursive:
    slt $t1, $a1, $t2 # check if value < a[mid]
    beq $t1, $zero, search_right # if value >= a[mid], search right

    search_left:
      addi $a3, $t0, -1
      jal search
      j search_return

    search_right:
      addi $a2, $t0, 1
      jal search
      j search_return

  search_return:
    lw $ra, 0($sp) # pop return address
    lw $a2, 4($sp) # pop left parameter
    lw $a3, 8($sp) # pop right parameter
    addi $sp, $sp, 12 # pop stack frame
    jr $ra

main:
  # prompt for array length
  la $a0, length_prompt # pass string
  li $v0, 4 # print
  syscall

  # receive input
  li $v0, 5
  syscall
  add $s0, $zero, $v0 # $s0 = length

  # allocate memory for array
  sll $a0, $s0, 2 # multiply by 4 for word alignment
  li $v0, 9 # allocate heap
  syscall
  add $s1, $zero, $v0 # $s1 = array address

  # populate array from user input
  add $t0, $zero, $zero # initialize counter
  array_loop:

    bne $t0, $s3, array_loop # loop until length reached

  exit:
    li $v0, 10
    syscall
