xori $b0, $zero, 0x5
salte shift_right 

trash:
xori $b0, $zero, 0x1
xori $b0, $zero, 0x1
xori $b0, $zero, 0x1
xori $b2, $zero, 0x1
xori $b2, $zero, 0x1

shift_right:
shift_d $b0, $b0, 1

fin $zero