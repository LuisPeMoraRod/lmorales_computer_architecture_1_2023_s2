# Instituto Tecnologico de Costa Rica
# Área Académica de Ingeniería en Computadores
# Arquitectura de Computadores I
# Proyecto Grupal 1
# Script en ensamblador con ISA MIPS
# Reverberacion de una señal de audio

.global _start

_start:

	# ------------------------------------------------------------------------
	
	# Valor del inicio de los datos del audio 1.
	la $s0, audio_0 # Registro $t0 representará al registro a0
	lw $s0, ($s0)	# $a0 ya estará al inicio del programa
	
	# Se guardan valores en los espacios de memoria donde iria
	# el audio 1. Todos estos datos ya estarán en memoria
	
	li $t1, 0	# 0000 0000
	li $t2, 64  # 0100 0000
	li $t3, 128 # 1000 0000
	
	sw $t1, 0($s0)	#1a 0.25
	sw $t2, 1($s0)  #1b
	sw $t3, 2($s0)	#1a -0.25
	sw $t2, 3($s0)  #1b
	
	# Retorna los resgistros a cero
	xori $t1, $zero, 0
	xori $t2, $zero, 0
	xori $t3, $zero, 0
	
	# ------------------------------------------------------------------------

	
set_data:

	# Obtener el valor de la cantidad de datos por audio
	
	# Este seria un xori con el valor del address exacto donde esta el dato
	# xori $t0, $zero, 0x00000
	la $t0, n		# Address de donde esta n (cantidad de datos)
	# keep
	lw $t0, ($t0)	# Guarda la cantidad de datos del audio en reg $t0
	
	# ------------------------------------------------------------------------
	
	# Guardar el valor de la ultima posicion de los datos del audio para
	# saber donde terminar el programa. Se sumaria la posicion del primer
	# dato de audio y la cantidad total de datos.
	
	add $t0, $t0, $s0 # Guarda el valor de la ultima posicion de datos del audio en reg $t0
	
	# ------------------------------------------------------------------------

	# Trae el valor de alpha
	
	# Este seria un xori con el valor del address exacto donde esta el dato
	# xori $t1, $zero, 0x00000
	la $t1, alpha_b		# Address de donde esta alpha (cantidad de datos)
	# Este valor sería decimal, así que en teoría los primeros 8 bits es 
	# la parte decimal y los siguientes 8 son la parte entera con el signo
	# keep
	lw $t1, ($t1)	# Guarda el valor de alpha en reg $t1
	
	# ------------------------------------------------------------------------
	
	# Para la resta: (1 - alpha)
	
	# Se acomodan los valores en los registros respectivos para la operacion
	
	# Se ingresa el 1 a los registros para hacer la resta
	xori $t6, $zero, 1
	xori $t7, $zero, 0
	
	# Se ingresa alpha en el registro entero del segundo operando
	add $t8, $zero, $t1
	# Para dejar solo la parte entera ($t8 >> 8)
	srl $t8, $t8, 8 	# shift right logical
	
	# Se ingresa alpha en el registro fraccionario del segundo operando
	add $t9, $zero, $t1
	# Para dejar solo la parte decimal ($t9 << 16)
	# Para este ejemplo en MIPS ($t9 << 24)
	sll $t9, $t9, 24 	# shift left logical
	# Se acomoda en los primeros valores para poder se utilizado ($t9 >> 16)
	# Para este ejemplo en MIPS ($t9 >> 24)
	srl $t9, $t9, 24 	# shift right logical
	
	# Se procede a generar el resultado de la resta
	
	# Para guardar la posicion de la siguiente instruccion se utilizara
	# El registro del audio que no se está utilizando
	# Se restablece el registo $a1 ($s1 en ejemplo de MIPS)
	# Se añade la cantidad de posiciones para la siguiente instruccion
	# 1 en script real (4 para ejemplo de MIPS)
	#add $s1, pc, 4
	
	
	# jal en ejemplo MIPS para continuar en la siguiente instruccion
	# despues de hacer un j a la resta
	jal sub
	
	
	
	# ACOMODAR EL RESULTADO DE LA RESTA EN LOS REGISTROS $t6 y $t7
	# PARA CONTINUAR CON LA MULTIPLICACION SIGUIENTE CON X(N)
	# O ACOMODAR EN REGISTROS FIJOS PARA LA MULTIPLICACION EN
	# TODAS LAS ITERACIONES
	
	
	
	# test number 1
	# xori $t6, $zero, 8
	# xori $t7, $zero, 192
	
	# test number 2
	# xori $t8, $zero, 4
	# xori $t9, $zero, 128
	
	
	
