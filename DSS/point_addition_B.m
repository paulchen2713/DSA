%
% ECC (Elliptic Curve Cryptography) B
%
% point addition function
%
% ref. Handbook of E&HECC, p.293
%
function [X3,Y3,Z3] = point_addition_B(X1, Y1, Z1, X2, Y2, Z2)
global a_dec ifx;

zero = zeros(ifx, 1);
one = zeros(ifx, 1);
one(1) = 1;
if any(X1 - one) == 0 && any(Y1 - one) == 0 && any(Z1 - zero) == 0
    X3 = X2;
    Y3 = Y2;
    Z3 = Z2;
    return
end

if any(X2 - one) == 0 && any(Y2 - one) == 0 && any(Z2 - zero) == 0
    X3 = X1;
    Y3 = Y1;
    Z3 = Z1;
    return
end

if any(X1 - X2) == 0
    if any(Y1 - addition_B(X2, Y2)) == 0
        X3 = one;
        Y3 = one;
        Z3 = zero;
        return
    else
        [X3, Y3, Z3] = point_double_B(X1, Y1, Z1);
        return
    end
else
    Z22 = square_B(Z2);
    A = multiplication_B(X1, Z22);
    Z12 = square_B(Z1);
    B = multiplication_B(X2, Z12);
    Z23 = multiplication_B(Z22, Z2);
    C = multiplication_B(Y1, Z23);
    Z13 = multiplication_B(Z12, Z1);
    D = multiplication_B(Y2, Z13);
    E = addition_B(A, B);
    F = addition_B(C, D);
    G = multiplication_B(E, Z1);
    FX2 = multiplication_B(F, X2);
    GY2 = multiplication_B(G, Y2);
    H = addition_B(FX2, GY2);
    Z3 = multiplication_B(G, Z2);
    I = addition_B(F, Z3);
    Z32 = multiplication_B(a_dec, square_B(Z3)); % special attention
    FI = multiplication_B(F, I);
    E2 = square_B(E);
    E3 = multiplication_B(E2, E);
    X3 = addition_B(addition_B(Z32, FI), E3); % X3=a*Z3^2+F*I+E^3, a=1
    IX3 = multiplication_B(I, X3);
    G2 = square_B(G);
    G2H = multiplication_B(G2, H);
    Y3 = addition_B(IX3, G2H);
end

return
