%
% bitcmp for 64bit
%
function out = bitcmp_64(a)
    a_left=a(1:8);
    a_right=a(9:16);
    a_left_dec=uint32(hex2dec(a_left));
    a_right_dec=uint32(hex2dec(a_right));
    a_left_dec=bitcmp(a_left_dec);
    a_right_dec=bitcmp(a_right_dec);
    a_left=dec2hex(a_left_dec,8);
    a_right=dec2hex(a_right_dec,8);
    out=strcat(a_left,a_right);
return

