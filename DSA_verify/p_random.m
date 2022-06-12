%
% random p generator
%
function out = p_random()
%
% randomly generate an odd number p between (for instance) 2~100000
p = floor((100000 - 2) * rand(1)) + 2;
if mod(p, 2) == 0
    p = p - 1;
end
out = p;
return
