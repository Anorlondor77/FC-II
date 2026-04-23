% Nom complet component/s del grup
clear all
close all

%% Operacions bàsiques
vecFila = [1 2 3 4 5];
vecCol = [6; 7; 8; 9; 10];

vecFilaT = vecFila.';
vecColT = vecCol.';

sumaVectors = vecFila + vecColT;
prodElement = vecFila .* vecColT;

%% Vectors
v_pas = 0:2.5:(0 + 2.5*(1000-1));
v_lin = linspace(0, 0 + 2.5*(1000-1), 1000);

%% Matrius
M = reshape(1:36, 6, 6);
dimM = size(M);

%% Operacions amb matrius
M_quadrat = M.^2;
M_mesEscalar = M + 5;
M_perEscalar = 3*M;
M_transposada = M.';
M_inversa = inv(M + eye(6));  % Es desplaça per evitar singularitat

A = [1 2; 3 4];
B = [0 1; 2 3];
AB = A*B;
BA = B*A;
sonConmutatives = isequal(AB, BA);

%% Extracció de dades
vec1 = M(:,4);
vec2 = M(2,:);
el3_vec1 = vec1(3);
el1_vec2 = vec2(1);

%% Senyals
v1 = repmat([zeros(1,20) ones(1,20)], 1, 4);  % 8 blocs de 20 mostres
v2 = linspace(20, 100, 160);
t = 0:2:(2*(160-1));

%% Representació
figure
hold on
plot(t, v1, 'LineWidth', 1.5)
plot(t, v2, 'LineWidth', 1.5)
xlabel('t')
ylabel('Amplitud')
title('Representació de v1 i v2 respecte t')
legend('v1', 'v2')
axis([t(1) t(end) min([v1 v2])-5 max([v1 v2])+5])
grid on

%% Complexos
comp1 = [1+1j, 2-1j, -1+2j, 0.5-3j, -2-2j, 3+0.2j, -0.7+0.9j, 1.5-1.2j, -3+0.5j, 2.2+2.8j];
comp1_real = real(comp1);
comp1_imag = imag(comp1);
comp1_abs = abs(comp1);
comp1_fase_graus = angle(comp1)*180/pi;
