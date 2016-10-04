clear
load workspace
close all
% Problem 2
hm1 = h1/(h1*h1');
y1 = conv(h1, hm1);
subplot(2, 3, 1)
plot(-10:1/16:10,y1)
hold on
title('Impulse Response when alpha = 0.2')
plot(-10:1:10, y1(1:16:length(y1)), 'ro')
grid on

hm2 = h2/(h2*h2');
y2 = conv(h2, hm2);
subplot(2, 3, 2)
plot(-10:1/16:10, y2)
hold on
title('Impulse Response when alpha = 0.4')
plot(-10:1:10, y2(1:16:length(y2)), 'ro')
grid on

[Y1, FY1] = freqz(y1, 1, -pi:pi/100000:pi);
subplot(2,3,3)
Y1mag = mag2db(abs(Y1));
plot(FY1/pi, Y1mag)
title('Frequency Response when alpha = 0.2')
grid on

[Y2, FY2] = freqz(y2, 1, -pi:pi/100000:pi);
subplot(2,3,4)
Y2mag = mag2db(abs(Y2));
plot(FY2/pi, Y2mag)
title('Frequency Response when alpha = 0.4')
grid on

subplot(2,3,5)
plot(FY1/pi, Y1mag)
ylim([18, 18.1])
title('Passband Ripple when alpha = 0.2')
grid on

subplot(2,3,6)
plot(FY2/pi, Y2mag)
ylim([18, 18.1])
title('Passband Ripple when alpha = 0.4')
grid on

save('workspace.mat')