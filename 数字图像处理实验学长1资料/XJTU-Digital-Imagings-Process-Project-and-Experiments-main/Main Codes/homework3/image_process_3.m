clc
clear
%% 读取图像
lena=imread('lena.bmp');
lena1=imread('lena1.bmp');
lena2=imread('lena2.bmp');

x=lena2-lena1
lena4=imread('lena4.bmp');

elain=imread('elain.bmp');
elain1=imread('elain1.bmp');
elain2=imread('elain2.bmp');
elain3=imread('elain3.bmp');

citywall=imread('citywall.bmp');
citywall1=imread('citywall1.bmp');
citywall2=imread('citywall2.bmp');

% %% 原图像的直方图
% figure;
% imhist(lena)
% title('lena 原图直方图');
% 
% figure;
% imhist(lena1)
% title('lena1 原图直方图');
% 
% figure;
% imhist(lena2)
% title('lena2 原图直方图');
% 
% 
% figure;
% imhist(lena4)
% title('lena4 原图直方图')
% 
% 
% figure;
% imhist(elain)
% title('elain 原图直方图')
% 
% 
% figure;
% imhist(elain1)
% title('elain1 原图直方图')
% 
% 
% figure;
% imhist(elain2)
% title('elain2 原图直方图')
% 
% 
% figure;
% imhist(elain3)
% title('elain3 原图直方图')
% 
% figure;
% imhist(citywall)
% title('citywall 原图直方图')
% 
% 
% figure;
% imhist(citywall1)
% title('citywall1 原图直方图')
% 
% 
% figure;
% imhist(citywall2)
% title('citywall2 原图直方图')


%% 题目二
% figure
% histeq(lena)

figure
subplot(1,2,1), imshow(lena), title('lena 原图')
subplot(1,2,2), imshow(histeq(lena)), title('lena 直方图均衡后的图像')

figure
subplot(1,2,1), imshow(lena1), title('lena1 原图')
subplot(1,2,2), imshow(histeq(lena1)), title('lena1 直方图均衡后的图像')

figure
subplot(1,2,1), imshow(lena2), title('lena2 原图')
subplot(1,2,2), imshow(histeq(lena2)), title('lena2 直方图均衡后的图像')


figure
subplot(1,2,1), imshow(lena4), title('lena4 原图')
subplot(1,2,2), imshow(histeq(lena4)), title('lena4 直方图均衡后的图像')

figure
subplot(1,2,1), imshow(elain), title('elain 原图')
subplot(1,2,2), imshow(histeq(elain)), title('elain 直方图均衡后的图像')

figure
subplot(1,2,1), imshow(elain1), title('elain1 原图')
subplot(1,2,2), imshow(histeq(elain1)), title('elain1 直方图均衡后的图像')

figure
subplot(1,2,1), imshow(elain2), title('elain2 原图')
subplot(1,2,2), imshow(histeq(elain2)), title('elain2 直方图均衡后的图像')

figure
subplot(1,2,1), imshow(elain3), title('elain3 原图')
subplot(1,2,2), imshow(histeq(elain3)), title('elain3 直方图均衡后的图像')

figure
subplot(1,2,1), imshow(citywall), title('citywall 原图')
subplot(1,2,2), imshow(histeq(citywall)), title('citywall 直方图均衡后的图像')


figure
subplot(1,2,1), imshow(citywall1), title('citywall1 原图')
subplot(1,2,2), imshow(histeq(citywall1)), title('citywall1 直方图均衡后的图像')

figure
subplot(1,2,1), imshow(citywall2), title('citywall2 原图')
subplot(1,2,2), imshow(histeq(citywall2)), title('citywall2 直方图均衡后的图像')



% figure;
% histeq(lena1)
% 
% figure;
% histeq(lena2)
% 
% figure;
% histeq(lena4)
% 
% 
% figure;
% histeq(elain)
% 
% figure;
% histeq(elain1)
% 
% figure;
% histeq(elain2)
% 
% figure;
% histeq(elain3)
% 
% figure;
% histeq(citywall)
% 
% figure;
% histeq(citywall1)
% 
% figure;
% histeq(citywall2)
% 
% figure;
% lena=histeq(lena);
% 
% imhist(lena)
% figure;
% 
% lena1=histeq(lena1);
% imhist(lena1)
% 
% figure;
% lena2=histeq(lena2);
% imhist(lena2)
% 
% figure;
% lena4=histeq(lena4);
% imhist(lena4)
% 
% 
% figure;
% elain=histeq(elain);
% imhist(elain)
% 
% figure;
% elain1=histeq(elain1);
% imhist(elain1)
% 
% figure;
% elain2=histeq(elain2);
% imhist(elain2)
% 
% figure;
% elain3=histeq(elain3);
% imhist(elain3)
% 
% figure;
% citywall=histeq(citywall);
% imhist(citywall)
% 
% figure;
% citywall1=histeq(citywall1);
% imhist(citywall1)
% 
% figure;
% citywall2=histeq(citywall2);
% imhist(citywall2)



