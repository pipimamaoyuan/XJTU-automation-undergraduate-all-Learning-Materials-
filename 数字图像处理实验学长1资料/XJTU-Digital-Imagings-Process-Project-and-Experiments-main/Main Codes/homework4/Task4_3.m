clear;
clc;

%��ȡͼ��
test3=imread('test3_corrupt.pgm');
test4=imread('test4 copy.bmp');

% ����Sobel��������test3��test4ͼ��ֱ����Sobel��Ե��⣬���ؼ����ͼ��
test3_sobel=Sobel(test3);
test4_sobel=Sobel(test4);

 % ����Laplace��������test3��test4ͼ��ֱ����Laplace��Ե��⣬���ؼ����ͼ��
test3_laplace=Laplace(test3);
test4_laplace=Laplace(test4);

% ����Canny��������test3��test4ͼ��ֱ����Canny��Ե��⣬���ؼ����ͼ��
test3_canny=Canny(test3);
test4_canny=Canny(test4);

%���Sobel��Ե�����ͼ��
figure('NumberTitle','off','Name','Sobel')
subplot(2,2,1);
imshow(test3);
title('ͼ��3ԭͼ');

subplot(2,2,2);
imshow(test3_sobel);
title('ͼ��3��sobelͼ��');

subplot(2,2,3);
imshow(test4);
title('ͼ��4��ԭͼ');

subplot(2,2,4);
imshow(test4_sobel);
title('ͼ��4��sobelͼ��');

%���Laplace��Ե�����ͼ��
figure('NumberTitle','off','Name','Laplace')
subplot(2,2,1);
imshow(test3);
title('ͼ��3ԭͼ');

subplot(2,2,2);
imshow(test3_laplace);
title('ͼ��3��laplaceͼ��');

subplot(2,2,3);
imshow(test4);
title('ͼ��4ԭͼ');

subplot(2,2,4);
imshow(test4_laplace);
title('ͼ��4��laplaceͼ��');

%���Canny��Ե�����ͼ��
figure('NumberTitle','off','Name','Canny')
subplot(2,2,1);
imshow(test3);
title('ͼ��3ԭͼ');

subplot(2,2,2);
imshow(test3_canny);
title('ͼ��3��Cannyͼ��');

subplot(2,2,3);
imshow(test4);
title('ͼ��4ԭͼ');

subplot(2,2,4);
imshow(test4_canny);
title('ͼ��4��Cannyͼ��');

%% 
%Canny�㷨
% ����һ������Canny���������Ϊһ��ͼ��
% �������ΪCanny��Ե�����ͼ��
function Img_out=Canny(Img)


Imgblur=GaussianFilter(Img,3,2);    %�ø�˹�˲���ͼ�����ģ�������Խ�������Ӱ��


[~,gx,gy]=Sobel(Imgblur);   %��Sobel�õ�x��y������ݶ�


g=uint8(sqrt(double(gx.*gx)+double(gy.*gy)));   %�õ�ͼ����ݶȷ�ֵ����


theta=atan2(double(gy),double(gx)); %�õ�ͼ����ݶȷ������


gcom=g; %׼��һ���洢�ռ�gcom


g=double(g);    %��g��Ϊdouble�ͣ�Ϊ��������׼��
%���潫���շ���ֱ��жϣ�
for i=2:size(g,1)-1
    for j=2:size(g,2)-2
        if ((theta(i,j)>=0)&(theta(i,j)<pi/4))|((theta(i,j)>=-pi)&(theta(i,j)<-3*pi/4))
            g1=g(i-1,j+1)*(gy(i,j)/gx(i,j))+g(i,j+1)*(1-gy(i,j)/gx(i,j));   %�ò�ֵ�õ��ݶȷ����ϵ�һ�������ص㣬��ͬ
            g2=g(i+1,j-1)*(gy(i,j)/gx(i,j))+g(i,j-1)*(1-gy(i,j)/gx(i,j));   %�ò�ֵ�õ��ݶȷ����ϵ���һ�������ص㣬��ͬ
            if (gcom(i,j)<=g1)|(gcom(i,j)<=g2)  
                gcom(i,j)=0;    %�����ݶȷ����ϲ��Ǽ���ֵ����0����ͬ
            end
        end
        if ((theta(i,j)>=pi/4)&(theta(i,j)<pi/2))|((theta(i,j)>=-3*pi/4)&(theta(i,j)<-pi/2))
            g1=g(i-1,j+1)*(gx(i,j)/gy(i,j))+g(i-1,j)*(1-gx(i,j)/gy(i,j));
            g2=g(i+1,j-1)*(gx(i,j)/gy(i,j))+g(i+1,j)*(1-gx(i,j)/gy(i,j));
            if (gcom(i,j)<=g1)|(gcom(i,j)<=g2)
                gcom(i,j)=0;
            end
        end
        if ((theta(i,j)>=pi/2)&(theta(i,j)<3*pi/4))|((theta(i,j)>=-pi/2)&(theta(i,j)<-pi/4))
            g1=g(i-1,j-1)*(-gx(i,j)/gy(i,j))+g(i-1,j)*(1+gx(i,j)/gy(i,j));
            g2=g(i+1,j+1)*(-gx(i,j)/gy(i,j))+g(i+1,j)*(1+gx(i,j)/gy(i,j));
            if (gcom(i,j)<=g1)|(gcom(i,j)<=g2)
                gcom(i,j)=0;
            end
        end
        if ((theta(i,j)>=3*pi/4)&(theta(i,j)<=pi))|((theta(i,j)>=-pi/4)&(theta(i,j)<0))
            g1=g(i-1,j-1)*(-gy(i,j)/gx(i,j))+g(i,j-1)*(1+gy(i,j)/gx(i,j));
            g2=g(i+1,j+1)*(-gy(i,j)/gx(i,j))+g(i,j+1)*(1+gy(i,j)/gx(i,j));
            if (gcom(i,j)<=g1)|(gcom(i,j)<=g2)
                gcom(i,j)=0;
            end
        end
    end
