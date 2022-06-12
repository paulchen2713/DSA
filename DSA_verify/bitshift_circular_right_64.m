%
% bitshift circular right function
%
function out = bitshift_circular_right_64(a, num)
% string input to be shift
a_left  = a(1:8);
a_right = a(9:16);
a_left_dec  = uint32(hex2dec(a_left));
a_right_dec = uint32(hex2dec(a_right));

if num < 32
    temp_left  = bitget(a_left_dec, 1 : num);
    temp_right = bitget(a_right_dec, 1 : num);
    a_left_dec  = bitshift(a_left_dec,  -num);
    a_right_dec = bitshift(a_right_dec, -num);
    for i = 1 : num
        a_left_dec  = bitset(a_left_dec,  32 - num + i, temp_right(i));
        a_right_dec = bitset(a_right_dec, 32 - num + i, temp_left(i));
    end
    a_left = dec2hex(a_left_dec, 8);
    a_right = dec2hex(a_right_dec, 8);
    a_hex = strcat(a_left, a_right);
    out=a_hex;
elseif num == 32
%   temp=a_left_dec;
%   a_left_dec=a_right_dec;
%   a_right_dec=temp;
%   a_left_hex=dec2hex(a_left_dec,8);
%   a_right_hex=dec2hex(a_right_dec,8);
%   a_hex=strcat(a_left_hex,a_right_hex);
%   out=a_hex;
    out = strcat(a_right, a_left);
else
    out = bitshift_circular_left_64(a, 64 - num);
end
return

