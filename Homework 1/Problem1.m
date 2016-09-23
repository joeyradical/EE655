clear
close all
% Problem 1
% Filter 1: roll off factor 0.2
h1 = rcosine(1, 8, 'sqrt', 0.2, 10);
h1 = h1/max(h1);

% Filter 2: roll off factor 0.4
h2 = rcosine(1, 8, 'sqrt', 0.4, 10);
h2 = h2/max(h2);

subplot(2,2,1);
plot(0:length(h1)-1, h1);
hold on
plot(0:8:length(h1)-1, h1(1:8:length(h1)), 'ro')
title('Impulse Response when alpha = 0.2')

subplot(2, 2, 2)
plot(0:length(h2)-1, h2)
hold on
title('Impulse Response when alpha = 0.4')
plot(0:8:length(h2)-1, h2(1:8:length(h2)), 'ro')
grid on

[H1, F1] = freqz(h1, 1, -pi:pi/100000:pi);
subplot(2,2,3)
H1mag = mag2db(abs(H1));
plot(F1/pi, H1mag)
title('Frequency Response when alpha = 0.2')
axes('Position',[.35 .35 .1 .1])
plot(F1/pi, H1mag)
ylim([17.585 17.615])
xlim([-0.11 0.11])
box on

[H2, F2] = freqz(h2, 1, -pi:pi/100000:pi);
subplot(2,2,4)
H2mag = mag2db(abs(H2));
plot(F2/pi, H2mag)
title('Frequency Response when alpha = 0.4')
axes('Position',[.79 .35 .1 .1])
plot(F2/pi, H2mag)
ylim([17.158 17.163])
xlim([-0.11 0.11])
box on
save('workspace.mat')





