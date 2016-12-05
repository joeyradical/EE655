function [hh,ggp,ggm,g]=band_edge_harris(m_smpl,alpha,m_dly)
% band_edge_harris(m_smpl,alpha,m_dly), 

% hh is sqrt Nyquist matched filter
% gg is positive freq band edge filter
% g  is baseband band edge filter
% m_smpl is samples/symbol, 
% alpha is excess bw
% m_dly is delay in symbols to center of filter
% n_len=2*m_dly+1
% try band_edge_harris(4,0.25,10) or band_edge_harris(4,0.25,15)

% m_smpl=4
% alpha=0.2
% m_dly=10;
%m_dly=floor(n_len/(2*m_smpl));

hh=rcosine(1,m_smpl,'sqrt',alpha,m_dly);
hh=hh/max(hh);
hh_scl=sum(hh);
nn=length(hh);

g1= sinc(2*alpha/m_smpl*(-m_dly*m_smpl:1:m_dly*m_smpl)-0.5);
g2 = sinc(2*alpha/m_smpl*(-m_dly*m_smpl:1:m_dly*m_smpl)+0.5);
g = g1 + g2;
g_scl=sum(g);
t = -m_dly:(2*m_dly)/(length(g)-1):m_dly;

%nn1=length(g)
mm=nn/2;
% now translate center to (1+alpha)*fs/2 or better way of putting is 
% R + alpha * R

phi=(1+alpha)*(-mm:0.5:mm)/(2*m_smpl);
phi=phi(2:2:length(phi));
ggp=exp(j*2*pi*phi).*g*sum(hh)/sum(g);
ggm=exp(-j*2*pi*phi).*g*sum(hh)/sum(g);
