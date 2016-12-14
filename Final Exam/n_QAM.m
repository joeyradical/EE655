function [y] = n_QAM(N,n)
% QAM_16(N)
%   Generates N symbols of n-QAM
%   N = number of symbols
%   n = number of constellation points (4 or 16)
if n ==16
    y=(floor(4*rand(1,N))-1.5)/1.5+j*(floor(4*rand(1,N))-1.5)/1.5;
elseif n==4
    y=(floor(2*rand(1,N))-0.5)/0.5+j*(floor(2*rand(1,N))-0.5)/0.5;
else
    y=-1;
    warning([num2str(n) ' is not a valid number of constellation points'])
end
    


end

