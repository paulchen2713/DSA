%
%ECC_B163_ECDSA
%
clear;
clc;
B163_ECDSA_time=cputime;
global f ifx a b f_dec fr_dec a_dec b_dec n_dec N;
m=163;
f=['000000c9';'00000000';'00000000';'00000000';'00000000';'00000008'];
fr=['000000c9';'00000000';'00000000';'00000000';'00000000';'00000000'];% fr(z)=f(z)+z^163
a=['00000001';'00000000';'00000000';'00000000';'00000000';'00000000'];
b=['4a3205fd';'512f7874';'1481eb10';'b8c953ca';'0a601907';'00000002'];
n=['a4234c33';'77e70c12';'000292fe';'00000000';'00000000';'00000004'];
Gx=['e8343e36';'d4994637';'a0991168';'86a2d57e';'f0eba162';'00000003'];% base point
Gy=['797324f1';'b11c5c0c';'a2cdd545';'71a0094f';'d51fbc6c';'00000000'];
fff=['ffffffff';'ffffffff';'ffffffff';'ffffffff';'ffffffff';'00000007'];
%
f_dec=hex2dec(f);
fr_dec=hex2dec(fr);
a_dec=hex2dec(a);
b_dec=hex2dec(b);
n_dec=hex2dec(n);
Gx_dec=hex2dec(Gx);
Gy_dec=hex2dec(Gy);
fff_dec=hex2dec(fff);
%
[ifx,ify]=size(f);
zero=zeros(ifx,1);
one=zeros(ifx,1);
one(1)=1;
%
n_fff_dec=bitxor(n_dec,fff_dec);
N=addition_n(n_fff_dec,one) ;%n+N=2^163
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% key generation
%
% select a random integer d, 1<= d <=n-1
%
d_dec=zeros(ifx,1);
for i=1:ifx-1
	d_dec(i)=floor((2^32-1)*rand(1))+1;
end
d_dec(ifx)=floor((n_dec(ifx)-1)*rand(1))+1;
%
% compute Q=(Qx,Qy)=d*G
%
[Qx,Qy]=point_multiplication_B163(Gx_dec,Gy_dec,d_dec);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% digital signature generation
%
% message: mess
%
mess='abc';
%
% select a random integer k, 1<= k <= n-1
%
k_dec=zeros(ifx,1);
for i=1:ifx-1
	k_dec(i)=floor((2^32-1)*rand(1))+1;
end
k_dec(ifx)=floor((n_dec(ifx)-1)*rand(1))+1;
%
% compute P=(Px,Py)=k*G
%
[Px,Py]=point_multiplication_B163(Gx_dec,Gy_dec,k_dec);
%
% compute r=Px mod n
%
r=Px;
while large_or_equal(r,n_dec)
	r=subtraction_n(r,n_dec);
end
%
% compute ki=k^(-1) mod n
%
ki=multiplicative_inverse_n(k_dec);
%
% compute e=SHA3_text(mess,'SHA3-512',512)
%
HASH1=SHA3_text(mess,'SHA3-512' ,512);
HASH=char();
for i=1:ifx-1
	HASH(i,:)=HASH1(8*(ifx-1-i)+1:8*(ifx-1-i+1));
end
HASH_dec=hex2dec(HASH);
HASH_dec(ifx)=0;
e=HASH_dec;
%
% compute dr=d*r
%
dr=multiplication_n(d_dec,r);
%
% compute s=k^(-1)*(e+d*r)
%
s=multiplication_n(ki,addition_n(e,dr));
%
% send the message mess and digital signature (r,s) to the receiver
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% digital signature authentication
%
% compute e=SHA3_text(mess,'SHA3-512',512)
%
HASH1=SHA3_text(mess,'SHA3-512',512);
HASH=char();
for i=1:ifx-1
	HASH(i,:)=HASH1(8*(ifx-1-i)+1:8*(ifx-1-i+1));
end
HASH_dec=hex2dec(HASH);
HASH_dec(ifx)=0;
e=HASH_dec;
%
% compute w=s^(-1) mod n
%
w=multiplicative_inverse_n(s);
%
% compute ul=e*w
% compute u2=r*w
%
u1=multiplication_n(e,w);
u2=multiplication_n(r,w);
%
% compute u1G=(ulGx,ulGy)=u1*G
% compute u2Q=(u2Qx,u2Qy)=u2*Q
[u1Gx,u1Gy]=point_multiplication_B163(Gx_dec,Gy_dec,u1);
[u2Qx,u2Qy]=point_multiplication_B163(Qx,Qy,u2);
%
% compute uGQ=(uGQx,uGQy)=u1*G+u2*Q
%
[uGQx,uGQy,uGQz]=point_addition_B163(u1Gx,u1Gy,one,u2Qx,u2Qy,one);
Z=multiplicative_inverse_B163(uGQz);
Z2=multiplication_B163(Z,Z);
Z3=multiplication_B163(Z2,Z);
uGQx=multiplication_B163(uGQx,Z2);
uGQy=multiplication_B163(uGQy,Z3);
%
% compute v=uGQx mod n
%
v=uGQx;
while large_or_equal(v,n_dec)
	v=subtraction_n(v,n_dec);
end
%
%verify
%
if any(v-r)==0
fprintf('\nAccept.\n');
else
fprintf('\nNot accept.\n');
end
B163_ECDSA_time=cputime-B163_ECDSA_time