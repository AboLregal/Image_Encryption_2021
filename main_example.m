clc
clear all
close all


I=imread('Aletta.(Isekai.Shokudou).600.2121109.jpg');
[M,N,nc]=size(I);
if mod(M,2)==1
    M=M+1;
end
if mod(N,2)==1
    N=N+1;
end
I=imresize(I,[M N]);
subplot(131)
imshow(I)
title('Original Image')
rounds=2;
for i=1:nc
    [I_enc(:,:,i),SX{i}]=Encrypt(I(:,:,i),rounds);
end
subplot(132)
imshow(I_enc)
title('Encrypted Image')

for i=1:nc
    I_dec(:,:,i)=Decrypt(I_enc(:,:,i),SX{i});
end
subplot(133)
imshow(I_dec)
title('Decrypted Image')

y1=I(:);
y2=I_dec(:);
MSE=sum((y1-y2).^2)/length(y1)
impsnr=psnr(I_dec,I)
