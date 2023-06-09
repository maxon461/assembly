.data
    wyn:     .word 0       # Result
    status:  .word 0       # Overflow status
    prompt1: .asciiz "Type your first value: "
    prompt2: .asciiz "Type your second value: "
    end_prompt: .asciiz "Your result is: "

.text
main:
    li $t2, 0       # Initialize result to 0
    li $t3, 0       # Initialize carry to 0
    
    la $a0, prompt1
    li $v0, 4
    syscall
    
    li $v0, 5       # System call code 5 for reading an integer
    syscall
    move $t0, $v0
    
    la $a0, prompt2
    li $v0, 4
    syscall
    
    li $v0, 5       # System call code 5 for reading an integer
    syscall
    move $t1, $v0
    
multiply_loop:
    beq $t1, $zero, end_multiply    # If second number is zero, end the multiplication

    andi $t4, $t1, 1        # Get the least significant bit of the second number

    beqz $t4, shift_multiply    # If the bit is 0, skip the addition

    add $t7, $t2 , $zero	# copying $t2 to $t7 , couse we need to remember it before overflow check

    addu $t2, $t2, $t0   # Add the first number to the result
    
    
    
    ble $t2 , $t7 , overflow

    
shift_multiply:
    sll $t0, $t0, 1     # Shift the first number left by 1 (multiply by 2)
    srl $t1, $t1, 1     # Shift the second number right by 1 (divide by 2)

    j multiply_loop     # Jump back to the beginning of the loop

end_multiply:
   

    sw $t2, wyn         # Store the result in the 'wyn' variable

    j exit_program      # Jump to the end of the program

overflow:
    li $t6, 1           # Set the overflow status to 1
    sw $t6, status      # Store the overflow status in the 'status' variable

exit_program:
    la $a0, end_prompt
    li $v0, 4
    syscall
    
    li $v0, 1
    move $a0, $t2
    syscall
    
    li $v0, 10          # Exit the program
    syscall
