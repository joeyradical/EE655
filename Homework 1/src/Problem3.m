clear
load workspace
close all

N = 1000;
x0 = ((floor(2*rand(1,N))-0.5)/0.5)+j*((floor(2*rand(1,N))-0.5)/0.5);
x1 = zeros(1, 8*N);
x1(1:8:8*N) = x0;
x1 = filter(h1,1,x1);
subplot(2,1,1)
plot(real(x1(1:800)), 'k')
grid on
title('Random QPSK data through shaping filter with alpha = 0.2')

x2 = zeros(1, 8*N);
x2(1:8:8*N) = x0;
x2 = filter(h2,1,x2);
subplot(2,1,2)
plot(real(x2(1:800)), 'k')
grid on
title('Random QPSK data through shaping filter with alpha = 0.4')
save('workspace.mat')