end
g=uint8(gcom); %�����º�ľ�����g��
high=30;low=5; %���øߵ���ֵ
gunderlow=uint8(g>=low);    %���ڵ���ֵ�ĵ�
g1=g.*gunderlow;    %�����ڵ���ֵ�ĵ���0
gbetween=uint8(g1<=high);   %��������ֵ֮��ĵ㣨��ȷ���㣩
gsure=uint8(g1>high);   %���ڸ���ֵ�ĵ㣬��ȷ�������ĵ�
[m,n]=size(gsure);z1=zeros(1,n);z2=zeros(m,1);  %z1��z2�ֱ���ˮƽ��ֱ��0����
%���²��������ڸ���ֵ�ĵ���չ��8-����
gsureex=gsure+[z2,gsure(:,1:n-1)]+[gsure(:,2:n),z2]+[z1;gsure(1:m-1,:)]+[gsure(2:m,:);z1]...
    +[z2,[z1(1:n-1);gsure(1:m-1,1:n-1)]]+[z2,[gsure(2:m,1:n-1);z1(1:n-1)]]...
    +[[z1(1:n-1);gsure(1:m-1,2:n)],z2]+[[gsure(2:m,2:n);z1(1:n-1)],z2];
gsureex=uint8(gsureex>0);
gbetween1=gbetween.*gsureex;    %�õ�8-�������и��ڸ���ֵ��Ĵ�ȷ����
Img_out=g1.*(gbetween1+gsure);  %���ߺϲ���Ϊ���ձ����ĵ�
Img_out=255*Img_out;    %�����ձ����ĵ�ǿ��
end

%Laplacian��Ե��ȡ
% ����һ������Laplace���������Ϊһ��ͼ��
% �������ΪLaplace��Ե�����ͼ��
function Img_out=Laplace(Img)

%����һ��3*3�ľ��󣬱�ʾ������˹���ӵ�ģ��
laplace=[1,1,1;1,-8,1;1,1,1];   

% �ö�ά�������conv2��������ͼ���������˹���ӽ��о�����õ���Ե�����ͼ��
% ���ֺ�ԭͼ����ͬ�Ĵ�С
Img_out=uint8(conv2(Img,laplace,'same'));
end

%Sobel��Ե��ȡ
% ����һ������Sobel���������Ϊһ��ͼ��
% �������ΪSobel��Ե�����ͼ���Լ�x��y������ݶȾ���
function [Img_out,gx,gy]=Sobel(Img)

%����һ��3*3�ľ��󣬱�ʾy�����Sobel���ӵ�ģ��
sobely=[1,2,1;
        0,0,0;
        -1,-2,-1]; 

%����һ��3*3�ľ��󣬱�ʾx�����Sobel���ӵ�ģ��
sobelx=[1,0,-1;
        2,0,-2;
        1,0,-1];  

% �ö�ά�������conv2��������ͼ���x�����Sobel���ӽ��о�����õ�x������ݶȾ���
gx=conv2(Img,sobelx,'same');

% �ö�ά�������conv2��������ͼ���y�����Sobel���ӽ��о�����õ�y������ݶȾ���
gy=conv2(Img,sobely,'same');

% �þ���ֵ����abs����x��y������ݶȾ��������ֵ��Ȼ����ӣ�
% �õ�Sobel��Ե�����ͼ��
Img_out=uint8(abs(gx)+abs(gy));
end

% ��˹�˲���
function Img_out=GaussianFilter(Img,masksize,sigma)
for i=1:masksize
    for j=1:masksize
        x=i-ceil(masksize/2);
        y=j-ceil(masksize/2);
        h(i,j)=exp(-(x^2+y^2)/(2*sigma^2))/(2*pi*sigma^2);
    end
end
Img_out=uint8(conv2(Img,h,'same'));
end

