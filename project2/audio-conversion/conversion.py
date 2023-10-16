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
            	

