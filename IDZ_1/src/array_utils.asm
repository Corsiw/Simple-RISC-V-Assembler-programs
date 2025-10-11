.text
.globl form_arrayB

# -------------------------------------------------------
# form_arrayB
# ������� ��������� ������ B �� ������ ������� A.
# ������ ��� ����� � ������� == ������� �� ����, �.�. ����� 1 3 5..0 2 4...
# ���������� ��������� (���������� ����� ����):
#   N    - 12(sp_old) ���������� ���������
#   Aadr - 8(sp_old) ����� ������� A
#   Badr - 4(sp_old) ����� ������� B
# �������: ������ (������ B ����������� �� �����)
# -------------------------------------------------------
form_arrayB:
	addi sp sp -32
	sw ra 28(sp)
	
	addi t0 sp 32 # t0 = old sp
	# �������� ���������� ���������
	lw t1 12(t0)
	lw t2 8(t0)
	lw t3 4(t0)
	sw t1 24(sp) # N
	sw t2 20(sp) # A
	sw t3 16(sp) # B
	
	# �������� i, j ��� A, B
	li t4 4
	sw t4 12(sp) # i
	sw zero 8(sp) # j
	
odd_loop:
	lw t1 24(sp)
	lw t4 12(sp)
	slli t1 t1 2
	bge t4 t1 even
	
	# ������� A �� i*4 � ��������� � t6
	lw t2 20(sp)
	add t2 t2 t4
	lw t6 0(t2)
	
	# ������� B �� j*4 � ��������� � ���� t6 
	lw t3 16(sp)
	lw t5 8(sp)
	add t3 t3 t5
	sw t6 0(t3)
  
  	# ������ i � j � ��������� � ����������
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
	
	# ������� A �� i*4 � ��������� � t6
	lw t2 20(sp)
	add t2 t2 t4
	lw t6 0(t2)
	
	# ������� B �� j*4 � ��������� � ���� t6 
	lw t3 16(sp)
	lw t5 8(sp)
	add t3 t3 t5
	sw t6 0(t3)
  
  	# ������� i � j � ��������� � ����������
	addi t4 t4 8
	sw t4 12(sp)
	addi t5 t5 4
	sw t5 8(sp)
 	j even_loop

end_form:
	lw ra 28(sp)
	addi sp sp 32
	ret
	
