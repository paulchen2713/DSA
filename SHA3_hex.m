%
% SHA3_text function
%
function HASH = SHA3_hex(s_input, HASH_type, HASH_len)
%
% parameters and message
%
% HASH_type
% HASH_len
% s_input
%
d = 0;
dd = 0;
subtype = '';
if strcmp(HASH_type, 'SHA3-224') == 1
    d = 224; % the fixed langth of the massage digest size
    dd = d;  % bit number
    subtype = 'HASH';
elseif strcmp(HASH_type, 'SHA3-256') == 1
    d = 256; % massage digest size
    dd = d;
    subtype = 'HASH';
elseif strcmp(HASH_type, 'SHA3-384') == 1
    d = 384; % massage digest size
    dd = d;
    subtype = 'HASH';
elseif strcmp(HASH_type, 'SHA3-512') == 1
    d = 512; % massage digest size
    dd = d;
    subtype = 'HASH';
elseif strcmp(HASH_type, 'SHAKE128') == 1
    d = 128;
    dd = HASH_len;
    subtype = 'XOF';
elseif strcmp(HASH_type, 'SHAKE256') == 1
    d = 256;
    dd = HASH_len;
    subtype = 'XOF';
end
%
% fixed coefficient
b = 1600;  % total bits = 25*25*64 = 1600
nr = 24;   % number of rounds
c = 2 * d; % capacity
r = b - c; % for every r-bit a section
w = b / 25;   % depth of the state array = 1600 / 25 = 64
LL = log2(w); % use LL to avoid naming collision in just L
%
%
% Lk: , k: 
[Lk, k] = input_string_2_L_array_hex(s_input, d, subtype);
for ix = 0 : 4
    for iy = 0 : 4
        % fprintf('L(%d, %d) = %s\n',ix, iy, Lk(ix + 1, iy + 1, :));
    end
end
%
% initial state array
%
Lp = char();
for iy = 0 : 4
    for ix = 0 : 4
        Lp(ix + 1, iy + 1, :) = '0000000000000000';
    end
end
%
% sponge construction
%
for ik = 1 : k
    L = Lk(:, :, :, ik);
    for iy = 0 : 4
        for ix = 0 : 4
            % L(ix + 1, iy + 1, :) = bitxor_64(L(ix + 1, iy + 1, :), Lp(ix + 1, iy + 1, :));
        end
    end
    L = f_function(L);
    Lp = L;
end
%
% final state
% fprintf('final state \n');
for ix = 0 : 4
    for iy = 0 : 4
        % fprintf('L(%d, %d) = %s\n',ix, iy, L(ix + 1, iy + 1, :, 1));
    end
end
%
% generation of the HASH value
%
HASH = char();
d8 = dd / 8;
counter = 0;
if strcmp(subtype, 'HASH') == 1
%     HASH = char();
%     d8 = dd / 8;
%     counter = 0;
    for iy = 0 : 4
        for ix = 0 : 4
            for iz = 0 : 7
                counter = counter + 1;
                if counter <= d8
                    HASH = strcat(HASH , L(ix + 1, iy + 1, 16 - 2*iz - 1, 1));
                    HASH = strcat(HASH , L(ix + 1, iy + 1, 16 - 2*iz    , 1));
                end
            end
        end
    end
elseif strcmp(subtype, 'XOF') == 1
    HASH = char();
    d8 = floor(dd / 8); % 
    r8 = r / 8;         % 
    counter = 0;
    for iy = 0 : 4
        for ix = 0 : 4
            for iz = 0 : 7
                counter = counter + 1;
                if counter <= r8
                    HASH = strcat(HASH , L(ix + 1, iy + 1, 16 - 2*iz - 1, 1));
                    HASH = strcat(HASH , L(ix + 1, iy + 1, 16 - 2*iz    , 1));
                end
            end
        end
    end
    while length(HASH) < d8 * 2
        L = f_function(L);
        counter = 0;
        for iy = 0 : 4
            for ix = 0 : 4
                for iz = 0 : 7
                    counter = counter + 1;
                    if counter <= r8
                        HASH = strcat(HASH , L(ix + 1, iy + 1, 16 - 2*iz - 1, 1));
                        HASH = strcat(HASH , L(ix + 1, iy + 1, 16 - 2*iz    , 1));
                    end
                end
            end
        end
    end % end while
    HASH = HASH(1 : d8 * 2);
end
HASH = lower(HASH);
%
return
