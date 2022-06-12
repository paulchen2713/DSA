%
% Mulplication over B-163
%
% ref. Guide p.53
%
function out=square_pre_B163(ai)
a=ai;
T=0;
for i=1:8
    T=bitset(T,2*i-1,bitget(a,i));
end
out=T;
return

