# Instituto Tecnologico de Costa Rica
# Area Academica de Ingenieria en Computadores
# Arquitectura de Computadores I
# Proyecto Grupal 1
# Script en ensamblador con ISA propio
# Reverberacion de una señal de audio

set_data:
	
	# Se guarda el valor de la posicion del primer dato de audio
	sume $b0, $a0, $zero

	# ------------------------------------------------------------------------
	
	# Para obtener el valor de la cantidad de datos por audio (n)
	xori $b9, $zero, 0x00000        # Pone en el registro la direcion de la primera parte del dato
    cargue $b8, $b9                 # Trae la parte mayor -> 0x000001
    shift_i $b9, $b9, 8             # 0x010000
    
    xori $b9, $zero, 0x00001        # Pone en el registro la direccion de la segunda parte del dato
    cargue $b9, $b9                 # Trae la parte mayor -> 0x00BAC6
    sume $b1, $b8, $b9              # Suma los valores y los deja en $b1

	# ------------------------------------------------------------------------

    # Guardar el valor de la ultima posicion de los datos del audio para
	# saber donde terminar el programa. Se sumaria la posicion del primer
	# dato de audio y la cantidad total de datos.
	
	sume $b2, $b1, $b0 # Guarda el valor de la ultima posicion de datos del audio en reg $b2
	
    # ------------------------------------------------------------------------

	# Trae el valor de k que es solo entero
	xori $b9, $zero, 0x00003        # Pone en el registro la direcion de la primera parte del dato
    cargue $b3, $b9                 # Trae el valor de k en el registro $b3
	
	# ------------------------------------------------------------------------	

    # Trae el valor de alpha, tiene parte entera y fraccionaria
	xori $b8, $zero, 0x00002        # Pone en el registro la direcion de la primera parte del dato
    cargue $b4, $b8                 # Trae el valor de alpha en el registro $b4
	
	# ------------------------------------------------------------------------

    # Para la resta: (1 - alpha)
	
	# Se acomodan los valores en los registros respectivos para la operacion

    # Se ingresa el 1.0 a los registros para hacer la resta
	xori $b9, $zero, 256	# 1 0000 0000, para mantener la parte fraccionaria en 0
	
    # Se hace la resta normalmente y se deja el valor en $b5
	reste $b5, $b9, $b4

    # Se elimina cualquier overflow ($b5 << 8)
	shift_i $b5, $b5, 8
	# Se retornan los valores que deben quedar ($b5 >> 8)
	shift_d $b5, $b5, 8
	
	# ------------------------------------------------------------------------

	# Valor maximo del buffer para esta k
	
	# Se suma desde el valor inicial del head del circular buffer ($cbh) hasta la
	# posicion que se necesite para mantener el valor n - k, por lo que se le sumara
	# el valor de k en $b3.
	sume $b6, $cbh, $b3
	
	# ------------------------------------------------------------------------

reverb:

	# Revisar si se ha llegado al final del audio
	# Compara el indice actual por donde se va en el audio
	# $a0 con $b2 que tiene el ultimo valor del audio.
	salte_ig $a0, $b2, end
	
	# Se ingresa (1 - alpha) en el registro fraccionario del primer operando
	sume $b7, $b5, $zero
	
	# Se trae x(n) en el registro para acomodarlo como segundo operando
	cargue $b8, $a0 # $a0 estara en la n de la posicion del audio actual

    # GUARDAR VALORES EN REGISTROS EN STACK PARA SER UTILIZADOS
	# EN LA SUBRUTINA DE MULTIPLICACION
	# $b0 -> direccion del primer dato de audio
	# $b1 -> cantidad de datos por audio
	# $b2 -> direccion del ultimo dato de audio
	# $b3 -> k (valor entero, sin parte fraccionaria)
	# $b4 -> alpha
	# $b5 -> (1 - alpha)
	# $b6 -> ultima direccion donde se guardara en el buffer
	
	# Para bajar el stack pointer se le resta 1 espacio de memoria completo
    # Es temp
	xori $b9, $zero, 1 # Se deja un registro con el valor de 1

    # Primero se baja el stack pointer
	reste $sp, $sp, $b9
	# Se guarda $b0
	guarde $b0, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $b9
	# Se guarda $b1
	guarde $b1, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $b9
	# Se guarda $b2
	guarde $b2, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $b9
	# Se guarda $b3
	guarde $b3, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $b9
	# Se guarda $b4
	guarde $b4, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $b9
	# Se guarda $b5
	guarde $b5, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $b9
	# Se guarda $b6
	guarde $b6, $sp
	
	# Todos los datos se encuentran en el stack, se puede proceder con la multiplicacion
	
	# ------------------------------------------------------------------------	

    # Preparar valores para la multiplicacion

	# Se ingresa x(n) en el registro fraccionario del segundo operando
	sume $b9, $b8, $zero
	
	# Se acomodara ahora para dejarlo bien en los dos registros
	
	# Para dejar solo la parte entera ($b8 >> 8)
	shift_d $b8, $b8, 8
	
	# Para dejar solo la parte decimal ($b9 << 16)
	shift_i $b9, $b9, 16
	# Se acomoda en los primeros valores para poder se utilizado ($b9 >> 16)
	shift_d $b9, $b9, 16
	
	# ------------------------------------------------------------------------
	
    # Preparar (1 - alpha) para multiplicar
	
	# Se ingresa (1 - alpha) en el registro entero del primer operando
	sume $b6, $b5, $zero
	
	# Para dejar solo la parte entera ($b6 >> 8)
	shift_d $b6, $b6, 8
	
	# Para dejar solo la parte decimal ($b7 << 16)
	shift_i $b7, $b7, 16
	# Se acomoda en los primeros valores para poder se utilizado ($b7 >> 16)
	shift_d $b7, $b7, 16

	# ------------------------------------------------------------------------

    # Para poder llevar a cabo la multiplicacion se tiene que ir a la subrutina
    # que cumple con la funcion de llevar a cabo el algoritmo de multiplicacion
    # para los valores representados como Q7.8.

    # Se guardara el valor de un label para volver luego de haber terminado la
    # subrutina de multiplicacion. Se usara el registro del audio 2: $a1
    xori $a1, $zero, _return_after_mul1

    # Salta a la subrutina de multiplicar
    salte mult

