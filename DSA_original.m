%
% DSA (Digital Signature Algorithm) main program
%
% ref. Wikipedia Digital Signature Algorithm
clear;
clc;
%
% L-bit prime number p, such that p-1 is a multiple of q, q | p-1
%
p = 667211;
%
% N-bit prime number q
%
q = 66721;
%
% randomly choose an integer h, 1 < h < p-1
%
h = 14;
%
% check whether h is a primitive root
%
index = zeros(p-1, 1);
hh = 1; % meaningful ?
for i = 1 : p-1
    hh = mod(hh * h, p);
    index(hh) = 1;
end
index_sum = sum(index);
if index_sum ~= p-1
    fprintf('\n warning! for the choice of h = %d\n', h);
end
%
% compute g = h^((p-1) / q) mod p
%
pq = (p-1) / q; % pq has to be an integer, keep it unchanged
g = 1;
pqq = pq; % keep pq unchanged, use pqq for following computation
hh = h;   % keep h  unchanged, use hh  for following computation
while pqq ~= 0
    if mod(pqq, 2) == 1
        g = mod(g * hh, p);
    end
    hh = mod(hh * hh, p);
    pqq = floor(pqq / 2);
end
%
% generate a private key x, 0 < x < q
%
x = 23456;
%
% generate a public key y, y = g^x mod p
%
y = 1;
xx = x; % keep x unchanged, use xx for following computation
gg = g; % keep g unchanged, use gg for following computation
while xx ~= 0
    if mod(xx, 2) == 1
        y = mod(y * gg, p);
    end
    gg = mod(gg * gg, p);
    xx = floor(xx / 2);
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% signing
%
% choose an integer k, 0 < k < q
%
k = 21399;
%
% public key:  p, q, g, y
% private key: x, k
%
% compute r = (g^k mod p) mod q
%
r = 1;
kk = k; % keep k unchanged, use kk for following computation
gg = g; % keep g unchanged, use gg for following computation
while kk ~= 0
    if mod(kk, 2) == 1
        r = mod(r * gg, p);
    end
    gg = mod(gg * gg, p);
    kk = floor(kk / 2);
end
r = mod(r, q);
%
% compute ki, ki * k == 1 mod q, k inverse element
%
% Algorithm 2.19 Extended Euclidean algorithm for integers
ua = k;
va = q;
x1a = 1;
y1a = 0;
x2a = 0;
y2a = 1;
% 3. while u != 0
while ua ~= 0
    % 3.1
    qa = floor(va / ua);
    ra = va - qa * ua; % remainder r
    xa = x2a - qa * x1a;
    ya = y2a - qa * y1a;
    % 3.2
    va = ua;
    ua = ra;
    x2a = x1a;
    x1a = xa;
    y2a = y1a;
    y1a = ya;
end
gcd = va;
xa = x2a;
ya = y2a;
% check if xa is positive, cause we take xa positive only
if xa < 0
    ki = xa + q;
else
    ki = xa;
end
%
% compute the HASH value of the message m
%
m = 'document';
HASH_type = 'SHA3-512';
HASH_len = 512;
m_SHA = SHA3_text(m, HASH_type, HASH_len);
% only take first N-bit of the hash value
m_SHA = hex2dec(m_SHA(1:8));
%
% compute s = (ki * SHA(m) + x*r ) mod q
%
xr = mod(x * r, q);        % xr == x * r
mxr = mod(m_SHA + xr, q); % mxr == SHA(m) + xr
s = mod(ki * mxr, q);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% send the signature to the receiver, signature: (m, r, s)
%
% compute w, w * s = 1 mod q, w as s inverse
%
uw = s;
vw = q;
x1w = 1;
y1w = 0;
x2w = 0;
y2w = 1;
% 3. while u != 0
while uw ~= 0
    % 3.1
    qw = floor(vw / uw);
    rw = vw - qw * uw;   % remainder r
    xw = x2w - qw * x1w;
    yw = y2w - qw * y1w;
    % 3.2
    vw = uw;
    uw = rw;
    x2w = x1w;
    x1w = xw;
    y2w = y1w;
    y1w = yw;
end
gcd = vw;
xw = x2w;
yw = y2w;
% check if xa is positive, cause we take xa positive only
if xw < 0
    w = xw + q;
else
    w = xw;
end
%
% compute HASH value m_HASH of the received message
%
HASH_type = 'SHA3-512';
HASH_len = 512;
m_HASH = SHA3_text(m, HASH_type, HASH_len);
% only take first N-bit of the hash value
m_HASH = hex2dec(m_HASH(1:8));
%
% compute u1 = (SHA(m) * w) mod q
% compute u2 = (r * w) mod q
%
u1 = mod(m_HASH * w, q);
u2 = mod(r * w, q);
%
% compute gu1 = g^u1 mod p
%
gu1 = 1;
uu1 = u1; % keep u1 unchanged, use uu1 for following computation
gg = g;   % keep g  unchanged, use gg  for following computation
while uu1 ~= 0
    if mod(uu1, 2) == 1
        gu1 = mod(gu1 * gg, p);
    end
    gg = mod(gg * gg, p);
    uu1 = floor(uu1 / 2);
end
%
% compute yu1 = y^u2 mod p
%
yu2 = 1;
uu2 = u2; % keep u1 unchanged, use uu1 for following computation
yy = y;   % keep y  unchanged, use yy  for following computation
while uu2 ~= 0
    if mod(uu2, 2) == 1
        yu2 = mod(yu2 * yy, p);
    end
    yy = mod(yy * yy, p);
    uu2 = floor(uu2 / 2);
end
%
% compute v = ((g^u1 * y^u2) mod p) mod q
%
gy = mod(gu1 * yu2, p);
v = mod(gy, q);
%
% signature verification
%
if v == r
    fprintf('\n Valid Signature \n');
elseif v ~= r
    fprintf('\n Invalid Signature \n');
end













