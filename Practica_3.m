% Nom complet component/s del grup
clear all
close all

%% Paràmetres
fs = 1e6;
Tobs = 5e-3;
t = 0:1/fs:(Tobs-1/fs);
Z = 50;
fm = 5e3;
fc = 100e3;
m = 0.8;

%% Senyals moduladora i portadora
xm = cos(2*pi*fm*t);
xc = cos(2*pi*fc*t);

%% AM: sAM(t) = (1 + m*xm(t))*xc(t)
sAM = (1 + m*xm).*xc;
[Xam, kam] = FuncioTFZP(sAM, fs, 8*length(sAM));

figure
subplot(2,1,1)
plot(t*1e3, sAM, 'LineWidth', 1.2)
xlabel('Temps (ms)')
ylabel('Amplitud')
title('Senyal AM en el temps')
grid on
subplot(2,1,2)
plot(kam/1e3, abs(Xam), 'LineWidth', 1.2)
xlabel('Freqüència (kHz)')
ylabel('|S_{AM}(f)|')
title('Espectre de la senyal AM')
axis([0 200 0 max(abs(Xam))*1.1])
grid on

%% Càlcul de m amb Emax i Emin (envolvent)
envAM = abs(hilbert(sAM));
Emax = max(envAM);
Emin = min(envAM);
m_temps = (Emax - Emin) / (Emax + Emin);

%% Càlcul de m amb espectre (fc i fc±fm)
[~, idx_fc] = min(abs(kam - fc));
[~, idx_fm_sup] = min(abs(kam - (fc + fm)));
A_fc = abs(Xam(idx_fc));
A_sb = abs(Xam(idx_fm_sup));
m_espectre = 2*(A_sb/A_fc);

%% Potència en dBm
PAMdBm = FuncioPotencia(Xam, kam, Z);
figure
plot(kam/1e3, PAMdBm, 'LineWidth', 1.2)
xlabel('Freqüència (kHz)')
ylabel('Potència (dBm)')
title('Potència espectral AM (Z = 50 \Omega)')
axis([0 200 min(PAMdBm) max(PAMdBm)+5])
grid on

%% DBL: sDBL(t) = xm(t)*xc(t)
sDBL = xm.*xc;
[Xdbl, kdbl] = FuncioTFZP(sDBL, fs, 8*length(sDBL));

figure
subplot(2,1,1)
plot(t*1e3, sDBL, 'LineWidth', 1.2)
xlabel('Temps (ms)')
ylabel('Amplitud')
title('Senyal DBL en el temps')
grid on
subplot(2,1,2)
plot(kdbl/1e3, abs(Xdbl), 'LineWidth', 1.2)
xlabel('Freqüència (kHz)')
ylabel('|S_{DBL}(f)|')
title('Espectre DBL')
axis([0 200 0 max(abs(Xdbl))*1.1])
grid on

%% BLU: BLS i BLI (mètode en quadratura)
% Per senyal sinusoidal: Hilbert{cos(2*pi*fm*t)} = sin(2*pi*fm*t)
xh = sin(2*pi*fm*t);
sBLS = xm.*cos(2*pi*fc*t) - xh.*sin(2*pi*fc*t);
sBLI = xm.*cos(2*pi*fc*t) + xh.*sin(2*pi*fc*t);

[Xbls, kbls] = FuncioTFZP(sBLS, fs, 8*length(sBLS));
[Xbli, kbli] = FuncioTFZP(sBLI, fs, 8*length(sBLI));

figure
subplot(2,1,1)
plot(kbls/1e3, abs(Xbls), 'LineWidth', 1.2)
xlabel('Freqüència (kHz)')
ylabel('|S_{BLS}(f)|')
title('Espectre BLU - BLS')
axis([0 200 0 max(abs(Xbls))*1.1])
grid on
subplot(2,1,2)
plot(kbli/1e3, abs(Xbli), 'LineWidth', 1.2)
xlabel('Freqüència (kHz)')
ylabel('|S_{BLI}(f)|')
title('Espectre BLU - BLI')
axis([0 200 0 max(abs(Xbli))*1.1])
grid on

% Resum de valors de m
m_estimacions = [m_temps, m_espectre];
