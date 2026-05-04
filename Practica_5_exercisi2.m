% Nombre autores
clear all
close all
clc

% EXERCICI 2
% SIMULACIÓ DE VARIABLES DISCRETES I LA SEVA PROBABILITAT

% 1.1 Inicialització del comptador de l'event A
comptadorA = 0;

% 1.2 Definició del nombre d'iteracions
iteracions = 10000; % Podeu provar també 10, 100 o 1000

% 1.3 Bucle principal de simulació
for i = 1:iteracions
    % 1.4 Nombre de clients nclients ~ Poisson(5)
    nclients = poissrnd(5);

    % 1.5 Generació de paquets per client segons numAleatori
    totalPaquets = 0;
    for j = 1:nclients
        numAleatori = rand();

        if numAleatori <= 0.4
            paquets = 1;
        elseif numAleatori > 0.4 && numAleatori <= 0.7
            paquets = 2;
        elseif numAleatori > 0.7 && numAleatori <= 0.9
            paquets = 3;
        else
            paquets = 4;
        end

        totalPaquets = totalPaquets + paquets;
    end

    % 1.6 Comprovació de l'event A: s'envien un màxim de 10 paquets
    if totalPaquets <= 10
        comptadorA = comptadorA + 1;
    end
end

% 1.7 Càlcul de probabilitat en percentatge i visualització per consola
probabilitatA = (comptadorA / iteracions) * 100;

fprintf('Resultat EXERCICI 2 amb iteracions = %d\n', iteracions);
fprintf('Probabilitat que s''enviïn com a màxim 10 paquets urgents en una hora (A): %.4f %%\n', probabilitatA);
