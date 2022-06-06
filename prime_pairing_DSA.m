%
% prime_pairing_DSA function
%
function [p, q] = prime_pairing_DSA(L, N)
%
% prime-paring for DSA
% prime p, 2^(L-1) < p < 2^L
% prime q, 2^(N-1) < q < 2^N
%
% L = 25;
% N = 11;
%
iteration = 40;
%
q = prime_generator(N);
%
% twoL1 = 2^(L-1), the lowerbound of p
%
L1 = L - 1;
twoL1 = 1;
twoL1q = floor(L1 / 32);
twoL1r = mod(L1, 32);
for i = 1 : twoL1q
    twoL1 = twoL1 * 2^32;
end
twoL1 = twoL1 * 2^twoL1r;
%
% twoL = 2^L, the upperbound of p
%
twoL = twoL1 * 2;
%
% generation of p
%
pq_min=ceil(twoL1/q);
pq_max=floor(twoL/q);
pq_mm=pq_max-pq_min;
%
%
flag_prime = 0; % set the flag to 0, means False
while flag_prime == 0
	pq = floor(pq_mm * rand(1)) + pq_min;
	p = pq * q + 1;
	if mod(p, 2) == 0
		continue;
	end
	%
	it = 0; % iteration index
	result = 'inconclusive';  % default setting 'inconclusive'
	while strcmp(result, 'inconclusive') == 1 && it <= iteration
		it = it + 1;
		result = Miller_Rabin_test(p);
	end
	if strcmp(result, 'inconclusive') == 1
		% after we find the possible valid prime number
        flag_prime = 1; % set the flag to 1, means True
	end
end
%
%fprintf('the current prime pair for DSA are: [p, q] = [%d, %d]\n', p, q);
%
% testing results:
%     [p, q] = [24202897, 1123]
%     [p, q] = [20974237, 1789]
%     [p, q] = [21477991, 1553]
%     [p, q] = [23699677, 1973]
%     [p, q] = [26740333, 1871]
return


