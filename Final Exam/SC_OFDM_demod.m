function [y] = SC_OFDM_demod(x,N,c)
%SC-OFDM(x,N)
%   Demodulates SC-OFDM data
%Input parameters:
%   x=input data stream
%   N=number of symbols
%   c=channel estimate(optional)
%Output variables:
%   y=demodulated data stored N*64 matrix

y=[];
for nn=1:160:N*160
   sym=x((nn+32):(nn+159)); % remove guard interval
   sym_f=fftshift(fft(sym)); % perform fft and center samples
   sym_c=sym_f(33:96); % obtain 64 center samples
   if exist('c','var')
       sym_c=sym_c./c(65+(-32:31)); %if channel is passed as parameter, equalize
   end
   y=[y; ifft(sym_c)]; % perform 64-point ifft
end

end