_return_after_mul1:

	# Resultado de la multiplicacion esta en $b2
	# Aqui se tiene $b2 = alpha * y(n - k)
	# Se guarda el resultado en el registro $b8 temporalmente para poder
	# sumarlo con el resultado parcial que se reintegrara al registro $b7
	# despues de traerlo del stack
	sume $b7, $b2, $zero

	# ------------------------------------------------------------------------

	# REESTABLECER VALORES EN REGISTROS EN STACK PARA SER UTILIZADOS
	# CON LOS VALORES DE REGISTROS NORMALES
	# $b0 -> direccion del primer dato de audio
	# $b1 -> cantidad de datos por audio
	# $b2 -> direccion del ultimo dato de audio
	# $b3 -> k (valor entero, sin parte fraccionaria)
	# $b4 -> alpha
	# $b5 -> (1 - alpha)
	# $b6 -> ultima direccion donde se guardara en el buffer

	# Para subir el stack pointer se le suma 1 espacio de memoria completo
	xori $b9, $zero, 1 # Se deja un registro con el valor de 1
	
	# Primero se trae el dato al registro 
	cargue $b6, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro
	cargue $b5, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro
	cargue $b4, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro
	cargue $b3, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro
	cargue $b2, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro
	cargue $b1, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro
	cargue $b0, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Queda vacio el stack
	
	# ------------------------------------------------------------------------

	# Verificacion para ver si se puede sumar alpha * y(n - k) al resultado
	
	# si (k + direccion del primer dato de audio) < (direccion del audio actual)
	# si ($b3 + $b0) < ($a0)
	# se puede sumar alpha * y(n - k)
	
	# $b8 = $b3 + $b0
	sume $b8, $b3, $b0
	
	# Si la direccion del dato actual es mayor, se puede sumar alpha * y(n - k)
	# Si no, se pasa directo a guardar el resultado
	salte_myq $b8, $a0, save_yn  # FALTA DONDE SALTAR

    # Entonces, como ya hay suficientes datos para obtener y(n - k)
	# Se puede proceder a calcular su direccion en el buffer circular
	# y(n - k) se encuentra en la posicion siguiente al head actual donde
	# se guardara el valor de y(n): $b8 = $cbh + 1, si $cbh != $b6

	# Para subir el circular buffer head $cbh se le suma 1 espacio de memoria completo
	xori $b9, $zero, 1 # Se deja un registro con el valor de 1

    # Se debe verificar que $cbh no este en la ultima posicion del buffer circular
	# Si no $cbh + 1 sera $cbh - k ($b3)
	salte_ig $cbh, $b6, get_first
	
	# Posicion por la cual obtener y(n - k) en el buffer circular
	# $b8 = $cbh + "1", es temp
	sume $b8, $cbh, $b9

    # Logica para la suma de alpha * y(n - k)
	salte sum_ynk 

get_first:

	# Como $cbh se encuentra en la ultima posicion del buffer
	# y(n - k) se encuentra en el primer espacio del buffer
	
	# $b8 = $cbh - $b3 (k)
	reste $b8, $cbh, $b3

	# Logica para la suma de alpha * y(n - k)
	salte sum_ynk

