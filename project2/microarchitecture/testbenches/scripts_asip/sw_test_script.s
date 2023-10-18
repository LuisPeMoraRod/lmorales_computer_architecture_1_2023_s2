xori $t1, $zero, 0x5
xori $t2, $zero, 0x8
sw $t2, 0($t1)
lw $t0, 0($t1)