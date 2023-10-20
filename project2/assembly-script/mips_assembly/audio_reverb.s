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
	
	# Valor del inicio de los datos del audio 2.
	la $s1, audio_1 # Registro $t0 representará al registro a0
	lw $s1, ($s1)	# $a1 ya estará al inicio del programa
	
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
	
	# $s2 es $cbt
	li $s2, 1007
	# $s3 es $cbh
	li $s3, 901
	
	# $s6 será el $sp que empezaría en 0x40000
	li $s6, 1024  # Empieza en 0x400
	
	# test number 1
	# xori $t6, $zero, 8
	# xori $t7, $zero, 192
	
	# test number 2
	# xori $t8, $zero, 4
	# xori $t9, $zero, 128
	
	# ------------------------------------------------------------------------

set_data:

	# Se guarda el valor de la posicion del primer dato de audio
	add $t0, $s0, $zero

	# ------------------------------------------------------------------------
	
	# Obtener el valor de la cantidad de datos por audio
	
	# Este seria un xori con el valor del address exacto donde esta el dato
	# xori $t9, $zero, 0x00000
	la $t9, n		# Address de donde esta n (cantidad de datos)
	# keep
	lw $t1, ($t9)	# Guarda la cantidad de datos del audio en reg $t1
	
	# VIENE EN DOS POSICIONES DE MEMORIA AL SER MAYOR DE 4 HEX 
	
	# ------------------------------------------------------------------------
	
	# Guardar el valor de la ultima posicion de los datos del audio para
	# saber donde terminar el programa. Se sumaria la posicion del primer
	# dato de audio y la cantidad total de datos.
	
	add $t2, $t1, $t0 # Guarda el valor de la ultima posicion de datos del audio en reg $t2
	
	# ------------------------------------------------------------------------

	# Trae el valor de k
	
	# Este seria un xori con el valor del address exacto donde esta el dato
	# xori $t1, $zero, 0x00001
	la $t3, k		# Address de donde esta el valor de k
	# Este valor es entero, por lo que no cumple con los primeros 8 bits de
	# parte fraccionaria
	lw $t3, ($t3)	# Guarda el valor de k en reg $t3
	
	# ------------------------------------------------------------------------	

	# Trae el valor de alpha
	
	# Este seria un xori con el valor del address exacto donde esta el dato
	# xori $t1, $zero, 0x00000
	la $t9, alpha		# Address de donde esta alpha (cantidad de datos)
	# Este valor sería fraccional, así que en teoría los primeros 8 bits es 
	# la parte decimal y los siguientes 8 son la parte entera con el signo
	lw $t4, ($t9)	# Guarda el valor de alpha en reg $t4
	
	# ------------------------------------------------------------------------
	
	# Para la resta: (1 - alpha)
	
	# Se acomodan los valores en los registros respectivos para la operacion

	# Se ingresa el 1.0 a los registros para hacer la resta
	xori $t8, $zero, 256	# 1 0000 0000, para mantener la parte fraccionaria en 0
	
	# Se hace la resta normalmente
	sub $t5, $t8, $t4
	
	# Se elimina cualquier overflow ($t5 << 8)
	# Para este ejemplo en MIPS ($t5 << 16)
	sll $t5, $t5, 16 	# shift left logical
	# Se retornan los valores que deben quedar ($t5 >> 8)
	# Para este ejemplo en MIPS ($t5 >> 16)
	srl $t5, $t5, 16 	# shift right logical
	
	# ------------------------------------------------------------------------
	
	# Valor máximo del buffer para esta k
	
	# Se suma desde el valor inicial del head del circular buffer ($cbh) hasta la
	# posicion que se necesite para mantener el valor n - k, por lo que se le sumará
	# el valor de k en $t3.
	# $cbh aqui es $s3
	add $t6, $s3, $t3
	
	# ------------------------------------------------------------------------
	
	# Guardar el valor inical del buffer en el registro del otro audio
	# $a1 en script real ($s1 en MIPS)
	# add $s1, $s3, $zero
	# ESTO SE PODRIA ACOMODAR EN UN REGISTRO DE PROPOSITO GENERAL
	# PERO HAY QUE REVISAR EN REVERB SI SE USA DE MANERA TEMPORAL

