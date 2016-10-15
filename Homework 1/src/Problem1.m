clear
close all
% Problem 1
% Filter 1: roll off factor 0.2
h1 = rcosine(1, 8, 'sqrt', 0.2, 10);
h1 = h1/max(h1);

% Filter 2: roll off factor 0.4
h2 = rcosine(1, 8, 'sqrt', 0.4, 10);
h2 = h2/max(h2);

subplot(2,2,1);
plot(0:length(h1)-1, h1, 'k');
hold on
plot(0:8:length(h1)-1, h1(1:8:length(h1)), 'ro')
title('Impulse Response when alpha = 0.2')
grid on

subplot(2, 2, 2)
plot(0:length(h2)-1, h2, 'k')
hold on
plot(0:8:length(h2)-1, h2(1:8:length(h2)), 'ro')
title('Impulse Response when alpha = 0.4')

grid on

subplot(2,2,3)
plot((-0.5:1/1024:0.5-1/1024)*8,fftshift(20*log10(abs(fft(h1/sum(h1),1024)))), 'k')
grid on
title('Frequency Response when alpha = 0.2')
axes('Position',[.35 .35 .1 .1])
plot((-0.5:1/1024:0.5-1/1024)*8,fftshift(20*log10(abs(fft(h1/sum(h1),1024)))),'k')
ylim([-0.025 0.025])
xlim([-0.5 0.5])
box on

subplot(2,2,4)
plot((-0.5:1/1024:0.5-1/1024)*8,fftshift(20*log10(abs(fft(h2/sum(h2),1024)))),'k')
grid on
title('Frequency Response when alpha = 0.4')
axes('Position',[.79 .35 .1 .1])
plot((-0.5:1/1024:0.5-1/1024)*8,fftshift(20*log10(abs(fft(h2/sum(h2),1024)))),'k')
ylim([-0.025 0.025])
xlim([-0.5 0.5])
box on
save('workspace.mat')