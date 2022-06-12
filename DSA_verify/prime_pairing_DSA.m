%
% prime-pairing for DSA
% prime: p, 2^(L-1)< p < 2^L
% prime: q, 2^(N-1)< p < 2^N
%
function [p,q]=prime_pairing_DSA(L,N)
iteration=40;
%
q=prime_generator(N);
%
% twoL1=2^(L-1)
%
L1=L-1;
twoL1=1;
twoL1q=floor(L1/32);
twoL1r=mod(L1,32);
for  i=1:twoL1q
	twoL1=twoL1*2^32;
end
twoL1=twoL1*2^twoL1r;
%
% twoL=2^L
%
twoL=twoL1*2;
%
% generation of p
%
pqmin=ceil(twoL1/q);
pqmax=floor(twoL/q);
pqmm=pqmax-pqmin;
%
%
flag_prime=0;
while flag_prime==0
	pq=floor(pqmm*rand(1))+pqmin;
	p=pq*q+1;
	if mod(p,2)==0
		continue;
	end
	%
	it=0;
	result='inconclusive';
	while strcmp(result,'inconclusive')==1 && it<=iteration
		it=it+1;
		result=Miller_Rabin_test(p);
	end
	if strcmp(result,'inconclusive')==1
		flag_prime=1;
	end
end
return