reverb:

	# Revisar si se ha llegado al final del audio
	# Compara el indice actual por donde se va en el audio ($s0 en ejemplo)
	# ($a0 en script real) con $t2 que tiene el ultimo valor del audio.
	beq $s0, $t2, end
	
	# Se ingresa (1 - alpha) en el registro fraccionario del primer operando
	add $t7, $t5, $zero
	
	# Se trae x(n) en el registro para acomodarlo como segundo operando
	lw $t8, ($s0)	# $a0 estara en la n de la posicion del audio actual
	
	# GUARDAR VALORES EN REGISTROS EN STACK PARA SER UTILIZADOS
	# EN LA SUBRUTINA DE MULTIPLICACION
	# $t0 -> dirección del primer dato de audio
	# $t1 -> cantidad de datos por audio
	# $t2 -> dirección del último dato de audio
	# $t3 -> k (valor entero, sin parte fraccionaria)
	# $t4 -> alpha
	# $t5 -> (1 - alpha)
	# $t6 -> ultima direccion donde se guardara en el buffer
	
	# $s6 será $sp en el script real
	
	# Para bajar el stack pointer se le resta 1 espacio de memoria completo
	# Para MIPS se le restarán 4 pero para el real será solo 1, es temp
	xori $t9, $zero, 4 # Se deja un registro con el valor de 1
	
	# Primero se baja el stack pointer
	sub $s6, $s6, $t9
	# Se guarda $t0
	sw $t0, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $t9
	# Se guarda $t1
	sw $t1, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $t9
	# Se guarda $t2
	sw $t2, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $t9
	# Se guarda $t3
	sw $t3, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $t9
	# Se guarda $t4
	sw $t4, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $t9
	# Se guarda $t5
	sw $t5, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $t9
	# Se guarda $t5
	sw $t6, ($s6)
	
	# Todos los datos se encuentran en el stack, se puede proceder con la multiplicacion
	
	# ------------------------------------------------------------------------	
	
	# Preparar valores para la multiplicacion

	# Se ingresa x(n) en el registro fraccionario del segundo operando
	add $t9, $t8, $zero
	
	# Se acomodará ahora para dejarlo bien en los dos registros
	
	# Para dejar solo la parte entera ($t8 >> 8)
	srl $t8, $t8, 8 	# shift right logical
	
	# Para dejar solo la parte decimal ($t9 << 16)
	# Para este ejemplo en MIPS ($t9 << 24)
	sll $t9, $t9, 24 	# shift left logical
	# Se acomoda en los primeros valores para poder se utilizado ($t9 >> 16)
	# Para este ejemplo en MIPS ($t9 >> 24)
	srl $t9, $t9, 24 	# shift right logical
	
	# ------------------------------------------------------------------------
	
	# Preparar (1 - alpha) para multiplicar
	
	# Se ingresa (1 - alpha) en el registro entero del primer operando
	add $t6, $t5, $zero
	
	# Para dejar solo la parte entera ($t6 >> 8)
	srl $t6, $t6, 8 	# shift right logical
	
	# Para dejar solo la parte decimal ($t7 << 16)
	# Para este ejemplo en MIPS ($t7 << 24)
	sll $t7, $t7, 24 	# shift left logical
	# Se acomoda en los primeros valores para poder se utilizado ($t7 >> 16)
	# Para este ejemplo en MIPS ($t7 >> 24)
	srl $t7, $t7, 24 	# shift right logical

	# ------------------------------------------------------------------------
	
	# guardar aqui en un registro la posicion de la instruccion luego de la multiplicacion
	# para poder usar el jr para continuar
	
	# Para guardar la posicion de la siguiente instruccion se utilizara
	# posiblemente el registro del audio que no se está utilizando
	# Se restablece el registo $a1 ($s1 en ejemplo de MIPS)
	# Se añade la cantidad de posiciones para la siguiente instruccion
	# 1 en script real (4 para ejemplo de MIPS)
	#add $s1, pc, 4
	
	# jal en ejemplo MIPS para continuar en la siguiente instruccion
	# despues de hacer un j a la multiplicacion
	jal mult
	
	# Resultado de la multiplicacion está en $t2
	# Aqui se tiene $t2 = (1 - alpha) * x(n)
	# Se guarda el resultado en el registro que mantendrá el resultado: $t7
	add $t7, $t2, $zero
	
	# ------------------------------------------------------------------------
	
	# REESTABLECER VALORES EN REGISTROS EN STACK PARA SER UTILIZADOS
	# CON LOS VALORES DE REGISTROS NORMALES
	# $t0 -> dirección del primer dato de audio
	# $t1 -> cantidad de datos por audio
	# $t2 -> dirección del último dato de audio
	# $t3 -> k (valor entero, sin parte fraccionaria)
	# $t4 -> alpha
	# $t5 -> (1 - alpha)
	# $t6 -> ulyima direccion donde se guardara en el buffer
	
	# $s6 es $sp en el script real
	
	# Para subir el stack pointer se le suma 1 espacio de memoria completo
	# Para MIPS se le sumarán 4 pero para el real será solo 1, es temp
	xori $t9, $zero, 4 # Se deja un registro con el valor de 1
	
	# Primero se trae el dato al registro 
	lw $t6, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t5, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t4, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t3, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t2, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t1, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t0, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Queda vacio el stack
	
	# ------------------------------------------------------------------------
	
	# Verificación para ver si se puede sumar alpha * y(n - k) al resultado
	
	# si (k + direccion del primer dato de audio) < (dirección del audio actual)
	# si ($t3 + $t0) < ($a0)
	# se puede sumar alpha * y(n - k)
	
	# $t8 = $t3 + $t0
	add $t8, $t3, $t0
	
	# Si la direccion del dato actual es mayor, se puede sumar alpha * y(n - k)
	# Si no, se pasa directo a guardar el resultado
	bgt $t8, $a0, save_yn
	
	# Entonces, como ya hay suficientes datos para obtener y(n - k)
	# Se puede proceder a calcular su direccion en el buffer circular
	# y(n - k) se encuentra en la posicion siguiente al head actual donde
	# se guardará el valor de y(n): $t8 = $cbh + 1, si $cbh != $t6
		
	# Para subir el circular buffer head ($cbh) $s3 se le suma 1 espacio de memoria completo
	# Para MIPS se le sumarán 4 pero para el real será solo 1, es temp
	xori $t9, $zero, 4 # Se deja un registro con el valor de 1
	
	# Se debe verificar que $cbh no esté en la ultima posicion del buffer circualr
	# Si no $cbh + 1 será $cbh - k ($t3)
	beq $s3, $t6, get_first
	
	# Posición por la cual obtener y(n - k) en el buffer circular
	# $t8 = $cbh + "1", es temp
	add $t8, $s6, $t9
	
	# Lógica para la suma de alpha * y(n - k)
	j sum_ynk
	
