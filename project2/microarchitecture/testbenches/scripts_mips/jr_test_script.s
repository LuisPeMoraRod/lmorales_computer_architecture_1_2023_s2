    xori $a0, $zero, 0x4
    xori $a1, $zero, 0x4
    xori $s0, $zero, 0xd
    jr $s0
suma:
	add $s0, $a0, $a1
    xori $a0, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf
    xori $s1, $zero, 0xf 
resta:
	sub $s0, $a0, $a1