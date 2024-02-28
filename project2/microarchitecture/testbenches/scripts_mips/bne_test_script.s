    xori $a0, $zero, 0x4
    xori $a1, $zero, 0x4
    bne $a0, $a1, resta
suma:
	add $s0, $a0, $a1
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf 
resta:
	sub $s0, $a0, $a1