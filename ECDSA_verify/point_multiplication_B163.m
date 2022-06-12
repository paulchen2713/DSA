%
% ECC ( Elliptic Curve Cryptography )
% Point multiplication
%
function [outx,outy]=point_multiplication_B163(xi,yi,ni)
global ifx;
zero=zeros(ifx,1);
one=zero;
one(1)=1;
n=ni;
%
%
nx=xi;
ny=yi;
nz=one;
Px=one;
Py=one;
Pz=zero;
for j=1:ifx
    for i=1:32
        bit=bitget(n(j),i);
        if bit==1
            if any(Pz-zero)==0
                Px=nx;
                Py=ny;
                Pz=nz;
            else
                [Px,Py,Pz]=point_addition_B163(Px,Py,Pz,nx,ny,nz);
            end
        end
        [nx,ny,nz]=point_double_B163(nx,ny,nz);
    end
end
Z=multiplicative_inverse_B163(Pz);
Z2=multiplication_B163(Z,Z);
Z3=multiplication_B163(Z2,Z);
%
outx=multiplication_B163(Px,Z2);
outy=multiplication_B163(Py,Z3);
return
