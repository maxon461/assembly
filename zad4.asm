#===================================================
.eqv STACK_SIZE		2048

#===================================================
.data

sys_stack_addr:	.word	0	# for system stack recover

stack:		.space 	STACK_SIZE


global_array: 	.space 	40	# 10 int * 4 bytes

#===================================================
.text
	sw $sp, sys_stack_addr
	la $sp, stack+STACK_SIZE	# stack initialization
	
main:
	li $t0, 10		# loop counter
	li $t1, 1		# value counter
	la $t2, global_array	# array pointer
	
fill:				# filling the array with 1 ... 10
	sw $t1, ($t2)
	addi $t2, $t2, 4
	
	addi $t1, $t1, 1
	subi $t0, $t0, 1
	
	bnez $t0, fill


# putting function arguments on the stack
	subi $sp, $sp, 4
	la $t0, global_array	# int* : array adress
	sw $t0, ($sp)
	
	subi $sp, $sp, 4
	li $t0, 10		# int : array length
	sw $t0, ($sp)	

# function call ...
	jal sum
	
	lw $t0, ($sp)		# load sum result
	
	addi $sp, $sp, 12	# deallocate whole stack
	
	
# print result
	li $v0, 1
	move $a0, $t0
	syscall
	
# BUG: RESULT NOT CORRECT, NEED TO DEBUG
	
# end of main:
	lw $sp, sys_stack_addr
	
	li $v0, 10	# program exit code
	syscall

# ========================================
	
sum:
# function frame preparation
	subi $sp, $sp, 4	# allocate space for return value
	
	subi $sp, $sp, 4
	sw $ra, ($sp)		# return adress put on stack
	
	subi $sp, $sp, 8	# 8 = 2 * sizeof (int); local variables
	
# the actual function body
	li $t0, 0
	sw $t0, ($sp)		# int s = 0;
	
	lw $t1, 16($sp)		# +4 words, counter := array length
	subi $t1, $t1, 1	
	sw $t1, 4($sp)		# int i = array_size - 1;
	
sum_calculation:
	blt $t1, $zero, end_sum_calculation	# break loop if i < 0
	
	lw $t0, ($sp)		# t0: sum
	lw $t1, 4($sp) 		# t1: i (loop counter)
	
	lw $t2, 20($sp)		# t2: now: array pointer
	sll $t3, $t1, 2		# array offset (for array[i] access)
	add $t2, $t2, $t3
	lw $t2, ($t2)		# t2: array[i]
	
	add $t0, $t0, $t2
	subi $t1, $t1, 1
	
	sw $t0, ($sp)		# save sum to stack
	sw $t1, 4($sp)		# save loop counter to stack
	
	j sum_calculation	# recheck condition
	
end_sum_calculation:
	sw $t0, 12($sp)		# return value saved
	addi $sp, $sp, 8	# deallocate local variables
	
	lw $ra, ($sp)
	addi $sp, $sp, 4	# pointer to return value
	
	jr $ra			# return
	
# =========================================
