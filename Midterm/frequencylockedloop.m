clear
close all
% Task a

% Generate shaping filter
h = rcosine(1,8,'sqrt',0.5,6);
h = h/max(h);

% Plot impulse response of shaping filter
figure
subplot(2,1,1)
plot(h, 'k')
title('Impulse Response of Shaping Filter')

% Plot frequency response of shaping filter
subplot(2,1,2)
plot(linspace(-0.5,0.5,1024)*8,fftshift(20*log10(abs(fft(h,1024)))),'k')
title('Frequency Response of Shaping Filter')

% Task b

% Generate modulation data and pass it through shaping filter
N = 1000;
x0=((floor(2*rand(1,N))-0.5)/0.5)+j*((floor(2*rand(1,N))-0.5)/0.5);
x1 = zeros(1,8*N);
x1(1:8:8*N)=x0;
x1=filter(h,1,x1);

% Plot real part of first 100 symbols
figure
subplot(2,1,1)
plot(0:99, real(x1(1:8:8*100)),'ro')
title('Real part of first 100 symbols')
ylim([-1.5 1.5])

% Plot imaginary part of first 100 symbols
subplot(2,1,2)
plot(0:99, imag(x1(1:8:8*100)),'ro')
title('Imaginary part of first 100 symbols')
ylim([-1.5 1.5])

% Plot eye diagram at modulator output
figure
subplot(2,1,1)
plot(0,0)
hold on
for n=1:8:8*N-8*2
    plot(-1:1/8:1, real(x1(n:n+8*2)), 'k')
end
title('Eye diagram at modulator output')

% Plot constellation diagram at modulator output
subplot(2,1,2)
plot(x1, 'k')
grid on
axis('square')
hold on
plot(x1(1:8:length(x1)),'r.')
ylim([-1.5 1.5])
xlim([-1.5 1.5])
title('Constellation diagram at modulator output')

% Task c

% Generate band edge filter
[h2, be_pos, be_bb] = band_edge_harris(4,0.5,6);
be_neg = conj(be_pos);

% Plot impulse response of downsampled shaping filter
figure
subplot(3,1,1)
plot(h2, 'k')
title('Impulse response of downsampled shaping filter')

% Plot impulse response of positive band-edge filter
subplot(3,1,2)
plot(real(be_pos),'b')
hold on
plot(imag(be_pos),'r')
title('Impulse response of positive band-edge filter')

% Plot frequency response of band-edge filters
subplot(3,1,3)
plot(linspace(-0.5,0.5,1024)*4,fftshift(abs(fft(be_neg,1024))),'b')
hold on
plot(linspace(-0.5,0.5,1024)*4,fftshift(abs(fft(be_bb,1024))),'r')
hold on
plot(linspace(-0.5,0.5,1024)*4,fftshift(abs(fft(be_pos,1024))),'b')
title('Frequency response of band-edge filters')

% Task d

% Downsample modulator signal
x2 = zeros(1,4*N);
x2 = x1(1:2:8*N);
% Scale downsampled matched filter
hm = h2/(h2*h2');
% Pass signal through filters
y1 = filter(hm,1,x2);
y2 = filter(be_neg,1,x2);
y3 = filter(be_pos,1,x2);

ww=kaiser(2048,10)';
ww=10*ww/sum(ww);
% Plot spectrum of modulated signal passed through matched filter
figure
subplot(2,1,1)
plot(linspace(-0.5,0.5,2048)*4,fftshift(20*log10(abs(fft(y1(1:2048).*ww)))),'k')
title('Spectrum of modulated signal passed through matched filter')

% Plot spectrum of modulated signal passed through band-edge filters
subplot(2,1,2)
plot(linspace(-0.5,0.5,1024)*4,fftshift(20*log10(abs(fft(be_neg,1024)))),'b')
hold on
plot(linspace(-0.5,0.5,2048)*4,fftshift(20*log10(abs(fft(y2(1:2048).*ww)))),'b')
hold on
plot(linspace(-0.5,0.5,1024)*4,fftshift(20*log10(abs(fft(be_pos,1024)))),'r')
hold on
plot(linspace(-0.5,0.5,2048)*4,fftshift(20*log10(abs(fft(y3(1:2048).*ww)))),'r')
grid on
axis([-4/2 4/2 -60 10])
title('Spectrum of modulated signal passed through band-edge filters')

% task e




