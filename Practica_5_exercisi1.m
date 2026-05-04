% Nombre autores
clear all
close all
clc

% EXERCICI 1
% SIMULACIÓ DE PROBABILITATS DE PROCESSOS INDEPENDENTS

% 1.1 Inicialització de comptadors
comptadorA = 0;
comptadorB = 0;

% 1.2 Definició del nombre de simulacions
numsims = 10000; % Podeu provar també 10, 100 o 1000

% 1.3 Bucle principal de simulació
for i = 1:numsims
    % 1.4 Generació de valors aleatoris uniformes per a M1 i M2
    M1 = rand();
    M2 = rand();

    % 1.5 Condicions de funcionament i actualització de comptadors
    funcionaM1 = (M1 < 0.6);
    funcionaM2 = (M2 < 0.7);

    % Event A: les dues màquines estan funcionant
    if funcionaM1 && funcionaM2
        comptadorA = comptadorA + 1;
    end

    % Event B: almenys una de les dues màquines està funcionant
    if funcionaM1 || funcionaM2
        comptadorB = comptadorB + 1;
    end
end

% 1.6 Càlcul de probabilitats en percentatge i visualització per consola
probabilitatA = (comptadorA / numsims) * 100;
probabilitatB = (comptadorB / numsims) * 100;

fprintf('Resultats EXERCICI 1 amb numsims = %d\n', numsims);
fprintf('Probabilitat que les dues màquines estiguin funcionant (A): %.4f %%\n', probabilitatA);
fprintf('Probabilitat que AL MENYS una màquina estigui funcionant (B): %.4f %%\n', probabilitatB);
