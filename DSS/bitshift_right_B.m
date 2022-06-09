%
% bit right-shift by one function
%
function out = bitshift_right_B(a)
global ifx;
bit_old = 0;
for i = 1 : ifx
    bit = bitget(a(ifx-i+1), 1);
    a(ifx-i+1) = bitshift(a(ifx-i+1), -1);
    a(ifx-i+1) = bitset(a(ifx-i+1), 32, bit_old);
    bit_old=bit;    
end
out = a;

return
