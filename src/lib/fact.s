.text
.globl _start

_start:

	li a0, 5 # argument
	jal ra, _fact

	j _exit
_fact:
	mv a1, a0
	li a2, 1 # stop condition comparison

_fact_loop:
	addi a1, a1, -1
	mul a0, a0, a1
	
	beq a1, a2, _return_fact  # stop condition: a1 == 1

	j _fact_loop

_return_fact:
	jalr a1, 0(ra)
	
_exit:
	# Exit the program
	li a0, 0     # Exit code
	li a7, SYS_EXIT  # Syscall number for exit
	ecall

