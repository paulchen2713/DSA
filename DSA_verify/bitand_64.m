%
% bitand_64 function
%
% function for 64-bit-and operation, reason why we manually design this
% operation is because the build-in 64-bit-and function in matlab is not 
% that accurate in higher digits, e.g. 52-bits or higher is not reliable
%
function out = bitand_64(a, b)
% split a into left, and right parts in char string type
a_left  = a(1:8);
a_right = a(9:16);
% convert a into decimal type
a_left_dec  = uint32(hex2dec(a_left));
a_right_dec = uint32(hex2dec(a_right));

% split b into left, and right parts in char string type
b_left  = b(1:8);
b_right = b(9:16);
% convert b into decimal type
b_left_dec  = uint32(hex2dec(b_left));
b_right_dec = uint32(hex2dec(b_right));

% do bit-and opertion separately
a_b_left_dec  = bitand(a_left_dec,  b_left_dec);
a_b_right_dec = bitand(a_right_dec, b_right_dec);

% turn a, b back into decimal type
a_b_left  = dec2hex(a_b_left_dec,  8);
a_b_right = dec2hex(a_b_right_dec, 8);

% concatenate left and right string
out = strcat(a_b_left, a_b_right);
return
