.global _start
_start:
	xori $a0, $zero, 0x4
	xori $t1, $zero, 0x1
	lw $t0, 0($a0)
	add $t0, $t0, $t1
	xori $t2, $zero, 0x1
    xori $t2, $zero, 0x2
    xori $t2, $zero, 0x3
    xori $t2, $zero, 0x4