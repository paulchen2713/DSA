%
% Miller-Rabin primality test
%
function out=Miller_Rabin_test(p)
p1=p-1;
%
% p-1=(2^k)*q
%
k=0;
q=p1;
while mod(q,2)==0
	k=k+1;
	q=floor(q/2);
end
%
% select randomly a number a, 0<a<p-1
%
a=floor((p-2)*rand(1))+1;
%
% aq=a^q
%
aq=1;
qq=q;
aa=a;
while qq~=0
	if mod(qq,2)==1
		aq=mod(aq*aa,p);
	end
	qq=floor(qq/2);
	aa=mod(aa*aa,p);
end
%
% test
%
result='';
if mod(aq,p)==1
result='inconclusive';
else
	if mod(aq,p)==p1
		result='inconclusive';
	else
		j=1;
		while strcmp(result,'')==1 && j<=k-1
			aq=mod(aq*aq,p);
			if aq==p1
				result='inconclusive';
			end
			j=j+1;
		end
	end
end
%
if strcmp(result,'')==1
	result='composite';
end
%
out=result;
return