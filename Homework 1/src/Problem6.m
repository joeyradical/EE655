clear
load workspace
close all
subplot(2,1,1)
plot(x1, 'k')
grid on
axis('square')
hold on
plot(x1(1:8:8*N),'r.')
title('Constellation Diagram at shaping filter output when alpha = 0.2')

subplot(2,1,2)
plot(x2, 'k')
grid on
axis('square')
hold on
plot(x2(1:8:8*N),'r.')
title('Constellation Diagram at shaping filter output when alpha = 0.4')

save('workspace.mat')