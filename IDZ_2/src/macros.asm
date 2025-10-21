.include "io.asm"
.include "segment_utils.asm"

# -----------------------------------------------------
# PRINT_STR(adr)
# ������ ������.
# ��������:
#   adr � ����� ASCIIZ-������
# ��������:
#   �� ���� �� �������� 12(sp).
# �����:
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
# ��������� ����� � �������� ������ ������� �������� � ������� freg.
# ��������:
#   freg � ���� �������, � ������� ����� ������� ��������.
# �����:
#   jal read_double
# -----------------------------------------------------
.macro READ_DOUBLE(%freg)
	jal read_double
	fmv.d %freg fa0
.end_macro


# -----------------------------------------------------
# PRINT_DOUBLE(freg)
# ������ ������ ����� � �������� ������ ������� ��������.
# ��������:
#   freg � ���� ������� �� ��������� ��� ������.
# ��������:
#   �� ���� �� �������� 8(sp).
# �����:
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
# ��������� ������ ��������� 2^(x^2+1) + x - 3 = 0 ������� ����.
# ������ ������ �� ������� [fleft; fright], ���� ������� �� ��������,
# �� ��������� [-10; 10] � ����� 0.5, ������� � [9.5; 10].
# ���� ����� �� ������� � [-10; 10], �� �������� �� ������ � ���������� 0 � fres.
# ���������:
#   fleft � ���� ������� ����� ������� ������ �����.
#   fright � ���� ������� ������ ������� ������ �����.
#   feps - ���� ������� �������� ������.
#   fres - ���� �������, � ������� ��������� �����
# ��������:
#   ����� fa0..fa2 �������� ��������������
# �����:
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
# ��������� freg �� ���������� [eps_min; eps_max]
# ������� �� input_err ��� ������������� ��������.
# ��������:
#   freg � ���� ������� ��� ��������
#   input_err - ����� ��� ������ ��� ������.
# -----------------------------------------------------
.macro CHECK_EPSILON(%freg, %input_err)
	fld ft0 eps_max t0
	fle.d t0 %freg ft0
	beqz t0 %input_err
	
	fld ft0 eps_min t0
	fge.d t0 %freg ft0
	beqz t0 %input_err
.end_macro
