%
% Reduction for B163
%
function out = reduction_B163(ci)
    global ifx fr_dec;
    C = ci; 
    %
    % Method I: ref. Guide p.55
    %
    for i=12:-1:7
        T=uint32(C(i));
        C(i-6)=addition_B163(C(i-6),bitshift(T,29));
        C(i-5)=addition_B163(addition_B163(addition_B163(C(i-5),bitshift(T,4)),addition_B163(bitshift(T,3),bitshift(T,-3))),T);
        C(i-4)=addition_B163(addition_B163(C(i-4),bitshift(T,-28)),bitshift(T,-29));
    end
    T=uint32(C(6));
    T=bitshift(T,-3);
    C(1)=addition_B163(addition_B163(addition_B163(C(1),bitshift(T,7)),addition_B163(bitshift(T,6),bitshift(T,3))),T);
    C(2)=addition_B163(addition_B163(C(2),bitshift(T,-25)),bitshift(T,-26));
    C(6)=bitand(C(6),7);
    out=C(1:6);
    %
    % Method II
    %
    % CB=C(ifx:2*ifx-1);
    % C=C(1:ifx);
    % C(ifx)=mod(C(ifx),8);
    % for i=1:3
    %     CB=bitshift_right_B163(CB);
    % end
    % C1=CB;
    % for i=1:3
    %     C1=bitshift_left_B163(C1);
    % end
    % C2=C1;
    % for i=1:3
    %     C2=bitshift_left_B163(C2);
    % end
    % C3=bitshift_left_B163(C2);
    % temp1=floor(C1(ifx)/8);
    % C1(ifx)=mod(C1(ifx),8);
    % temp2=floor(C2(ifx)/8);
    % C2(ifx)=mod(C2(ifx),8);
    % temp3=floor(C3(ifx)/8);
    % C3(ifx)=mod(C3(ifx),8);
    % out=addition_B163(addition_B163(addition_B163(C,CB),addition_B163(C1,C2)),C3);
    % if temp1~=0
    %     temp11=bitshift(temp1,3);
    %     temp12=bitshift(temp11,3);
    %     temp13=bitshift(temp12,1);
    %     out(1)=bitxor(bitxor(bitxor(out(1),temp1),bitxor(temp11,temp12)),temp13);
    % end
    % if temp2~=0
    %     temp21=bitshift(temp2,3);
    %     temp22=bitshift(temp21,3);
    %     temp23=bitshift(temp22,1);
    %     out(1)=bitxor(bitxor(bitxor(out(1),temp2),bitxor(temp21,temp22)),temp23);
    % end
    % if temp3~=0
    %     temp31=bitshift(temp3,3);
    %     temp32=bitshift(temp31,3);
    %     temp33=bitshift(temp32,1);
    %     out(1)=bitxor(bitxor(bitxor(out(1),temp3),bitxor(temp31,temp32)),temp33);
    % end
    %
    % Method III
    %
    % zero=zeros(ifx,1);
    % CB=C(ifx:2*ifx-1);
    % for i=1:3
    %     CB=bitshift_right_B163(CB);
    % end
    % C=C(1:ifx);
    % C(ifx)=mod(C(ifx),8);
    % CC=C;
    % %
    % %
    % while any(CB-zero)==1
    %     a=CB;
    %     b=fr_dec;
    %     c=zeros(2*ifx,1);
    %     for k=1:32
    %         for j=1:ifx
    %             if bitget(a(j),k)==1
    %                 Cj=c(j:j+ifx-1);
    %                 Cj=addition_B163(Cj,b);
    %                 c(j:j+ifx-1)=Cj;
    %             end
    %         end
    %         b=bitshift_left_B163(b);
    %     end
    %     C=c;
    %     CB=C(ifx:2*ifx-1);
    %     for i=1:3
    %         CB=bitshift_right_B163(CB);
    %     end
    %     C=C(1:ifx);
    %     C(ifx)=mod(C(ifx),8);
    %     CC=addition_B163(CC,C);
    % end
    % out=CC;
    %
return

