%
% bit string (number) > reverse > hex
%
% input: 0,1 decimal string
%
function out=bitstring_reverse_2_hex(bs)
    bs=(flipud(bs'))';
    bs=char(bs+48);
    bs_hex=char();
    for i=0:15
        bs_hex=strcat(bs_hex,dec2hex(bin2dec(bs(i*4+1:(i+1)*4)),1));
    end
    out=bs_hex;
return

