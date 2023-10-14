# Instituto Tecnologico de Costa Rica
# Área Académica de Ingeniería en Computadores
# Arquitectura de Computadores I
# Proyecto Grupal 1
# Script en ensamblador con ISA MIPS
# Reverberacion de una señal de audio

.global _start

.data

	audio_0: 	 	.word 0xA000		# Reg (a0) con el puntero del audio 0
	audio_1: 	 	.word 0x1BAC6		# Reg (a1) con el puntero del audio 1
	alpha_a: 	 	.word 0b00000000	# Parte entera del alpha
	alpha_b: 	 	.word 0b10011001	# Parte fraccionaria del alpha
	red_alpha_a: 	.word 0b00000010	# Parte entera de la expresión del alpha para reducir
	red_alpha_b: 	.word 0b10000000	# Parte fraccionaria de la expresión del alpha para reducir
	k_sinfs_a:	 	.word 0b00000000	# Parte entera de k_sinfs
	k_sinfs_b:    	.word 0b00001100	# Parte fraccionaria de k_sinfs
	fs:			 	.word 44100			# Frecuencia de muestreo
	k:				.word 2205			# Retardo tiene que se un numero entero
	n:				.word 113350		# Cantidad de muestras del audio
	

_start:
	