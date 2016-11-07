function [null] = plotConstellationDiagram(x1,fs,str)
% Plots the constellation diagram of a modulated signal
%   x1 = input data
%  fs = samples per symbol of x1
% str = title of plot
plot(x1, 'k')
grid on
axis('square')
hold on
plot(x1(1:fs:length(x1)),'r.')
title(str)
end

