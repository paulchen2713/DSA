%
% bit left-shift by one function
%
function out = special_bitshift_left_B(a)
    global ifx;
    a = uint32(a);
    bit_old = 0;
    for i = 1 : ifx+1 % special
        bit = bitget(a(i), 32);
        a(i) = bitshift(a(i), 1);
        a(i) = bitset(a(i), 1, bit_old);
        bit_old = bit;    
    end
    out = double(a);
return

