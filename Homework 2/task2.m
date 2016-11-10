clear 
close all
%task A
N = 1000
sigma = 0.02
fs = 4
h = rcosine(1, fs, 'sqrt', 0.5, 6);
h = h/max(h);
x0 = ((floor(2*rand(1,N))-0.5)/0.5)+j*((floor(2*rand(1,N))-0.5)/0.5);
x1 = zeros(1, 4*N);
x1(1:4:4*N) = x0;
x1 = filter(h,1,x1);


subplot(2,1,1)
plotEyeDiagram(x1,fs,'Eye diagram of modulated data')
subplot(2,1,2)
plotConstellationDiagram(x1,fs,'Constellation diagram of modulated data')

%task b
figure
x2 = x1 + sigma*(randn(1,length(x1))+j*randn(1,length(x1)));
x3 = x2 * exp(j *2*pi*0.05);
subplot(2,1,1)
plotEyeDiagram(x3,fs,'Eye diagram of modulated data with noise and phase shift')
subplot(2,1,2)
plotConstellationDiagram(x3,fs,'Constellation diagram of modulated data with noise and phase shift')

%task c
hm = h/(h*h');
y=filter(hm,1,x3);
figure
subplot(2,1,1)
plotEyeDiagram(y,fs,'Eye diagram at matched filter output')
subplot(2,1,2)
plotConstellationDiagram(y,fs,'Constellation diagram at matched filter output')

%task d
x5 = zeros(1,fs*N);
reg = zeros(1,49);
for n=1:fs*N
    reg=[x3(n) reg(1:48)];
    x5(n)=reg*hm';
      if n>20
        if rem(n,4)==1;
           x5_d=sign(real(x5(n)));
           y5_d=sign(imag(x5(n)));
           i = (n-1)/4;
           p2(i) = (x5_d+j*y5_d)*conj(x5(n));
           hold on
        end
      end
end
figure
subplot(2,1,1)
plot(p2(20:end), 'k')
grid on
axis('square')
hold on
plot(p2(20:end),'r.')
title('Output of detector')
subplot(2,1,2)
plot(0:length(p2)-1, -angle(p2)/(2*pi))
title('Output of ATAN')

%task e
theta_0= 2*pi/1000;
eta=sqrt(2)/2;
eta=1*eta;
k_i= (4*theta_0*theta_0)/(1+2*eta*theta_0+theta_0*theta_0);
k_p= (4*eta*theta_0)/(1+2*eta*theta_0+theta_0*theta_0);
 
phs_accum=0;
int=0;
fltr_hld=0;
reg=zeros(1,49);
m=1;
p2_sv = zeros(1,999)
d_phi_sv = zeros(1,999);
for n=1:4000
    p1=x3(n)*exp(-j*2*pi*phs_accum);
    reg=[p1 reg(1:48)];
    x5(n)=reg*hm';
      if n>20
        if rem(n,4)==1;
           x5_d=sign(real(x5(n)));
           y5_d=sign(imag(x5(n)));
           i = (n-1)/4;
           p2 = (x5_d+j*y5_d)*conj(x5(n));
           p2_sv(i) = p2;
           d_phi=-angle(p2)/(2*pi);
           d_phi_sv(m)=d_phi;
              int=int+d_phi*k_i;
              fltr=int+d_phi*k_p;
              fltr_hld=fltr;
              m=m+1;
        end
        phs_accum_sv(n)=phs_accum;
           phs_accum=phs_accum+fltr_hld;
      end
end
figure
subplot(3,1,1)
plotConstellationDiagram(x5,fs,'Constellation diagram with PLL')
subplot(3,1,2)
plot(p2_sv(20:end), 'k')
grid on
axis('square')
hold on
plot(p2_sv(20:end),'r.')
title('Output of detector')
subplot(3,1,3)
plot(0:length(d_phi_sv)-1, d_phi_sv)
title('Output of ATAN')