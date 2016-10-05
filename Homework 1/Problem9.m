clear
load workspace
close all
subplot(2,1,1)
plot(y1, 'k')
grid on
axis('square')
hold on
plot(y1(1:8:8*N),'r.')
title('Constellation Diagrams at matched filter output when alpha = 0.2')

subplot(2,1,2)
plot(y2, 'k')
grid on
axis('square')
hold on
plot(y2(1:8:8*N),'r.')
title('Constellation Diagrams at matched filter output when alpha = 0.4')

save('workspace.mat')