get_first:

	# Como $cbh se encuentra en la última posición del buffer
	# y(n - k) se encuentra en el primer espacio del buffer
	
	# $t8 = $cbh - $t3 (k)
	sub $t8, $s6, $t3

	# Lógica para la suma de alpha * y(n - k)
	j sum_ynk
	
sum_ynk:

	# El resultado parcial de y(n) está en $t7, que quedará en el stack mientras se multiplica
	# La direccion de memoria con y(n - k) está en $t8
	
	# Se ingresa alpha en el registro fraccionario del segundo operando
	add $t9, $t4, $zero
	
	# Se trae y(n - k) en el registro $t8 temporal 
	# Se debe acomodar luego como operando en los registros correspondientes
	lw $t8, ($t8)
	
	# GUARDAR VALORES EN REGISTROS EN STACK PARA SER UTILIZADOS
	# EN LA SUBRUTINA DE MULTIPLICACION
	# $t0 -> dirección del primer dato de audio
	# $t1 -> cantidad de datos por audio
	# $t2 -> dirección del último dato de audio
	# $t3 -> k (valor entero, sin parte fraccionaria)
	# $t4 -> alpha
	# $t5 -> (1 - alpha)
	# $t6 -> ultima direccion donde se guardara en el buffer
	# $t7 -> resultado parcial de y(n)
	
	# $s6 será $sp en el script real
	
	# Para bajar el stack pointer se le resta 1 espacio de memoria completo
	# Para MIPS se le restarán 4 pero para el real será solo 1, es temp
	# Se usa $s1 porque no hay mas registros ya
	xori $s1, $zero, 4 # Se deja un registro con el valor de 1
	
	# Primero se baja el stack pointer
	sub $s6, $s6, $s1
	# Se guarda $t0
	sw $t0, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $s1
	# Se guarda $t1
	sw $t1, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $s1
	# Se guarda $t2
	sw $t2, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $s1
	# Se guarda $t3
	sw $t3, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $s1
	# Se guarda $t4
	sw $t4, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $s1
	# Se guarda $t5
	sw $t5, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $s1
	# Se guarda $t6
	sw $t6, ($s6)
	
	# Se baja el stack pointer
	sub $s6, $s6, $s1
	# Se guarda $t7
	sw $t7, ($s6)
	
	# Todos los datos se encuentran en el stack, se puede proceder con la multiplicacion
	
	# ------------------------------------------------------------------------
	
	# alpha completo está en $t9
	# y(n - k) completo está en $t8
	
	# Preparar valores para la multiplicacion

	# Se ingresa alpha en los registros del primer operando
	add $t6, $t9, $zero
	add $t7, $t9, $zero
	
	# Se acomodará ahora para dejarlo bien en los dos registros
	
	# Para dejar solo la parte entera ($t6 >> 8)
	srl $t6, $t6, 8 	# shift right logical
	
	# Para dejar solo la parte fraccionaria ($t7 << 16)
	# Para este ejemplo en MIPS ($t7 << 24)
	sll $t7, $t7, 24 	# shift left logical
	# Se acomoda en los primeros valores para poder se utilizado ($t7 >> 16)
	# Para este ejemplo en MIPS ($t7 >> 24)
	srl $t7, $t7, 24 	# shift right logical
	
	# ------------------------------------------------------------------------

	# Se ingresa y(n - k) en los registros del segundo operando
	# ya está en $t8
	add $t9, $t8, $zero
	
	# Se acomodará ahora para dejarlo bien en los dos registros
	
	# Para dejar solo la parte entera ($t8 >> 8)
	srl $t8, $t8, 8 	# shift right logical
	
	# Para dejar solo la parte fraccionaria ($t9 << 16)
	# Para este ejemplo en MIPS ($t9 << 24)
	sll $t9, $t9, 24 	# shift left logical
	# Se acomoda en los primeros valores para poder se utilizado ($t9 >> 16)
	# Para este ejemplo en MIPS ($t9 >> 24)
	srl $t9, $t9, 24 	# shift right logical
	
	# ------------------------------------------------------------------------	
	
	# guardar aqui en un registro la posicion de la instruccion luego de la multiplicacion
	# para poder usar el jr para continuar
	
	# Para guardar la posicion de la siguiente instruccion se utilizara
	# posiblemente el registro del audio que no se está utilizando
	# Se restablece el registo $a1 ($s1 en ejemplo de MIPS)
	# Se añade la cantidad de posiciones para la siguiente instruccion
	# 1 en script real (4 para ejemplo de MIPS)
	#add $s1, pc, 4
	
	# jal en ejemplo MIPS para continuar en la siguiente instruccion
	# despues de hacer un j a la multiplicacion
	jal mult	
	
	# Resultado de la multiplicacion está en $t2
	# Aqui se tiene $t2 = alpha * y(n - k)
	# Se guarda el resultado en el registro $t8 temporalmente para poder
	# sumarlo con el resultado parcial que se reintegrará al registro $t7
	# despues de traerlo del stack
	add $t8, $t2, $zero
	
	# ------------------------------------------------------------------------
	
	# REESTABLECER VALORES EN REGISTROS EN STACK PARA SER UTILIZADOS
	# CON LOS VALORES DE REGISTROS NORMALES
	# $t0 -> dirección del primer dato de audio
	# $t1 -> cantidad de datos por audio
	# $t2 -> dirección del último dato de audio
	# $t3 -> k (valor entero, sin parte fraccionaria)
	# $t4 -> alpha
	# $t5 -> (1 - alpha)
	# $t6 -> ulyima direccion donde se guardara en el buffer
	# $t7 -> resultado parcial de y(n)
	
	# $s6 es $sp en el script real
	
	# Para subir el stack pointer se le suma 1 espacio de memoria completo
	# Para MIPS se le sumarán 4 pero para el real será solo 1, es temp
	xori $t9, $zero, 4 # Se deja un registro con el valor de 1	
	
	# Primero se trae el dato al registro 
	lw $t7, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t6, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t5, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t4, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t3, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t2, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t1, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Primero se trae el dato al registro 
	lw $t0, ($s6)
	# Se sube el stack pointer
	add $s6, $s6, $t9
	
	# Queda vacio el stack
	
	# ------------------------------------------------------------------------
	
	# El resultado de la reciente multiplicacion está en $t8
	# Se debe sumar ahora con el resultado parcial que se habia calculado antes ($t7)
	add $t7, $t7, $t8
	
	# Se completa así el calculo de y(n)
	# Puede proceder a guardarse en el buffer circular
	
	# Pasa a guardar el dato de y(n)
	j save_yn
	
	
