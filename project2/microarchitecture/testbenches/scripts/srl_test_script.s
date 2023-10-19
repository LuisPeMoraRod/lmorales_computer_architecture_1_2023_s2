.global _start
_start:
    xori $a0, $zero, 0x8
	sll $t0, $a0, 0x3
    xori $t1, $zero, 0x5
    add $t0, $t0, $t1