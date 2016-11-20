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
plot(0:99, real(x1(1:8:8*100)),'k')
title('Real part of first 100 symbols')
ylim([-1.5 1.5])

% Plot imaginary part of first 100 symbols
subplot(2,1,2)
plot(0:99, imag(x1(1:8:8*100)),'k')
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
[h2, be_pos, be_bb] = band_edge_harris_2(4,0.5,6);
be_pos = be_pos/sum(h2);
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
plot(linspace(-0.5,0.5,1024)*4,fftshift(abs(fft(h2/sum(h2),1024))),'r')
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
plot(linspace(-0.5,0.5,1024)*4,fftshift(20*log10(abs(fft(h2/sum(h2),1024)))),'r')
hold on
plot(linspace(-0.5,0.5,2048)*4,fftshift(20*log10(abs(fft(y1(1:2048).*ww)))),'b')
axis([-4/2 4/2 -60 10])
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

% Task e

% Apply spin to the modulated signal
ff=0.05;
x3=x2.*exp(j*2*pi*(1:4*N)*ff);

% Pass signal through filters
y1 = filter(hm,1,x3);
y2 = filter(be_neg,1,x3);
y3 = filter(be_pos,1,x3);

% Plot spectrum of modulated signal passed through matched filter
figure
subplot(2,1,1)
plot(linspace(-0.5,0.5,1024)*4,fftshift(20*log10(abs(fft(h2/sum(h2),1024)))),'r')
hold on
plot(linspace(-0.5,0.5,2048)*4,fftshift(20*log10(abs(fft(y1(1:2048).*ww)))),'b')
axis([-4/2 4/2 -60 10])
title('Spectrum of modulated frequency offset signal passed through matched filter')

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
title('Spectrum of modulated frequency offset signal passed through band-edge filters')

% Task f
theta_0= 2*pi/500;
eta=sqrt(2)/2;

k_i_f= (4*theta_0*theta_0)/(1+2*eta*theta_0+theta_0*theta_0);
k_p_f= (4*eta*theta_0)/(1+2*eta*theta_0+theta_0*theta_0);

reg_f=zeros(1,49);
int_f=0.0;
reg_avg=0.0;
accum_f=0.0;

det_sv=zeros(1,4*N);
phs_f=zeros(1,4*N);
sm_f_sv=zeros(1,4*N);
% Frequency lock loop
for nn=1:4*N
    x4(nn)=x3(nn)*exp(-j*2*pi*accum_f);  
    reg_f=[x4(nn) reg_f(1:48)];
    be_1=reg_f*be_pos.';
    be_2=reg_f*be_neg.';

    be_1_sv(nn)=be_1;
    be_2_sv(nn)=be_2;

    det=(abs(be_1)^2-abs(be_2)^2);
    det_sv(nn)=det;
    reg_avg=0.1*det+0.9*reg_avg;
    int_f=int_f+k_i_f*reg_avg;
    sm_f =int_f+k_p_f*reg_avg;
    sm_f_sv(nn) = sm_f;

    phs_f(nn)=accum_f;
    accum_f=accum_f+1*sm_f;
end
figure
subplot(2,1,1)
% Plot frequency response of shaping and band edge filters
plot(linspace(-0.5,0.5,1024)*4,fftshift(20*log10(abs(fft(h2/sum(h2),1024)))),'b')
hold on
plot(linspace(-0.5,0.5,1024)*4,fftshift(20*log10(abs(fft(be_neg,1024)))),'b')
hold on
plot(linspace(-0.5,0.5,1024)*4,fftshift(20*log10(abs(fft(be_pos,1024)))),'b')
hold on
% Plot input spectrum
plot(linspace(-0.5,0.5,2048)*4,fftshift(20*log10(abs(fft(x3(1:2048).*ww)))),'r')
title('Input spectrum and frequency response of shaping and band edge filters')
subplot(2,1,2)
% Plot output spectrum
plot(linspace(-0.5,0.5,2048)*4,fftshift(20*log10(abs(fft(x4(1:2048).*ww)))),'r')
hold on
% Plot DDS signal
plot(linspace(-0.5,0.5,2048)*4,fftshift(20*log10(abs(fft(exp(-j*2*pi*phs_f(1:2048).*ww))))),'b')
hold on
% Plot frequency response of shaping filter
plot(linspace(-0.5,0.5,1024)*4,fftshift(20*log10(abs(fft(h2/sum(h2),1024)))),'m')
title('Frequency response of shaping filter, FLL output and DDS signal spectrum')
% Plot phase profile of spinning frequency and phase accumulator
figure
subplot(2,1,1)
plot(1:N*4,(1:4*N)*ff,'b')
hold on
plot(1:N*4,phs_f,'r')
title('Phase profile of spinning frequency and phase accumulator')
% Plot output of loop filter
subplot(2,1,2)
plot(sm_f_sv,'b')
hold on
% Plot difference of band edge filters
plot(det_sv,'r')
title('Output of loop filter and difference of band edge filters')

%Plot constellation diagrams
figure
subplot(1,3,1)
grid on
axis('square')
hold on
plot(x2(1:4:end),'r.')
ylim([-1.5 1.5])
xlim([-1.5 1.5])
title('Constellation at input of spinner')
subplot(1,3,2)
grid on
axis('square')
hold on
plot(x3(1:4:end),'r.')
ylim([-1.5 1.5])
xlim([-1.5 1.5])
title('Constellation at output of spinner')
subplot(1,3,3)
grid on
axis('square')
hold on
plot(x4(1:4:2000),'b.')
hold on
plot(x4(2001:4:end),'r.')
ylim([-1.5 1.5])
xlim([-1.5 1.5])
title('Constellation at output of FLL')



