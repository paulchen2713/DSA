%
% Multiplicative inverse module f(x)
%
function out=multiplicative_inverse_B163(ai)
global f_dec ifx;
one=zeros(ifx,1);
one(1)=1;
zero=zeros(ifx,1);
a=ai;
%
% ref. Guide p.59
%
u=a;
v=f_dec;
g1=one;
g2=zero;
while any(u-one) && any(v-one)
    while bitget(u(1,:),1)==0
        u=bitshift_right_B163(u);
        if bitget(g1(1,:),1)==0
            g1=bitshift_right_B163(g1);
        else
            g1=bitshift_right_B163(addition_B163(g1,f_dec));
        end
    end
    while bitget(v(1,:),1)==0
        v=bitshift_right_B163(v);
        if bitget(g2(1,:),1)==0
            g2=bitshift_right_B163(g2);
        else
            g2=bitshift_right_B163(addition_B163(g2,f_dec));
        end
    end
    deg_u=0;
    deg_v=0;
    for i=1:ifx
        for j=1:32
            if bitget(u(i),j)==1
                deg_u=(i-1)*32+j;
            end
            if bitget(v(i),j)==1
                deg_v=(i-1)*32+j;
            end
        end
    end
    if deg_u > deg_v
        u=addition_B163(u,v);
        g1=addition_B163(g1,g2);
    else
        v=addition_B163(u,v);
        g2=addition_B163(g1,g2);
    end
end
if any(u-one)==0
    out=g1;
else
    out=g2;
end
return