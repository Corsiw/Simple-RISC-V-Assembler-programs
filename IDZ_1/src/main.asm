j main
.include "macros.asm"

.data
	msg_enterN:    .asciz "������� ������ ������� N (<=10): "
	msg_errN:       .asciz "������: N ������ ���� �� 1 �� 10\n"
	msg_inputA:    .asciz "������� ����� ����� �� ������ � ������\n"
	msg_arrayA:    .asciz "�������� ������ A:\n"
	msg_arrayB:    .asciz "�������������� ������ B:\n"

.text

.globl main
main:
	PRINT_STR(msg_enterN)
	READ_INT(s0)
	# �������� �� ������������
	blez s0 n_error
	li t0 10
	bgt s0 t0 n_error
	
	# ��������� ������ ��� ������ A � B
	li s1 4
	mul s1 s0 s1 # s1 = array size in bytes
	sub sp sp s1
	mv s2 sp # s2 = A array address
	sub sp sp s1
	mv s3 sp # s3 = B array address
	
	PRINT_STR(msg_inputA)
	READ_ARR(s0, s2)
	PRINT_STR(msg_arrayA)
	PRINT_ARR(s0, s2)
	
	FORM_ARR(s0, s2, s3)
	PRINT_STR(msg_arrayB)
	PRINT_ARR(s0, s3)
	
	# ����������� ���� �� A � �� B
	add sp sp s1
	add sp sp s1
	j main

n_error:
	PRINT_STR(msg_errN)
	j main

end:
	li a7 10
	ecall
