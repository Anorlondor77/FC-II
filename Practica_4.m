% Nom complet component/s del grup
clear all
close all

%% Paràmetres generals
fs = 4e6;
dim = 20000;
t = (0:dim-1)/fs;

%% 1) Senyal FM principal
Ac = 1e-1;
fc = 1e6;
fm = 5e3;
Deltafmax = 10e3;

beta = Deltafmax/fm;
xfm = Ac*cos(2*pi*fc*t + beta*sin(2*pi*fm*t));

if beta > 0.2
    tipusFM = 'Banda ampla';
elseif beta < 0.2
    tipusFM = 'Banda estreta';
else
    tipusFM = 'Cas límit (beta = 0.2)';
end

[Xfm, kfm] = FuncioTFZP(xfm, fs, 15*dim);

figure(1)
subplot(2,1,1)
plot(t*1e3, xfm, 'LineWidth', 1.2)
xlabel('Temps (ms)')
ylabel('Amplitud (V)')
title(['Senyal FM principal al temps - ' tipusFM])
axis([0 0.2 min(xfm)*1.1 max(xfm)*1.1])
grid on

subplot(2,1,2)
plot(kfm/1e6, fftshift(abs(Xfm)), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|X_{FM}(f)|')
title('Espectre FM principal (zero padding x15)')
axis([0.97 1.03 0 max(fftshift(abs(Xfm)))*1.1])
grid on

%% 2) Moduladora amb contínua (valors exactes enunciat)
fm2 = 10e3;
Am = 3;
Constant1 = 0;
Constant2 = 15;
fc2 = 1e6;
Ac2 = 2;
K1 = 5e3;

Deltafmax2 = K1*Am;
beta2 = Deltafmax2/fm2;

vfm1 = Ac2*cos(2*pi*(fc2 + K1*Constant1)*t + beta2*sin(2*pi*fm2*t));
vfm2 = Ac2*cos(2*pi*(fc2 + K1*Constant2)*t + beta2*sin(2*pi*fm2*t));

[Xvfm1, kvfm1] = FuncioTFZP(vfm1, fs, 15*dim);
[Xvfm2, kvfm2] = FuncioTFZP(vfm2, fs, 15*dim);

figure(2)
subplot(2,1,1)
plot(kvfm1/1e6, fftshift(abs(Xvfm1)), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|V_{FM1}(f)|')
title('Espectre vfm1(t) (centrat a 1 MHz)')
axis([0.85 1.25 0 max(fftshift(abs(Xvfm1)))*1.1])
grid on

subplot(2,1,2)
plot(kvfm2/1e6, fftshift(abs(Xvfm2)), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|V_{FM2}(f)|')
title('Espectre vfm2(t) (desplaçat a 1.075 MHz)')
axis([0.85 1.25 0 max(fftshift(abs(Xvfm2)))*1.1])
grid on

%% 3) Anul·lació de tons fc ± 2fm (J2(beta)=0)
Deltafmax3 = 22.5e3;
eixbeta = 2:0.001:9;
J = besselj(2, eixbeta);

idxCanviSigne = find(J(1:end-1).*J(2:end) <= 0);
betaZeros = zeros(1, numel(idxCanviSigne));
for i = 1:numel(idxCanviSigne)
    b1 = eixbeta(idxCanviSigne(i));
    b2 = eixbeta(idxCanviSigne(i)+1);
    j1 = J(idxCanviSigne(i));
    j2 = J(idxCanviSigne(i)+1);
    betaZeros(i) = b1 - j1*(b2-b1)/(j2-j1);
end
betaZeros = betaZeros(1:2);
fmZero1 = Deltafmax3/betaZeros(1);
fmZero2 = Deltafmax3/betaZeros(2);

figure(3)
plot(eixbeta, J, 'LineWidth', 1.2)
hold on
plot(betaZeros, besselj(2,betaZeros), 'ro', 'MarkerFaceColor', 'r')
xlabel('\beta')
ylabel('J_2(\beta)')
title('J_2(\beta) i zeros per anul·lar tons fc \pm 2f_m')
grid on

% Ens quedem amb els dos zeros de J2 dins [2,9]
betaZeros = betaZeros(1:2);
fmZero1 = Deltafmax3/betaZeros(1);
fmZero2 = Deltafmax3/betaZeros(2);

figure(3)
plot(eixbeta, J, 'LineWidth', 1.2)
hold on
plot(betaZeros, besselj(2,betaZeros), 'ro', 'MarkerFaceColor', 'r')
xlabel('\beta')
ylabel('J_2(\beta)')
title('J_2(\beta) i zeros per anul·lar tons fc \pm 2f_m')
grid on

xCancel1 = Ac2*cos(2*pi*fc2*t + betaZeros(1)*sin(2*pi*fmZero1*t));
xCancel2 = Ac2*cos(2*pi*fc2*t + betaZeros(2)*sin(2*pi*fmZero2*t));

[Xc1, kc1] = FuncioTFZP(xCancel1, fs, 15*dim);
[Xc2, kc2] = FuncioTFZP(xCancel2, fs, 15*dim);

figure(4)
subplot(2,1,1)
plot(kc1/1e6, fftshift(abs(Xc1)), 'LineWidth', 1.2)
hold on
xline((fc2-2*fmZero1)/1e6, '--r', 'f_c-2f_m')
xline((fc2+2*fmZero1)/1e6, '--r', 'f_c+2f_m')
xlabel('Freqüència (MHz)')
ylabel('|X_{FM}(f)|')
title('Espectre FM amb \beta=\beta_{0,1} (anul·lació fc\pm2f_m)')
axis([0.97 1.03 0 max(fftshift(abs(Xc1)))*1.1])
grid on

subplot(2,1,2)
plot(kc2/1e6, fftshift(abs(Xc2)), 'LineWidth', 1.2)
hold on
xline((fc2-2*fmZero2)/1e6, '--r', 'f_c-2f_m')
xline((fc2+2*fmZero2)/1e6, '--r', 'f_c+2f_m')
xlabel('Freqüència (MHz)')
ylabel('|X_{FM}(f)|')
title('Espectre FM amb \beta=\beta_{0,2} (anul·lació fc\pm2f_m)')
axis([0.97 1.03 0 max(fftshift(abs(Xc2)))*1.1])
grid on

%% Variables de comprovació
Svfm1 = fftshift(abs(Xvfm1));
Svfm2 = fftshift(abs(Xvfm2));
posMask1 = kvfm1 >= 0;
posMask2 = kvfm2 >= 0;
[~, i1] = max(Svfm1(posMask1));
[~, i2] = max(Svfm2(posMask2));
kpos1 = kvfm1(posMask1);
kpos2 = kvfm2(posMask2);

resultatsFM = struct();
resultatsFM.beta_principal = beta;
resultatsFM.tipusFM = tipusFM;
resultatsFM.beta_apartat2 = beta2;
resultatsFM.centre_vfm1_Hz = kpos1(i1);
resultatsFM.centre_vfm2_Hz = kpos2(i2);
resultatsFM.betaZerosJ2 = betaZeros;
resultatsFM.fmZeros_Hz = [fmZero1 fmZero2];

disp(['beta apartat 2 = ', num2str(beta2)])
disp(['Tipus FM principal = ', tipusFM])
disp(['Centre vfm2 (Hz) = ', num2str(resultatsFM.centre_vfm2_Hz)])
disp(['Zeros J2(beta) = ', num2str(betaZeros)])
