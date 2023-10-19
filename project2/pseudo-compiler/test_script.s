#comment
suma:
    cargue $b2, $b3
    guarde $b0, $b1 #comment
    salte resta
    salte_myq $b0, $b1, resta
    xori $b0, $zero, -1
    xori $b0, $zero, 0x3
    salte_ig $b0, $b1, suma
resta:
    xori $b0, $zero, 0x4
    fin $zero
    
    