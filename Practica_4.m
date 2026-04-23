% Nom complet component/s del grup
clear all
close all

%% Paràmetres de l'enunciat
fs = 4e6;
dim = 20000;
Ac = 1e-1;
fc = 1e6;
fm = 5e3;
Deltafmax = 10e3;
t = (0:dim-1)/fs;

%% Senyal FM base
% xfm(t) = Ac*cos(2*pi*fc*t + beta*sin(2*pi*fm*t))
beta = Deltafmax / fm;
xfm = Ac*cos(2*pi*fc*t + beta*sin(2*pi*fm*t));

% Classificació banda estreta / banda ampla (beta << 1 => estreta)
if beta < 0.3
    tipusFM = 'Banda estreta';
else
    tipusFM = 'Banda ampla';
end

% Espectre amb zero padding x15
[Xfm, kfm] = FuncioTFZP(xfm, fs, 15*dim);
idxBand = (kfm >= 0.97e6) & (kfm <= 1.03e6);

figure
subplot(2,1,1)
plot(t*1e3, xfm, 'LineWidth', 1.2)
xlabel('Temps (ms)')
ylabel('Amplitud')
title(['FM en el temps - ' tipusFM ', \beta = ' num2str(beta)])
grid on
subplot(2,1,2)
plot(kfm(idxBand)/1e6, abs(Xfm(idxBand)), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|X_{FM}(f)|')
title('Espectre FM (0.97 MHz - 1.03 MHz, zero padding x15)')
grid on

%% Validació teòrica de banda: Regla de Carson i Bessel
BW_carson = 2*(Deltafmax + fm);
ordreBessel = 0:12;
coefBessel = besselj(ordreBessel, beta);
ordresSignificatius = ordreBessel(abs(coefBessel) >= 0.01);
if isempty(ordresSignificatius)
    nMax = 0;
else
    nMax = max(ordresSignificatius);
end
BW_bessel = 2*nMax*fm;

%% Moduladora amb contínua
% xm1(t): sense contínua
% xm2(t): amb contínua
xm1 = cos(2*pi*fm*t);
xm2 = 1 + cos(2*pi*fm*t);

% Sensibilitat freqüencial (Hz/V), fixada per Deltafmax del cas xm1
kf = Deltafmax / max(abs(xm1));

Deltafmax1 = kf * max(abs(xm1));
Deltafmax2 = kf * max(abs(xm2));

beta1 = Deltafmax1 / fm;
beta2 = Deltafmax2 / fm;

% Implementació FM general via integral de la moduladora
phi1 = 2*pi*fc*t + 2*pi*kf*cumtrapz(t, xm1);
phi2 = 2*pi*fc*t + 2*pi*kf*cumtrapz(t, xm2);
vfm1 = Ac*cos(phi1);
vfm2 = Ac*cos(phi2);

[Xvfm1, kvfm1] = FuncioTFZP(vfm1, fs, 15*dim);
[Xvfm2, kvfm2] = FuncioTFZP(vfm2, fs, 15*dim);
idxBand1 = (kvfm1 >= 0.97e6) & (kvfm1 <= 1.03e6);
idxBand2 = (kvfm2 >= 0.97e6) & (kvfm2 <= 1.03e6);

figure
subplot(2,1,1)
plot(kvfm1(idxBand1)/1e6, abs(Xvfm1(idxBand1)), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|V_{FM1}(f)|')
title(['vfm1(t) - \Deltaf_{max}=' num2str(Deltafmax1/1e3) ' kHz, \beta=' num2str(beta1)])
grid on
subplot(2,1,2)
plot(kvfm2(idxBand2)/1e6, abs(Xvfm2(idxBand2)), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|V_{FM2}(f)|')
title(['vfm2(t) - \Deltaf_{max}=' num2str(Deltafmax2/1e3) ' kHz, \beta=' num2str(beta2)])
grid on

%% Anul·lació de tons amb Bessel (J0(beta)=0)
betaSweep = 2:0.001:9;
J0 = besselj(0, betaSweep);
sgn = sign(J0);
idxCanvi = find(sgn(1:end-1).*sgn(2:end) < 0);

betaZeros = zeros(1, numel(idxCanvi));
for ii = 1:numel(idxCanvi)
    b1 = betaSweep(idxCanvi(ii));
    b2 = betaSweep(idxCanvi(ii)+1);
    betaZeros(ii) = fzero(@(b) besselj(0,b), [b1 b2]);
end

fmZeros = Deltafmax ./ betaZeros;

% Comprovació espectral amb el primer zero
betaCancel = betaZeros(1);
fmCancel = fmZeros(1);
xCancel = Ac*cos(2*pi*fc*t + betaCancel*sin(2*pi*fmCancel*t));
[Xcancel, kcancel] = FuncioTFZP(xCancel, fs, 15*dim);
idxBandCancel = (kcancel >= 0.97e6) & (kcancel <= 1.03e6);

figure
plot(kcancel(idxBandCancel)/1e6, abs(Xcancel(idxBandCancel)), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|X_{cancel}(f)|')
title(['Comprovació anul·lació de portadora: J_0(\beta)=0, \beta=' num2str(betaCancel)])
grid on

% Resultats teòrics resum
resultatsFM = struct('beta', beta, 'tipusFM', tipusFM, 'BW_carson', BW_carson, ...
    'BW_bessel', BW_bessel, 'nMax', nMax, 'Deltafmax1', Deltafmax1, ...
    'Deltafmax2', Deltafmax2, 'beta1', beta1, 'beta2', beta2, ...
    'betaZeros', betaZeros, 'fmZeros', fmZeros);
