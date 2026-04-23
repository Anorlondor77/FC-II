% Nom complet component/s del grup
clear all
close all

%% Paràmetres
fs = 4e6;
dim = 20000;
Ac = 1e-1;
fc = 1e6;
fm = 5e3;
Deltafmax = 10e3;

t = (0:dim-1)/fs;

%% Senyal FM principal
beta = Deltafmax/fm;
xfm = Ac*cos(2*pi*fc*t + beta*sin(2*pi*fm*t));

if beta < 1
    tipusFM = 'Banda estreta';
else
    tipusFM = 'Banda ampla';
end

figure
subplot(2,1,1)
plot(t*1e3, xfm, 'LineWidth', 1.2)
xlabel('Temps (ms)')
ylabel('Amplitud')
title(['FM en el temps - ' tipusFM])
grid on

[Xfm, kfm] = FuncioTFZP(xfm, fs, 15*dim);
subplot(2,1,2)
plot(kfm/1e6, abs(Xfm), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|X_{FM}(f)|')
title('Espectre FM amb zero padding x15')
axis([0.97 1.03 0 max(abs(Xfm))*1.1])
grid on

%% Moduladora amb contínua
A1 = 1;
A2 = 1;
DC = 0.4;

xm1 = A1*cos(2*pi*fm*t);
xm2 = DC + A2*cos(2*pi*fm*t);

kf = Deltafmax/A1;
Deltafmax1 = kf*max(abs(xm1));
Deltafmax2 = kf*max(abs(xm2));

beta1 = Deltafmax1/fm;
beta2 = Deltafmax2/fm;

vfm1 = Ac*cos(2*pi*fc*t + beta1*xm1);
vfm2 = Ac*cos(2*pi*fc*t + beta2*xm2);

[Xvfm1, kvfm1] = FuncioTFZP(vfm1, fs, 15*dim);
[Xvfm2, kvfm2] = FuncioTFZP(vfm2, fs, 15*dim);

figure
subplot(2,1,1)
plot(kvfm1/1e6, abs(Xvfm1), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|V_{FM1}(f)|')
title('Espectre vfm1(t)')
axis([0.97 1.03 0 max(abs(Xvfm1))*1.1])
grid on
subplot(2,1,2)
plot(kvfm2/1e6, abs(Xvfm2), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|V_{FM2}(f)|')
title('Espectre vfm2(t)')
axis([0.97 1.03 0 max(abs(Xvfm2))*1.1])
grid on

%% Anul·lació de tons amb Bessel
betas = 2:0.001:9;
J0 = besselj(0, betas);
idxZeros = find(abs(J0) < 1e-3);
betaZeros = unique(round(betas(idxZeros), 3));

if isempty(betaZeros)
    betaCancel = 2.405;
else
    betaCancel = betaZeros(1);
end

fmCancel = Deltafmax / betaCancel;
xCancel = Ac*cos(2*pi*fc*t + betaCancel*sin(2*pi*fmCancel*t));
[Xcancel,kcancel] = FuncioTFZP(xCancel, fs, 15*dim);

figure
plot(kcancel/1e6, abs(Xcancel), 'LineWidth', 1.2)
xlabel('Freqüència (MHz)')
ylabel('|X_{cancel}(f)|')
title('Comprovació d''anul·lació de tons (J_0(\beta) \approx 0)')
axis([0.97 1.03 0 max(abs(Xcancel))*1.1])
grid on

% Variables útils de resultat
resultatsFM = struct('beta',beta,'tipusFM',tipusFM,'Deltafmax1',Deltafmax1,...
    'Deltafmax2',Deltafmax2,'beta1',beta1,'beta2',beta2,...
    'betaCancel',betaCancel,'fmCancel',fmCancel);
