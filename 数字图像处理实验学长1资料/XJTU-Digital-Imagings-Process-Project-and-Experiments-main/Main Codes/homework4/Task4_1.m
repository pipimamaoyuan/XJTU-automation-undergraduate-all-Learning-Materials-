clear;
clc;
%��ȡͼ��
test1=imread('test1.pgm');
test2=imread('test2.tif');

% ����MedianFilter��������test1��test2ͼ��ֱ������ֵ�˲��������˲����ͼ��
test1_median_3=MedianFilter(test1,3);
test2_median_3=MedianFilter(test2,3);

test1_median_5=MedianFilter(test1,5);
test2_median_5=MedianFilter(test2,5);

test1_median_7=MedianFilter(test1,7);
test2_median_7=MedianFilter(test2,7);

%����GaussianFilter��������test1��test2ͼ��ֱ���и�˹�˲�����׼��Ϊ1.5�������˲����ͼ��
test1_gaussian_3=GaussianFilter(test1,3,1.5);
test2_gaussian_3=GaussianFilter(test2,3,1.5);

test1_gaussian_5=GaussianFilter(test1,5,1.5);
test2_gaussian_5=GaussianFilter(test2,5,1.5);

test1_gaussian_7=GaussianFilter(test1,7,1.5);
test2_gaussian_7=GaussianFilter(test2,7,1.5);

%���ͼ��
figure('NumberTitle','off','Name','ͼ��һ����ֵ�˲�ͼ��')
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

figure('NumberTitle','off','Name','ͼ�������ֵ�˲�ͼ��')
subplot(2,2,1);
imshow(test2);
title('ԭͼ');

subplot(2,2,2);
imshow(test2_median_3);
title('mask:3*3');

subplot(2,2,3);
imshow(test2_median_5);
title('mask:5*5');

subplot(2,2,4);
imshow(test2_median_7);
title('mask:7*7');

figure('NumberTitle','off','Name','ͼ��һ�ĸ�˹�˲�ͼ��')
subplot(2,2,1);
imshow(test1);
title('ԭͼ');

subplot(2,2,2);
imshow(test1_gaussian_3);
title('mask:3*3');

subplot(2,2,3);
imshow(test1_gaussian_5);
title('mask:5*5');

subplot(2,2,4);
imshow(test1_gaussian_7);
title('mask:7*7');

figure('NumberTitle','off','Name','ͼ����ĸ�˹�˲�ͼ��')
subplot(2,2,1);
imshow(test2);
title('ԭͼ');

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
% ��ֵ�˲�
% ����һ���������������Ϊһ��ͼ����˲����Ĵ�С���������Ϊ��ֵ�˲����ͼ��
function Img_out=MedianFilter(Img,masksize)

% �����˲����İ뾶������ȡ��
exsize=floor(masksize/2);

%��replicateģʽ�������Ʊ�Ե���أ�������ͼ�������չ����չ�Ĵ�СΪ�˲����İ뾶
Imgex=padarray(Img,[exsize,exsize],'replicate','both'); 

%��ȡ����ͼ��Ĵ�С
[m,n]=size(Img);

%��ʼ�����ͼ��Ϊ������ͼ����ͬ�Ĵ�С������
Img_out=Img;    

%��������ͼ���ÿ������
for i=1:m
    for j=1:n

        % ����չ���ͼ���н�ȡ�Ե�ǰ����Ϊ���ĵ��˲�����С������
        neighbor=Imgex(i:i+masksize-1,j:j+masksize-1);  

%���������������ֵ����ֵ����Ϊ���ͼ��ĵ�ǰ����ֵ
        Img_out(i,j)=median(neighbor(:)); 
    end
end
end


% ��˹�˲�����
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
