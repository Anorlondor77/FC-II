function [X,k] = FuncioTFZP(x,fs,dimFinal)
% FuncioTFZP - Calcula l'FFT amb zero-padding i retorna eix de freqüències.
%   [X,k] = FuncioTFZP(x,fs,dimFinal)
%   x: senyal en el domini temporal
%   fs: freqüència de mostreig (Hz)
%   dimFinal: longitud final de la FFT

x = x(:).';
N = length(x);

if dimFinal < N
    error('dimFinal ha de ser major o igual que la longitud de x.');
end

xzp = [x zeros(1, dimFinal - N)];
X = fftshift(fft(xzp));
k = (-dimFinal/2:dimFinal/2-1) * (fs/dimFinal);
end
