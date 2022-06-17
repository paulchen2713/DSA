%
% ECC B163 ElGama cryptographic system
%
% clear all;
clc;

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
% testing
%
% by using equation in Guide to ECC textbook, p.81
% y^2 + xy = x^3 + ax^2 + b
%
% perform the squre, and multiplication operation through the subfunction
left = addition_B(square_B(Gy_dec), multiplication_B(Gx_dec, Gy_dec));
right = addition_B(multiplication_B(square_B(Gx_dec), addition_B(Gx_dec, a_dec)), b_dec);
check = any(left - right); % any( if != 0 ) return 1, else return 0
%
% ECC cryptographic system
%
% Alice sends a message to Bob
%
% preparation process for Bob
%    private key: nb
%    public key: G = [Gx, Gy], Pb = nb*G
%
% ECC_B163_ElGama1 = cputime;
starting_time = cputime; % fetch the current time at the starting time
nb = ['00000065';'00000000';'00000000';'ffffffff';'ffffffff';'00000000'];
nb_dec = hex2dec(nb);
[Pbx, Pby] = point_multiplication_B(Gx_dec, Gy_dec, nb_dec);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
% Encryption process
%   message: M
%   private key: na
%
M = 'Someday';
% M = 'Do not judge a book by its cover. Do not judge me from my outside.';
M_len = length(M);
M_dec = double(M);
% (Pmx, Pmy) point on elliptic curve of M
Pmx = zeros(ifx, M_len);
Pmy = zeros(ifx, M_len);
%
% y^2 + xy = x^3 + ax^2 + b, if we know x then we can compute the LHS as C
% y^2 + xy = C, C = Right Hand Side compute result
% y^2/x^2 + y/x = C/x^2 = C'
% (y')^2 + y' = C', y' = y/x, C' = C/x^2
%
% using Algorithm 3.85 to slove (y')^2 + y' = C', Guide to ECC, p.133
% y' = H(C')
%    = C' + (C')^4 + (C')^16 + ... + (C')^{(m-1)/2}
%    = sigma{(C')2^2i}, i=0~(m-1)/2
%
load M_B163; % load the output data from M.mat that we have computed previously
for im = 1 : M_len
    Pmx(:, im) = Mx(:, M_dec(im) - 31);
    Pmy(:, im) = My(:, M_dec(im) - 31);
end
%
% Pa = na * G
%
na = ['00000029';'00000000';'ffffffff';'ffffffff';'ffffffff';'00000000'];
na_dec = hex2dec(na);
[Pax, Pay] = point_multiplication_B(Gx_dec, Gy_dec, na_dec);
%
% naPb = na * Pb
%
[naPbx, naPby] = point_multiplication_B(Pbx, Pby, na_dec);
%
% Pm_naPb =  Pm + naPb
%
Pm_naPbx = zeros(ifx, M_len);
Pm_naPby = zeros(ifx, M_len);
for im = 1 : M_len
    [Pm_naPbx(:, im), Pm_naPby(:, im), Z] = point_addition_B(Pmx(:, im), Pmy(:, im), one, naPbx, naPby, one);
    % turn the result back to 2D
    Z = multiplicative_inverse_B(Z);
    Z2 = square_B(Z);
    Z3 = multiplication_B(Z2, Z); % Z^3
    %
    Pm_naPbx(:, im) = multiplication_B(Pm_naPbx(:, im), Z2);
    Pm_naPby(:, im) = multiplication_B(Pm_naPby(:, im), Z3);
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
% Decryption process
%   received message: Pa, Pm_naPb
%
% nbPa = nb * Pa
%
[nbPbx, nbPby] = point_multiplication_B(Pax, Pay, nb_dec);
%
% R_Pm = Pm_naPb - nbPa ("-" for substraction) 
%
R_Pmx = zeros(ifx, M_len);
R_Pmy = zeros(ifx, M_len);
for im = 1 : M_len
    % ref. Guide ro ECC, p.81 Negative
    [Pm_naPbx(:, im), Pm_naPby(:, im), Z] = ...
        point_addition_B(Pm_naPbx(:, im), Pm_naPby(:, im), one, nbPbx, addition_B(nbPbx, nbPby), one);
    % turn the result back to 2D
    Z = multiplicative_inverse_B(Z);
    Z2 = square_B(Z);             
    Z3 = multiplication_B(Z2, Z); % Z^3
    %
    R_Pmx(:, im) = multiplication_B(Pm_naPbx(:, im), Z2);
    R_Pmy(:, im) = multiplication_B(Pm_naPby(:, im), Z3);
end
%
R_M_dec = zeros(1, M_len);
for im = 1 : M_len
    R_M_dec(im) = floor(R_Pmx(1, im) / 100);
end
R_M = char(R_M_dec);
%
%
ending_time = cputime;
ECC_B163_ElGama1 = ending_time - starting_time; % running time = ending - starting time
% ECC_B163_ElGama1 = cputime - ECC_B163_ElGama1; 
%
fprintf('the original message is:  %s\n', M);
fprintf('the recovered message is: %s\n', R_M);
fprintf('the computation time is:  %s\n', ECC_B163_ElGama1);
%

