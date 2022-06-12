%
% inputstring to L array
%
function [out,k]=inputstring_2_L_array_hex(s_input,d,subtype)
c=2*d;
r=1600-c;
%
s_length=length(s_input)/2;
s=s_input;
%
r8=r/8;
k=floor(s_length/r8)+1;
sr=mod(s_length,r8);
if strcmp(subtype,'HASH')==1
    if sr==r8-1
        s=strcat(s,dec2hex(128+6,2)); % padding:01100001
    else
        s=strcat(s,dec2hex(6,2)); % padding: 01100000 00000000 .... 00000000 00000001
        for i=1:r8-sr-2
            s=strcat(s,'00');
        end
        s=strcat(s,dec2hex(128,2));
    end
elseif strcmp(subtype,'XOF')==1
    if sr==r8-1
        s=strcat(s,dec2hex(128+16+15,2)); % padding:11111001
    else
        s=strcat(s,dec2hex(16+15,2)); % padding: 11111000 00000000 .... 00000000 00000001
        for i=1:r8-sr-2
            s=strcat(s,'00');
        end
        s=strcat(s,dec2hex(128,2));
    end
end
%
%
r64=r/64;
Lk=char();
index=2;
for ik=1:k
    for iy=0:4
        for ix=0:4
            if ix+5*iy+1<=r64
                for iz=0:7
                    Lk(ix+1,iy+1,2*(8-iz)-1:2*(8-iz),ik)=s(index-1:index);
                    index=index+2;
                end
            else
                Lk(ix+1,iy+1,:,ik)='0000000000000000';
            end
        end
    end
end
out=Lk;
return

