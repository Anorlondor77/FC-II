% Nombre autores
clear all
close all
clc

% EXERCICI 2
% SIMULACIÓ DE VARIABLES DISCRETES I LA SEVA PROBABILITAT

valors_iteracions = [10 100 1000 10000];
lambda = 5;

for idx = 1:length(valors_iteracions)
    iteracions = valors_iteracions(idx);

    % 1.1 Inicialització del comptador de l'event A
    comptadorA = 0;

    % 1.3 Bucle principal
    for i = 1:iteracions
        % 1.4 nclients ~ Poisson(5) amb mètode de Knuth
        L = exp(-lambda);
        k = 0;
        p = 1;

        while p > L
            k = k + 1;
            p = p * rand();
        end

        nclients = k - 1;

        % 1.5 Assignació de paquets per client
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

        % 1.6 Event A: s'envien com a màxim 10 paquets
        if totalPaquets <= 10
            comptadorA = comptadorA + 1;
        end
    end

    % 1.7 Probabilitat en %
    probabilitatA = (comptadorA / iteracions) * 100;

    fprintf('EXERCICI 2 - iteracions = %d\n', iteracions);
    fprintf('P(A) com a màxim 10 paquets urgents: %.4f %%\n\n', probabilitatA);
end
