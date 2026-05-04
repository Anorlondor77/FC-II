% Nombre autores
clear all
close all
clc

% EXERCICI 1
% SIMULACIÓ DE PROBABILITATS DE PROCESSOS INDEPENDENTS

valors_numsims = [10 100 1000 10000];

for idx = 1:length(valors_numsims)
    numsims = valors_numsims(idx);

    % 1.1 Inicialització de comptadors
    comptadorA = 0;
    comptadorB = 0;

    % 1.3 Bucle principal
    for i = 1:numsims
        % 1.4 Generació de nombres aleatoris uniformes
        M1 = rand();
        M2 = rand();

        % 1.5 Condicions de funcionament
        funcionaM1 = (M1 < 0.6);
        funcionaM2 = (M2 < 0.7);

        % Event A: les dues màquines estan funcionant
        if funcionaM1 && funcionaM2
            comptadorA = comptadorA + 1;
        end

        % Event B: almenys una màquina està funcionant
        if funcionaM1 || funcionaM2
            comptadorB = comptadorB + 1;
        end
    end

    % 1.6 Càlcul de probabilitats en %
    probabilitatA = (comptadorA / numsims) * 100;
    probabilitatB = (comptadorB / numsims) * 100;

    fprintf('EXERCICI 1 - numsims = %d\n', numsims);
    fprintf('P(A) dues màquines funcionant: %.4f %%\n', probabilitatA);
    fprintf('P(B) AL MENYS una màquina funcionant: %.4f %%\n\n', probabilitatB);
end
