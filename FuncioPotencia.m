function [PxdBm] = FuncioPotencia(X,k,Z)
% FuncioPotencia - Calcula la potència espectral en dBm sobre una impedància Z.
%   [PxdBm] = FuncioPotencia(X,k,Z)
%   X: espectre complex (amplitud de pics)
%   k: eix de freqüències (no s'usa al càlcul, es rep per compatibilitat)
%   Z: impedància en ohms

% Càlcul de potència equivalent per mostra espectral.
PxW = (abs(X).^2) ./ (2*Z);

% Evitar logaritme de zero.
PxW(PxW == 0) = eps;

PxdBm = 10*log10(PxW/1e-3);
end
