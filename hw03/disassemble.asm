.data

output:
  .word 0 # allocate output space

start_address:
  .word 0x00400000 # Default start address

output_prompt:
  .asciiz "0x"

input_prompt:
  .asciiz "Number of instructions to print: "

.text

main:
  la $a0, input_prompt # Pass the input prompt
  li $v0, 4 # Print the input prompt
  syscall

  li $v0, 5 # Receive input
  syscall

  add $t0, $v0, $zero # Load the counter
  lw $t1, start_address # Load the starting address

  loop:
    bne $t0, $zero, loop_continue
    j exit

  loop_continue:
    # Print output prompt
    la $a0, output_prompt
    li $v0, 4
    syscall

    lw $t3, ($t1) # Load the value at the address

    addi $t2, $zero, 8 # Initialize hex conversion counter

    hexloop:
      rol $t3, $t3, 4 # Rotate to next character
      andi $t4, $t3, 0x0000000f # Mask single character

      slti $t5, $t4, 0xa # Compare to hex A
      beq $t5, $zero, alpha

      addi $t4, $t4, 48 # Translate integer to integer character
      j printchar

      alpha:
        addi $t4, $t4, 87 # Translate integer to alpha character

      printchar:
        add $a0, $t4, $zero
        li $v0, 11 # Print the output
        syscall
      
      addi $t2, $t2, -1 # Decrement hex conversion counter
      bne $t2, $zero, hexloop

    # Print newline
    addi $a0, $zero, 10 # LF
    li $v0, 11 # Print single char
    syscall

    addi $t0, $t0, -1 # Decrement the counter
    addi $t1, $t1, 4

    j loop

  exit:
    li $v0, 10
    syscall
