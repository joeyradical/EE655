load workspace
close all
figure
subplot(2,1,1)
plot(0,0)
hold on
for n=1:8:8*N-16
    plot(-1:1/8:1, real(y1(n:n+16)), 'b')
end
hold off
title('Eye Diagram at output of matched filter when alpha = 0.2')
subplot(2,1,2)
plot(0,0)
hold on
for n=1:8:8*N-16
    plot(-1:1/8:1, real(y2(n:n+16)), 'b')
end
hold off
title('Eye Diagram at output of matched filter when alpha = 0.4')
save('workspace.mat')