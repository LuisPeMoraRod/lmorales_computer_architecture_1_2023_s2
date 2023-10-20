xori $b0, $zero, 0x5
xori $b1, $zero, 0x4
salte_myq $b0, $b1, shift_right 

trash:
xori $b2, $zero, 0x1
xori $b2, $zero, 0x1
xori $b2, $zero, 0x1
xori $b2, $zero, 0x1
xori $b2, $zero, 0x1

shift_right:
shift_d $b0, $b0, 1

fin $zero