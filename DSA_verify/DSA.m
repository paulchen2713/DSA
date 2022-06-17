%
% easy example for DSA(digital signature algoruthm)
% ref: wiki,digital signature algorithm
%
clear;
clc;
%
% choose an N-bit prime q
% choose an L-bit prime p such that p-1 is a multiple of q
%
L=26;
N=12;
[p,q]=prime_pairing_DSA(L,N);
%
% choose an integer h randomly, 1<h<p-1
%
h=floor((p-3)*rand(1))+2;
% %
% % check h is whether a primitive root
% %
% index=zeros(p-1,1);
% hh=1;
% for i=1:p-1
    % hh=mod(hh*h,p);
	% index(hh)=1;
% end
% index_sum=sum(index);
% if index_sum~=p-1
    % fprintf('\nwarning for the choice of h=%d\n',h)
% end
%
% compute g=h^((p-1)/q) mod p
%
pq=(p-1)/q;
g=1;
pqq=pq;
hh=h;
while pqq~=0
    if mod(pqq,2)==1
	    g=mod(g*hh,p);
	end
	hh=mod(hh*hh,p);
	pqq=floor(pqq/2);
end
%
% choose an integer x, 0<x<q
%
x=floor((q-1)*rand(1))+1;
%
% compute y=g^x mod p
%
y=1;
xx=x;
gg=g;
while xx~=0
    if mod(xx,2)==1
	    y=mod(y*gg,p);
	end
	gg=mod(gg*gg,p);
	xx=floor(xx/2);
end
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% signing
%
% choose an integer k, 0<k<q
%
k=floor((q-1)*rand(1))+1;
%
% public key: p,q,g,y
% private key: x,k
%
% compute r=(g^k mod p) mod q
%
r=1;
kk=k;
gg=g;
while kk~=0
    if mod(kk,2)==1
	    r=mod(r*gg,p);
	end
	gg=mod(gg*gg,p);
	kk=floor(kk/2);
end
r=mod(r,q);
%
% compute ki,k*ki==1 mod q
%
ua=k;
va=q;
x1a=1;
y1a=0;
x2a=0;
y2a=1;
while ua~=0
    qa=floor(va/ua);
	ra=va-qa*ua;
	xa=x2a-qa*x1a;
	ya=y2a-qa*y1a;
	va=ua;
	ua=ra;
	x2a=x1a;
	x1a=xa;
	y2a=y1a;
	y1a=ya;
end
gcd=va;
xa=x2a;
ya=y2a;
if xa<0
	ki=xa+q;
else
	ki=xa;
end
%
% compute HASH value m_SHA of the message m
%
m = 'document';
HASHtype='SHA3-512';
HASHlength=512;
m_SHA=SHA3_text(m,HASHtype,HASHlength);
m_SHA=hex2dec(m_SHA(1:8));
%
% compute s=(ki*(m_SHA+x*r)) mod q
%
xr=mod(x*r,q);
mxr=mod(m_SHA+xr,q);
s=mod(ki*mxr,q);
%
% send the signature:(m,r,s) to the receiver
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% verifying a signature
%
% compute w such that s*w=1 mod q
%
ua=s;
va=q;
x1a=1;
y1a=0;
x2a=0;
y2a=1;
while ua~=0
	qa=floor(va/ua);
	ra=va-qa*ua;
	xa=x2a-qa*x1a;
	ya=y2a-qa*y1a;
	va=ua;
	ua=ra;
	x2a=x1a;
	x1a=xa;
	y2a=y1a;
	y1a=ya;
end
gcd=va;
xa=x2a;
ya=y2a;
if xa<0
	w=xa+q;
else
	w=xa;
end
%
% compute HASH value m_SHA of the message m
%
m='document';
HASHtype='SHA3-512';
HASHlength=512;
m_SHA=SHA3_text(m,HASHtype,HASHlength);
m_SHA=hex2dec(m_SHA(1:8));
%
% compute ul=mod(m_SHA*w,q)
% compute u2=mod(r*w,q)
%
u1=mod(m_SHA*w,q);
u2=mod(r*w,q);
%
% compute gu=g^ul mod p
%
gu=1;
uu1=u1;
gg=g;
while uu1~=0
	if mod(uu1,2)==1
		gu=mod(gu*gg,p);
	end
	gg=mod(gg*gg,p);
	uu1=floor(uu1/2);
end
%
% compute yu=y^u2 mod p
%
yu=1;
uu2=u2;
yy=y;
while uu2~=0
	if mod(uu2,2)==1
		yu=mod(yu*yy,p);
	end
	yy=mod(yy*yy,p);
	uu2=floor(uu2/2);
end
%
% compute v=((g^ul)*(y^u2) mod p) mod q
%
gy=mod(gu*yu,p);
v=mod(gy,q);
%
% verifying
%
if v==r
    fprintf('\nValid Signature\n');
else
    fprintf('\nNot Valid Signature\n');
end
%
