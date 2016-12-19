clear
close all

% Task a)
x0_dat=[];
x4_dat=[];
N=50;

for nn=1:N
    fx1=zeros(1,128);
    x_d=(floor(4*rand(1,64))-1.5)/1.5+ j*(floor(4*rand(1,64))-1.5)/1.5;
    fx_d=fftshift(fft(x_d));
    fx1(65+(-32:31))=fx_d;
    fx1=fftshift(fx1);
    x1=ifft(fx1);
    xx0=[zeros(1,32) x1];  % guard interval
    xx4=[x1(97:128) x1];   % cyclic prefix in guard interval
    x0_dat=[x0_dat xx0];
    x4_dat=[x4_dat xx4];
end

% Plot real part of first 500 samples of data stream
figure
subplot(3,1,1)
plot(0:499,real(x0_dat(1:500)))
title('Real part of first 500 samples')
subplot(3,1,2)
plot(0:499,imag(x0_dat(1:500)))
title('Imaginary part of first 500 samples')
subplot(3,1,3)
N_win=2048;
ww=kaiser(N_win)';
ww=ww/sum(ww);
plot(linspace(-0.5,0.5,N_win),fftshift(20*log10(abs(fft(x0_dat(1:N_win)).*ww))))
title('2048-point windowed power spectrum of signal')

% Task b)

% Demodulate data
y0_dat=SC_OFDM_demod(x0_dat,N);
% Plot samples
plot_samples(y0_dat);

% Task c)
chan=[1 0 0 0 0.2*j 0 0 0 0 0 0 0.1]; %channel
% Pass data through channel
x0_dat_c=filter(chan,1,x0_dat);
% Demodulate data
y0_dat_c=SC_OFDM_demod(x0_dat_c,N);
% Plot samples
plot_samples(y0_dat_c,' with channel');

% Task d)
% Pass data through channel
x4_dat_c=filter(chan,1,x4_dat);
% Demodulate data
y4_dat_c=SC_OFDM_demod(x4_dat_c,N);
% Plot samples
plot_samples(y4_dat_c,' with cyclic prefix');

% Task e)
NN=64;
rr=((0:NN-1)-0.5).*((0:NN-1)+0.5)/2; % 64-Pnt quadratic phase profile
prb0=exp(j*2*pi*rr/NN);             % 64-pnt Zadoff-Chu Sequence
fprb0=fftshift(fft(prb0));           % DC-Centered fft of ZC sequence
fprb1=zeros(1,128);                  % 128-pnt empty frequency arrary
fprb1(65+(-32:31))=fprb0;            % 64-pnt FFT centered in 128 pnt array
prb1=2*ifft(fftshift(fprb1));       % 128-pnt 1-to-2 interpolated sequence
prb1a=[prb1(97:128) prb1];          % appendcyclic shift

% Plot real part of probe
figure(100)
subplot(3,1,1)
plot(0:63,real(prb0),'linewidth',2)
grid on
axis([0 64 -1.2 1.2])
title('Real part of 64 Point Zadoff-Chu Sequence')
xlabel('Time index')
ylabel('Amplitude')
% Plot imaginary part of probe
subplot(3,1,2)
plot(0:63,imag(prb0),'r','linewidth',2)
grid on
axis([0 64 -1.2 1.2])
title('Imaginary part of 64 Point Zadoff-Chu Sequence')
xlabel('Time index')
ylabel('Amplitude')

% Plot frequency response of probe
subplot(3,1,3)
plot(-64:63,real(fprb1)/8,'linewidth',2)
hold on
plot(-64:63,imag(fprb1)/8,'r','linewidth',2)
hold off
grid on
axis([-64 64 -1.2 1.2])
title('FFT of 64 Point Zadoff-Chu Sequence With DC Centered in Center of 128 Point Sequence')
xlabel('Time index')
ylabel('Amplitude')

% Task f)

% Pass probe through channel
xprb=filter(chan,1,prb1a);
xprb=xprb+0.00*(randn(1,160)+j*randn(1,160));

% Plot frequency response of probe
figure
subplot(2,1,1)
plot(-64:63,fftshift(fft(prb1a(33:end)))/8,'linewidth',2)
hold on
% Plot frequency response of probe passed through channel
plot(-64:63,fftshift(fft(xprb(33:end)))/8,'r','linewidth',2)
hold on
plot(-64:63,fftshift(fft(chan,128)),'m','linewidth',2)
hold off
grid on
axis([-64 64 -3 3])
title('Frequency responses')
xlabel('Time index')
ylabel('Amplitude')
legend('Probe', 'Probe through channel','Channel')

% Estimate channel
f_xprb=fftshift(fft(xprb(33:end)));
f_prb1a=fftshift(fft(prb1a(33:end)));
f_chan=zeros(1,128);
f_chan(65+(-32:31))=f_xprb(65+(-32:31))./f_prb1a(65+(-32:31));

subplot(2,1,2)
plot(-64:63,f_chan,'r','linewidth',2)
hold on
plot(-64:63,fftshift(fft(chan,128)),'b','linewidth',2)
xlim([-64 63])
title('Frequency response of channel')
legend('Estimated channel', 'Actual channel')

% Task g
 
% Demodulate data and equalize
y4_dat_eq=SC_OFDM_demod(x4_dat_c,N,f_chan);
% Plot samples
plot_samples(y4_dat_eq,' with equalization');



