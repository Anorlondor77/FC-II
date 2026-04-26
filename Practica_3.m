% Nom complet component/s del grup
clear all
close all

%% Parametres
fs = 1e8;              % frequencia de mostreig
dim = 12000;           % nombre de mostres
t = (0:dim-1)/fs;      % vector temporal
Z = 50;                % impedancia en ohms

Am = 1;                % amplitud moduladora
fm = 125e3;            % frequencia moduladora
Ac = 0.25;             % amplitud portadora
fc = 3.2e6;            % frequencia portadora
m = 0.8;               % index de modulacio AM

%% Senyals moduladora i portadora
xm = Am*cos(2*pi*fm*t);
xc = Ac*cos(2*pi*fc*t);

%% MODULACIO AM
sAM = (1 + m*xm).*xc;

figure(1)
subplot(2,1,1)
plot(t*1e6, sAM, 'LineWidth', 1.2)
xlabel('Temps (\mus)')
ylabel('Amplitud (V)')
title('Senyal AM en el domini temporal')
axis([0 40 min(sAM)*1.1 max(sAM)*1.1])
grid on

[Xam, kam] = FuncioTFZP(sAM, fs, 10*dim);
XamShift = fftshift(Xam);
SAm = abs(XamShift);

subplot(2,1,2)
plot(kam/1e6, SAm, 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|S_{AM}(f)|')
title('Espectre del senyal AM')
axis([2.9 3.5 0 max(SAm)*1.1])
grid on

%% Calcul de m a partir d'Emax i Emin de l'envolvent
envAM = Ac*(1 + m*xm);
Emax = max(envAM);
Emin = min(envAM);
m_temps = (Emax - Emin)/(Emax + Emin);

disp(['Index de modulacio m calculat en el temps = ', num2str(m_temps)])

%% Identificacio de tons de l'espectre
[~, idx_fc] = min(abs(kam - fc));
[~, idx_sb_sup] = min(abs(kam - (fc + fm)));
[~, idx_sb_inf] = min(abs(kam - (fc - fm)));

A_fc = abs(XamShift(idx_fc));
A_sb_sup = abs(XamShift(idx_sb_sup));
A_sb_inf = abs(XamShift(idx_sb_inf));

disp(['To portadora a fc = ', num2str(kam(idx_fc)/1e6), ' MHz'])
disp(['To lateral superior a fc+fm = ', num2str(kam(idx_sb_sup)/1e6), ' MHz'])
disp(['To lateral inferior a fc-fm = ', num2str(kam(idx_sb_inf)/1e6), ' MHz'])

%% Potencia del senyal AM
PAMdBm = FuncioPotencia(Xam, kam, Z);
figure(2)
Pplot = fftshift(real(PAMdBm));
PplotRel = Pplot - max(Pplot);

plot(kam/1e6, PplotRel, 'LineWidth', 1.2)
hold on
plot(kam(idx_fc)/1e6, PplotRel(idx_fc), 'ro', 'MarkerFaceColor', 'r')
plot(kam(idx_sb_sup)/1e6, PplotRel(idx_sb_sup), 'ko', 'MarkerFaceColor', 'k')
plot(kam(idx_sb_inf)/1e6, PplotRel(idx_sb_inf), 'ko', 'MarkerFaceColor', 'k')

xlabel('Freqüència (MHz)')
ylabel('Potència relativa (dBc)')
title('Potència del senyal AM (pics principals marcats)')
axis([2.9 3.5 -80 2])
grid on

%% Calcul de m a partir de l'espectre
% En AM: amplitud lateral = (m/2)*amplitud portadora
m_espectre = 2*(A_sb_sup/A_fc);

disp(['Index de modulacio m calculat amb l''espectre = ', num2str(m_espectre)])
disp(['Diferencia lateral-portadora (teoric) = ', num2str(20*log10(m/2)), ' dB'])
disp(['Diferencia lateral-portadora (mesurat) = ', num2str(20*log10(A_sb_sup/A_fc)), ' dB'])

%% MODULACIO DBL
sDBL = xm.*xc;
[Xdbl, kdbl] = FuncioTFZP(sDBL, fs, 10*dim);

figure(3)
subplot(2,1,1)
plot(t*1e6, sDBL, 'LineWidth', 1.2)
xlabel('Temps (\mus)')
ylabel('Amplitud (V)')
title('Senyal DBL en el domini temporal')
axis([0 40 min(sDBL)*1.1 max(sDBL)*1.1])
grid on

subplot(2,1,2)
plot(kdbl/1e6, fftshift(abs(Xdbl)), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|S_{DBL}(f)|')
title('Espectre del senyal DBL')
axis([2.9 3.5 0 max(fftshift(abs(Xdbl)))*1.1])
grid on

%% MODULACIO BLU
% x~m(t) = Am*sin(2*pi*fm*t)
xmh = Am*sin(2*pi*fm*t);

% Eq. BLU: sBLU(t) = xm(t)*xc(t) ± x~m(t)*Ac*sin(2*pi*fc*t)
sBLS = xm.*xc - xmh.*Ac.*sin(2*pi*fc*t);   % Banda lateral superior
sBLI = xm.*xc + xmh.*Ac.*sin(2*pi*fc*t);   % Banda lateral inferior

[Xbls, kbls] = FuncioTFZP(sBLS, fs, 10*dim);
[Xbli, kbli] = FuncioTFZP(sBLI, fs, 10*dim);

figure(4)
subplot(2,1,1)
plot(kbli/1e6, fftshift(abs(Xbli)), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|S_{BLI}(f)|')
title('Espectre BLU - BLI')
axis([2.9 3.5 0 max(fftshift(abs(Xbli)))*1.1])
grid on

subplot(2,1,2)
plot(kbls/1e6, fftshift(abs(Xbls)), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|S_{BLS}(f)|')
title('Espectre BLU - BLS')
axis([2.9 3.5 0 max(fftshift(abs(Xbls)))*1.1])
grid on

%% Variables finals de comprovacio
m_estimacions = [m_temps, m_espectre];
freq_interes = [fc-fm, fc, fc+fm];

disp('Valors finals de m:')
disp(m_estimacions)

disp('Freqüències d''interès (Hz):')
disp(freq_interes)
