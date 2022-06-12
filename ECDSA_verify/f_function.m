%
% f function for SHA3
%
function out=f_function(L)
b=1600;
nr=24;
w=b/25;
LL=log2(w);
for ir=0:nr-1
    %
    % theta step mapping
    %
    C=char();
    for ix=0:4
        C(ix+1,:)=L(ix+1,1,:);
        for iy=1:4
            C(ix+1,:)=bitxor_64(C(ix+1,:),L(ix+1,iy+1,:));
        end
    end
    for ix=0:4
        for iy=0:4
            CL=C(mod(ix-1,5)+1,:);
            CR=bitshift_circular_left_64(C(mod(ix+1,5)+1,:),1);
            L(ix+1,iy+1,:)=bitxor_64(bitxor_64(L(ix+1,iy+1,:),CL),CR);
        end
    end
%     fprintf('\nAfter theta step mapping:\n');
%     for ix=0:4
%         for iy=0:4
%             fprintf('\nL(%d,%d)=%s\n',ix,iy,L(ix+1,iy+1,:));
%         end
%     end
    %
    % rho step mapping
    %
    ix=1;
    iy=0;
    for it=0:23
        L(ix+1,iy+1,:)=bitshift_circular_left_64(L(ix+1,iy+1,:),mod((it+1)*(it+2)/2,w));
        temp=ix;
        ix=iy;
        iy=mod(2*temp+3*iy,5);
    end
%     fprintf('\nAfter rho step mapping:\n');
%     for ix=0:4
%         for iy=0:4
%             fprintf('\nL(%d,%d)=%s\n',ix,iy,L(ix+1,iy+1,:));
%         end
%     end
    %
    % pi step mapping
    %
    temp=L;
    for ix=0:4
        for iy=0:4
            L(ix+1,iy+1,:)=temp(mod(ix+3*iy,5)+1,ix+1,:);
        end
    end
%     fprintf('\nAfter pi step mapping:\n');
%     for ix=0:4
%         for iy=0:4
%             fprintf('\nL(%d,%d)=%s\n',ix,iy,L(ix+1,iy+1,:));
%         end
%     end
    %
    % chi step mapping
    %
    temp=L;
    for ix=0:4
        for iy=0:4
            AA=bitand_64(bitcmp_64(temp(mod(ix+1,5)+1,iy+1,:)),temp(mod(ix+2,5)+1,iy+1,:));
            L(ix+1,iy+1,:)=bitxor_64(temp(ix+1,iy+1,:),AA);
        end
    end
%     fprintf('\nAfter chi step mapping:\n');
%     for ix=0:4
%         for iy=0:4
%             fprintf('\nL(%d,%d)=%s\n',ix,iy,L(ix+1,iy+1,:));
%         end
%     end
    %
    % iota step mapping
    %
    RC=zeros(1,64);
    for j=0:LL
        t=j+7*ir;
        if mod(t,255)==0
            RC(2^j)=1;
        else
            R=[1 0 0 0 0 0 0 0];
            for i=1:mod(t,255)
                R=[0 R];
                R(1)=bitxor(R(1),R(9));
                R(5)=bitxor(R(5),R(9));
                R(6)=bitxor(R(6),R(9));
                R(7)=bitxor(R(7),R(9));
                R=R(1:8);
            end
            RC(2^j)=R(1);
        end
    end
    RC_hex=bitstring_reverse_2_hex(RC);
    L(1,1,:)=bitxor_64(L(1,1,:),RC_hex);
%     fprintf('\nAfter iota step mapping:\n');
%     for ix=0:4
%         for iy=0:4
%             fprintf('\nL(%d,%d)=%s\n',ix,iy,L(ix+1,iy+1,:));
%         end
%     end
end
out=L;
return




