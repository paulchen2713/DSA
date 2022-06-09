%
% f_function for SHA3
%
function out = f_function(L)
% fixed coefficient
b = 1600; % total bits = 25*25*64 = 1600
nr = 24;  % number of rounds
w = b/25;
LL = log2(w); % use LL to avoid naming collision in just L

for ir = 0 : nr-1
    %
    % Algorithm 1: £c(A), theta step mapping
    %
    C = char(); % Column state array
    for ix = 0 : 4
        C(ix + 1, :) = L(ix + 1, 1, :);
        for iy = 1 : 4
            % use subfunction bitxor_64 to sum up the col and lane
            C(ix + 1, :) = bitxor_64(C(ix + 1, :), L(ix + 1, iy + 1, :));
        end
    end
    %
    % 
    for ix = 0 : 4
        for iy = 0 : 4
            CL = C(mod(ix-1, 5) + 1, :); % C left hand side
            CR = bitshift_circular_left_64(C(mod(ix+1, 5) + 1, :), 1); % C Right hand side
            L(ix + 1, iy + 1, :) = bitxor_64(bitxor_64(L(ix + 1, iy + 1, :), CL), CR);
        end
    end
    % print out L after theta mapping
    % fprintf('\n After theta step mapping: \n');
    for ix = 0 : 4
        for iy = 0 : 4
            % fprintf('L(%d, %d) = %s\n',ix, iy, L(ix + 1, iy + 1, :));
        end
    end
    %
    % Algorithm 2: £l(A), rho step mapping
    %
    ix = 1;
    iy = 0;
    for it = 0 : 23
        L(ix+1, iy+1, :) = bitshift_circular_left_64(L(ix+1, iy+1, :), mod((it+1)*(it+2)/2, w));
        temp = ix;
        ix = iy;
        iy = mod(2*temp + 3*iy, 5);
    end
    % print out L atfer rho step mapping
    % fprintf('\n After rho step mapping: \n');
    for ix = 0 : 4
        for iy = 0 : 4
            % fprintf('L(%d, %d) = %s\n', ix, iy, L(ix + 1, iy + 1, :));
        end
    end
    %
    % Algorithm 3: £k(A), pi step mapping
    %
    temp = L;
    for ix = 0 : 4
        for iy = 0 : 4
            L(ix + 1, iy + 1, :) = temp(mod(ix + 3*iy, 5) + 1, ix + 1, :);
        end
    end
    % print out L atfer pi step mapping
    % fprintf('\n After pi step mapping: \n');
    for ix = 0 : 4
        for iy = 0 : 4
            % fprintf('L(%d, %d) = %s\n',ix, iy, L(ix + 1, iy + 1, :));
        end
    end
    %
    % Algorithm 4: £q(A), chi step mapping
    %
    temp = L;
    for ix = 0 : 4
        for iy = 0 : 4
%             first_lane_rhs  = bitcmp_64(temp(mod(ix + 1, 5) + 1, iy + 1, :)); % 1st lane of RHS
%                               bitcmp_64(temp(mod(ix + 1, 5) + 1, iy + 1, :))
%             second_lane_rhs = temp(mod(ix + 2, 5) + 1, iy + 1, :); % 2nd lane of RHS
%                               temp(mod(ix + 2, 5) + 1, iy + 1, :)
%             AA = bitand_64(first_lane_rhs, second_lane_rhs);
            AA = bitand_64(bitcmp_64(temp(mod(ix + 1, 5) + 1, iy + 1, :)), temp(mod(ix + 2, 5) + 1, iy + 1, :));
            L(ix + 1, iy + 1, :) = bitxor_64(temp(ix + 1, iy + 1, :), AA);
        end
    end
    % print out L atfer chi step mapping
    % fprintf('\n After chi step mapping: \n');
    for ix = 0 : 4
        for iy = 0 : 4
            % fprintf('L(%d, %d) = %s\n',ix, iy, L(ix + 1, iy + 1, :));
        end
    end
    %
    % Algorithm 5: rc(t)
    %
    RC = zeros(1, 64);
    for j = 0 : LL
        t = j + 7*ir;
        if mod(t, 255) == 0
            RC(2^j) = 1;
        else
            R = [1 0 0 0 0 0 0 0];
            for i = 1 : mod(t, 255)
                R = [0 R];                 % a. R = 0 || R
                R(1) = bitxor(R(1), R(9)); % b. R[0] = R[0] xor R[8]
                R(5) = bitxor(R(5), R(9)); % c. R[4] = R[4] xor R[8]
                R(6) = bitxor(R(6), R(9)); % d. R[5] = R[5] xor R[8]
                R(7) = bitxor(R(7), R(9)); % e. R[6] = R[6] xor R[8]
                R = R(1:8);                % f. R = Trunc8[R]
            end
            RC(2^j) = R(1); % return R[0]
        end
    end
    RC_hex = bitstring_reverse_2_hex(RC);
    L(1, 1, :) = bitxor_64(L(1, 1, :), RC_hex);
    % print out L atfer chi step mapping
    % fprintf('\n After iota step mapping: \n');
    for ix = 0 : 4
        for iy = 0 : 4
            % fprintf('L(%d, %d) = %s\n',ix, iy, L(ix + 1, iy + 1, :));
        end
    end
end
out = L;
return
