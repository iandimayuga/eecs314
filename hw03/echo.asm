.data

coefficients:
  .word 0 # allocate input space

input_prompt:
  .asciiz "Enter a string.\n"

output_prompt:
  .asciiz "Echo: "

.text

main:
  la $a0, input_prompt # Pass the input prompt
  li $v0, 4 # Print the input prompt
  syscall

  la $a0, input # Pass the input location
  la $a1, input # Pass the input length

  li $v0, 8 # Receive input
  syscall

  la $a0, output_prompt # Pass the output prompt
  li $v0, 4 # Print the output prompt

  la $a0, input # Pass the input location
  li $v0, 4 # Print the input as output
  syscall

  li $v0, 10
  syscall
