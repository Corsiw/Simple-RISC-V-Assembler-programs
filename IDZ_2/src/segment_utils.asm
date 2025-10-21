.data
	ln2_val:     .double 0.69314718055994530942
	dbl_one:    .double 1.0
	dbl_zero:   .double 0.0
	dbl_two:    .double 2.0
	dbl_three:  .double 3.0
	
	#epsilon lower and upper bounds
	eps_max:   .double 0.001
	eps_min:   .double 0.00000001
	
	# constants for scanning
	scan_start:      .double -10.0
	scan_end:        .double 10.0
	scan_step:       .double 0.5

	max_iterations: .word 200
	
	root_out_of_bounds_msg: .asciz "Корень уравнения находится вне переданного отрезка и вне отрезка [-10; 10]"

.text
.globl calculate_root

# -------------------------------------------------------
# calculate_root
# Функция находит корень уравнения 2^(x^2 + 1) + x - 3 = 0,
# с точностью eps на отрезке [a; b].
# Если корня там нет, то сканирует [-10; 10] и ищет корень там.
# Формальные параметры (передаются через регистры):
#   fa0 - a
#   fa1 - b
#   fa2 - eps
# Возврат: результат вычесления корня уровнения fa0
# -------------------------------------------------------
calculate_root:
	addi sp sp -64
	sw ra 60(sp)
	fsd fs0 52(sp) # a
	fsd fs1 44(sp) # b
	fsd fs2 36(sp) # eps
	fsd fs3 28(sp) # f_a
	fsd fs4 20(sp) # f_b
	fsd fs5 12(sp) # x_new
	sw s0 8(sp) # i
	
	fmv.d fs0 fa0
	fmv.d fs1 fa1
	fmv.d fs2 fa2
	
	# Сегмент подходит => a0 == 0
	jal check_segment
	beqz a0 loop_setup
	
start_scaning:
	# a = 9.5; b = 10
	fld ft0 scan_step t0
	fld fs1 scan_end t0
	fsub.d fs0 fs1 ft0
	
loop_scaning:
	# fa0 = a; fa1 = b
	fmv.d fa0 fs0
	fmv.d fa1 fs1
	
	jal check_segment
	beqz a0 loop_setup
	
	# a -= 0.5; b -= 0.5
	fld ft0 scan_step t0
	fsub.d fs0 fs0 ft0
	fsub.d fs1 fs1 ft0
	
	# t0 = b > scan_end ? 1 : 0
	fld ft0 scan_end t0
	fgt.d t1 fs1 ft0
	
	# t1 = a < scan_start ? 1 : 0
	fld ft0 scan_start t0
	flt.d t2 fs0 ft0
	
	# продолжаем луп, если и а, и б внутри [-10; 10]
	or t1 t1 t2
	beqz t1 loop_scaning
	
	j root_out_of_bounds_error

loop_setup:
	# i = 0
	mv s0 zero
	
	# f_a = f(a) 
	fmv.d fa0 fs0
	jal calculate_f
	fmv.d fs3 fa0
	
	# f_b = f(b)
	fmv.d fa0 fs1
	jal calculate_f
	fmv.d fs4 fa0
	
loop:
	# ft0 = b-a; ft1 = abs(b - a)
	fsub.d ft0 fs1 fs0
	fsgnjx.d ft1 ft0 ft0
	
	# while (abs(b-a) > eps && i < max_iterations)
	fgt.d t0 ft1 fs2
	beqz t0 loop_end
	lw t0 max_iterations
	bge s0 t0 loop_end
	
	# ft2 = f_b * (b - a)
	fmul.d ft2 fs4 ft0
	# ft3 = f_b - f_a
	fsub.d ft3 fs4 fs3
	# ft2 = f_b * (b - a) / (f_b - f_a)
	fdiv.d ft2 ft2 ft3
	# x_new = b - f_b * (b - a) / (f_b - f_a)
	fsub.d fs5 fs1 ft2
	
	# Проверка, чтобы x_new не застревал на границе, иначе бывает, что метод очень медленно сходится.
	# if abs(x_new - a) < eps || abs(x_new - b) < eps: x_new = (a+b)/2
	fsub.d ft2 fs5 fs0
	fsgnjx.d ft2 ft2 ft2
	flt.d t0 ft2 fs2
	
	fadd.d ft3 fs0 fs1
	fld ft4 dbl_two t0
	fdiv.d fs5 ft3 ft4
	
	fsub.d ft2 fs5 fs1
	fsgnjx.d ft2 ft2 ft2
	flt.d t0 ft2 fs2
	beq t0 zero ok_x
	
	fadd.d ft3 fs0 fs1
	fld ft4 dbl_two t0
	fdiv.d fs5 ft3 ft4
	
