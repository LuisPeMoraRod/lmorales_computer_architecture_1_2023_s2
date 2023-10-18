.global _start
_start:
	xori $t0, $zero, 0xf
	xori $a0, $zero, 0x3
	sw $t0, 0($a0)
    lw $t1, 0($a0)
    add $t1, $t1, $a0