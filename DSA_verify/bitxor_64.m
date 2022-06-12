%
% bitxor_64 function
%
% function for 64-bit-xor operation, reason why we manually design this
% operation is because the build-in 64-bit-xor function in matlab is not 
% that accurate in higher digits, e.g. 52-bits or higher is not reliable
function out = bitxor_64(a, b)
% a, b in char string type
a_left  = a(1:8);
a_right = a(9:16);
b_left  = b(1:8);
b_right = b(9:16);
% convert a, b into decimal type
a_left_dec  = uint32(hex2dec(a_left));
a_right_dec = uint32(hex2dec(a_right));
b_left_dec  = uint32(hex2dec(b_left));
b_right_dec = uint32(hex2dec(b_right));
%
a_b_left_dec  = bitxor(a_left_dec,  b_left_dec);
a_b_right_dec = bitxor(a_right_dec, b_right_dec);
%
a_b_left  = dec2hex(a_b_left_dec, 8);
a_b_right = dec2hex(a_b_right_dec, 8);
%
% concatenate left and right string
out = strcat(a_b_left, a_b_right);
return
