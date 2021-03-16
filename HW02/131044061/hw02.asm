.data
result_array: .space 400
index: .word 0			#index for result_array
with: .word -1			#sign of the number
word_bytes: .word 4
input_array: .space 400
func_call_print: .asciiz "Func Call: "
newline: .asciiz "\n"
possible: .asciiz "Possible!! \n"
not_possible: .asciiz "Not Possible!!\n"
comma: .asciiz " "
func_call: .word 0




.text
.globl main
main:
jal read_array
move $t8, $a2 # target number copy
move $t9, $a1 # array size copy
jal CheckSumPossibility
li $v0, 4
la $a0, func_call_print
syscall
li $v0, 1
lw $a0, func_call
syscall
li $v0, 4
la $a0, newline
syscall
li $v0, 4
la $a0, newline
syscall
li $t0, 1
li $s1, 0
beq $v1, $t0, print_array
li $v0, 4
la $a0, not_possible
syscall
li $v0, 10
syscall


CheckSumPossibility:
	lw $t6, func_call
	addi $t6, $t6, 1
	sw $t6, func_call
	beq $a2, $zero, positive_return # return 1
	beq $a1, $zero, negative_return # return 0
	addi $t0, $a1, -1 # t0 = size-1
	lw $t6, word_bytes
	mult $t0, $t6 # 4 * (size-1) hi lo = t2
	mflo $t2	# copy Lo to $t2 = 4*(size-1)
	#sw $t3, 0($t1)
	la $t6, input_array # sw $s1, 100($s2)
	add $t6, $t6, $t2
	lw $t5, 0($t6)
	slt $t3, $a2, $t5
	bne $t3, $zero, first_call	# first_call => if(arr[size-1] > num)
	li $t0, 1
	sw $t0, with # with = 1
	# returnArray[index++] = arr[size-1];
	addi $t0, $a1, -1 # t0 = size-1
	lw $t6, word_bytes
	mult $t0, $t6 # 4 * (size-1) hi lo = t2
	mflo $t2	# copy Lo to $t2 = 4*(size-1)
	la $t6, input_array # sw $s1, 100($s2)
	add $t6, $t6, $t2
	lw $t5, 0($t6) # arr[size - 1]
	lw $t0, index
	lw $t6, word_bytes
	mult $t0, $t6 # 4 * (size-1) hi lo = t2
	mflo $t2	# copy Lo to $t2 = 4*(size-1)
	la $t6, result_array # sw $s1, 100($s2)
	add $t6, $t6, $t2 # return_array[index]
	sw $t5, 0($t6)
	lw $t0, index
	addi $t0, $t0, 1
	sw $t0, index
	# sw $t2(input_array) ,index(result_array)
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a2, 4($sp)
	sw $a1, 0($sp)
	#addi $t0, $a1, -1 # t0 = size-1
	# addi $a1, $a1, -1 # size--
	lw $t6, word_bytes
	addi $t0, $a1, -1
	mult $t0, $t6  # 4 * (size-1) hi lo = t2
	mflo $t2 # copy Lo to $t2 = 4*(size-1)
	la $t6, input_array
	add $t6, $t6, $t2
	lw $t5, 0($t6)
	sub $a2, $a2, $t5	# num = num - arr[size]
	addi $a1, $a1, -1 # size--
	jal	CheckSumPossibility
	lw $a1, 0($sp)
	lw $a2, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	bne $v1, $zero, return # return value != 0 return
	li $t0, -1
	lw $t1, with
	bne $t1, $t0, return # with value != -1 return
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t0, 1
	sw $t0, with
	lw $t0, index
	addi $t0, $t0, -1
	sw $t0, index # index-- # returnarray[index] atamasina gerek yoktur!!!
	# addi index, index, -1 # index-- # returnarray[index] atamasina gerek yoktur!!!
	addi $a1, $a1, -1 #size--
	jal CheckSumPossibility
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	bne $v1, $zero, return
	li $t0, -1
	sw $t0, with
	jr $ra
	

return:
	jr	$ra
	

print_array:
	li $v0, 4
	la $a0, possible
	syscall
	j print_array2

print_array2:
	lw $t2, index
	addi $t2, $t2, -1
	li $t3, -1
	beq $t2, $t3, EXIT2
	lw $t0, word_bytes
	mult $t0, $t2
	mflo $t3
	la $t6, result_array
	add $t6, $t6, $t3
	lw $t3, 0($t6)
	li $v0, 1
	move $a0, $t3
	syscall
	li $v0, 4
	la $a0, comma
	syscall
	sw $t2, index
	j print_array2

first_call:
	addi $t0, $t0, -1
	sw $t0, with # with = -1
	addi $a1, $a1, -1 # size--
	j CheckSumPossibility

negative_return:
	#lw $t1, with		# t1 = with
	li $t2, 1			# t2 = 1
	lw $t0, with
	beq $t0, $t2, delete_last_element	# if with == 1 delete last element
	li $v1, 0
	jr $ra

delete_last_element:
	sw $t3, index
	addi $t3, $t3, -1
	lw $t3, index	# index--;
	li $v1, 0
	jr $ra

positive_return:
	li $v1, 1
	jr $ra

read_array:
	li $v0, 5
	syscall
	move $a1, $v0 # array size
	li $v0, 5
	syscall
	move $a2, $v0 # target number
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	move $s0, $zero
	jal input_array_loop
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra

input_array_loop:
	slt $t0, $s0, $a1
	beq $t0, $zero, EXIT
	la $t1, input_array # address of array
	sll $t2, $s0, 2 # i*4byte
	add $t1, $t1, $t2 # arr[i]
	li $v0, 5
	syscall
	move $t3, $v0 # input number
	sw $t3, 0($t1)
	addi $s0, $s0, 1
	j input_array_loop

EXIT:
	jr $ra

EXIT2:
	li $v0, 10
	syscall
