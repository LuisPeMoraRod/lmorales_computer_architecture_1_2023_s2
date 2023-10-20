# Instituto Tecnologico de Costa Rica
# Área Académica de Ingeniería en Computadores
# Arquitectura de Computadores I
# Proyecto Grupal 1
# Script en ensamblador con ISA propio
# Reverberacion de una señal de audio

set_data:
	
	# Se guarda el valor de la posicion del primer dato de audio
	add $t0, $a0, $zero

	# ------------------------------------------------------------------------
	
	# Para obtener el valor de la cantidad de datos por audio
	xori $b9, $zero, 0x00000        # Pone en el registro la direcion de la primera parte del dato
    cargue $b8, $b9                 # Trae la parte mayor -> 0x000001
    shift_i $b9, $b9, 8             # 0x010000
    
    xori $t8, $zero, 0x00001
    
