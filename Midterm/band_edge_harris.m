function [hh,gg,g]= band_edge_harris(m_smpl,alpha,m_dly)
% band_edge_harris(m_smpl,alpha,m_dly), 
% hh is sqrt Nyquist matched filter
% gg     positive freq band edge filter
% g      baseband band edge filter
% m_smpl samples/symbol, alpha excess bw
% m_dly is delay in symbols to filter center
% n_len=2*m_dly+1
hh=rcosine(1,m_smpl,'sqrt',alpha,m_dly);
hh=hh/(max(hh));
nn=length(hh);
tt= (-m_dly*m_smpl:1:m_dly*m_smpl);
g=sinc(2*alpha/m_smpl*tt-0.5) + sinc(2*alpha/m_smpl*tt+0.5);
g=g/sum(g);
mm=nn/2;

% now translate center to (1+alpha)*fs/2
phi=(1+alpha)*(-mm:0.5:mm)/(2*m_smpl);
phi=phi(2:2:length(phi));
gg=exp(j*2*pi*phi).*g;