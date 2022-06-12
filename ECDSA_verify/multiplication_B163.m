%
% Mulplication over B-163
%
% ref. Guide p.49
%
function out=multiplication_B163(ai,bi)
global ifx;
a=ai;
b=bi;
b(ifx+1)=0;
c=zeros(2*ifx,1);
for k=1:32
    for j=1:ifx
        if bitget(a(j),k)==1
            Cj=c(j:j+ifx);
            Cj=addition_B163(Cj,b);
            c(j:j+ifx)=Cj;
        end
    end
    b=special_bitshift_left_B163(b);
end
out=reduction_B163(c);
return

