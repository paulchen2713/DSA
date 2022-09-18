%
% prime generation by Miller-Rabin primality test
% prime: p, 2^(L-1)<p<2^L
%
function p = prime_generator(L)
	iteration = 40;
	%
	% twoL1=2^(L-1)
	%
	L1=L-1;
	twoL1=1;
	twoL1q=floor(L1/32);
	twoL1r=mod(L1,32);
	for i=1:twoL1q
		twoL1=twoL1*2^32;
	end
	twoL1=twoL1*2^twoL1r;
	%
	% twoL=2^L
	%
	twoL=twoL1*2;
	%
	% select randomly a number p, 2^(L-1) < p < 2^L
	%
	dd=twoL-twoL1-1;
	%
	flag_prime=0;
	while flag_prime==0
		p=floor(dd*rand(1))+1;
		p=p+twoL1;
		if mod(p,2)==0
			p=p-1; % p:odd
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

