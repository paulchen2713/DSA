%
% Mulplication over B-163
%
% ref. Guide p.53
%
function out=square_B163(ai)
global ifx;
cc=2^8;
cc2=cc^2;
a=ai;
c=zeros(2*ifx,1);
for i=1:ifx
    u0=mod(a(i),cc);
    temp=floor(a(i)/cc);
    u1=mod(temp,cc);
    temp=floor(temp/cc);
    u2=mod(temp,cc);
    u3=floor(temp/cc);
    c(2*i-1)=square_pre_B163(u0)+square_pre_B163(u1)*cc2;
    c(2*i)=square_pre_B163(u2)+square_pre_B163(u3)*cc2;
end
out=reduction_B163(c);
return

