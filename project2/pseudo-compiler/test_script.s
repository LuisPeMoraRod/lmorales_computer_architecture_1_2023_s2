xori $b0, $zero, 0x3
salte_ig $b0, $zero, complemento_a_dos

multiplicacion:
    xori $b1, $zero, 0x4
    multiplique $b0, $b0, $b1
    salte guardar_dato

complemento_a_dos:
    xori $b0, $b0, -1
    xori $b1, $zero, 1
    sume $b0, $b0, $b1 

guardar_dato:
    xori $b2, $zero, 1
    reste $sp, $sp, $b2
    guarde $b0, $sp
    cargue $b1, $sp
    fin $zero

    
    