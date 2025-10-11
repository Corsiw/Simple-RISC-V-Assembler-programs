j test
.include "macros.asm"

.data
	msg1:      .asciz "义耱 1: n < 0"
	test1N:    .word -10
	test1A:    .word 1,2,3,4,5
	test1B:    .space 20
	
	msg2:      .asciz "义耱 2: n = 0"
	test2N:    .word 0
	test2A:    .word 1,2,3,4,5
	test2B:    .space 20
	
	msg3:      .asciz "义耱 3: n > 10\n"
	test3N:    .word 11
	test3A:    .word 1,2,3,4,5
	test3B:    .space 44
	
	msg4:      .asciz "义耱 4: n = 5\n"
	test4N:    .word 5
	test4A:    .word -1,0,3,0x7FFFFFFF,0x80000000
	test4B:    .space 20
	

.text
.globl test

test:
	PRINT_STR(msg1)
	lw s0, test1N
	la s1, test1A
	la s2, test1B
	FORM_ARR(s0, s1, s2)
	PRINT_ARR(s0, s1)
	PRINT_ARR(s0, s2)
	
	PRINT_STR(msg2)
	lw s0, test2N
	la s1, test2A
	la s2, test2B
	FORM_ARR(s0, s1, s2)
	PRINT_ARR(s0, s1)
	PRINT_ARR(s0, s2)

	PRINT_STR(msg3)
	lw s0, test3N
	la s1, test3A
	la s2, test3B
	FORM_ARR(s0, s1, s2)
	PRINT_ARR(s0, s1)
	PRINT_ARR(s0, s2)
	
	PRINT_STR(msg4)
	lw s0, test4N
	la s1, test4A
	la s2, test4B
	FORM_ARR(s0, s1, s2)
	PRINT_ARR(s0, s1)
	PRINT_ARR(s0, s2)
	
end:
	li a7 10
	ecall