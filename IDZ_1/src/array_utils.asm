.text
.globl form_arrayB

# -------------------------------------------------------
# form_arrayB
# Функция формирует массив B на основе массива A.
# Считаю что места в массиве == индексы от нуля, т.е. будет 1 3 5..0 2 4...
# Формальные параметры (передаются через стек):
#   N    - 12(sp_old) количество элементов
#   Aadr - 8(sp_old) адрес массива A
#   Badr - 4(sp_old) адрес массива B
# Возврат: ничего (массив B заполняется на месте)
# -------------------------------------------------------
form_arrayB:
	addi sp sp -32
	sw ra 28(sp)
	
	addi t0 sp 32 # t0 = old sp
	# Копируем переданные параметры
	lw t1 12(t0)
	lw t2 8(t0)
	lw t3 4(t0)
	sw t1 24(sp) # N
	sw t2 20(sp) # A
	sw t3 16(sp) # B
	
	# Смещения i, j для A, B
	li t4 4
	sw t4 12(sp) # i
	sw zero 8(sp) # j
	
odd_loop:
	lw t1 24(sp)
	lw t4 12(sp)
	slli t1 t1 2
	bge t4 t1 even
	
	# Смещаем A на i*4 и сохраняем в t6
	lw t2 20(sp)
	add t2 t2 t4
	lw t6 0(t2)
	
	# Смещаем B на j*4 и сохраняем в него t6 
	lw t3 16(sp)
	lw t5 8(sp)
	add t3 t3 t5
	sw t6 0(t3)
  
  	# Смащем i и j и сохраняем в переменные
	addi t4 t4 8
	sw t4 12(sp)
	addi t5 t5 4
	sw t5 8(sp)
 	j odd_loop

even:
	li t4 0
	sw t4 12(sp) # i
  
even_loop:
  	lw t1 24(sp)
	lw t4 12(sp)
	slli t1 t1 2
	bge t4 t1 end_form
	
	# Смещаем A на i*4 и сохраняем в t6
	lw t2 20(sp)
	add t2 t2 t4
	lw t6 0(t2)
	
	# Смещаем B на j*4 и сохраняем в него t6 
	lw t3 16(sp)
	lw t5 8(sp)
	add t3 t3 t5
	sw t6 0(t3)
  
  	# Смещаем i и j и сохраняем в переменные
	addi t4 t4 8
	sw t4 12(sp)
	addi t5 t5 4
	sw t5 8(sp)
 	j even_loop

end_form:
	lw ra 28(sp)
	addi sp sp 32
	ret
	
