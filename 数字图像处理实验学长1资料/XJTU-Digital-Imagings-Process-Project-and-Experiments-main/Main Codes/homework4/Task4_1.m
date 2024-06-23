clear;
clc;
%读取图像：
test1=imread('test1.pgm');
test2=imread('test2.tif');

% 调用MedianFilter函数，对test1和test2图像分别进行中值滤波，返回滤波后的图像
test1_median_3=MedianFilter(test1,3);
test2_median_3=MedianFilter(test2,3);

test1_median_5=MedianFilter(test1,5);
test2_median_5=MedianFilter(test2,5);

test1_median_7=MedianFilter(test1,7);
test2_median_7=MedianFilter(test2,7);

%调用GaussianFilter函数，对test1和test2图像分别进行高斯滤波，标准差为1.5，返回滤波后的图像
test1_gaussian_3=GaussianFilter(test1,3,1.5);
test2_gaussian_3=GaussianFilter(test2,3,1.5);

test1_gaussian_5=GaussianFilter(test1,5,1.5);
test2_gaussian_5=GaussianFilter(test2,5,1.5);

test1_gaussian_7=GaussianFilter(test1,7,1.5);
test2_gaussian_7=GaussianFilter(test2,7,1.5);

%输出图像：
figure('NumberTitle','off','Name','图像一的中值滤波图像')
subplot(2,2,1);
imshow(test1);
title('original');

subplot(2,2,2);
imshow(test1_median_3);
title('mask:3*3');

subplot(2,2,3);
imshow(test1_median_5);
title('mask:5*5');
subplot(2,2,4);
imshow(test1_median_7);
title('mask:7*7');

figure('NumberTitle','off','Name','图像二的中值滤波图像')
subplot(2,2,1);
imshow(test2);
title('原图');

subplot(2,2,2);
imshow(test2_median_3);
title('mask:3*3');

subplot(2,2,3);
imshow(test2_median_5);
title('mask:5*5');

subplot(2,2,4);
imshow(test2_median_7);
title('mask:7*7');

figure('NumberTitle','off','Name','图像一的高斯滤波图像')
subplot(2,2,1);
imshow(test1);
title('原图');

subplot(2,2,2);
imshow(test1_gaussian_3);
title('mask:3*3');

subplot(2,2,3);
imshow(test1_gaussian_5);
title('mask:5*5');

subplot(2,2,4);
imshow(test1_gaussian_7);
title('mask:7*7');

figure('NumberTitle','off','Name','图像二的高斯滤波图像')
subplot(2,2,1);
imshow(test2);
title('原图');

subplot(2,2,2);
imshow(test2_gaussian_3);
title('mask:3*3');

subplot(2,2,3);
imshow(test2_gaussian_5);
title('mask:5*5');

subplot(2,2,4);
imshow(test2_gaussian_7);
title('mask:7*7');
%% 
% 中值滤波
% 定义一个函数，输入参数为一幅图像和滤波器的大小，输出参数为中值滤波后的图像
function Img_out=MedianFilter(Img,masksize)

% 计算滤波器的半径，向下取整
exsize=floor(masksize/2);

%用replicate模式，即复制边缘像素，对输入图像进行扩展，扩展的大小为滤波器的半径
Imgex=padarray(Img,[exsize,exsize],'replicate','both'); 

%获取输入图像的大小
[m,n]=size(Img);

%初始化输出图像为和输入图像相同的大小和类型
Img_out=Img;    

%遍历输入图像的每个像素
for i=1:m
    for j=1:n

        % 从扩展后的图像中截取以当前像素为中心的滤波器大小的邻域
        neighbor=Imgex(i:i+masksize-1,j:j+masksize-1);  

%对邻域的所有像素值求中值，作为输出图像的当前像素值
        Img_out(i,j)=median(neighbor(:)); 
    end
end
end


% 高斯滤波函数
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
