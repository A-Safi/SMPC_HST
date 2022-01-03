%% SYSTEM Linear
M=ln;
A=zeros(2*(M));
vn=100;

A(1:M,M+1:end)=eye(M);
for i=M+1:2*(M)
    if i-(M)==1
        A(i,2)= -k/m;
    elseif i-M==2
        A(i,i-(M))= -2*k/m;
        A(i,i-(M)+1)= k/m;
    elseif i-(M)==M
        A(i,i-M)= -2*k/m;
        A(i,i-M-1)= k/m;
    else
        A(i,i-(M))= -2*k/m;
        A(i,i-(M)-1)= k/m;
        A(i,i-(M)+1)= k/m;
        
    end
    
end
A(M+2:end,M+2:end)= -(-c1-2*c2*vn)*eye(M-1);
A(M+1,2)=1;
A(M+1,M+1)=(-c1-2*c2*vn);
B =zeros(2*(M),M);
for i=M+1:2*M
    if i-(M)>1
        B(i,i-(M+1))= -1/m;
        B(i,i-(M+1)+1)= 1/m;
        
    end
end
B(M+1,1)=1/m;
D=zeros(2*(M),1);
D((M+1),1)=-c0+k*lk/m;

D((M+2),1)=-k*lk/m;
D(2*(M),1)=-k*lk/m;

% C = zeros(M,2*M);
% C(:,M+1:2*M) =eye(M);
C=eye(2*M);
