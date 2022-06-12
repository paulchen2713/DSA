%
% bit left-shift by one
%
function out=special_bitshift_left_B163(ai)
global ifx;
a=uint32(ai);
bit_old=0;
for i=1:ifx+1
    bit=bitget(a(i),32);
    a(i)=bitshift(a(i),1);
    a(i)=bitset(a(i),1,bit_old);
    bit_old=bit;    
end
out=double(a);
return