save_yn:

	# PROCESO DE GUARDADO DE y(n) EN EL BUFFER CIRCULAR	

	# Circular Buffer Tail: $cbt -> $s2
	# Circular Buffer Head: $cbh -> $s3
	
	
	# Se guarda el dato en la posición que tenga guardada el head ($cbh)
	sw $t7, ($s3)

	# Si la posicion del head está en la ultima posible posición
	# debe retornar al inicio
	beq $s3, $t6, return_head
	
	# Para aumentar la posicion del head se le suma 1 espacio de memoria completo
	# Para MIPS se le sumarán 4 pero para el real será solo 1, es temp
	xori $t9, $zero, 4 # Se deja un registro con el valor de 1
	
	# Si la posicion del tail está en la misma posición del head
	# Deben actualizarse ambos valores
	beq $s2, $s3, forward_both
	
	# Se avanza el head ($s3) -> ($cbh) a la siguiente posición del buffer
	add $s3, $t9, $zero
	
	# Termina el proceso de guardado, continuar
	j next_data	

	
return_head:

	# Para obtener la posicion inicial del buffer se retará el valor de k
	# a la ultima dirección del buffer para esta especifica 
	# %t9 = $t6 - $t3, es temp
	sub $t8, $t6, $t3

	# Si la posicion del tail está en la misma posición del head
	# Deben actualizarse ambos valores
	beq $s2, $s3, return_both
	
	# Se retorna el head ($s3) -> ($cbh) a la posición inicial del buffer
	add $s3, $t8, $zero
	
	# Termina el proceso de guardado, continuar
	j next_data
	
	
