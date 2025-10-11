.data 
	half_const: .double 0.5
	one_const: .double 1.0
	default_tol: .double 1.0e-6
	zero_d: .double 0.0
	max_iter: .word 50

.text
	.globl sqrt_f64
	
sqrt_f64:
	addi sp sp -32
	sw ra 28(sp)
	sw s0 24(sp)
	fsd fs0 16(sp)
	fsd fs1 8(sp)
	addi s0 sp 32
	
	fld fs0 8(s0)
	fld fs1 0(s0)

	fld ft0 zero_d t0
	feq.d t0 fs0 ft0 # t0 = 1 if a ==0.0
	bnez t0 ret_zero
	
	flt.d t0 fs0 ft0 # t0 = 1 if a < 0.0
	bnez t0 ret_neg
	
	# if tol == 0.0 -> load default_tol
	feq.d t0 fs1 ft0
	beqz t0 tol_ok
	fld fs1 default_tol t0

tol_ok:
	# init statring value x0
	# if a > 1.0: x0 = a/2
	# else: x0 = 1.0
	
	fld ft1 one_const t0
	flt.d t0 ft1 fs0 # t0 = 1 if a > 1.0
	beqz t0 guess_one
	
	# guess = a / 2
	fld ft2 half_const t1
	fmul.d ft0 fs0 ft2
	j iter_start


guess_one:
	fmv.d ft0 ft1 # ft0 = 1.0
	
	
iter_start:
	li t1 0
	li t2 50 
	
loop:
	# ft3 = a / x_n
	fdiv.d ft3 fs0 ft0
	
	# x_n+1 = 0.5 * (x_n + a/x_n) -> ft4
	fadd.d ft4 ft0 ft3
	fld ft5 half_const t3
	fmul.d ft4 ft4 ft5
	
	# ft6 = dif
	fsub.d ft6, ft4, ft0
	
	# check |dif| < tol:
	fneg.d ft7 ft6
	flt.d t3 ft6 fs1 # t3 = 1 if dif < tol
	flt.d t4 ft7 fs1 # t4 = 1 if -dif < tol
	and t5 t3 t4
	bnez t5 done
	
	# x_n = x_n+1
	fmv.d ft0 ft4
	
	addi t1 t1 1
	blt t1 t2 loop
	
done:
	fmv.d fa0 ft4
	j return

ret_zero:
	fmv.d fa0 ft0
	j return

ret_neg:
	fmv.d fa0 fs0
	j return
	
return:
	lw ra 28(sp)
	lw s0 24(sp)
	fld fs0 16(sp)
	fld fs1 8(sp)
	addi sp sp 32
	ret