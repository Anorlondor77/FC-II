function [PxdBm] = FuncioPotencia(X,k,Z)
% FuncioPotencia - Potència equivalent per bin espectral en dBm.
%   X s'assumeix obtingut amb FFT no normalitzada.

N = numel(k);
Vpk = abs(X) / N;
Vrms = Vpk / sqrt(2);
PxW = (Vrms.^2) / Z;
PxW(PxW <= 0) = eps;
PxdBm = 10*log10(PxW/1e-3);
end
