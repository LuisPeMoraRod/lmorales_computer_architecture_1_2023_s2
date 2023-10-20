# Abre el archivo MP3 en modo binario
with open('audioTest.mp3', 'rb') as mp3_file:
    # Lee los datos binarios del archivo
    mp3_data = mp3_file.read()

# Abre un archivo de texto en el que escribirás los valores hexadecimales sin el prefijo "0x" y con dos dígitos
with open('mp3_hex.txt', 'w') as hex_file:
    # Convierte cada byte en el archivo MP3 a un valor hexadecimal y escribe en el archivo de texto
    for byte in mp3_data:
        hex_value = hex(byte)[2:]  # Elimina el prefijo "0x"
        # Añade ceros a la izquierda para que el valor tenga dos dígitos
        hex_value = hex_value.zfill(2)
        hex_file.write(hex_value + '\n')

# Abre un archivo de texto en el que escribirás los valores decimales con solo dos dígitos decimales
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


# Abre un archivo de texto en el que escribirás los valores binarios en formato Q7.8
with open('mp3_q7.8.txt', 'w') as binary_file:
    # Convierte cada valor decimal a binario en formato Q7.8 y escribe en el archivo de texto
    with open('mp3_decimal.txt', 'r') as decimal_file:
        for line in decimal_file:
            decimal_value = float(line)
            # Convierte el valor decimal a binario en formato Q7.8
            binary_value = bin(int(decimal_value * (2 ** 8)) & 0xFFFF)  # Multiplica por 2^8 y convierte a binario
            binary_file.write(binary_value[2:].zfill(16) + '\n')  # Añade ceros a la izquierda para tener 16 bits

