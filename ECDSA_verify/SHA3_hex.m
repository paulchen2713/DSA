%
% SHA3
%
function HASH=SHA3_text(s_input,HASHtype,HASHlength)
%
%
if strcmp(HASHtype,'SHA3-224')==1
    d=224;
    dd=d;
    subtype='HASH';
elseif strcmp(HASHtype,'SHA3-256')==1
    d=256;
    dd=d;
    subtype='HASH';
elseif strcmp(HASHtype,'SHA3-384')==1
    d=384;
    dd=d;
    subtype='HASH';
elseif strcmp(HASHtype,'SHA3-512')==1
    d=512;
    dd=d;
    subtype='HASH';
elseif strcmp(HASHtype,'SHAKE128')==1
    d=128;
    dd=HASHlength;
    subtype='XOF';
elseif strcmp(HASHtype,'SHAKE256')==1
    d=256;
    dd=HASHlength;
    subtype='XOF';
end
%
b=1600;
nr=24;
c=2*d;
r=b-c;
w=b/25;
LL=log2(w);
%
%
[Lk,k]=inputstring_2_L_array_hex(s_input,d,subtype);
%
% initial state arry
%
Lp=char();
for iy=0:4
    for ix=0:4
        Lp(ix+1,iy+1,:)='0000000000000000';
    end
end
%
% sponge construction
%
for ik=1:k
    L=Lk(:,:,:,ik);
    for iy=0:4
        for ix=0:4
            L(ix+1,iy+1,:)=bitxor_64(L(ix+1,iy+1,:),Lp(ix+1,iy+1,:));
        end
    end
    L=f_function(L);
    Lp=L;
end
%
% fprintf('\nfinal state:\n')
% for ix=0:4
%     for iy=0:4
%         fprintf('\nL(%d,%d)=%s\n',ix,iy,L(ix+1,iy+1,:));
%     end
% end
%
% generation of HASH value
%
if strcmp(subtype,'HASH')==1
    HASH=char();
    d8=dd/8;
    counter=0;
    for iy=0:4
        for ix=0:4
            for iz=0:7
                counter=counter+1;
                if counter<=d8
                    HASH=strcat(HASH,L(ix+1,iy+1,16-2*iz-1));
                    HASH=strcat(HASH,L(ix+1,iy+1,16-2*iz));
                end
            end
        end
    end
elseif strcmp(subtype,'XOF')==1
    HASH=char();
    d8=floor(dd/8);
    r8=r/8;
    counter=0;
    for iy=0:4
        for ix=0:4
            for iz=0:7
                counter=counter+1;
                if counter<=r8
                    HASH=strcat(HASH,L(ix+1,iy+1,16-2*iz-1));
                    HASH=strcat(HASH,L(ix+1,iy+1,16-2*iz));
                end
            end
        end
    end
    while length(HASH)<d8*2
        L=f_function(L);
        counter=0;
        for iy=0:4
            for ix=0:4
                for iz=0:7
                    counter=counter+1;
                    if counter<=r8
                        HASH=strcat(HASH,L(ix+1,iy+1,16-2*iz-1));
                        HASH=strcat(HASH,L(ix+1,iy+1,16-2*iz));
                    end
                end
            end
        end
    end
    HASH=HASH(1:d8*2);
end
HASH=lower(HASH);
return













