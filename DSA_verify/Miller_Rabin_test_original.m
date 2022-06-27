%
% Miller Rabin primality test main program
%
clear;
clc;
%
% randomly generate an odd number p between (for instance) 2~100000
%
p = floor((100000 - 2) * rand(1)) + 2;
if mod(p, 2) == 0
    p = p - 1;
end
%
p1 = p-1;
%
k = 0;
q = p1;
while mod(q, 2) == 0
    k = k + 1;
    q = floor(q / 2);
end
%
% randomly select a number a, 0 < a < p-1
%
a = floor((p-2)*rand(1)) + 1;
%
% compute aq = a^q
%
aq = 1;
qq = q; % keep q unchanged, use qq for following computation
aa = a; % keep a unchanged, use aa for following computation
while qq ~= 0
    if mod(qq, 2) == 0
        aq = mod(aq * aa, p);
    end
    qq = floor(qq / 2);
    aa = mod(aa * aa, p);
end
%
% testing
%
result = ''; % store the result in a empty string
if mod(aq, p) == 1
    result = 'inconclusive';
end
if mod(aq, p) ~= 1
    if mod(aq, p) == p1
        result = 'inconclusive';
    end
    if mod(aq, p) ~= p1
       j = 1; % number of iterations
       while strcmp(result, '') == 1 && j <= k -1
           aq = mod(aq * aq, p);
           if aq == p1
               result = 'inconclusive';
           end
           j = j + 1;
       end
    end
end
%
if strcmp(result, '') == 1
    result = 'composite';
end
%
% if the result is "composite," means p is definitely not a prime number 
% if the result is "inconclusive," means 25% chance that p is not a prime 
%
fprintf('the current result is: %s\n', result);