sum_ynk:

	# El resultado parcial de y(n) esta en $b7, que quedara en el stack mientras se multiplica.
	# La direccion de memoria con y(n - k) esta en $b8.
	
	# Se ingresa alpha en el registro fraccionario del segundo operando
	sume $b9, $b4, $zero
	
	# Se trae y(n - k) en el registro $b8 temporal 
	# Se debe acomodar luego como operando en los registros correspondientes
	cargue $b8, $b8
	
	# GUARDAR VALORES EN REGISTROS EN STACK PARA SER UTILIZADOS
	# EN LA SUBRUTINA DE MULTIPLICACION
	# $b0 -> direccion del primer dato de audio
	# $b1 -> cantidad de datos por audio
	# $b2 -> direccion del ultimo dato de audio
	# $b3 -> k (valor entero, sin parte fraccionaria)
	# $b4 -> alpha
	# $b5 -> (1 - alpha)
	# $b6 -> ultima direccion donde se guardara en el buffer
	# $b7 -> resultado parcial de y(n)

   	# Para bajar el stack pointer se le resta 1 espacio de memoria completo
	# Se usa $a1 temporalmente porque no hay mas registros ya
	xori $a1, $zero, 1 # Se deja un registro con el valor de 1

    # Primero se baja el stack pointer
	reste $sp, $sp, $a1
	# Se guarda $b0
	guarde $b0, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $a1
	# Se guarda $b1
	guarde $b1, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $a1
	# Se guarda $b2
	guarde $b2, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $a1
	# Se guarda $b3
	guarde $b3, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $a1
	# Se guarda $b4
	guarde $b4, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $a1
	# Se guarda $b5
	guarde $b5, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $a1
	# Se guarda $b6
	guarde $b6, $sp
	
	# Se baja el stack pointer
	reste $sp, $sp, $a1
	# Se guarda $b7
	guarde $b7, $sp
	
	# Todos los datos se encuentran en el stack, se puede proceder con la multiplicacion
	
	# ------------------------------------------------------------------------

	# alpha completo esta en $b9
	# y(n - k) completo esta en $b8
	
	# Preparar valores para la multiplicacion

	# Se ingresa alpha en los registros del primer operando
	sume $b6, $b9, $zero
	sume $b7, $b9, $zero
	
	# Se acomodara ahora para dejarlo bien en los dos registros
	
	# Para dejar solo la parte entera ($b6 >> 8)
	shift_d $b6, $b6, 8
	
	# Para dejar solo la parte fraccionaria ($b7 << 16)
	shift_i $b7, $b7, 16
	# Se acomoda en los primeros valores para poder se utilizado ($b7 >> 16)
	shift_d $b7, $b7, 16
	
	# ------------------------------------------------------------------------

	# Se ingresa y(n - k) en los registros del segundo operando
	# ya esta en $b8
	sume $b9, $b8, $zero
	
	# Se acomodara ahora para dejarlo bien en los dos registros
	
	# Para dejar solo la parte entera ($b8 >> 8)
	shift_d $b8, $b8, 8
	
	# Para dejar solo la parte fraccionaria ($b9 << 16)
	shift_i $b9, $b9, 16
	# Se acomoda en los primeros valores para poder se utilizado ($b9 >> 16)
	shift_d $b9, $b9, 16
	
	# ------------------------------------------------------------------------	

    # Para poder llevar a cabo la multiplicacion se tiene que ir a la subrutina
    # que cumple con la funcion de llevar a cabo el algoritmo de multiplicacion
    # para los valores representados como Q7.8.

    # Se guardara el valor de un label para volver luego de haber terminado la
    # subrutina de multiplicacion. Se usara el registro del audio 2: $a1
    xori $a1, $zero, _return_after_mul2

    # Salta a la subrutina de multiplicar
    salte mult

