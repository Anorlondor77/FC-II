% Nom complet component/s del grup
clear all
close all

%% Operacions bàsiques en Matlab
vecFila4 = [1 2 3 4];
vecCol2 = [5; 6];

vecFila4T = transpose(vecFila4);
vecCol2T = transpose(vecCol2);

a = [1 3 5 7 9];
b = [2 4 6 8 10];
suma_ab = a + b;
prod_ab = a .* b;

%% Vector de 1000 mostres separades 2.5 i equivalent amb linspace
v_espaiat = 0:2.5:(0 + 2.5*(1000-1));
v_linspace = linspace(0, 0 + 2.5*(1000-1), 1000);

%% Matriu 6x6
m_a = [1 2 3 4 5 6;
       7 8 9 1 2 3;
       4 5 6 7 8 9;
       2 4 6 8 1 3;
       5 7 9 2 4 6;
       3 1 8 5 7 9];

files_columnes = size(m_a);

%% Operacions amb matrius
m_b = m_a.^2;
m_c = 3*(m_a + 2);
m_aT = transpose(m_a);
m_aInv = inv(m_a);

AB = m_a*m_b;
BA = m_b*m_a;
esCommutatiu = isequal(AB, BA);

%% Obtenció d'elements
vec1 = m_a(:,4);
vec2 = m_a(2,:);
tercer_vec1 = vec1(3);
primer_vec2 = vec2(1);

%% Representació gràfica
n = 160/8;
v1 = repmat([zeros(1,n) ones(1,n)], 1, 4);
v2 = linspace(20,100,160);
t = 0:2:(2*(160-1));

figure(1)
hold on
plot(t,v1,'LineWidth',1.2)
plot(t,v2,'LineWidth',1.2)
xlabel('Temps (s)')
ylabel('Amplitud')
title('v1 i v2 en funció de t')
legend('v1','v2')
axis([0 t(end) -5 105])
grid on

%% Nombres complexos
comp1 = (1:10) + 1j*(5:-1:-4);
comp1_real = real(comp1);
comp1_imag = imag(comp1);
comp1_modul = abs(comp1);
comp1_fase_graus = angle(comp1)*180/pi;
