.data

.text

search: # (array, value, left, right)
  addi $sp, $sp, -12 # allocate 3 words on stack (ra, left, right)
  sw $ra, 0($sp) # push return address
  sw $a2, 4($sp) # push left parameter
  sw $a3, 8($sp) # push right parameter


main:
  exit:
    li $v0, 10
    syscall
