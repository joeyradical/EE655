clear
load workspace
close all
% Problem 2
hm1 = h1/(h1*h1');
y1 = conv(h1, hm1);
subplot(3, 2, 1)
plot(0:length(y1)-1,y1, 'k')
hold on
title('Impulse Response when alpha = 0.2')
plot(0:8:length(y1)-1, y1(1:8:length(y1)), 'ro')
grid on

hm2 = h2/(h2*h2');
y2 = conv(h2, hm2);
subplot(3, 2, 2)
plot(0:length(y2)-1, y2, 'k')
hold on
title('Impulse Response when alpha = 0.4')
plot(0:8:length(y2)-1, y2(1:8:length(y2)), 'ro')
grid on

subplot(3,2,3)
plot((-0.5:1/1024:0.5-1/1024)*8,fftshift(20*log10(abs(fft(y1/sum(y1),1024)))),'k')
title('Frequency Response when alpha = 0.2')
grid on

subplot(3,2,4)
plot((-0.5:1/1024:0.5-1/1024)*8,fftshift(20*log10(abs(fft(y2/sum(y2),1024)))),'k')
title('Frequency Response when alpha = 0.4')
grid on

subplot(3,2,5)
plot((-0.5:1/1024:0.5-1/1024)*8,fftshift(20*log10(abs(fft(y1/sum(y1),1024)))),'k')
ylim([-0.03, 0.03])
title('Passband Ripple when alpha = 0.2')
grid on

subplot(3,2,6)
plot((-0.5:1/1024:0.5-1/1024)*8,fftshift(20*log10(abs(fft(y2/sum(y2),1024)))),'k')
ylim([-0.03 0.03])
title('Passband Ripple when alpha = 0.4')
grid on

save('workspace.mat')