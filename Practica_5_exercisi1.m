% Nombre autores
clear all
close all
clc

%% PRACTICA 5 - PROBABILITAT
% Aquest script resol els dos exercicis de simulacio de la practica.

%% EXERCICI 1
% Simulacio de probabilitats de processos independents
% M1 funciona amb probabilitat 0.6
% M2 funciona amb probabilitat 0.7
% Event A: les dues maquines funcionen
% Event B: almenys una maquina funciona

numsims = 10000;  % Podeu provar 10, 100, 1000, 10000

comptA = 0;
comptB = 0;

for k = 1:numsims
    M1 = rand;
    M2 = rand;

    funcionaM1 = (M1 < 0.6);
    funcionaM2 = (M2 < 0.7);

    if funcionaM1 && funcionaM2
        comptA = comptA + 1;
    end

    if funcionaM1 || funcionaM2
        comptB = comptB + 1;
    end
end

probA = 100 * comptA / numsims;
probB = 100 * comptB / numsims;

fprintf('EXERCICI 1\n');
fprintf('numsims = %d\n', numsims);
fprintf('P(A: les dues maquines funcionen) = %.4f %%\n', probA);
fprintf('P(B: almenys una maquina funciona) = %.4f %%\n\n', probB);

%% EXERCICI 2
% Simulacio de variables discretes i la seva probabilitat
% Nombre de clients/hora ~ Poisson(5)
% Cada client envia 1,2,3,4 paquets amb probabilitats 0.4,0.3,0.2,0.1
% Event A: s'envien com a maxim 10 paquets en una hora

iteracions = 10000;  % Podeu provar 10, 100, 1000, 10000
lambda = 5;
comptA2 = 0;

for it = 1:iteracions
    % Generacio de nclients ~ Poisson(lambda) amb transformada inversa
    % (evitem funcions de toolboxes externs)
    L = exp(-lambda);
    p = 1;
    nclients = 0;
    while p > L
        nclients = nclients + 1;
        p = p * rand;
    end
    nclients = nclients - 1;

    totalPaquets = 0;
    for c = 1:nclients
        numAleatori = rand;

        if numAleatori <= 0.4
            paquetsClient = 1;
        elseif numAleatori <= 0.7
            paquetsClient = 2;
        elseif numAleatori <= 0.9
            paquetsClient = 3;
        else
            paquetsClient = 4;
        end

        totalPaquets = totalPaquets + paquetsClient;
    end

    if totalPaquets <= 10
        comptA2 = comptA2 + 1;
    end
end

probA2 = 100 * comptA2 / iteracions;

fprintf('EXERCICI 2\n');
fprintf('iteracions = %d\n', iteracions);
fprintf('P(A: com a maxim 10 paquets/hora) = %.4f %%\n', probA2);
