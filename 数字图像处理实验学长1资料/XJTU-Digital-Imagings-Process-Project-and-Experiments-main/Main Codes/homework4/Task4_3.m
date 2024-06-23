clear;
clc;

%读取图像
test3=imread('test3_corrupt.pgm');
test4=imread('test4 copy.bmp');

% 调用Sobel函数，对test3和test4图像分别进行Sobel边缘检测，返回检测后的图像
test3_sobel=Sobel(test3);
test4_sobel=Sobel(test4);

 % 调用Laplace函数，对test3和test4图像分别进行Laplace边缘检测，返回检测后的图像
test3_laplace=Laplace(test3);
test4_laplace=Laplace(test4);

% 调用Canny函数，对test3和test4图像分别进行Canny边缘检测，返回检测后的图像
test3_canny=Canny(test3);
test4_canny=Canny(test4);

%输出Sobel边缘检测后的图像：
figure('NumberTitle','off','Name','Sobel')
subplot(2,2,1);
imshow(test3);
title('图像3原图');

subplot(2,2,2);
imshow(test3_sobel);
title('图像3的sobel图像');

subplot(2,2,3);
imshow(test4);
title('图像4的原图');

subplot(2,2,4);
imshow(test4_sobel);
title('图像4的sobel图像');

%输出Laplace边缘检测后的图像
figure('NumberTitle','off','Name','Laplace')
subplot(2,2,1);
imshow(test3);
title('图像3原图');

subplot(2,2,2);
imshow(test3_laplace);
title('图像3的laplace图像');

subplot(2,2,3);
imshow(test4);
title('图像4原图');

subplot(2,2,4);
imshow(test4_laplace);
title('图像4的laplace图像');

%输出Canny边缘检测后的图像：
figure('NumberTitle','off','Name','Canny')
subplot(2,2,1);
imshow(test3);
title('图像3原图');

subplot(2,2,2);
imshow(test3_canny);
title('图像3的Canny图像');

subplot(2,2,3);
imshow(test4);
title('图像4原图');

subplot(2,2,4);
imshow(test4_canny);
title('图像4的Canny图像');

%% 
%Canny算法
% 定义一个函数Canny，输入参数为一幅图像，
% 输出参数为Canny边缘检测后的图像
function Img_out=Canny(Img)


Imgblur=GaussianFilter(Img,3,2);    %用高斯滤波对图像进行模糊处理以降低噪声影响


[~,gx,gy]=Sobel(Imgblur);   %用Sobel得到x，y方向的梯度


g=uint8(sqrt(double(gx.*gx)+double(gy.*gy)));   %得到图像的梯度幅值矩阵


theta=atan2(double(gy),double(gx)); %得到图像的梯度方向矩阵


gcom=g; %准备一个存储空间gcom


g=double(g);    %将g化为double型，为下面运算准备
%下面将按照方向分别判断：
for i=2:size(g,1)-1
    for j=2:size(g,2)-2
        if ((theta(i,j)>=0)&(theta(i,j)<pi/4))|((theta(i,j)>=-pi)&(theta(i,j)<-3*pi/4))
            g1=g(i-1,j+1)*(gy(i,j)/gx(i,j))+g(i,j+1)*(1-gy(i,j)/gx(i,j));   %用插值得到梯度方向上的一个亚像素点，下同
            g2=g(i+1,j-1)*(gy(i,j)/gx(i,j))+g(i,j-1)*(1-gy(i,j)/gx(i,j));   %用插值得到梯度方向上的另一个亚像素点，下同
            if (gcom(i,j)<=g1)|(gcom(i,j)<=g2)  
                gcom(i,j)=0;    %若在梯度方向上不是极大值则置0，下同
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
g=uint8(gcom); %将更新后的矩阵存回g中
high=30;low=5; %设置高低阈值
gunderlow=uint8(g>=low);    %低于低阈值的点
g1=g.*gunderlow;    %将低于低阈值的点置0
gbetween=uint8(g1<=high);   %介于两阈值之间的点（待确定点）
gsure=uint8(g1>high);   %高于高阈值的点，即确定保留的点
[m,n]=size(gsure);z1=zeros(1,n);z2=zeros(m,1);  %z1，z2分别是水平竖直的0向量
%以下操作将高于高阈值的点扩展到8-邻域：
gsureex=gsure+[z2,gsure(:,1:n-1)]+[gsure(:,2:n),z2]+[z1;gsure(1:m-1,:)]+[gsure(2:m,:);z1]...
    +[z2,[z1(1:n-1);gsure(1:m-1,1:n-1)]]+[z2,[gsure(2:m,1:n-1);z1(1:n-1)]]...
    +[[z1(1:n-1);gsure(1:m-1,2:n)],z2]+[[gsure(2:m,2:n);z1(1:n-1)],z2];
gsureex=uint8(gsureex>0);
gbetween1=gbetween.*gsureex;    %得到8-邻域中有高于高阈值点的待确定点
Img_out=g1.*(gbetween1+gsure);  %两者合并即为最终保留的点
Img_out=255*Img_out;    %将最终保留的点强化
end

%Laplacian边缘提取
% 定义一个函数Laplace，输入参数为一幅图像，
% 输出参数为Laplace边缘检测后的图像
function Img_out=Laplace(Img)

%定义一个3*3的矩阵，表示拉普拉斯算子的模板
laplace=[1,1,1;1,-8,1;1,1,1];   

% 用二维卷积函数conv2，对输入图像和拉普拉斯算子进行卷积，得到边缘检测后的图像，
% 保持和原图像相同的大小
Img_out=uint8(conv2(Img,laplace,'same'));
end

%Sobel边缘提取
% 定义一个函数Sobel，输入参数为一幅图像，
% 输出参数为Sobel边缘检测后的图像，以及x，y方向的梯度矩阵
function [Img_out,gx,gy]=Sobel(Img)

%定义一个3*3的矩阵，表示y方向的Sobel算子的模板
sobely=[1,2,1;
        0,0,0;
        -1,-2,-1]; 

%定义一个3*3的矩阵，表示x方向的Sobel算子的模板
sobelx=[1,0,-1;
        2,0,-2;
        1,0,-1];  

% 用二维卷积函数conv2，对输入图像和x方向的Sobel算子进行卷积，得到x方向的梯度矩阵
gx=conv2(Img,sobelx,'same');

% 用二维卷积函数conv2，对输入图像和y方向的Sobel算子进行卷积，得到y方向的梯度矩阵
gy=conv2(Img,sobely,'same');

% 用绝对值函数abs，对x，y方向的梯度矩阵求绝对值，然后相加，
% 得到Sobel边缘检测后的图像
Img_out=uint8(abs(gx)+abs(gy));
end

% 高斯滤波：
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

