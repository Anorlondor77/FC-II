% Nom complet component/s del grup
clear all
close all

%% PART 1: Funcions (creades en fitxers separats)
% FuncioTFZP.m
% FuncioPotencia.m

%% PART 2: Efecte del zero-padding
fs = 1.4e6;
Tobs = 10e-3;
dim = round(fs*Tobs);
t = (0:dim-1)/fs;
Z = 50;

f1 = 850;  A1 = 4;
f2 = 410;  A2 = 8;
f3 = 1580; A3 = 3;
f4 = 0;    A4 = 6;

s1 = A1*sin(2*pi*f1*t);
s2 = A2*sin(2*pi*f2*t);
s3 = A3*sin(2*pi*f3*t);
s4 = A4*cos(2*pi*f4*t);

figure(1)
subplot(3,1,1)
plot(t*1e3,s1,'LineWidth',1.2)
xlabel('Temps (ms)')
ylabel('Amplitud (V)')
title('s1(t)')
grid on

[S1, k1] = FuncioTFZP(s1, fs, dim);
subplot(3,1,2)
plot(k1, fftshift(abs(S1)), '-*')
xlabel('Freqüència (Hz)')
ylabel('|S1(f)|')
title('S1(f) sense zero-padding')
axis([-1500 1500 0 max(fftshift(abs(S1)))*1.1])
grid on

[S1zp, k1zp] = FuncioTFZP(s1, fs, 18*dim);
subplot(3,1,3)
plot(k1zp, fftshift(abs(S1zp)), '-*')
xlabel('Freqüència (Hz)')
ylabel('|S1(f)|')
title('S1(f) amb zero-padding x18')
axis([-1500 1500 0 max(fftshift(abs(S1zp)))*1.1])
grid on

deltaF_senseZP = fs/dim;
deltaF_ambZP = fs/(18*dim);
disp(['Resolució sense ZP = ', num2str(deltaF_senseZP), ' Hz'])
disp(['Resolució amb ZP x18 = ', num2str(deltaF_ambZP), ' Hz'])

%% PART 3: Suma de senoides
s12 = s1 + s2;
ssuma = s1 + s2 + s3 + s4;

figure(2)
subplot(2,1,1)
plot(t*1e3,s12,'LineWidth',1.2)
xlabel('Temps (ms)')
ylabel('Amplitud (V)')
title('s12(t)=s1(t)+s2(t)')
grid on

[S12, k12] = FuncioTFZP(s12, fs, 10*dim);
subplot(2,1,2)
plot(k12, fftshift(abs(S12)), 'LineWidth',1.2)
xlabel('Freqüència (Hz)')
ylabel('|S12(f)|')
title('S12(f) amb zero-padding x10')
axis([-3000 3000 0 max(fftshift(abs(S12)))*1.1])
grid on

figure(3)
subplot(2,1,1)
plot(t*1e3,ssuma,'LineWidth',1.2)
xlabel('Temps (ms)')
ylabel('Amplitud (V)')
title('ssuma(t)=s1+s2+s3+s4')
grid on

[Ssuma, ksuma] = FuncioTFZP(ssuma, fs, 10*dim);
subplot(2,1,2)
plot(ksuma, fftshift(abs(Ssuma)), 'LineWidth',1.2)
xlabel('Freqüència (Hz)')
ylabel('|Ssuma(f)|')
title('Ssuma(f) amb zero-padding x10')
axis([-3000 3000 0 max(fftshift(abs(Ssuma)))*1.1])
grid on

%% PART 4: Espectre de senyals quadrats
faq = 650;
q20 = 4*square(2*pi*faq*t,20) + 4;
q50 = 10*square(2*pi*faq*t,50);

figure(4)
subplot(2,1,1)
plot(t*1e3,q20,'LineWidth',1.2)
xlabel('Temps (ms)')
ylabel('Amplitud (V)')
title('q20(t)')
grid on

subplot(2,1,2)
plot(t*1e3,q50,'LineWidth',1.2)
xlabel('Temps (ms)')
ylabel('Amplitud (V)')
title('q50(t)')
grid on

[Q20, kQ20] = FuncioTFZP(q20, fs, 10*dim);
[Q50, kQ50] = FuncioTFZP(q50, fs, 10*dim);

figure(5)
subplot(2,1,1)
plot(kQ20, fftshift(abs(Q20)), 'LineWidth',1.2)
xlabel('Freqüència (Hz)')
ylabel('|Q20(f)|')
title('Espectre Q20(f)')
axis([-6000 6000 0 max(fftshift(abs(Q20)))*1.1])
grid on

