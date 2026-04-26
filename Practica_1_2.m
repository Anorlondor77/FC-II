% Nom complet component/s del grup
clear all
close all

%% Paràmetres base
A = 1;
fa = 100;
fs = 1e6;
Z = 50;

% 3 períodes de la senoide
T = 1/fa;
t = 0:1/fs:(3*T - 1/fs);
xa = A*sin(2*pi*fa*t);

figure(1)
plot(t, xa, 'LineWidth', 1.5)
xlabel('Temps (s)')
ylabel('Amplitud')
title('Senoide de 3 períodes')
grid on

%% FFT i eix k (sense zero padding)
N = length(xa);
X = (1/N)*fft(xa);
k = (0:N-1)*fs/N - fs/2;

figure(2)
plot(k, fftshift(abs(X)), 'LineWidth', 1.2)
xlabel('Freqüència (Hz)')
ylabel('|X(f)|')
title('FFT de la senoide (sense zero padding)')
grid on

%% Zero padding per augmentar resolució
factorZP = 16;
dimFinal = factorZP*N;
[Xzp,kzp] = FuncioTFZP(xa, fs, dimFinal);

figure(3)
plot(kzp, fftshift(abs(Xzp)), 'LineWidth', 1.2)
xlabel('Freqüència (Hz)')
ylabel('|X(f)|')
title('FFT de la senoide amb zero padding')
grid on

%% Suma de senoides
xsum = sin(2*pi*100e3*t) + 0.8*sin(2*pi*180e3*t) + 0.6*sin(2*pi*260e3*t);
[Xsum,ksum] = FuncioTFZP(xsum, fs, factorZP*length(xsum));

figure(4)
subplot(2,1,1)
plot(t, xsum, 'LineWidth', 1.2)
xlabel('Temps (s)')
ylabel('Amplitud')
title('Suma de senoides (temps)')
grid on

subplot(2,1,2)
plot(ksum, fftshift(abs(Xsum)), 'LineWidth', 1.2)
xlabel('Freqüència (Hz)')
ylabel('|X(f)|')
title('Suma de senoides (freqüència)')
grid on

%% Senyal quadrada
fq = 50e3;
xsq = square(2*pi*fq*t);
[Xsq,ksq] = FuncioTFZP(xsq, fs, factorZP*length(xsq));

figure(5)
subplot(2,1,1)
plot(t, xsq, 'LineWidth', 1.2)
xlabel('Temps (s)')
ylabel('Amplitud')
title('Senyal quadrada (temps)')
grid on

subplot(2,1,2)
plot(ksq, fftshift(abs(Xsq)), 'LineWidth', 1.2)
xlabel('Freqüència (Hz)')
ylabel('|X(f)|')
title('Senyal quadrada (freqüència)')
grid on

%% Potència en dBm
PxdBm_xsum = FuncioPotencia(Xsum, ksum, Z);

figure(6)
plot(ksum, fftshift(real(PxdBm_xsum)), 'LineWidth', 1.2)
xlabel('Freqüència (Hz)')
ylabel('Potència (dBm)')
title('Potència espectral de la suma de senoides')
grid on

%% Enventanat i comparació de lòbuls
f0 = 100.5e3; % lleugerament desalineat per veure lòbuls
Nw = 1024;
tw = (0:Nw-1)/fs;
xw = sin(2*pi*f0*tw);

wRect = ones(1,Nw);
wHam = hamming(Nw).';
wTri = triang(Nw).';

[Xrect,krect] = FuncioTFZP(xw.*wRect, fs, 16*Nw);
[Xham, kham] = FuncioTFZP(xw.*wHam, fs, 16*Nw);
[Xtri, ktri] = FuncioTFZP(xw.*wTri, fs, 16*Nw);

RectdB = 20*log10(max(fftshift(abs(Xrect))/max(abs(Xrect)), eps));
HamdB = 20*log10(max(fftshift(abs(Xham))/max(abs(Xham)), eps));
TridB = 20*log10(max(fftshift(abs(Xtri))/max(abs(Xtri)), eps));

figure(7)
plot(krect/1e3, RectdB, 'LineWidth', 1.2)
hold on
plot(kham/1e3, HamdB, 'LineWidth', 1.2)
plot(ktri/1e3, TridB, 'LineWidth', 1.2)
xlabel('Freqüència (kHz)')
ylabel('Magnitud normalitzada (dB)')
title('Comparació de lòbul principal i lòbuls secundaris')
legend('Rectangular','Hamming','Triangular')
axis([80 120 -120 5])
grid on
