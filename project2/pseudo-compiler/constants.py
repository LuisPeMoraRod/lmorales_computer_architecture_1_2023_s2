CLI_ERROR_CODE = 2

# types
R = 'R'
I = 'I'
J = 'J'

IMM_SIZE = 13
ADDR_SIZE = 21

#mnemonics
ADD = 'sume'
SUB = 'reste'
MULT = 'multiplique'
SLL = 'shift_i'
SRL = 'shift_d'
SLT = 'menor_que'
JR = 'salte_r'
XORI = 'xori'
BEQ = 'salte_ig'
BGT = 'salte_myq'
SW = 'guarde'
LW = 'cargue'
J = 'salte'
END = 'fin'

isa = {
    ADD : {'type': R, 'opcode': '000', 'funct': '0000'},
    SUB : {'type': R, 'opcode': '000', 'funct': '0001'},
    MULT : {'type': R, 'opcode': '000', 'funct': '0010'},
    SLL : {'type': R, 'opcode': '000', 'funct': '0011'},
    SRL : {'type': R, 'opcode': '000', 'funct': '0100'},
    SLT : {'type': R, 'opcode': '000', 'funct': '0101'},
    JR : {'type': R, 'opcode': '000', 'funct': '0110'},
    XORI : {'type': I, 'opcode': '001'},
    BEQ : {'type': I, 'opcode': '010'},
    BGT : {'type': I, 'opcode': '011'},
    SW : {'type': I, 'opcode': '100'},
    LW : {'type': I, 'opcode': '101'},
    J : {'type': J, 'opcode': '110'},
    END: {'type': None, 'opcode': '111'},
}

#Registers names
registers = {
    '$zero': '0000', 
    '$a0': '0001', 
    '$a1': '0010', 
    '$sp': '0011', 
    '$cbh': '0100', 
    '$cbt': '0101', 
    '$b0': '0110', 
    '$b1': '0111', 
    '$b2': '1000', 
    '$b3': '1001', 
    '$b4': '1010', 
    '$b5': '1011', 
    '$b6': '1100', 
    '$b7': '1101', 
    '$b8': '1110', 
    '$b9': '1111'
}
