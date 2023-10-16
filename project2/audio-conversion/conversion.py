# Abre el archivo MP3 en modo binario
with open('audioTest.mp3', 'rb') as mp3_file:
    # Lee los datos binarios del archivo
    mp3_data = mp3_file.read()

# Abre un archivo de texto en el que escribirás los valores hexadecimales
with open('mp3_hex.txt', 'w') as hex_file:
    # Convierte cada byte en el archivo MP3 a un valor hexadecimal y escribe en el archivo de texto
    for byte in mp3_data:
        hex_value = hex(byte)
        hex_file.write(hex_value + '\n')

# Abre un archivo de texto en el que escribirás los valores decimales
with open('mp3_decimal.txt', 'w') as decimal_file:
    # Convierte cada valor hexadecimal a decimal y escribe en el archivo de texto
    with open('mp3_hex.txt', 'r') as hex_file:
        for line in hex_file:
            hex_value = line.strip()
            decimal_value = int(hex_value, 16)
            div = 2*decimal_value / 255
            if div == 0:
            	decimal_file.write(str(div) + '\n')
            else:
            	valor = div-1
            	decimal_file.write(str(valor) + '\n')
            	
# Abre un archivo de texto en el que escribirás los valores en formato Q7.8 con bit de signo
with open('mp3_q7.8.txt', 'w') as q7_8_signed_file:
    # Abre el archivo de valores decimales ajustados
    with open('mp3_decimal.txt', 'r') as decimal_adjusted_file:
        for line in decimal_adjusted_file:
            decimal_value = float(line.strip())
            
            # Determina el bit de signo
            if decimal_value < 0:
                sign_bit = 1
                # Convierte el valor decimal negativo a su valor absoluto
                decimal_value = abs(decimal_value)
            else:
                sign_bit = 0
            
            # Convierte el valor decimal a Q7.8
            if decimal_value > 1.0:
                decimal_value = 1.0
            
            int_part = int(decimal_value * 128)
            frac_part = int((decimal_value * 128 - int_part) * 256)
            
            q7_8_value = (sign_bit << 15) | (int_part << 8) | frac_part
            
            q7_8_signed_file.write(format(q7_8_value, '016b') + '\n')
            
# Abre un archivo de texto en el que escribirás los valores en formato hexadecimal sin "0x"
with open('final.txt', 'w') as hex_clean_file:
    # Abre el archivo de valores en formato Q7.8 con bit de signo
    with open('mp3_q7.8.txt', 'r') as q7_8_signed_file:
        for line in q7_8_signed_file:
            q7_8_value = int(line.strip(), 2)  # Convierte el valor binario a entero
            
            # Convierte el valor a formato hexadecimal y quita el "0x"
            hex_value = hex(q7_8_value)[2:]
            
            # Asegúrate de que el valor tenga una longitud de 4 caracteres (incluyendo ceros a la izquierda si es necesario)
            hex_value = hex_value.zfill(4)
            
            # Escribe el valor en formato hexadecimal sin "0x" en el archivo de texto
            hex_clean_file.write(hex_value + '\n')

