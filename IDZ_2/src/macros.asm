.include "io.asm"
.include "segment_utils.asm"

# -----------------------------------------------------
# PRINT_STR(adr)
# Печать строки.
# Параметр:
#   adr – адрес ASCIIZ-строки
# Передача:
#   на стек по смещению 12(sp).
# Вызов:
#   jal print_string
# -----------------------------------------------------
.macro PRINT_STR(%adr)
	addi sp sp -16
	la t0 %adr
	sw t0 12(sp)
	jal print_string
	addi sp sp 16
.end_macro


# -----------------------------------------------------
# READ_DOUBLE(%freg)
# Считывает число с плаващей точкой двойной точности в регистр freg.
# Параметр:
#   freg – флот регистр, в который будет считано значение.
# Вызов:
#   jal read_double
# -----------------------------------------------------
.macro READ_DOUBLE(%freg)
	jal read_double
	fmv.d %freg fa0
.end_macro


# -----------------------------------------------------
# PRINT_DOUBLE(freg)
# Печать одного числа с плаващей точкой двойной точности.
# Параметр:
#   freg – флот регистр со значением для печати.
# Передача:
#   на стек по смещению 8(sp).
# Вызов:
#   jal print_double
# -----------------------------------------------------
.macro PRINT_DOUBLE(%freg)
	addi sp sp -16
	fsd %freg 8(sp)
	jal print_double
	addi sp sp 16
.end_macro


# -----------------------------------------------------
# SEGMENT_METHOD(fleft, fright, feps, fres)
# Вычисляет корень уравнения 2^(x^2+1) + x - 3 = 0 методом хорд.
# Корень ищется на отрезке [fleft; fright], если отрезок не подходит,
# то сканирует [-10; 10] с шагом 0.5, начиная с [9.5; 10].
# Если корня не нашлось и [-10; 10], то сообщает об ошибке и возвращает 0 в fres.
# Параметры:
#   fleft – флот регистр левая граница поиска корня.
#   fright – флот регистр правая граница поиска корня.
#   feps - флот регистр точность поиска.
#   fres - флот регистр, в который запишется ответ
# Передача:
#   Через fa0..fa2 регистры соответственно
# Вызов:
#   jal calculate_root
# -----------------------------------------------------
.macro SEGMENT_METHOD(%fleft, %fright, %feps, %fres)
	addi sp sp -16
	sw ra 12(sp)
	
	fmv.d fa0 %fleft
	fmv.d fa1 %fright
	fmv.d fa2 %feps
	
	jal calculate_root
	fmv.d %fres fa0
	
	lw ra 12(sp)
	addi sp sp 16
.end_macro


# -----------------------------------------------------
# CHECK_EPSILON(freg, input_err)
# Проверяет freg на нахождение [eps_min; eps_max]
# Прыгает на input_err при отрицательной проверке.
# Параметр:
#   freg – флот регистр для проверки
#   input_err - лейбл для прыжка при ошибке.
# -----------------------------------------------------
.macro CHECK_EPSILON(%freg, %input_err)
	fld ft0 eps_max t0
	fle.d t0 %freg ft0
	beqz t0 %input_err
	
	fld ft0 eps_min t0
	fge.d t0 %freg ft0
	beqz t0 %input_err
.end_macro
