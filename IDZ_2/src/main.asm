j main
.include "macros.asm"

.data
	prompt_eps:     .asciz "\nВведите эпсилон между 1e-3 и 1e-8: "
	bad_eps:         .asciz "Неподходящее значение. Использую 1e-8.\n"
	start_msg:       .asciz "Начинаю метод хорд\n"
	result_msg:      .asciz "Корень = "

.text

.globl main
main:
	# Читаем эпсилон
	PRINT_STR(prompt_eps)
	READ_DOUBLE(fs2)
	
	# Проверки на корректность
	CHECK_EPSILON(fs2, eps_error)
	
start_calc:
	PRINT_STR(start_msg)
	
	fld fs0 dbl_two t0
	fld fs1 dbl_three t0
	
	SEGMENT_METHOD(fs0, fs1, fs2, fa0)
	
	PRINT_STR(result_msg)
	PRINT_DOUBLE(fa0)
	
	j main

eps_error:
	PRINT_STR(bad_eps)
	fld fs2 eps_min t0 
	j start_calc

end:
	li a7 10
	ecall