reverb:

	# Revisar si se ha llegado al final del audio
	# Compara el indice actual por donde se va en el audio ($s0 en ejemplo)
	# ($a0 en script real) con $t0 que tiene el ultimo valor del audio.
	beq $s0, $t0, end
	
	# Traer el dato x(n) de memoria

	lw $t8, ($s0)	# $a0 estara en la n de la posicion del audio actual
	
	
	# ACOMODAR EL DATO EN LOS VALORES PARA LA MULTIPLICACION
	
	
	# Multiplicar (1 - alpha) con x(n)
	
	# Guardar resultado en reg 
	
	# Comp si ya se puede sumar el valor anterior de y(n)
	# si k >= n
	
	# 	Calcular n - k
	
	# 	Traer el dato y(n - k) del buffer circular
	
	# 	Multiplicar alpha con y(n - k)
	
	#	Sumar al resultado en reg $t1
	
	# GUARDAR EL Y(N) EN BUFFER CIRCULAR
	
	
	
	# TESTING ONLY
	j end
	


# ------------------------------- OPERACIONES -------------------------------- #

sum:
	# a + c
	add $t4, $t6, $t7
	# c + d
	add $t5, $t8, $t9


sub:
	# a - b
	sub $t4, $t6, $t7
	# c - d
	sub $t5, $t8, $t9
	
	# Para retornar a la siguiente instruccion desde donde se llamó
	# $ra guarda la direccion de esa instruccion en ejemplo de MIPS
	j $ra
	
	
mult:
	# high = a x c
	mul $t1, $t6, $t8 # Guarda el resultado de high en reg $t1

	
	# mid = (a x d) + (b x c)
	# (a x d)
	mul $t2, $t6, $t9
	# (b x c)
	mul $t0, $t7, $t8
	# mid result
	add $t2, $t2, $t0 # Guarda el resultado de mid en reg $t2
	# reset $t0
	xori $t0, $zero, 0 # maybe no necesario
	
	
	# low = b x d
	mul $t3, $t7, $t9 # Guarda el resultado de low en reg $t3

	
	# result = (high << 8) + mid + (low >> 8)
	# para el result: (high << 8)
	sll $t1, $t1, 8 	# shift left logical
	# para el result: (low >> 8)
	srl $t3, $t3, 8 	# shift right logical
	
	# Genera el resultado
	add $t0, $t1, $t2
	add $t0, $t0, $t3
	
# ---------------------------------------------------------------------------- #

	
end:
	li $2, 10
	syscall		# Use syscall 10 to stop simulation
	
	
	
.data

	audio_0: 	 	.word 4096			# Reg (a0) con el puntero del audio 0
	audio_1: 	 	.word 113350		# Reg (a1) con el puntero del audio 1
	alpha_a: 	 	.word 0				# Parte entera del alpha
	alpha_b: 	 	.word 153			# Parte fraccionaria del alpha
	# No, mejor calcular y guardar en variable
	red_alpha_a: 	.word 2				# Parte entera de la expresión del alpha para reducir
	red_alpha_b: 	.word 128			# Parte fraccionaria de la expresión del alpha para reducir
	# -----------------------------------------
	k_sinfs_a:	 	.word 0				# Parte entera de k_sinfs
	k_sinfs_b:    	.word 12			# Parte fraccionaria de k_sinfs
	fs:				.word 44100			# Frecuencia de muestreo
	k:				.word 2205			# Retardo tiene que se un numero entero
	n:				.word 113350		# Cantidad de muestras del audio
	