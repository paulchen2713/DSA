%
% Mulplication over B function
%
% ref. Guide to ECC textbook, p.53
%
% insert 0s in every 2bit, extend input from 8 to 16 bits
function out = square_pre_B(a)
    T = 0;
    for i = 1 : 8
        T = bitset(T, 2*i - 1, bitget(a, i));
    end
    out = T;
return
%

