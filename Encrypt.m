function [I_enc,SS]=Encrypt(I,rounds)

if nargin<1
    error('You must enter at least the image')
elseif nargin<2
    rounds=2;
    warning('Rounds not found, we will use 2 rounds')
end
rounds=ceil(rounds);
if rounds<1
    error('Rounds is less than 1')
end
[M,N]=size(I);
% To Make Sure That image size is even
if mod(M,2)==1
    I(M+1,:)=uint8(0);
    M=M+1;
end
if mod(N,2)==1
    I(:,N+1)=uint8(0);
    N=N+1;
end
MN=M*N;

for round_iter=1:rounds
% #2
P=double(I(:));

% #3
x=(sum(P)+MN)/(MN+(2^23));
for i=2:6
    x(i)=mod(x(i-1)*1e6,1);
end

% #sys 1
a=10;b=8/3;c=28;d=-1;e=8;r=3;
L=@(t,x)[a*(x(2)-x(1))+x(4)-x(5)-x(6)
    c*x(1)-x(2)-x(1)*x(3)
    -b*x(3)+x(1)*x(2)
    d*x(4)-x(2)*x(3)
    e*x(6)+x(3)*x(2)
    r*x(1)];

N0=.9865*MN/3;
MN3=ceil(MN/3);
[T,Y]=ode45(L,[N0 MN3],x);
% #4
L=Y(1:MN3,1:2:5);
L=L(:);L=L(1:MN);
% #5
[L2,S]=sort(L);
SS{round_iter}=S;
% #6
R=P(S);
% #7
R_=reshape(R,[M N]);
A=[89 55;55 34];
for i=1:2:M
    for j=1:2:N
        Cx=[R_(i,j) R_(i,j+1)
            R_(i+1,j) R_(i+1,j+1)];
        fz=Cx*A;
        C(i,j)=fz(1,1);
        C(i,j+1)=fz(1,2);
        C(i+1,j)=fz(2,1);
        C(i+1,j+1)=fz(2,2);
    end
end
I=mod(C,256);
P=I(:);
end
I_enc=uint8(I);