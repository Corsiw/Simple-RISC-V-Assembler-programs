# Нарисовать горизонтальную линию высотой от regStart до regEnd
.macro DRAW_LINE(%regColor, %regStart, %regEnd)
	    bge %regStart %regEnd wrong_args
	    mv      t5 %regStart     		# Y = regStart - идем по строкам, реже обход по вертикали
	hLoop:							# Цикл по вертикали
	    mv      t6 zero     		# X = 0
	wLoop:							# Цикл по горизонтали
	    sw      %regColor (s3)     		# Красим линию
	next:
	    # Следующая точка и проверки на окончание
	    addi    s3 s3 4     		# Следующий адрес в видеопамяти
	    addi    t6 t6 1     		# X++
	    blt     t6 s1 wLoop
	    addi    t5 t5 1     		# Y++
	    
	    blt t5 %regEnd hLoop
	wrong_args:
.end_macro

.include "macro-syscalls.m"
.eqv WIDTH          512
.eqv HIGHT          256
.eqv flagColor1      0xFFFFFF	# Цвет флага
.eqv flagColor2      0x0039A6	# Цвет флага (синий)
.eqv flagColor3      0xD52B1E	# Цвет флага (красный)
.eqv BASE           0x10010000	# Начало видеопамяти

.text
main:
    li      s0 flagColor1
    li      s1 WIDTH		# Хранение ширины экрана (maxX)
    li      s2 HIGHT			# Хранение высоты экрана (maxY)
    li      s3 BASE			# Хранение начала видеопамяти
    
    mv s4 zero # s4 = start of the line
    addi t2 zero 3
    div s5 s2 t2 # s5 = 1/3 * hight; end of the line
    
    DRAW_LINE(s0, s4, s5)
    
    mv s4 s5
    add s5 s5 s5
    li s0 flagColor2
    DRAW_LINE(s0, s4, s5)
    
    add s5 s5 s4
    add s4 s4 s4
    li s0 flagColor3
    DRAW_LINE(s0, s4, s5)
       
    exit
