.global _start
_start:
    xori $a0, $zero, 0x8
	srl $t0, $a0, 0x3
    xori $t1, $zero, 0x5
    add $t0, $t0, $t1