clear;
clc;
%读取图像
test3=imread('test3_corrupt.pgm');
test4=imread('test4 copy.bmp');

% 调用Unsharp函数，对图像进行反锐化掩模和高提升滤波的处理，
% 返回处理后的图像和掩模
[test3_unsharp,test3_highboost,test3_mask]=Unsharp(test3);
[test4_unsharp,test4_highboost,test4_mask]=Unsharp(test4);

%输出图像test3的原图及各种操作后的图像：
figure('NumberTitle','off','Name','test3')


subplot(2,2,1);
imshow(test3);
title('原图');

subplot(2,2,2);
imshow(test3_mask);
title('反锐化掩膜');

subplot(2,2,3);
imshow(test3_unsharp);
title('反锐化掩膜处理后的图像');

subplot(2,2,4);
imshow(test3_highboost);
title('滤波后的图像');

%输出图像test4的原图及各种操作后的图像：
figure('NumberTitle','off','Name','test4')
subplot(2,2,1);imshow(test4);title('原图');
subplot(2,2,2);imshow(test4_mask);title('反锐化掩膜');
subplot(2,2,3);imshow(test4_unsharp);title('反锐化掩膜处理后的图像');
subplot(2,2,4);imshow(test4_highboost);title('滤波后的图像');

%% 
% 反锐化掩模
% 定义一个函数，输入参数为一幅图像，
% 输出参数为反锐化掩模处理后的图像，高提升滤波后的图像和反锐化掩模
function [Img_unsharp,Img_highboost,mask_unsharp]=Unsharp(Img)

%调用GaussianFilter函数，对输入图像进行高斯滤波，
% 得到虚化图像，滤波器的大小为7*7，标准差为3
Imgblur=GaussianFilter(Img,7,3);    

%用原图像减去虚化图像，得到反锐化掩模
mask_unsharp=Img-Imgblur;   

%用原图像加上反锐化掩模，得到反锐化掩模处理后的图像
Img_unsharp=Img+mask_unsharp;   

%用原图像加上3倍的反锐化掩模，得到高提升滤波后的图像（k=3）
Img_highboost=Img+3*mask_unsharp;  
end

% 高斯滤波
%定义函数，输入参数为一幅图像，滤波器的大小和标准差，
% 输出参数为高斯滤波后的图像
function Img_out=GaussianFilter(Img,masksize,sigma)

%遍历滤波器的每个元素
for i=1:masksize
    for j=1:masksize

        % 计算当前元素的横坐标，相对于滤波器的中心
        x=i-ceil(masksize/2);

        % 计算当前元素的纵坐标，相对于滤波器的中心
        y=j-ceil(masksize/2);

        % 根据高斯函数的公式，计算当前元素的值
        h(i,j)=exp(-(x^2+y^2)/(2*sigma^2))/(2*pi*sigma^2);
    end
end

 % 用二维卷积函数conv2，对输入图像和滤波器进行卷积，
 % 得到滤波后的图像，保持和原图像相同的大小
Img_out=uint8(conv2(Img,h,'same'));
end

