j main
.include "macro.asm"

.data
	input_double: .asciz "������� �������������� ����� ��� ���������� �����: "
	input_tol: .asciz "������� �������� ���������� - �������������� �����: "
	result: .asciz "��������� ����������: "
	number_err: .asciz "������� ������������ �����"

.text
.globl main

main:
	PRINT_STR(input_double)
	READ_DOUBLE(fs0)
	PRINT_STR(input_tol)
	READ_DOUBLE(fs1)
	CHECK_INPUT(fs0, input_err)
	CHECK_INPUT(fs1, input_err)
	SQRT(fs0, fs1)
	PRINT_STR(result)
	PRINT_DOUBLE(fa0)
	j end
	
input_err:
	PRINT_STR(number_err)
	
end:
	li a7 10
	ecall