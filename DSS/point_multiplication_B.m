%
% point multiplication function for B
%
function [outx, outy] = point_multiplication_B(xi, yi, n)
global ifx;

zero = zeros(ifx, 1);
one  = zeros(ifx, 1);
one(1) = 1;
%
% mapping 2D coordinate to 3D coordinate, through Jacobian coordinate
% the point at infinite correspoond to (1:1:0)
% (x    , y    ) --> (x:y:1)
% (X/Z^2, Y/Z^3) <-- (X:Y:Z)
nx = xi;
ny = yi;
nz = one;
Px = one;
Py = one;
Pz = zero;
% compute in 3D
for j = 1 : ifx
    for i = 1 : 32
        bit = bitget(n(j), i);
        if bit == 1
            % if P is the infinite point, perform infinite point addition
            if any(Px - one) == 0 && any(Py - one) == 0 && any(Pz - zero) == 0
                % infinite point addition == point it-self
                Px = nx;
                Py = ny;
                Pz = nz;
            % if P is not the infinite point, perform normal point addition
            else
                [Px, Py, Pz] = point_addition_B(Px, Py, Pz, nx, ny, nz);
            end
            [nx, ny, nz] = point_double_B(nx, ny, nz);
        end
    end
end
%
% turn the result back to 2D
Z = multiplicative_inverse_B(Pz);
Z2 = square_B(Z);             
Z3 = multiplication_B(Z2, Z); % Z^3
%
outx = multiplication_B(Px, Z2);
outy = multiplication_B(Py, Z3);

return
