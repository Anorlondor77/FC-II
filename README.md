# FC-II

## Instrucciones para Codex

Genera código MATLAB completo y ejecutable para cada archivo.

### Reglas
- Cada script empieza con:
```matlab
% Nombre autores
clear all
close all
```
- Código claro y ordenado
- Respetar figuras, ejes y unidades
- No inventar nada

---

# PRACTICA 0

## Enunciado

### Operaciones básicas
- Crear vectores fila y columna
- Transponer vectores
- Sumar vectores
- Multiplicar elemento a elemento (.*)

### Vectores
- Crear vector de 1000 muestras:
  - inicio = 0
  - paso = 2.5
- Crear mismo vector con linspace

### Matrices
- Crear matriz 6x6
- Usar size

### Operaciones con matrices
- Elevar elementos al cuadrado
- Sumar escalar
- Multiplicar escalar
- Transpuesta
- Inversa
- Comprobar conmutatividad

### Extracción de datos
- Columna 4 → vec1
- Fila 2 → vec2
- Elemento 3 de vec1
- Elemento 1 de vec2

### Señales
- v1: 160 muestras, 8 bloques alternos (0 y 1)
- v2: 160 muestras de 20 a 100
- t: inicio 0, paso 2

### Representación
- plot(v1, v2 vs t)
- usar: figure, hold, xlabel, ylabel, title, legend, axis

### Complejos
- Crear vector comp1 (10 valores complejos)
- Obtener:
  - real
  - imag
  - abs
  - fase en grados

---

# PRACTICA 1-2

## Enunciado

### Funciones
Crear:

[X,k] = FuncioTFZP(x,fs,dimFinal)

[PxdBm] = FuncioPotencia(X,k,Z)

### Parte práctica
- Generar senoide:
  - A = 1
  - fa = 100 Hz
  - fs = 1e6
  - representar 3 periodos

- FFT:
  - usar fft
  - usar fftshift
  - construir eje k

- Zero padding:
  - aumentar resolución frecuencial

- Suma de senoides

- Señal cuadrada:
  - usar square

- Potencia:
  - calcular en dBm
  - Z = 50 ohm

- Enventanado:
  - rectangular
  - hamming
  - triangular

- Comparar lóbulos:
  - principal
  - secundarios

---

# PRACTICA 3

## Enunciado

### Señales
- xm(t): moduladora
- xc(t): portadora

### AM
- sAM(t) = (1 + m*xm(t))*xc(t)
- m = 0.8

- Representar:
  - tiempo
  - frecuencia

- Calcular m:
  - con Emax y Emin
  - con espectro

### Espectro
- fc
- fc ± fm

### Potencia
- calcular en dBm (Z = 50 ohm)

### DBL
- sDBL(t) = xm(t)*xc(t)

### BLU
- BLS
- BLI
- usar seno y coseno

---

# PRACTICA 4

## Enunciado

### Parámetros
- fs = 4e6
- dim = 20000

### Señal FM
- Ac = 1e-1
- fc = 1e6
- fm = 5e3
- Δfmax = 10e3

xfm(t) = Ac*cos(2*pi*fc*t + beta*sin(2*pi*fm*t))

### Cálculos
- beta = Δfmax / fm
- determinar si banda estrecha o ancha

### Espectro
- usar FuncioTFZP
- zero padding x15
- rango: 0.97 MHz – 1.03 MHz

### Moduladora con continua
- xm1(t)
- xm2(t)

- calcular:
  - Δfmax
  - beta
  - vfm1(t)
  - vfm2(t)

### Anulación de tonos
- usar funciones de Bessel
- variar beta entre 2 y 9
- encontrar ceros
- calcular fm
- comprobar en espectro
