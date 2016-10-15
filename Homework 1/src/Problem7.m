clear
load workspace
close all


y1 = filter(hm1,1,x1);
subplot(2,1,1)
plot(real(y1(1:800)), 'k')
grid on
title('Random QPSK data through both filters with alpha = 0.2')

y2 = filter(hm2,1,x2);
subplot(2,1,2)
plot(real(y2(1:800)), 'k')
grid on
title('Random QPSK data through both filters with alpha = 0.4')
save('workspace.mat')