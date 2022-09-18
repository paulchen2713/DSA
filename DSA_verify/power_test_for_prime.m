%
% power test for prime, primitive root
%
clear;
clc;
%
p  = 13; % prime number p to be tested
PP = zeros(p-1, p); % constract a prime matrix PP
% ip row
for ipr = 1 : p-1
    PP(ipr, 1) = ipr;
    % ip column
    for ipc = 2 : p
        PP(ipr, ipc) = mod(PP(ipr, ipc - 1) * ipr, p);
    end
end
%
% 2nd, 6th, 7th, 11th row are the primitive element
%

