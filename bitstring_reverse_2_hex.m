%
% bit string(in decimal number) --> reverse --> hex
%
function out = bitstring_reverse_2_hex(bitstring)
bs = bitstring;      % bs for bitstring
bs = (flipud(bs'))'; % transpose -> flip upside down -> transpose
bs = char(bs + 48);  % text 0 in ASCII code is 48
bs_hex = char();
for i = 0 : 15
    bs_hex = strcat(bs_hex, dec2hex(bin2dec(bs(i*4 + 1 : (i+1)*4)), 1));
end
% output 16-bit string, test through bitstring_reverse_2_hex(zeros(1, 64))
out = bs_hex;
return
