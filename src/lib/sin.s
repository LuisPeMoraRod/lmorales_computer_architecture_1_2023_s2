.data
threshold: .float 0.0001

.equ SYS_EXIT, 93
.equ TAYLOR_TERMS, 12

.text
.globl _start

_start:
	li a1, 2
	fcvt.s.w f1, a1
	fcvt.d.s f0, f1 

	jal ra, _sin

	j _exit

#-----------------------------------------------------------------
# sin(x) 
# inputs:
#	f0 -> x (doble-precision floating-point)

#output:
#	f0 -> result
_sin:
	li t0, 0
	li t1, 0
	li t2, TAYLOR_TERMS
	li t3, 2
	
	fcvt.s.w f2, t0  # integer to single-precision float
	fcvt.d.s f1, f2  # single-precision float to double-precision float

	fmv.d f6, f0 #store x in f2

	addi sp, sp, -4
	sw ra, 0(sp) # backup ra
_sin_loop:
	addi t0, t0, 1
	beq t0, t2, _return_sin # stop condition

	rem t4, t0, t3
	beq t4, zero, _sin_loop # if t0 is even

	fmv.d f0, f6 # recover f0
	mv a0, t0
	jal ra, _taylor_term # save term to f0

	addi t1, t1, 1
	rem t4, t1, t3
	
	bne t4, zero, _sum_term # if t1 is even: sum term, if not subtract term

_sub_term:
	fsub.d f1, f1, f0
	j _next_iter

_sum_term:		
	fadd.d f1, f0, f1 # sum accumulate

_next_iter:	
	fmv.d f0, f2 # recover x to f0
	j _sin_loop

	
_return_sin:
	fmv.d f0, f1
	lw ra, 0(sp)
	addi sp, sp, 4 # recover ra
	jalr a1, 0(ra)
	
#-----------------------------------------------------------------
# Term of Taylor Series: (x^n)/(n!) 
# inputs:
#	f0 -> x (doble-precision floating-point)
#	a0 -> n (integer)

#output:
#	f0 -> result
_taylor_term:
	addi sp, sp, -4
	sw ra, 0(sp)  # backup ra

	fmv.d f5, f1  # backup f1

	# arguments for pow(a0, a0) = a0^a1
	jal ra, _pow  # f0 = x^n
	
	jal ra, _fact  # a0 = n!

	jal ra, _div_d_i  #f0 = (x^n)/(n!)

_return_taylor_term:
	fmv.d f1, f5 #recover f1

	lw ra, 0(sp)  #recover ra
	addi sp, sp, 4

	jalr a1, 0(ra)
#-----------------------------------------------------------------
# Double-precision floating point division
# input:
#	a0 -> numerator (integer)
#	a1 -> denominator (integer)

#output:
#	f0 -> double-precision floating-point

_div_i_i:
	fcvt.s.w f0, a0  # integer to single-precision float
	fcvt.s.w f1, a1  # integer to single-precision float
	
	fcvt.d.s f2, f0  # single-precision float to double-precision float
	fcvt.d.s f3, f1  # single-precision float to double-precision float

	fdiv.d f0, f2, f3  # store result of division in f0: f2/f3 = f0

_return_div_i_i:
	jalr a1, 0(ra)

#-----------------------------------------------------------------
# Double-precision floating point division
# input:
#	f0 -> numerator (double-precision float)
#	a0 -> denominator (integer)

#output:
#	f0 -> double-precision floating-point

_div_d_i:
	fcvt.s.w f2, a0  # integer to single-precision float
	fcvt.d.s f1, f2  # single-precision float to double-precision float

	fdiv.d f2, f0, f1  # store result of division in f2: f0/f1 = f1
	fmv.d f0, f2  # return result in f0

_return_div_d_i:
	jalr a1, 0(ra)

#-----------------------------------------------------------------
# Power method

# input:
# 	f0 -> base (double-precision floating point)
#	a0 -> power (integer)

#output:
#	f0 -> result: f0^a0
_pow:
	addi sp, sp, -4
	sw a0, 0(sp) # backup a0

	fmv.d f1, f0

	li a1, 1
	fcvt.s.w f1, a1
	fcvt.d.s f0, f1 # initial value: f0 = 1 

	li a1, 0  # stop condition
_pow_loop:
	beq a0, a1, _return_pow  # stop condition: a0 == 0
	
	fmul.d f0, f0, f1  # save power result in f0
	
	addi a0, a0, -1
	j _pow_loop

_return_pow:
	lw a0, 0(sp)
	addi sp, sp, 4
	jalr a1, 0(ra)


#-----------------------------------------------------------------
# Factorial method: n!
#input:
#	a0 -> n (integer)

#output:
#	a0 -> n! (integer)

_fact:
	mv a1, a0
	li a2, 1  # stop condition comparison

_fact_loop:
	beq a1, a2, _return_fact  # stop condition: a1 == 1

	addi a1, a1, -1
	mul a0, a0, a1  # save factorial result in a0
	
	j _fact_loop

_return_fact:
	jalr a1, 0(ra)

#-----------------------------------------------------------------
# Exit
	
_exit:
	# Exit the program
	li a0, 0     # Exit code
	li a7, SYS_EXIT  # Syscall number for exit
	ecall


