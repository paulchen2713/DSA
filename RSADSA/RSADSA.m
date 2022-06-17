%
% RSA scheme DSA(Digital Signature Alogorithm)
%
% Purpose:
%   Signature generation: Alice
%   Signature verification: Bob
%
% step 1: Alice choose two very large distinct primes p and q, and computes 
%         n = p * q and £p(n) = (p-1) * (q-1)
% 
% step 2: Alice choose a random integer e, 1 < e < phi_n, such that gcd(e, £p(n)) = 1 
%
% step 3: Alice finds d, 1 < d < £p(n), such that e * d = 1 mod £p(n)
%
% step 4: Alice makes (n, e) public, and keeps (p, q, d) private
% 
% step 5: Alice computes s = HASH(m)^d mod n, and sends [m, s] to Bob where
%         m is the transmitted message, and s is the corresponded signature
% 
% step 6: Bob verifies [m, s] by computing s^e mod n, and comparing HASH(m),
%         and s^e mod n
%
clear;
clc;
starting_time = cputime; % fetch the current time at the starting time
%
% step 1: Alice choose two very large distinct primes p and q, and computes 
%         n = p * q and £p(n) = (p-1) * (q-1)
%
N = 13;
p = prime_generator(N);
q = prime_generator(N-1);
%
n = p * q;
phi_n = (p-1) * (q-1);
% 
% step 2: Alice choose a random integer e, 1 < e < phi_n, such that gcd(e, £p(n)) = 1 
%
flag = 0;
while flag == 0
    e = floor((phi_n - 2) * rand(1)) + 2;
    %
    % compute gcd(e, £p(n))
    %
    % Algorithm 2.19 Extended Euclidean algorithm for integers
    ue = e;     % u
    ve = phi_n; % v
    x1e = 1;
    y1e = 0;
    x2e = 0;
    y2e = 1;
    while ue ~= 0
        % 3.1
        qe = floor(ve / ue); % qq
        re = ve - qe * ue;
        xe = x2e - qe * x1e;
        ye = y2e - qe * y1e;
        % 3.2
        ve = ue;
        ue = re;
        x2e = x1e;
        x1e = xe;
        y2e = y1e;
        y1e = ye;
    end
    % gcd, Greatest Common Divisor
    gcd = ve;
    xe = x2e; % x
    % ye = y2e;
    if gcd == 1
        flag = 1;
    end
end
%
% step 3: Alice finds d, 1 < d < £p(n), such that e * d = 1 mod £p(n)
%         because m^£p(n) = 1 mod n
% check if xe is positive, cause we take xe positive only
if xe < 0
    d = phi_n + xe;
else
    d = xe;
end
%
% step 4: Alice makes (n, e) public, and keeps (p, q, d) private
% 
% step 5: Alice computes s = HASH(m)^d mod n, and sends [m, s] to Bob where
%         m is the transmitted message, and s is the corresponded signature
%
m = 'document';       % message sended: m
% m = 'The low secrecy message Alice sended to Bob that only need verification.';
HASH_type = 'SHA3-512'; % HASH type: SHA3-512
HASH_len = 512;         % output length: 512 bits
m_SHA3 = SHA3_text(m, HASH_type, HASH_len); % hash value of m: m_SHA3
ms = hex2dec(m_SHA3(1:3)); % take only the first 1~3 digit of m_SHA3
%
% s = HASH(m)^d mod n,
%
s = 1;
dd = d;  % keep d  unchanged, use dd for following computation
mm = ms; % keep ms unchanged, use mm for following computation
while dd ~= 0
    if mod(dd, 2) == 1
        s = mod(s * mm, n);
    end
    dd = floor(dd / 2);
    mm = mod(mm * mm, n);
end
% 
% step 6: Bob verifies [m, s] by computing s^e mod n, and comparing HASH(m),
%         and s^e mod n
%
m = 'document';       % received message: m
% m = 'The low secrecy message Alice sended to Bob that onlt need verification.';
HASH_type = 'SHA3-512'; % corresponded HASH type: SHA3-512
HASH_len = 512;         % corresponded output length: 512 bits
m_SHA3 = SHA3_text(m, HASH_type, HASH_len); % corresponded hash value of m: m_SHA3
ms = hex2dec(m_SHA3(1:3)); % corresponded first 1~3 digit of m_SHA3
%
% rms = s^e mod n, recovery ms
%
rms = 1;
ee = e;  % keep e unchanged, use ee for following computation
ss = s;  % keep s unchanged, use ss for following computation
while ee ~= 0
    if mod(ee, 2) == 1
        rms = mod(rms * ss, n);
    end
    ee = floor(ee / 2);
    ss = mod(ss * ss, n);
end
ending_time = cputime; % fetch the current time at the ending time
RSADSA_time = ending_time - starting_time; % total computation time
%
% verification
%
if any(ms - rms) == 0
    fprintf('\nValid Signature. \n\n');
    % if its a valid signature, then print out the related data
    fprintf('the message m is: %s \n', m);
    fprintf('the first 3 digit of the hash value of m in hex is: %s \n', m_SHA3(1:3));
    fprintf('the first 3 digit of the hash value of m in dec is: %d \n', ms);
    fprintf('the public keys [n, e] are: [%d, %d] \n', n, e);
    fprintf('the private keys [p, q, d] are: [%d, %d, %d] \n', p, q, d);
    fprintf('the total computation time required is: %f sec \n\n', RSADSA_time);
else
    fprintf('\nInvalid Signature. \n\n');
end
%
%

