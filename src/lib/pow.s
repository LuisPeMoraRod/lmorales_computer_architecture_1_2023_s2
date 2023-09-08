.equ SYS_EXIT, 93

.text
.globl _start

_start:

	li a0, 3 # argument: base
	li a1, 3 # argument: power
	jal ra, _pow

	j _exit
_pow:
	mv a2, a0
	li a0, 1 # initial value
	li a3, 0 # stop condition
_pow_loop:
	beq a1, a3, _return_pow  # stop condition: a1 == 0
	
	mul a0, a0, a2 # save power result in a0
	
	addi a1, a1, -1
	j _pow_loop

_return_pow:
	jalr a1, 0(ra)
	
_exit:
	# Exit the program
	li a0, 0     # Exit code
	li a7, SYS_EXIT  # Syscall number for exit
	ecall

