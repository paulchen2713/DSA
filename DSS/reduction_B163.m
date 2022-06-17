%
% Reduction for B163, similar to module operation, B163 only
%
function out = reduction_B163(C)
    %
    % ref. Guide to ECC textbook, p.55
    %
    % C = a + b is consist of 12 sections of 32-bit words
    % first, compute the result of 11~6 sections(12~7 in matlab indecies)
    for i = 12 : -1 : 7
        T = uint32(C(i));
        % C(0) = T << 29, C(1) = T >> 3
        C(i-6) = addition_B(C(i-6), bitshift(T, 29));
        C(i-5) = addition_B(addition_B(addition_B(C(i-5), bitshift(T, 4)), addition_B(bitshift(T, 3), bitshift(T, -3))), T);
        C(i-4) = addition_B(addition_B(C(i-4), bitshift(T, -28)), bitshift(T, -29));
    end
    T = uint32(C(6)); % T = C(6)
    T = bitshift(T, -3);
    C(1) = addition_B(addition_B(addition_B(C(1), bitshift(T, 7)), addition_B(bitshift(T, 6), bitshift(T, 3))), T);
    % C(2) = addition_B(addition_B(C(2),bitshift(T,-25)),bitshift(T,-26));
    C(2) = addition_B(addition_B(addition_B(C(2), bitshift(T, -25)), bitshift(T, -26)), bitshift(T, -29));
    C(6) = bitand(C(6), 7); % contend last 7 bits, through bitmask 000...0111
    out = C(1:6);
return

