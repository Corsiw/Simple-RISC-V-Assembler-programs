.data
	space:    .asciz " "
	nl:    .asciz "\n"

.text
.global print_string, read_double, print_double


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
	
	
read_double:
	addi sp sp -16
	sw ra 12(sp)

	li a7 7
	ecall

	lw ra 12(sp)
	addi sp sp 16
	ret


print_double:
	addi sp sp -16
	sw ra 12(sp)
	sw s0 8(sp)
	addi s0 sp 16 # s0 = old sp
	
	fld fa0 8(s0)
	li a7 3
	ecall

	lw ra 12(sp)
	lw s0 8(sp)
	addi sp sp 16
	ret
