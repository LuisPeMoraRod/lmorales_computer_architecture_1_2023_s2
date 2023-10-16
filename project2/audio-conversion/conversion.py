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