_return_after_mul2:

	# Resultado de la multiplicacion esta en $b2
	# Aqui se tiene $b2 = alpha * y(n - k)
	# Se guarda el resultado en el registro $b8 temporalmente para poder
	# sumarlo con el resultado parcial que se reintegrara al registro $b7
	# despues de traerlo del stack
	sume $b8, $b2, $zero

	# ------------------------------------------------------------------------

	# REESTABLECER VALORES EN REGISTROS EN STACK PARA SER UTILIZADOS
	# CON LOS VALORES DE REGISTROS NORMALES
	# $b0 -> direccion del primer dato de audio
	# $b1 -> cantidad de datos por audio
	# $b2 -> direccion del ultimo dato de audio
	# $b3 -> k (valor entero, sin parte fraccionaria)
	# $b4 -> alpha
	# $b5 -> (1 - alpha)
	# $b6 -> ulyima direccion donde se guardara en el buffer
	# $b7 -> resultado parcial de y(n)

    # Para subir el stack pointer se le suma 1 espacio de memoria completo
	# Es temp
	xori $b9, $zero, 1 # Se deja un registro con el valor de 1	

    # Primero se trae el dato al registro 
	cargue $b7, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro 
	cargue $b6, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro 
	cargue $b5, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro 
	cargue $b4, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro 
	cargue $b3, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro 
	cargue $b2, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro 
	cargue $b1, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Primero se trae el dato al registro 
	cargue $b0, $sp
	# Se sube el stack pointer
	sume $sp, $sp, $b9
	
	# Queda vacio el stack
	
	# ------------------------------------------------------------------------

    # El resultado de la reciente multiplicacion esta en $b8
	# Se debe sumar ahora con el resultado parcial que se habia calculado antes ($b7)
	sume $b7, $b7, $b8
	
	# Se completa asi el calculo de y(n)
	# Puede proceder a guardarse en el buffer circular
	
	# Pasa a guardar el dato de y(n)
	salte save_yn

save_yn:

	# PROCESO DE GUARDADO DE y(n) EN EL BUFFER CIRCULAR	

	# Circular Buffer Tail: $cbt
	# Circular Buffer Head: $cbh
	
	# Se guarda el dato en la posicion que tenga guardada el head ($cbh)
	guarde $b7, $cbh

	# Si la posicion del head esta en la ultima posible posicion
	# debe retornar al inicio
	salte_ig $cbh, $b6, return_head
	
	# Para aumentar la posicion del head se le suma 1 espacio de memoria completo
	# Es temp
	xori $b9, $zero, 1 # Se deja un registro con el valor de 1
	
	# Si la posicion del tail esta en la misma posicion del head
	# Deben actualizarse ambos valores
	salte_ig $cbt, $cbh, forward_both
	
	# Se avanza el head ($cbh) a la siguiente posicion del buffer
	sume $cbh, $cbh, $b9
	
	# Termina el proceso de guardado, continuar
	salte next_data	

return_head:

	# Para obtener la posicion inicial del buffer se retara el valor de k
	# a la ultima direccion del buffer para esta especifica 
	# %b9 = $b6 - $b3, es temp
	reste $b8, $b6, $b3

	# Si la posicion del tail esta en la misma posicion del head
	# Deben actualizarse ambos valores
	salte_ig $cbt, $cbh, return_both
	
	# Se retorna el head ($cbh) a la posicion inicial del buffer
	sume $cbh, $b8, $zero
	
	# Termina el proceso de guardado, continuar
	salte next_data

return_both:

	# Se retorna el head ($cbh) a la posicion inicial del buffer
	sume $cbh, $b8, $zero
	
	# Se retorna el tail ($cbt) a la posicion inicial del buffer
	sume $cbt, $b8, $zero
	
	# Termina el proceso de guardado, continuar
	salte next_data

forward_both:

	# Se avanza el head ($cbh) a la siguiente posicion del buffer
	sume $cbh, $cbh, $b9
	
	# Se avanza el tail ($cbt) a la siguiente posicion del buffer
	sume $cbt, $cbt, $b9
	
	# Termina el proceso de guardado, continuar
	salte next_data

next_data:

	# Como ya se guardo el nuevo dato y(n) en el buffer circular,
	# se puede pasar a la siguiente posicion del audio
	
	# Para aumentar la posicion del audio se le suma 1 espacio de memoria completo
    # Es temp
	xori $b9, $zero, 1 # Se deja un registro con el valor de 1
	
	# Vuelve al inicio del ciclo de reverb
	salte reverb

mult:
	# $b3: high = a x c
	multiplique $b3, $b6, $b8 # Guarda el resultado de high en reg $b3
	sume
	# $b4: mid = (a x d) + (b x c)
	# (a x d)
	multiplique $b4, $b6, $b9
	# (b x c)
	multiplique $b1, $b7, $b8 # $b1 sobra
	# mid result
	sume $b4, $b4, $b1 # Guarda el resultado de mid en reg $b4
	
	
	# low = b x d
	multiplique $b5, $b7, $b9 # Guarda el resultado de low en reg $b5

	
	# result = (high << 8) + mid + (low >> 8)
	# para el result: (high << 8)
	shift_i $b3, $b3, 8
	# para el result: (low >> 8)
	shift_d $b5, $b5, 8
	
	# Genera el resultado
	sume $b2, $b3, $b4
	sume $b2, $b2, $b5
	
	# Para retornar a la siguiente instruccion desde donde se llamo
	# $a1 guarda la direccion de esa instruccion con el jr se vuelve al
    # valor exacto de la instruccion siguiente.
	salte_r $a1

end:
    fin $zero
