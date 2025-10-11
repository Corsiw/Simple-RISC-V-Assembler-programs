.include "sqrt.asm"
.include "io.asm"

.macro SQRT(%freg_num, %freg_tol)
	addi sp sp -16
	fsd %freg_num 8(sp)
	fsd %freg_tol 0(sp)
	jal sqrt_f64
	addi sp sp 16
.end_macro

.macro PRINT_STR(%adr)
	addi sp sp -16
	la t0 %adr
	sw t0 12(sp)
	jal print_string
	addi sp sp 16
.end_macro

.macro PRINT_DOUBLE(%freg)
	addi sp sp -16
	fsd %freg 8(sp)
	jal print_double
	addi sp sp 16
.end_macro

.macro READ_DOUBLE(%freg)
	jal read_double
	fmv.d %freg fa0
.end_macro

.macro CHECK_INPUT(%freg, %input_err)
	fld ft0 zero_d t0
	fge.d t0 %freg ft0
	beqz t0 %input_err
.end_macro
	

