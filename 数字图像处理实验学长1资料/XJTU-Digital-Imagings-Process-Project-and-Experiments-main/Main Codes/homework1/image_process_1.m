clc
clear
%% 题目1
Image=imread('7.bmp');
figure;

% 在图形窗口中显示原始图像
imshow(Image)
title('7 image information');

% 获取 BMP 文件的信息
info = imfinfo('7.bmp');
% 显示信息
disp(info);

% 打开 BMP 文件
fid = fopen('7.bmp','r','l'); % 'r' 表示只读模式，'l' 表示小端字节顺序

% 读取文件信息头
file_header = fread(fid,14,'uint8'); % 读取 14 个字节，数据类型为无符号 8 位整数

% 读取位图信息头
bitmap_header = fread(fid,40,'uint8'); % 读取 40 个字节，数据类型为无符号 8 位整数
% 关闭文件
fclose(fid);


%% 题目2
% 读取名为 lena.bmp 的图像文件
Image=imread('lena.bmp');
figure;

% 在图形窗口中显示原始图像
imshow(Image)
title('8 bit');

% 获取图像 I 的宽度和高度，并分别赋值给变量 width 和 height
[width,height]=size(Image);

%初始化
img128=zeros(width,height);
img64=zeros(width,height);
img32=zeros(width,height);
img16=zeros(width,height);
img8=zeros(width,height);
img4=zeros(width,height);
img2=zeros(width,height);

for i=1:width
    for j=1:height
        img128(i,j)=floor(Image(i,j)/2);
    end
end
figure;
% 在图形窗口中显示图像 img128，将其转换为 8 位无符号整数，并指定灰度范围为 [0,127]
imshow(uint8(img128),[0,127])
title('7 bit');


for i=1:width
    for j=1:height
        img64(i,j)=floor(Image(i,j)/4);
        img32(i,j)=floor(Image(i,j)/8);
        img16(i,j)=floor(Image(i,j)/16);
        img8(i,j)=floor(Image(i,j)/32);
        img4(i,j)=floor(Image(i,j)/64);
        img2(i,j)=floor(Image(i,j)/128);
    end
end
figure;
imshow(uint8(img64),[0,63])
title('6 bit');

figure;
imshow(uint8(img32),[0,31])
title('5 bit');

figure;
imshow(uint8(img16),[0,15])
title('4 bit');

figure;
imshow(uint8(img8),[0,7])
title('3 bit');

figure;
imshow(uint8(img4),[0,3])
title('2 ibt');

figure;
imshow(uint8(img2),[0,1])
title('1 bit');

%% 题目3
% 读取名为 lena.bmp 的图像文件，
lenaimage=imread('lena.bmp');
figure;

% 在图形窗口中绘制图像的直方图，显示其灰度分布
imhist(lenaimage)
title('直方图');
average_gray_value=mean2(lenaimage);
Standard_deviation=std2(lenaimage);
Variance_gray_value=Standard_deviation^2;

%输出结果
% disp("平均灰度值：",average_gray_value)
% disp("灰度值标准差：",Standard_deviation)
% disp("灰度值方差：",Variance_gray_value)


%% 题目4
% 读取名为 lena.bmp 的图像文件
lenaimage=imread('lena.bmp');

 % 将图像的大小缩放为 2048 x 2048 像素，并使用最近邻插值法
nearest=imresize(lenaimage,[2048 2048],'nearest');

%原图
figure;
imshow(lenaimage);
title('原图');


figure;
imshow(nearest);
title('最近邻插值图像');


bilinearity=imresize(lenaimage,[2048 2048],'bilinear');
figure;
imshow(bilinearity);
title('双线性法插值图像');


bicubic=imresize(lenaimage,[2048 2048],'bicubic');
figure;
imshow(bicubic);
title('双三次插值图像');

%% 题目5
%水平偏移
% 定义变换类型为仿射变换
t_type='affine';

% 定义变换矩阵为
t_matrix=[1 3 0;
          0 1 0;
          0 0 1];

% 根据变换类型和变换矩阵，创建一个变换对象，并将其存储在变量 t 中
t=maketform(t_type,t_matrix);

lena=imread('lena.bmp');
elain1=imread('elain1.bmp');

a_t=imtransform(lena,t);
c_t=imtransform(elain1,t);
figure;
imshow(lena);
title('lena 原图');


b1=imresize(a_t,[2048 2048],'nearest');
figure;
imshow(b1);
title('lena水平，最邻近插值图像');


b2=imresize(a_t,[2048 2048],'bilinear');
figure;
imshow(b2);
title('lena水平，双线性');


b3=imresize(a_t,[2048 2048],'bicubic');
figure;
imshow(b3);
title('lena水平，双三次插值图像');


figure;
imshow(elain1);
title('elain origin');


d1=imresize(c_t,[2048 2048],'nearest');
figure;
imshow(d1);
title('elain水平，最邻近插值图像');


d2=imresize(c_t,[2048 2048],'bilinear');
figure;
imshow(d2);
title('elain水平，双线性插值图像');


d3=imresize(c_t,[2048 2048],'bicubic');
figure;
imshow(d3);
title('elain水平，双三次插值图像');

%旋转30度
lenaimage=imread('lena.bmp');
b=imrotate(lenaimage,30,'bilinear','crop');
figure;
imshow(lenaimage);
title('lena 原图');


b1=imresize(b,[2048 2048],'nearest');
figure;
imshow(b1);
title('lena旋转，最邻近插值图像');


b2=imresize(b,[2048 2048],'bilinear');
figure;
imshow(b2);
title('lena旋转，双线性插值图像');


b3=imresize(b,[2048 2048],'bicubic');
figure;
imshow(b3);
title('lena旋转，双三次插值图像');


c=imread('elain1.bmp');
d=imrotate(c,30,'bilinear','crop');
figure;
imshow(c);
title('elain 原图');


d1=imresize(d,[2048 2048],'nearest');
figure;
imshow(d1);
title('elain旋转，最邻近插值图像');


d2=imresize(d,[2048 2048],'bilinear');
figure;
imshow(d2);
title('elain旋转，双线性插值图像');


d3=imresize(d,[2048 2048],'bicubic');
figure;
imshow(d3);
title('elain旋转，双三次插值图像');





