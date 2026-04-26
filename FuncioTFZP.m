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

X = (1/N)*fft(x,dimFinal);
k = (0:dimFinal-1)*fs/dimFinal - fs/2;

end
