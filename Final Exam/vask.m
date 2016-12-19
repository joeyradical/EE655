clear
close all

% Task A

NN=63;     
rr=(0:NN).*(0:NN)/2;
prb0=exp(j*2*pi*rr/NN);
fprb0=fft(prb0);
fprb1=zeros(1,128);
fprb1(65+(-32:31))=fprb0;
fprb1(65-32)=fprb1(65-31);
fprb1(65+32)=fprb1(65+31);
prb1=ifft(fftshift(fprb1));
prb1a=[prb1(97:128) prb1];


% Plot real part of probe time series
N_win=length(prb1a);
subplot(3,1,1)
plot(0:N_win-1,real(prb1a))
title('Real part of probe time series')
% Plot imaginary part of probe time series
subplot(3,1,2)
plot(0:N_win-1,imag(prb1a))
title('Imaginary part of probe time series')
% Plot magnitude of the probe's frequency response
subplot(3,1,3)
plot(linspace(-0.5,0.5,N_win),fftshift(abs(fft(prb1a))))
title('Magnitude of probe frequency response')

% Task B

% Pass probe through channel
cc=[1 0 0 0 0.2*j 0 0 0 0 0 0 0.1];
xprb=filter(cc,1,prb1a);
xprb=xprb+0.01*(randn(1,160)+j*randn(1,160));

% Plot FFT of long preamble
figure
subplot(2,1,1)
plot(linspace(-0.5,0.5,128),fftshift((abs(fft(prb1a(33:160))))),'r')
hold on
% Plot Channel response of preamble
plot(linspace(-0.5,0.5,128),fftshift((abs(fft(xprb(33:160))))),'b')
hold on
% Plot frequency response of channel
plot(linspace(-0.5,0.5,128),fftshift((abs(fft(cc,128)))),'g')
legend('Probe preamble','Preamble through channel','Channel')
title('Frequency responses')

% Estimate channel
cc_hat=xprb./prb1a;
% Plot estimated channel response and actual channel
subplot(2,1,2)
plot(linspace(-0.5,0.5,128),fftshift((abs(fft(cc_hat,128)))))
hold on
plot(linspace(-0.5,0.5,128),fftshift((abs(fft(cc,128)))))
title('Frequency responses of channel and estimated channel')
legend('Estimated channel','Channel')

% Task c
N=50;
x=[];

for n=1:N
    cp0=(floor(2*rand(1,16))-0.5)/0.5+j*(floor(2*rand(1,16))-0.5)/0.5;
    cp0=reshape([cp0 cp0 cp0 cp0],1,64); 
    fcp0=fft(cp0);

    fcp1=zeros(1,128);
    fcp1(65+(-32:31))=fcp0;
    fcp1(65-32)=sqrt(0.5)*fcp1(65-32);
    fcp1(65+32)=fcp1(65-32);

    cp1=2*ifft(fftshift(fcp1));
    cp1a=[cp1(97:128) cp1];
    x=[x cp1a];
end

% Plot real part of first 500 samples
subplot(3,1,1)
plot(0:499,real(x(1:500)))
title('Real part of first 500 samples')
% Plot imaginary part of first 500 samples
subplot(3,1,2)
plot(0:499,imag(x(1:500)))
title('Imaginary part of first 500 samples')
% Plot 2048-point power spectrum
ww=kaiser(2048)';
ww=ww/sum(ww);
subplot(3,1,3)
plot(linspace(-0.5,0.5,2048),fftshift(20*log10(abs(fft(x(1:2048)).*ww))));
ylim([-100 0])
title('2048-point Power spectrum of SC-OFDM signal')

% Task D
% Plot real part of successive symbols
subplot(3,1,1)
plot(0:79,reshape(real(x(1:2:end)),50,80))
title('Time series of succesive symbols')

% Pass signal through demodulator chain

for n=1:160:N*160
    x1=x((n+32):(n+160-1)); %remove cyclic prefix
    
end







