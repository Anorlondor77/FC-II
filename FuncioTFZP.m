function [X,k] = FuncioTFZP(x,fs,dimFinal)
% FuncioTFZP - FFT centrada amb zero-padding i eix de freqüència coherent.
%   [X,k] = FuncioTFZP(x,fs,dimFinal)

x = x(:).';
N = numel(x);

if dimFinal < N
    error('dimFinal ha de ser >= length(x).');
end

dimFinal = round(dimFinal);
xzp = [x zeros(1, dimFinal - N)];

X = fftshift(fft(xzp, dimFinal));
k = (-floor(dimFinal/2):ceil(dimFinal/2)-1) * (fs/dimFinal);
end
