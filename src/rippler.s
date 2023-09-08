.data
	buffer_orig: .space 307201
	buffer_new: .space 307201
.section .rodata
	.factor: .float 0.0837758040957  # Approximation of 2*pi/75
	.two_pi: .float 6.2831853071796 # Approximation of 2*pi

.equ IMG_SIZE, 307201
.equ STDIN, 0
.equ STDOUT, 1
.equ SYS_READ, 63
.equ SYS_WRITE, 64
.equ SYS_EXIT, 93
.equ TAYLOR_TERMS, 12
.equ X_SIZE, 640
.equ Y_SIZE, 480
.equ X_MAX, 639
.equ Y_MAX, 479

.text
.globl _start

_start:

	jal ra, _read_stdin
	jal ra, _rippler
	jal ra, _write_out

#-----------------------------------------------------------------
# Read input file 
_read_stdin:
	# Read from stdin
	li a0, STDIN   # File descriptor (stdin)
	la a1, buffer_orig # Buffer address
	li a2, IMG_SIZE     # Number of bytes to read
	li a7, SYS_READ     # Syscall number for read
	ecall
	jalr a1, 0(ra)

#-----------------------------------------------------------------
# Rippler effect
_rippler:
	addi sp, sp, -4
	sw ra, 0(sp) # backup ra

	mv t0, zero # iterator x
	mv t1, zero # iterator y
_rippler_loop:
	li t2, Y_SIZE # max iteration
	beq t1, t2, _return_rippler

	li t2, X_SIZE # max iteration in row
	beq t0, t2, _new_row
	
	addi sp, sp, -4
	sw t0, 0(sp) # backup t0
	addi sp, sp, -4
	sw t1, 0(sp) # backup t1
	
	mv a0, t0 #a0 -> x
	mv a6, a0 #a6 -> x
	mv a1, t1 #a1 -> y
	mv a7, a1 #a7 -> y
	jal ra, _rippler_fun #a0 -> x_aux
	
	li t0, X_MAX
	rem a4, a0, t0 # a4 -> x_new =  x_aux % 639

	bne a0, a4, _next_iter
	
	lw t1, 0(sp)
	lw t0, 4(sp)
	mv a0, t1 #a0 -> y
	mv a1, t0 #a1 -> x
	jal ra, _rippler_fun #a0 -> y_aux

	li t0, Y_MAX
	rem a5, a0, t0 # a5 -> y_new = y_aux % 479
	
	bne a0, a5, _next_iter

_reassign_byte:
	addi a4, a4, 1 #x_new + 1
	addi a5, a5, 1 #y_new + 1

	mv a0, a6
	mv a1, a7
	jal ra, _get_i #a0 = data_orig(x,y)

	mv a2, a0
	mv a0, a4
	mv a1, a5
	jal ra, _set_i # update data


_next_iter:
	lw t1, 0(sp) # recover t1
	addi sp, sp, 4 
	lw t0, 0(sp) # recover t0
	addi sp, sp, 4
	
	addi t0, t0, 1
	j _rippler_loop

_new_row:
	mv t0, zero
	addi t1, t1, 1	
	j _rippler_loop

_return_rippler:
	lw ra, 0(sp)
	addi sp, sp, 4 # recover ra
	jalr a1, 0(ra)

#-----------------------------------------------------------------
# Rippler function: x_new = x + A * sin(2*pi * y / L)
# inputs:
#	a0 -> x (integer)
#	a1 -> y (integer)

# output:
# 	a0 -> x_new (integer)

_rippler_fun:
	addi sp, sp, -4
	sw ra, 0(sp) # backup ra
	addi sp, sp, -4
	sw a0, 0(sp) # backup x

	la t3, .factor
	flw f0, 0(t3) # 2*pi/75
	fcvt.d.s f1, f0 # convert to double-precision floating-point

	fcvt.s.w f2, a1 # convert to single-precision floating-point
	fcvt.d.s f0, f2 # convert to double-precision floating-point
		
	fmul.d f2, f1, f0 #f0 = 2*pi/L * y
	fmv.d f0, f2
	jal ra, _sin 

	la t1, buffer_orig
	mv t0, zero
	lb t0, 0(t1)
	fcvt.s.w f2, t0 # convert to single-precision floating-point
	fcvt.d.s f1, f2 # convert to double-precision floating-point

	fmul.d f2, f1, f0 #f0 = A * sin(2*pi/L * y)
	fmv.d f0, f2

	lw a0, 0(sp) # recover x
	addi sp, sp, 4
	fcvt.s.w f2, a0 # convert to single-precision floating-point
	fcvt.d.s f1, f2 # convert to double-precision floating-point

	fadd.d f0, f1, f0 # f = x + A * sin(2*pi * y / L)

	fcvt.w.d a0, f0 # convert double to integer

	lw ra, 0(sp)
	addi sp, sp, 4
	jalr a1, 0(ra)
	
#-----------------------------------------------------------------
# Get byte at (i,j) position
# inputs:
#	a0 -> x
#	a1 -> y

#output:
#	a0 = data(x,y)

_get_i:
	li t0, X_SIZE
	mul t1, a1, t0 
	add t1, a0, t1 #offset
	
	la t0, buffer_orig
	add t1, t0, t1 #address of position
	addi t1, t1, 1
	lb a0, 0(t1)

	jalr a1, 0(ra)
	
#-----------------------------------------------------------------
# Set byte at (i,j) position
# inputs:
#	a0 -> x
#	a1 -> y
#	a2 -> data

_set_i:
	li t0, X_SIZE
	mul t1, a1, t0 
	add t1, a0, t1 #offset
	
	la t0, buffer_new
	add t1, t0, t1 #address of position
	addi t1, t1, 1
	sb a2, 0(t1)

	jalr a1, 0(ra)
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

_polar_redundance:
	la t4, .two_pi
	flw f2, 0(t4) # 2*pi
	fcvt.d.s f3, f2 # convert to double-precision floating-point

_p_red_loop:
	fle.d t4, f0, f3
	bnez t4, _compute_sin
	fsub.d f0, f0, f3

	j _p_red_loop

_compute_sin:

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
	j _next_iter_sin

_sum_term:		
	fadd.d f1, f0, f1 # sum accumulate

_next_iter_sin:	
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
	
	fmul.d f2, f0, f1  # save power result in f0
	fmv.d f0, f2
	
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
# Write output

_write_out:  
	#update amplitude
	la t0, buffer_orig
	mv t1, zero
	lb t1, 0(t0)
	addi t1, t1, 5

	la a1, buffer_new # Buffer address
	sb t1, 0(a1)
	
	# Write to console
	li a0, STDOUT   # File descriptor (stdout)
	li a2, IMG_SIZE   # Number of bytes to write
	li a7, SYS_WRITE    # Syscall number for write
	ecall

#-----------------------------------------------------------------
# Exit

_exit:
	# Exit the program
	li a0, 0     # Exit code
	li a7, SYS_EXIT  # Syscall number for exit
	ecall

