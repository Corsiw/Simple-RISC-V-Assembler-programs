.data
	space:    .asciz " "
	nl:    .asciz "\n"

.text
.global print_string, read_int, print_int, read_array, print_array


print_string:
	addi sp sp -16
	sw ra 12(sp)
	sw s0 8(sp)
	addi s0 sp 16 # s0 = old sp
	
	lw a0 12(s0)
	li a7 4
	ecall

	lw ra 12(sp)
	lw s0 8(sp)
	addi sp sp 16
	ret
	
	
read_int:
	addi sp sp -16
	sw ra 12(sp)

	li a7 5
	ecall

	lw ra 12(sp)
	addi sp sp 16
	ret


print_int:
	addi sp sp -16
	sw ra 12(sp)
	sw s0 8(sp)
	addi s0 sp 16 # s0 = old sp
	
	lw a0 12(s0)
	lw a0 0(a0)
	li a7 1
	ecall

	lw ra 12(sp)
	lw s0 8(sp)
	addi sp sp 16
	ret


read_array:
	addi sp sp -32
	sw ra 28(sp)
	sw s0 24(sp)
	sw s1 20(sp)
	sw s2 16(sp)
	addi s0 sp 32 # s0 = old sp
	
	# Сохраняем переданные параметры на стеке
	lw s1 12(s0) # N
	lw s2 8(s0) # Arr
	sw s1 12(sp)
	sw s2 8(sp)
	
loop_read:
	lw s1 12(sp)
	blez s1 end_read
	# Возвращаем результат через a0
	jal read_int
	
	lw s2 8(sp)
	sw a0 0(s2)
	
	addi s1 s1 -1
	addi s2 s2 4
	sw s1 12(sp)
	sw s2 8(sp)
	j loop_read
	
end_read:
	lw ra 28(sp)
	lw s0 24(sp)
	lw s1 20(sp)
	lw s2 16(sp)
	addi sp sp 32
	ret
		

print_array:
	addi sp sp -32
	sw ra 28(sp)
	sw s0 24(sp)
	sw s1 20(sp)
	sw s2 16(sp)
	addi s0 sp 32 # s0 = old sp
	
	# Копируем параметры на стек
	lw s1 12(s0)
	lw s2 8(s0)
	sw s1 12(sp)
	sw s2 8(sp)
	blez s1 end_print
	
loop_print:
	lw s2 8(sp)
	# Передаем адрес числа для печати по смещению 12(sp)
	addi sp sp -16
	sw s2 12(sp)
	jal print_int
	addi sp sp 16
	
	lw s1 12(sp)
	addi s1 s1 -1
	addi s2 s2 4
	blez s1 end_print
	
	# Сохраняем значения переменных
	sw s1 12(sp)
	sw s2 8(sp)
	
	# Передаем адрес лейбла для печати по смещениею 12(sp)
	addi sp sp -16
	la t0 space
	sw t0 12(sp)
	jal print_string
	addi sp sp 16
	
	j loop_print
	
end_print:
	# Передаем адрес лейбла для печати по смещениею 12(sp)
	addi sp sp -16
	la t0 nl
	sw t0 12(sp)
	jal print_string
	addi sp sp 16
	
	lw ra 28(sp)
	lw s0 24(sp)
	lw s1 20(sp)
	lw s2 16(sp)
	addi sp sp 32
	ret