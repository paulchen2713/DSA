%
% Addition over B function
%
function out = addition_B(a, b)
a = uint32(a);
b = uint32(b);
c = bitxor(a, b);
out = double(c);

return
