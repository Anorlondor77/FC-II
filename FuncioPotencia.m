function [PxdBm] = FuncioPotencia(X,k,Z)
% FuncioPotencia - Calcula la potència espectral en dBm sobre una impedància Z.
%   [PxdBm] = FuncioPotencia(X,k,Z)
%   X: espectre complex
%   k: eix de freqüències (no s'usa al càlcul, es rep per compatibilitat)
%   Z: impedància en ohms

Px = (1/Z)*(X.*conj(X));
Px = max(Px, eps);
PxdBm = 10*log10(Px*1000);

end