ok_x:
	# fa0 = f(x_new)
	fmv.d fa0 fs5
	jal calculate_f
	
	# ft3 = abs(f(x_new))
	fsgnjx.d ft3 fa0 fa0
	
	# if abs(f(x_new )) < eps: loop_drop
	flt.d t0 ft3 fs2
	bne t0 zero loop_drop
	
	# if f_b * f(x_new) < 0
	fmul.d ft4 fs4 fa0
	fld ft5 dbl_zero t0
	flt.d t0 ft4 ft5
	bne t0 zero change_a
	
	# b = x_new; f_b = f(x_new)
	fmv.d fs1 fs5
	fmv.d fs4 fa0
	
	# i += 1
	addi s0 s0 1
	j loop
	
change_a:
	# a = x_new; f_a = f(x_new)
	fmv.d fs0 fs5
	fmv.d fs3 fa0
	
	# i += 1
	addi s0 s0 1
	j loop
	
loop_drop:
	# возвращаем x_new
	fmv.d fa0 fs5
	j end_calculate_root

loop_end:
	# возвращаем приближенный корень x_new при превышении числа итераций
	fmv.d fa0 fs5
	j end_calculate_root

root_out_of_bounds_error:
	# return 0 при ошибке
	fld fa0 dbl_zero t0
	
	# выводим сообщение об ошибке
	lw a0 root_out_of_bounds_msg
	li a7 4
	ecall
	
	# очищаем стек
	j end_calculate_root

end_calculate_root:
	lw ra 60(sp)
	fld fs0 52(sp)
	fld fs1 44(sp)
	fld fs2 36(sp)
	fld fs3 28(sp)
	fld fs4 20(sp)
	fld fs5 12(sp)
	lw s0 8(sp)
	addi sp sp 64
	ret

			
# -------------------------------------------------------
# check_segment(a: freg, b: freg)
# Проверяет есть ли корень уравнения 2^(x^2 + 1) + x - 3 = 0,
# на отрезке [a; b].
# Формальные параметры (передаются через регистры):
#   fa0 - a
#   fa1 - b
# Возврат: результат вычесления корня уровнения fa0
# -------------------------------------------------------
check_segment:
	addi sp sp -32
	sw ra 28(sp)
	fsd fs0 20(sp) # a
	fsd fs1 12(sp) # b
	fsd fs2 4(sp) # f_a
	
	fmv.d fs0 fa0
	fmv.d fs1 fa1
	
	# считаем f(a) и сохраняем в f_a (fs2)
	jal calculate_f
	fmv.d fs2 fa0
	
	# считаем f(b) результат в fa0
	fmv.d fa0 fs1
	jal calculate_f 
	
	# ft0 = f(a) * f(b); ft1 = 0.0
	fmul.d ft0 fs2 fa0
	fld ft1 dbl_zero t0
	
	# t0 = f(a) * f(b) > 0 ? 1 : 0
	fgt.d a0 ft0 ft1
	
	lw ra 28(sp)
	fld fs0 20(sp)
	fld fs1 12(sp)
	fld fs2 4(sp)
	addi sp sp 32
	ret
	

# -------------------------------------------------------
# calculate_root
# Функция находит корень уравнения 2^(x^2 + 1) + x - 3 = 0,
# с точностью eps на отрезке [a; b].
# Если корня там нет, то сканирует [-10; 10] и ищет корень там.
# Формальные параметры (передаются через регистры):
#   fa0 - a
#   fa1 - b
#   fa2 - eps
# Возврат: результат вычесления корня уровнения fa0
# -------------------------------------------------------
calculate_f:
	addi sp sp -16
	sw ra 12(sp)
	
	# ft0 = x^2 + 1
	fmul.d ft0 fa0 fa0
	fld ft1 dbl_one t0
	fadd.d ft0 ft0 ft1
	
	# z = ft0 = (x^2 + 1) * ln(2)
	fld ft1 ln2_val t0
	fmul.d ft0 ft0 ft1
	
	fld ft1 dbl_one t0 # sum
	fmv.d ft2 ft1 # term
	fmv.d ft3 ft1 # n = 1
	fld ft4 eps_min t0 # ft4 = eps
	fmv.d ft5 ft1 # ft5 = 1.0

# Считаем через Тейлора
exp_loop:
	# term = term * z / n
	fmul.d ft2 ft2 ft0
	fdiv.d ft2 ft2 ft3
	
	# if term < eps: break
	flt.d t0 ft2 ft4
	bne t0 zero exp_done
	
	# sum += term
	fadd.d ft1 ft1 ft2
	
	# n += 1.0
	fadd.d ft3 ft3 ft5
	j exp_loop
	
exp_done:
	# ft1 = e ^ ((x^2 + 1) * ln(2))
	
	# fa0 = e ^ ((x^2 + 1) * ln(2)) + x +3.0
	fld ft2 dbl_three t0
	fadd.d fa0 ft1 fa0
	fsub.d fa0 fa0 ft2
	
end_calculate_f:
	lw ra 12(sp)
	addi sp sp 16
	ret