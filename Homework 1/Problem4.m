clear
close all
load workspace
ww = kaiser(2048,12)';
ww = 10*ww/sum(ww);
subplot(2,1,1)
plot((-0.5:1/2048:(0.5-1/2048))*8, fftshift(20*log10(abs(fft(x1(1:2048).*ww)))),'k')
title('2048 point windowed Power Spectrum of filter with alpha = 0.2')

subplot(2,1,2)
plot((-0.5:1/2048:(0.5-1/2048))*8, fftshift(20*log10(abs(fft(x2(1:2048).*ww)))),'k')
title('2048 point windowed Power Spectrum of filter with alpha = 0.4')

