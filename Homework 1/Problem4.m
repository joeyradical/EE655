clear
close all
load workspace
ww = kaiser(2000,12);
ww = ww/sum(ww)*10;

ffx = zeros(1,2000);
mm = 0;
for k = 1:500:6000
    fx = abs(fft(x1(k:k+1999).*ww')).^2;
    ffx = ffx + fx;
    mm = mm + 1;
end
ffx = ffx/mm
subplot(2,1,1)
plot((-0.5:1/2000:0.5-1/2000), fftshift(10*log10(ffx)), 'r', 'linewidth', 2)
title('Power Spectrum of filter with alpha = 0.2')

ffx = zeros(1,2000);
mm = 0;
for k = 1:500:6000
    fx = abs(fft(x2(k:k+1999).*ww')).^2;
    ffx = ffx + fx;
    mm = mm + 1;
end
ffx = ffx/mm;
subplot(2,1,2)
plot((-0.5:1/2000:0.5-1/2000), fftshift(10*log10(ffx)), 'r', 'linewidth', 2)
title('Power Spectrum of filter with alpha = 0.4')

