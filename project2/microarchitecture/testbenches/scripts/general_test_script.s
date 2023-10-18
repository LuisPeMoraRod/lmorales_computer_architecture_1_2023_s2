.global _start
_start:
	xori $s0, $zero, 0x3
	xori $s1, $zero, 0x3
	j next1
next2:
	xori $s0, $zero, 0x4
	xori $s1, $zero, 0x3
next1:
	sub $s2, $s1, $s0
	beq $s0, $s1, next2
	add $s3, $s0, $s1
	sw $s3, 16($s2)
	lw $s4, 16($s2)
	slt $s5, $s0, $s4
	lw $s3, 16($s2)
	xori $s3, $s2, 0x1
	xori $s5, $s5, 0x1
	jr $s5