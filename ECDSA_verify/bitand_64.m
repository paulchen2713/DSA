%
% bitand for 64 bits
%
function out = bitand_64(a,b)
    a_left=a(1:8);
    a_right=a(9:16);
    a_left_dec=uint32(hex2dec(a_left));
    a_right_dec=uint32(hex2dec(a_right));
    b_left=b(1:8);
    b_right=b(9:16);
    b_left_dec=uint32(hex2dec(b_left));
    b_right_dec=uint32(hex2dec(b_right));

    a_b_left_dec=bitand(a_left_dec,b_left_dec);
    a_b_right_dec=bitand(a_right_dec,b_right_dec);

    a_b_left=dec2hex(a_b_left_dec,8);
    a_b_right=dec2hex(a_b_right_dec,8);

    out=strcat(a_b_left,a_b_right);
return

