function [null] = plot_samples(x,str)
%plot_samples(x,str)
%   Takes an input matrix x containing demodulated OFDM_data and plots
%   overlaid real samples, imaginary samples, and constellation points
%   
%   There is also an optional arguments str which appends text to the plot
%   titles.
if ~exist('str','var')
    str='';
end

% Plot time overlapped real samples
figure
subplot(3,1,1)
plot(0:63,real(x),'ro');
title(['Real samples', str])
xlim([0 63])
% Plot time overlaid imaginary samples
subplot(3,1,2)
plot(0:63,imag(x),'ro')
title(['Imaginary samples',str])
xlim([0 63])
% Plot overlaid constellation points
subplot(3,1,3)
plot(x,'ro')
axis('square')
title(['Constellation points',str])

end

