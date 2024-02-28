.global _start
_start:
    xori $a0, $zero, 0x6
    xori $a1, $zero, 0xa
    sub $t0, $a0, $a1