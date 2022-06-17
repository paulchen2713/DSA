%
% ECC B163 ElGama cryptographic system
%
clear;
clc;
%
global f fr ifx a b f_dec fr_dec a_dec b_dec;
m = 163; % B-m == B163
% split the large number into 6 row, each row is a 8-digit hexadecimal, 
% cause the number is too large to be represent or store in single byte
f  = ['000000c9';'00000000';'00000000';'00000000';'00000000';'00000008'];
fr = ['000000c9';'00000000';'00000000';'00000000';'00000000';'00000000'];
a  = ['00000001';'00000000';'00000000';'00000000';'00000000';'00000000'];
b  = ['4a3205fd';'512f7874';'1481eb10';'b8c953ca';'0a601907';'00000002'];
n  = ['a4234c33';'77e70c12';'000292fe';'00000000';'00000000';'00000004'];
Gx = ['e8343e36';'d4994637';'a0991168';'86a2d57e';'f0eba162';'00000003'];
Gy = ['797324f1';'b11c5c0c';'a2cdd545';'71a0094f';'d51fbc6c';'00000000'];
%
ifx = size(f, 1);
zero = zeros(ifx, 1); % the 0 for BigNumber computation
one  = zeros(ifx, 1); % the 1 for BigNumber computation
one(1) = 1;
%
f_dec  = hex2dec(f);
fr_dec = hex2dec(fr);
a_dec  = hex2dec(a);
b_dec  = hex2dec(b);
n_dec  = hex2dec(n);
Gx_dec = hex2dec(Gx);
Gy_dec = hex2dec(Gy);
%
% ref. Guide to ECC, p.132
%
Mx = zeros(ifx, 95); % meaningful ASCII code range fron 32 to 126
My = zeros(ifx, 95); % 126 - 32 + 1 == 95
for im = 32 : 126
    % im
    X = 100 * im;
    flag = 1; % if not find
    while flag == 1
        % X 
        x = zero;
        x(1) = X;
        % RHS = x^3 + ax^2 + b
        right = addition_B(multiplication_B(square_B(x), addition_B(x, a_dec)), b_dec);
        x2 = multiplicative_inverse_B(square_B(x));
        c = multiplication_B(right, x2); % c == C'
        H = zero; % H = H(C')
        c4 = c; % c4
        % m == order of the function
        for i = 0 : (m-1)/2
            H = addition_B(H, c4);
            c4 = square_B(square_B(c4));
        end
        y = multiplication_B(H, x);
        % LHS = y^2 + xy
        left = addition_B(square_B(y), multiplication_B(x, y));
        %
        % if X is on the curve
        if any(left - right) == 0
            Mx(:, im - 31) = x;
            My(:, im - 31) = y;
            % right
            % left
            flag = 0;
        %
        % if X is not on the curve
        else
            % brute force to find the point that on the curve
            X = X + 1;
        end
    end
end
save M_B163 Mx My % saving var Mx, My in M_B163.mat
%
