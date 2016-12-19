clear
close all
N=100; %number of samples
g=50; % length of guard interval
n_bins=201; % amount of frequency bins
x=[];
% Task a
% Create 20 OFDM symbols
for n=1:N
    % Insert guard interval    
    x_sym=zeros(1,g+n_bins);
    % Insert data
    x_sym((g+1):end)=ifft(fftshift([zeros(1,50) n_QAM(50,16) 0 n_QAM(50,16) zeros(1,50)]))*10;
    x=[x x_sym];
end
    % Append symbol to data vector

% Task b

% Plot real part of first 1000 samples
figure
subplot(2,1,1)
plot(0:999,real(x(1:1000)))
title('Real part of first 1000 samples')
% Plot power spectrum
ww=kaiser(2048)';
ww=ww/sum(ww);
subplot(2,1,2)
plot(linspace(-0.5,0.5,2048),fftshift(20*log10(abs(fft(x(1:2048)).*ww))))
title('Power spectrum of OFDM signal')

% Task c

% Demodulate data
y=OFDM_demod(x,g,N,n_bins);
% Plot real part of time series
figure
subplot(2,1,1)
plot(real(y),'bo')
title('Spectral lines of demodulated signal')
xlim([0 201])
% Plot constellation diagram
subplot(2,1,2)
plot(y,'bo')
axis('square')
xlim([-1.5 1.5])
ylim([-1.5 1.5])
title('Constellation diagram of demodulated signal')

% Task d
chan=[1 0 0 0 0.2*j 0 0 0 0 0 0 0.1]; %channel
% Pass signal through channel
x1=filter(chan,1,x);
% Demodulate data
y1=OFDM_demod(x1,g,N,n_bins);
% Plot real part of time series
figure
plot(real(y1),'bo')
title('Spectral lines of demodulated signal (channel present)')
xlim([0 201])
% Plot constellation diagram
figure
plot(y1,'bo')
axis('square')
xlim([-1.5 1.5])
ylim([-1.5 1.5])
title('Constellation diagram of demodulated signal (channel present)')

% Task e

% Replace guard interval with cyclic prefix
for n=1:(n_bins+g):(N*(n_bins+g))
   tmp=x(n+(n_bins+g)-50:(n+n_bins+g-1)); % obtain last 50 samples of symbol
   x(n:n+g-1)=tmp; % insert cyclic prefix
end

% Pass signal through channel
x2=filter(chan,1,x);
% Demodulate data
y2=OFDM_demod(x2,g,N,n_bins);
% Plot real part of time series
figure
plot(real(y2),'bo')
title('Spectral lines of demodulated signal with cyclic prefix (channel present)')
xlim([0 201])
% Plot spectral lines
figure
plot(y2,'bo')
axis('square')
xlim([-1.5 1.5])
ylim([-1.5 1.5])
title('Constellation diagram of demodulated signal with cyclic prefix (channel present)')

% Task f

data=ifft(fftshift([zeros(1,50) n_QAM(50,4) 0 n_QAM(50,4) zeros(1,50)])); %create preamble
p=[data(n_bins-49:end) data];
x=[p x]; %append preamble to data sequence

chan=[1 0 0 0 0.2*j 0 0 0 0 0 0 0.1]; %channel
% Pass signal through channel
x3=filter(chan,1,x);
% Demodulate data
[y3]=OFDM_demod(x3,g,N+1,n_bins,p);
% Plot real part of time series
figure
plot(real(y3),'bo')
title('Spectral lines of demodulated signal with equalization')
xlim([0 201])
% Plot spectral lines
figure
plot(y3,'bo')
axis('square')
xlim([-1.5 1.5])
ylim([-1.5 1.5])
title('Constellation diagram of demodulated signal with equalization')