subplot(2,1,2)
plot(kQ50, fftshift(abs(Q50)), 'LineWidth',1.2)
xlabel('Freqüència (Hz)')
ylabel('|Q50(f)|')
title('Espectre Q50(f)')
axis([-6000 6000 0 max(fftshift(abs(Q50)))*1.1])
grid on

PQ20dBm = FuncioPotencia(Q20, kQ20, Z);
PQ50dBm = FuncioPotencia(Q50, kQ50, Z);

figure(6)
subplot(2,1,1)
plot(kQ20, fftshift(real(PQ20dBm)), 'LineWidth',1.2)
xlabel('Freqüència (Hz)')
ylabel('Potència (dBm)')
title('Potència Q20(f)')
axis([-6000 6000 min(fftshift(real(PQ20dBm))) max(fftshift(real(PQ20dBm)))+3])
grid on

subplot(2,1,2)
plot(kQ50, fftshift(real(PQ50dBm)), 'LineWidth',1.2)
xlabel('Freqüència (Hz)')
ylabel('Potència (dBm)')
title('Potència Q50(f)')
axis([-6000 6000 min(fftshift(real(PQ50dBm))) max(fftshift(real(PQ50dBm)))+3])
grid on

%% PART 5: Enfinestrament
fsw = 1.6e6;
dimw = 10000;
fw = 4.5e3;
tw = (0:dimw-1)/fsw;
g = sin(2*pi*fw*tw);

w_ham = window(@hamming, dimw);
w_tri = window(@triang, dimw);

g_ham = g.*w_ham';
g_tri = g.*w_tri';

figure(7)
subplot(3,1,1)
plot(tw*1e3,g,'LineWidth',1.2)
xlabel('Temps (ms)')
ylabel('Amplitud')
title('g(t) - rectangular')
grid on

subplot(3,1,2)
plot(tw*1e3,g_ham,'LineWidth',1.2)
xlabel('Temps (ms)')
ylabel('Amplitud')
title('g_{ham}(t)')
grid on

subplot(3,1,3)
plot(tw*1e3,g_tri,'LineWidth',1.2)
xlabel('Temps (ms)')
ylabel('Amplitud')
title('g_{tri}(t)')
grid on

[G, kG] = FuncioTFZP(g, fsw, 16*dimw);
[Gham, kGham] = FuncioTFZP(g_ham, fsw, 16*dimw);
[Gtri, kGtri] = FuncioTFZP(g_tri, fsw, 16*dimw);

figure(8)
subplot(3,1,1)
plot(kG, fftshift(abs(G)), 'LineWidth',1.2)
xlabel('Freqüència (Hz)')
ylabel('|G(f)|')
title('Espectre de g(t)')
axis([3500 5500 0 max(fftshift(abs(G)))*1.1])
grid on

subplot(3,1,2)
plot(kGham, fftshift(abs(Gham)), 'LineWidth',1.2)
xlabel('Freqüència (Hz)')
ylabel('|G_{ham}(f)|')
title('Espectre de g_{ham}(t)')
axis([3500 5500 0 max(fftshift(abs(Gham)))*1.1])
grid on

subplot(3,1,3)
plot(kGtri, fftshift(abs(Gtri)), 'LineWidth',1.2)
xlabel('Freqüència (Hz)')
ylabel('|G_{tri}(f)|')
title('Espectre de g_{tri}(t)')
axis([3500 5500 0 max(fftshift(abs(Gtri)))*1.1])
grid on

Gm = fftshift(abs(G));
Ghm = fftshift(abs(Gham));
Gtm = fftshift(abs(Gtri));

idxMain = find(abs(kG-fw) == min(abs(kG-fw)), 1);

maskLS = (kG > fw+200) & (kG < fw+2200);
LS_rect = max(Gm(maskLS));
LS_ham = max(Ghm(maskLS));
LS_tri = max(Gtm(maskLS));

LP_rect = Gm(idxMain)/LS_rect;
LP_ham = Ghm(idxMain)/LS_ham;
LP_tri = Gtm(idxMain)/LS_tri;

disp(['LP/LS rectangular = ', num2str(LP_rect), ' (', num2str(20*log10(LP_rect)), ' dB)'])
disp(['LP/LS hamming = ', num2str(LP_ham), ' (', num2str(20*log10(LP_ham)), ' dB)'])
disp(['LP/LS triangular = ', num2str(LP_tri), ' (', num2str(20*log10(LP_tri)), ' dB)'])
