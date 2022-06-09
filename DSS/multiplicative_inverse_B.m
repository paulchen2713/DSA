%
% Multiplicative inverse module function
%
function out=multiplicative_inverse_B(a)
global f_dec ifx;
one = zeros(ifx,1);
one(1) = 1;
zero = zeros(ifx, 1);
%
% ref. Guide to ECC textbook, p.59
%
% 1. u = a, v = f
u = a;
v = f_dec;
%
% 2. g1 = 1, g2 = 0
g1 = one; 
g2 = zero;
%
% 3. while (u != 1 && v != 1)
while any(u-one) && any(v-one)
    %
    % 3.1 while (z % u == 0)
    while bitget(u(1, :), 1) == 0
        % u = u / z
        u = bitshift_right_B(u);
        % 
        if bitget(g1(1, :), 1) == 0
            g1 = bitshift_right_B(g1);
        else
            g1 = bitshift_right_B(addition_B(g1, f_dec));
        end
    end
    %
    % 3.2 while (z % v == 0)
    while bitget(v(1, :), 1) == 0
        v = bitshift_right_B(v);
        if bitget(g2(1, :), 1) == 0
            g2 = bitshift_right_B(g2);
        else
            g2 = bitshift_right_B(addition_B(g2, f_dec));
        end
    end
    %
    % find the deg(u), deg(v)
    i = ifx;
    while u(i) == 0
        i = i - 1;
    end
    j = 32;
    while bitget(u(i), j) == 0
        j = j - 1;
    end
    deg_u = (i-1)*32 + j;
    i = ifx;
    while v(i) == 0
        i = i - 1;
    end
    j = 32;
    while bitget(v(i), j) == 0
        j = j - 1;
    end
    deg_v = (i-1)*32 + j;
    %
    % 3.3 if deg(u) > deg(v)
    if deg_u > deg_v
        % then u = u + v, g1 = g1 + g2
        u  = addition_B(u, v);
        g1 = addition_B(g1, g2);
    % else when deg(u) < deg(v)
    else
        % then v = v + u, g2 = g2 + g1
        v  = addition_B(u, v);
        g2 = addition_B(g1, g2);
    end
end
if any(u - one) == 0
    out = g1;
else
    out = g2;
end

return
