%
% Addition over B163
%
function out=addition_B163(ai,bi)
a=uint32(ai);
b=uint32(bi);
c=bitxor(a,b);
out=double(c);
return