.global _start
_start:
    xori $a0, $zero, 0x4
    xori $a1, $zero, 0xa
    add $t0, $a0, $a1 