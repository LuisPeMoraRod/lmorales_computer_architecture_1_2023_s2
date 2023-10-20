from pydub import AudioSegment
import numpy as np

def agregar_reverberacion(audio, k, alpha):

    # Convertir el AudioSegment a un array NumPy
    audio_array = np.array(audio.get_array_of_samples())

    # Crear un array para el efecto de reverberación con ceros
    reverb = np.zeros_like(audio_array)

    # Agregar el efecto de reverberación
    for i in range(k, len(audio_array)):
        #reverb[i] = audio_array[i - k] + alpha * reverb[i - k]
        
        reverb[i]= (audio_array[i]-alpha*audio_array[i-k])/(1 - alpha)

    # Sumar el audio original con el efecto de reverberación
    audio_con_reverb = audio_array + reverb

    # Crear un nuevo AudioSegment con el audio modificado
    audio_modificado = AudioSegment(
        audio_con_reverb.tobytes(),
        frame_rate=audio.frame_rate,
        sample_width=audio.sample_width,
        channels=audio.channels
    )

    return audio_modificado

# Cargar el archivo de audio de entrada
entrada = AudioSegment.from_file("badtrip_mora_7s.wav")

# Definir el retardo y la atenuación
k = 500  # Ajusta el retardo según tus preferencias
alpha = 0.2  # Ajusta la atenuación según tus preferencias

# Agregar reverberación al audio de entrada
audio_con_reverberacion = agregar_reverberacion(entrada, k, alpha)

# Guardar el audio con reverberación
audio_con_reverberacion.export("reverbAudio.wav", format="wav")
