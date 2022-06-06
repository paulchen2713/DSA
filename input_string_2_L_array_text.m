%
% inputstring_2_L_array_text function
%
function [out, k] = input_string_2_L_array_text(s_input, d, subtype)
% fixed coefficients
b = 1600;
c = 2 * d;
r = b - c; % rate,  for every r-bit a section
%
s_len = length(s_input);
s = char();
for is = 1 : s_len
    s = strcat(s, dec2hex(double(s_input(is)), 2));
end
%
r8 = r / 8; % every 1 char == 2 hex digits == 8-bit
k = floor(s_len / r8) + 1;
sr = mod(s_len, r8);
%
% 2 kinds of padding
if strcmp(subtype, 'HASH') == 1
    if sr == r8 - 1
        s = strct(s, dec2hex(128 + 6, 2)); % padding 01100001
    elseif sr ~= r8 - 1
        s = strcat(s, dec2hex(6, 2)); % padding 01100000 ... 
        for i = 1 : (r8 - sr - 2)
            s = strcat(s, '00'); % padding ... 00000000 ...
        end
        s = strcat(s, dec2hex(128, 2)); % padding ... 00000001
    end
elseif strcmp(subtype, 'XOF') == 1
    if sr == r8 - 1
        % padding 11111001 in reverse order, which means msb is actually the right-most bit
        s = strcat(s, dec2hex(128 + 16 + 15, 2));
    elseif sr ~= r8 - 1
        s = strcat(s, dec2hex(16 + 15, 2)); % padding 111110000 ... 
        for i = 1 : (r8 - sr - 2)
            s = strcat(s, '00'); % padding ... 00000000 ...
        end
        s = strcat(s, dec2hex(128, 2)); % padding ... 00000001
    end 
end
%
% convert the message into the lane array
r64 = r / 64; 
Lk = char();
index = 2;
for ik = 1 : k
    for iy = 0 : 4
        for ix = 0 : 4
            % 2 conditions
            if (ix + 5*iy + 1) <= r64
                for iz = 0 : 7
                    % fetch 2 hex-digit a time
                    Lk(ix + 1, iy + 1, 2*(8-iz) - 1 : 2*(8-iz), ik) = s(index - 1 : index);
                    index = index + 2;
                end
            else
                % padding 16 binary zero(4 hex-digit zero)
                Lk(ix + 1, iy + 1, :, ik) = '0000000000000000';
            end
        end
    end
end
out = Lk;
% [out, k] = [Lk, k];
return
