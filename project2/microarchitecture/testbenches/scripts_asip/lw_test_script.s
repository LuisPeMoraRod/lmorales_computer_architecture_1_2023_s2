xori $t0, $zero, 0x5
lw $t1, 0($t0)
xori $t2, $zero, 0x1
sub $t0, $t0, $t2
lw $t1, 0($t0)