xori $b0, $zero, 0x2
xori $b1, $zero, 0x3

xori $b2, $zero, return_sum
salte sum
return_sum:

xori $b0, $zero, 0x0

sum:
    xori $b3, $zero, -1
    sume $sp, $sp, $b3
    guarde $b2, $sp

    sume $b1, $b0, $b1

    cargue $b2, $sp
    xori $b3, $zero, 1
    sume $sp, $sp, $b3

    salte_r $b2