# Abre el primer archivo MP3 en modo binario
with open('audioClean.mp3', 'rb') as mp3_file1:
    # Lee los datos binarios del primer archivo
    mp3_data1 = mp3_file1.read()

# Abre el segundo archivo MP3 en modo binario
with open('reverbAudio.mp3', 'rb') as mp3_file2:
    # Lee los datos binarios del segundo archivo
    mp3_data2 = mp3_file2.read()



# Abre un archivo de texto en el que escribirás los valores hexadecimales sin el prefijo "0x" y con dos dígitos
with open('mp3_hex.txt', 'w') as hex_file:
    # Convierte cada byte en el primer archivo MP3 a un valor hexadecimal y escribe en el archivo de texto
    for byte in mp3_data1:
        hex_value = hex(byte)[2:]  # Elimina el prefijo "0x"
        # Añade ceros a la izquierda para que el valor tenga dos dígitos
        hex_value = hex_value.zfill(2)
        hex_file.write(hex_value + '\n')

    # Convierte cada byte en el segundo archivo MP3 a un valor hexadecimal y escribe en el archivo de texto
    for byte in mp3_data2:
        hex_value = hex(byte)[2:]  # Elimina el prefijo "0x"
        # Añade ceros a la izquierda para que el valor tenga dos dígitos
        hex_value = hex_value.zfill(2)
        hex_file.write(hex_value + '\n')


# Abre un archivo de texto para escribir los valores decimales
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

# Abre un archivo de texto para escribir los valores Q7.8
with open('mp3_q7.8.txt', 'w') as binary_file:
    # Convierte cada valor decimal a binario en formato Q7.8 y escribe en el archivo de texto
    with open('mp3_decimal.txt', 'r') as decimal_file:
        for line in decimal_file:
            decimal_value = float(line)
            # Convierte el valor decimal a binario en formato Q7.8
            binary_value = bin(int(decimal_value * (2 ** 8)) & 0xFFFF)  # Multiplica por 2^8 y convierte a binario
            binary_file.write(binary_value[2:].zfill(16) + '\n')  # Añade ceros a la izquierda para tener 16 bits


# Abre un archivo de texto para los valores hexadecimales
with open('final.txt', 'w') as hex_4digits_file:
    # Abre el archivo de valores Q7.8
    with open('mp3_q7.8.txt', 'r') as q7_8_file:
        for line in q7_8_file:
            q7_8_value = int(line.strip(), 2)  # Convierte el valor binario a decimal
            
            # Convierte el valor decimal a hexadecimal de cuatro dígitos
            hex_4digits = format(q7_8_value, '04X')
            
            # Escribe el valor en formato hexadecimal de cuatro dígitos en el archivo de texto
            hex_4digits_file.write(hex_4digits + '\n')


# Abre un archivo MIF para escribir los valores
with open('mp3_data.mif', 'w') as mif_file:
    # Escribe el encabezado del archivo MIF
    mif_file.write("DEPTH = 262144;\n")  # Cambia la profundidad según tus necesidades
    mif_file.write("WIDTH = 16;\n")
    mif_file.write("ADDRESS_RADIX = HEX;\n")
    mif_file.write("DATA_RADIX = HEX;\n")
    mif_file.write("CONTENT\n")
    mif_file.write("BEGIN\n")

    # Abre el archivo de valores hexadecimales de cuatro dígitos
    with open('final.txt', 'r') as final:

        # Coloca los valores de las constantes en la posición de memoria necesaria
        
        mif_file.write("00000 : 0001;\n")
        mif_file.write("00001 : BAC6;\n")
        mif_file.write("00002 : 0099;\n")
        mif_file.write("00003 : 089D;\n")
        mif_file.write("00004 : 000C;\n")
        mif_file.write("00005 : AC44;\n")
        mif_file.write("00006 : 0280;\n")

        

        # Rellena las posiciones de memoria de 0x00000 a 0x00FFF con ceros
        for address in range(0x00007, 0x01000):
            mif_file.write(f"{address:05X} : 0000;\n")
            
        address = 0x01000  # Inicializa la dirección de memoria en 0x01000
        
        for line in final:
            hex_value = line.strip()
            if address >= 0x01000 and address <= 0x3858B:
                mif_file.write(f"{address:05X} : {hex_value.upper()};\n")
                address += 1
                

        # Rellena las posiciones de memoria de 0x00000 a 0x00FFF con ceros
        for address in range(0x3858C, 0x40000):
            mif_file.write(f"{address:05X} : 0000;\n")

    # Cierra el archivo MIF
    mif_file.write("END;\n")



