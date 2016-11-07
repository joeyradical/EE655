function [null] = plotEyeDiagram(x1,fs,str)
%Plots the constellation diagram of a modulated signal
%  x1 = modulated signal
% fs = samples per symbol of x1
% str = title of plot
plot(0,0)
hold on

for n=1:fs:fs*1000-fs*2
    plot(-1:1/fs:1, real(x1(n:n+fs*2)), 'k')
end
hold off
title(str)


end

