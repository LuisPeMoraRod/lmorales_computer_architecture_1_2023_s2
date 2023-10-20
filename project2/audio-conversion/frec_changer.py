import scipy.io.wavfile as wav
import scipy.signal
import numpy as np

def cambiar_frecuencia_muestreo(input_file, output_file, nueva_frecuencia):
    # Cargar el archivo WAV original
    fs, data = wav.read(input_file)

    # Calcular la relación de cambio de frecuencia
    relacion_frecuencia = nueva_frecuencia / fs

    # Aplicar la re-muestreo para cambiar la frecuencia de muestreo
    data_resampled = scipy.signal.resample(data, int(len(data) * relacion_frecuencia))

    # Guardar el archivo WAV con la nueva frecuencia de muestreo
    wav.write(output_file, nueva_frecuencia, data_resampled.astype(np.int16))

    print(f"Frecuencia de muestreo cambiada a {nueva_frecuencia} y archivo guardado como {output_file}")

# Ejemplo de uso
archivo_entrada = "audioClean.wav"
archivo_salida = "output.wav"
nueva_frecuencia = 17500  # Frecuencia de muestreo deseada en Hz

cambiar_frecuencia_muestreo(archivo_entrada, archivo_salida, nueva_frecuencia)
