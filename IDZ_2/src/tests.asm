j test
.include "macros.asm"

.data
	nl:          .asciz "\n"
	
	msg1:      .asciz "\n义耱 1: eps = 1e-3; a, b for root near 0.5"
	test1a:     .double 0.5
	test1b:     .double 1.0
	test1eps:  .double 0.001
	
	msg2:      .asciz "\n义耱 2: eps = 1e-5; bad a , b"
	test2a:     .double 2.0
	test2b:     .double 3.0
	test2eps:  .double 0.00001
	
	msg3:      .asciz "\n义耱 3: eps = 1e-8; a, b for root = -1"
	test3a:     .double -1.5
	test3b:     .double -0.5
	test3eps:  .double 0.000000001
	
	msg4:      .asciz "\n义耱 4: eps = 1e-12; a, b for root = -1"
	test4a:     .double -1.5
	test4b:     .double -0.5
	test4eps:  .double 0.0000000000001
	
	msg5:      .asciz "\n义耱 5: eps = 10.0; bad a, b"
	test5a:     .double 12.0
	test5b:     .double 13.0
	test5eps:  .double 10.0
	
	msg6:      .asciz "\n义耱 6: eps = 10.0; only eps range check"
	test6eps:  .double 10.0
	
	msg7:      .asciz "\n义耱 7: eps = 1e-17; only eps range check"
	test7eps:  .double 0.00000000000000001

.text
.globl test

# TEST1
test:
	PRINT_STR(msg1)
	fld fa0 test1a t0
	fld fa1 test1b t0
	fld fa2 test1eps t0
	CHECK_EPSILON(fa2, calc1)
calc1:
	SEGMENT_METHOD(fa0, fa1, fa2, fa4)
	PRINT_STR(nl)
	PRINT_DOUBLE(fa4)

# TEST2
	PRINT_STR(msg2)
	fld fa0 test2a t0
	fld fa1 test2b t0
	fld fa2 test2eps t0
	SEGMENT_METHOD(fa0, fa1, fa2, fa4)
	PRINT_STR(nl)
	PRINT_DOUBLE(fa4)
	
# TEST3	
	PRINT_STR(msg3)
	fld fa0 test3a t0
	fld fa1 test3b t0
	fld fa2 test3eps t0
	SEGMENT_METHOD(fa0, fa1, fa2, fa4)
	PRINT_STR(nl)
	PRINT_DOUBLE(fa4)
	
# TEST4
	PRINT_STR(msg4)
	fld fa0 test4a t0
	fld fa1 test4b t0
	fld fa2 test4eps t0
	SEGMENT_METHOD(fa0, fa1, fa2, fa4)
	PRINT_STR(nl)
	PRINT_DOUBLE(fa4)
	
# TEST5
	PRINT_STR(msg5)
	fld fa0 test5a t0
	fld fa1 test5b t0
	fld fa2 test5eps t0
	SEGMENT_METHOD(fa0, fa1, fa2, fa4)
	PRINT_STR(nl)
	PRINT_DOUBLE(fa4)
	
# TEST6
	PRINT_STR(msg6)
	fld fa2 test6eps t0
	CHECK_EPSILON(fa2, set_default_eps1)
	PRINT_STR(nl)
	PRINT_DOUBLE(fa2)
	j test7
	
set_default_eps1:
	fld fa2 eps_min t0
	PRINT_STR(nl)
	PRINT_DOUBLE(fa2)
	
# TEST7
test7:
	PRINT_STR(msg7)
	fld fa2 test7eps t0
	CHECK_EPSILON(fa2, set_default_eps2)
	PRINT_STR(nl)
	PRINT_DOUBLE(fa2)
	j test7
	
set_default_eps2:
	fld fa2 eps_min t0
	PRINT_STR(nl)
	PRINT_DOUBLE(fa2)
	
end:
	li a7 10
	ecall
