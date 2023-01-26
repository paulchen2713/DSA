%
% ECC ( Elliptic Curve Cryptography ) B-163
%   point double
%   ref. Handbook of E & H p.293
%
function [X3, Y3, Z3] = point_double_B163(X1, Y1, Z1)
    global b_dec;
    A=square_B163(X1);
    B=square_B163(A);
    C=square_B163(Z1);
    C2=square_B163(C);
    C4=square_B163(C2);
    bC4=multiplication_B163(b_dec,C4);
    X3=addition_B163(B,bC4);
    Z3=multiplication_B163(X1,C);
    Y1Z1=multiplication_B163(Y1,Z1);
    SUM=addition_B163(addition_B163(A,Y1Z1),Z3);
    SUMX3=multiplication_B163(SUM,X3);
    BZ3=multiplication_B163(B,Z3);
    Y3=addition_B163(BZ3,SUMX3);
    %
    % A=multiplication_B163(X1,X1);
    % B=multiplication_B163(A,A);
    % C=multiplication_B163(Z1,Z1);
    % C2=multiplication_B163(C,C);
    % C4=multiplication_B163(C2,C2);
    % bC4=multiplication_B163(b_dec,C4);
    % X3=addition_B163(B,bC4);
    % Z3=multiplication_B163(X1,C);
    % Y1Z1=multiplication_B163(Y1,Z1);
    % SUM=addition_B163(addition_B163(A,Y1Z1),Z3);
    % SUMX3=multiplication_B163(SUM,X3);
    % BZ3=multiplication_B163(B,Z3);
    % Y3=addition_B163(BZ3,SUMX3);
    %
return

