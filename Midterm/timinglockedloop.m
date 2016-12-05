clear
close all

% Task a

% shaping filter
hhx=rcosine(1,8,'sqrt',0.5,6);   % Shaping Filter
hh=[hhx zeros(1,7)];            % zero extend for length a multiple of 8             
hh=hh/max(hh);                  % scale for unity amplitude at modulator
hh2=reshape(hh,8,13);  

hh_t=rcosine(1,60,'sqrt',0.5,6);                % Matched filter
hh_t=[hh_t zeros(1,59)];                        % zeros extending
scl=hh_t(1:30:length(hh_t))*hh(1:4:length(hh))';% scale for unity gain
hh_t=hh_t/scl;
hh_t2=reshape(hh_t,30,26);


% Plot frequency response for each matched filter
figure
subplot(1,2,1)
for k = 1:30
    plot(linspace(-0.5,0.5,1024)*2,fftshift(abs(fft(hh_t2(k,:),1024))),'b')
    hold on
end
title('Frequency response of all 30 filters')
% Plot group delay for each matched filter
subplot(1,2,2)
plot(0,0); hold on
for k=1:30
[GD,W]=grpdelay(hh_t2(k,:),1,128,'whole');
plot((-0.5:1/128:0.5-1/128)*2,fftshift(GD))
grid on
end
hold off
axis([-1 1 10.9 12.1])
title('Group delay of all 30 filters')

% Task b

% Create modulated data
N_dat=1000;
   x0=(floor(2*rand(1,N_dat))-0.5)/0.5+j*(floor(2*rand(1,N_dat))-0.5)/0.5;

% Shape and up-sample input constellation
reg=zeros(1,13);
mm=0;               %output clock index
for nn=1:N_dat
   reg=[x0(nn) reg(1:12)];
      for kk=1:8
          x1(mm+kk)=reg*hh2(kk,:)';
      end
   mm=mm+8;
end
% Generate timing error   
x2=x1(3:4:8*N_dat);

% Plot constellation diagram of data passed through each matched filter
figure

for n = 1:30   
    subplot(6,5,n)
    v=filter(hh_t2(n,:),1,x2);
    grid on
    
    plot(v(2:2:end),'r.')
    ylim([-1.5 1.5])
    xlim([-1.5 1.5])
    axis('square')
    title(['Filter no. ' num2str(n)])
end

% Task c

% Create polyphase derivative matched filter

dhh_t=conv(hh_t,[1 0 -1]*30);                   % derivative matched filter

dhh_t2=reshape(dhh_t(2:781),30,26);             % 32 path polyphase dMF

% Timing Recovery Loop
theta_0= 2*pi/200;
eta=sqrt(2)/2;
eta=4*eta;

k_i_t= (4*theta_0*theta_0)/(1+2*eta*theta_0+theta_0*theta_0);
k_p_t= (4*eta*theta_0)/(1+2*eta*theta_0+theta_0*theta_0);

reg_t=zeros(1,26);
int_t=0.0;

x6 = zeros(1,2*N_dat);

ndx_strt=10;   % Can Change starting index

accum_t=ndx_strt;
accum_t_sv=zeros(1,N_dat);

% figure(4)
pp=-1;
mm=1;                           % output clock at 1-sample per symbol
for nn=21:2:length(x2)-2
    reg_t=[x2(nn) reg_t(1:25)];     % new sample in matched filter register
    pntr=floor(accum_t);            % point to a coefficient set
    y_t1 =reg_t*hh_t2(pntr,:)';      % MF output time sample
    dy_t1=reg_t*dhh_t2(pntr,:)';    % dMF output time sample 
    x6(nn)=y_t1;                    % save MF output sample

    reg_t=[x2(nn+1) reg_t(1:25)];   % new sample in matched filter register
    y_t2=reg_t*hh_t2(pntr,:)';      % point to a coefficient set
    x6(nn+1)=y_t2;                   % MF output time sample
    dy_t2=reg_t*dhh_t2(pntr,:)';    % dMF output time sample 

    det_t=pp*real(y_t2)*real(dy_t2);  % y*y_dot product (timing error)
    det_t_sv(mm)=det_t;             % save timing error
    int_t=int_t+k_i_t*det_t;        % Loop filter integrator 
    sm_t =int_t+k_p_t*det_t;        % loop filter output

    accum_t_sv(mm)=accum_t;         % save timing accumulator content
    mm=mm+1;                        % increment symbol clock
    accum_t=accum_t+sm_t;           % update accumulator
    
    if accum_t>31                   % test for accumulator overflow
        accum_t=accum_t-30;
        pp=-pp;
    end

    if accum_t<1                    % test for accumulator underflow
        accum_t=accum_t+30;
        pp=-pp;
    end
end

figure(50)
subplot(3,1,1)
plot(accum_t_sv(1:N_dat))
hold on
plot(floor(accum_t_sv(1:N_dat)),'r')
hold off
grid on
axis([0 1000 0 30])
title('Timing Loop Phase Accumulator and Pointer')


subplot(3,2,3)
plot(0,0)
hold on
for nn=1000:4:length(x2)-4
    plot(-1:1/2:1,real(x2(nn:nn+4)))
end
hold off
grid on
title('Eye Diagram')

subplot(3,2,4)
plot(x2(2:2:length(x2)),'r.')
grid on
axis('square')
title('Constellation Diagram')

subplot(3,2,5)
plot(0,0)
hold on
for nn=1000:4:length(x6)-4
    plot(-1:1/2:1,real(x6(nn:nn+4)))
end
hold off
grid on
title('Eye Diagram')

subplot(3,2,6)
plot(x6(2:2:200),'.')
hold on
plot(x6(1000:2:length(x6)),'r.')

hold off
grid on
axis('square')
title('Constellation Diagram')