return_both:

	# Se retorna el head ($s3) -> ($cbh) a la posición inicial del buffer
	add $s3, $t8, $zero
	
	# Se retorna el tail ($s2) -> ($cbt) a la posición inicial del buffer
	add $s2, $t8, $zero
	
	# Termina el proceso de guardado, continuar
	j next_data
	
	
forward_both:

	# Se avanza el head ($s3) -> ($cbh) a la siguiente posición del buffer
	add $s3, $t9, $zero
	
	# Se avanza el tail ($s2) -> ($cbt) a la siguiente posición del buffer
	add $s2, $t9, $zero
	
	# Termina el proceso de guardado, continuar
	j next_data
	
	
next_data:

	# Como ya se guardó el nuevo dato y(n) en el buffer circular,
	# se puede pasar a la siguiente posicion del audio
	
	# Para aumentar la posicion del audio se le suma 1 espacio de memoria completo
	# Para MIPS se le sumarán 4 pero para el real será solo 1, es temp
	xori $t9, $zero, 4 # Se deja un registro con el valor de 1
	
	# Vuelve al inicio del ciclo de reverb
	j reverb

mult:
	# $t3: high = a x c
	mul $t3, $t6, $t8 # Guarda el resultado de high en reg $t3

	
	# $t4: mid = (a x d) + (b x c)
	# (a x d)
	mul $t4, $t6, $t9
	# (b x c)
	mul $t1, $t7, $t8 # $t1 sobra
	# mid result
	add $t4, $t4, $t1 # Guarda el resultado de mid en reg $t4
	# reset $t0
	# xori $t0, $zero, 0 # maybe no necesario
	
	
	# low = b x d
	mul $t5, $t7, $t9 # Guarda el resultado de low en reg $t5

	
	# result = (high << 8) + mid + (low >> 8)
	# para el result: (high << 8)
	sll $t3, $t3, 8 	# shift left logical
	# para el result: (low >> 8)
	srl $t5, $t5, 8 	# shift right logical
	
	# Genera el resultado
	add $t2, $t3, $t4
	add $t2, $t2, $t5
	
	# Para retornar a la siguiente instruccion desde donde se llamó
	# $ra guarda la direccion de esa instruccion en ejemplo de MIPS
	# En el script real se usará un jr con el valor exacto de la instruccion siguiente
	j $ra
	
# ---------------------------------------------------------------------------- #
	
end:
	li $2, 10
	syscall		# Use syscall 10 to stop simulation
	
	
	
.data

	audio_0: 	 	.word 4096			# Reg (a0) con el puntero del audio_0 0 x 00 10 00
	audio_1: 	 	.word 117446		# Reg (a1) con el puntero del audio_1 0 x 01 CA C6
	alpha:	 	 	.word 153			# alpha 0 x 00 00 99
	# No, mejor calcular y guardar en variable
	red_alpha_a: 	.word 2				# Parte entera de la expresión del alpha para reducir
	red_alpha_b: 	.word 128			# Parte fraccionaria de la expresión del alpha para reducir
	# -----------------------------------------
	k_sinfs_a:	 	.word 0				# Parte entera de k_sinfs
	k_sinfs_b:    	.word 12			# Parte fraccionaria de k_sinfs 0 x 00 00 0C
	fs:				.word 44100			# Frecuencia de muestreo 0 x 00 AC 44
	k:				.word 2205			# Retardo tiene que se un numero entero 0 x 00 08 9D
	n:				.word 113350		# Cantidad de muestras del audio 0 x 01 BA C6
