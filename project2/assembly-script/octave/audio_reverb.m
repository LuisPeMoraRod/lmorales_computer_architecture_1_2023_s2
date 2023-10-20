% Autor : Luis Chavarria Zamora
% Software : GNU/Octave
% Codigo de ejemplo para insercion y retiro de reverberacion

% Borra lo anterior
clear
clc

% Lectura del archivo
[archivo, fs] = audioread('badtrip_mora_7s.wav');

%disp(size(archivo));
%disp(fs);

% Parametros del filtro
alpha = 0.2;
k_sinfs = 0.500;

% Ajuste para el retardo k
k = fs * k_sinfs;

% Redondeo hacia abajo, pues k debe ser entero
k = floor(k);

% Se crea una matriz de k filas llena de
% ceros para implementar el retardo hasta k muestras
polos = zeros(1, k);

% Se coloca el y(n)
polos(1) = 1;

% Se coloca el retardo a la muestra y(n−k )
polos(k) = alpha;

% Se coloca la atenuacion (1 − alpha) a la muestra x(n)
ceros = 1 - alpha;

% Aplica el filtro
salida_filtro = filter(ceros, polos, archivo) ;

% Reproduce el sonido
player_salida = audioplayer(salida_filtro, fs) ;
play(player_salida) ;

% Eliminacion de reverberacion
input('Presione enter para escuchar reverberacion eliminada') ;
% Se invierten Y y X al ser un proceso inverso
salida_filtro = filter(polos, ceros, salida_filtro) ;
player_salida = audioplayer(salida_filtro, fs) ;
play(player_salida);

