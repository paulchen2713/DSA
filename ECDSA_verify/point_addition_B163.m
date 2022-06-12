%
% ECC ( Elliptic Curve Cryptography ) B-163
% point addition
%
function [X3,Y3,Z3]=point_addition_B163(X1,Y1,Z1,X2,Y2,Z2)
Z22=square_B163(Z2);
A=multiplication_B163(X1,Z22);
Z12=square_B163(Z1);
B=multiplication_B163(X2,Z12);
Z23=multiplication_B163(Z22,Z2);
C=multiplication_B163(Y1,Z23);
Z13=multiplication_B163(Z12,Z1);
D=multiplication_B163(Y2,Z13);
E=addition_B163(A,B);
F=addition_B163(C,D);
G=multiplication_B163(E,Z1);
FX2=multiplication_B163(F,X2);
GY2=multiplication_B163(G,Y2);
H=addition_B163(FX2,GY2);
Z3=multiplication_B163(G,Z2);
I=addition_B163(F,Z3);
Z32=square_B163(Z3);
FI=multiplication_B163(F,I);
E2=square_B163(E);
E3=multiplication_B163(E2,E);
X3=addition_B163(addition_B163(Z32,FI),E3);
IX3=multiplication_B163(I,X3);
G2=square_B163(G);
G2H=multiplication_B163(G2,H);
Y3=addition_B163(IX3,G2H);
%
%
% Z22=multiplication_B163(Z2,Z2);
% A=multiplication_B163(X1,Z22);
% Z12=multiplication_B163(Z1,Z1);
% B=multiplication_B163(X2,Z12);
% Z23=multiplication_B163(Z22,Z2);
% C=multiplication_B163(Y1,Z23);
% Z13=multiplication_B163(Z12,Z1);
% D=multiplication_B163(Y2,Z13);
% E=addition_B163(A,B);
% F=addition_B163(C,D);
% G=multiplication_B163(E,Z1);
% FX2=multiplication_B163(F,X2);
% GY2=multiplication_B163(G,Y2);
% H=addition_B163(FX2,GY2);
% Z3=multiplication_B163(G,Z2);
% I=addition_B163(F,Z3);
% Z32=multiplication_B163(Z3,Z3);
% FI=multiplication_B163(F,I);
% E2=multiplication_B163(E,E);
% E3=multiplication_B163(E2,E);
% X3=addition_B163(addition_B163(Z32,FI),E3);
% IX3=multiplication_B163(I,X3);
% G2=multiplication_B163(G,G);
% G2H=multiplication_B163(G2,H);
% Y3=addition_B163(IX3,G2H);
return
