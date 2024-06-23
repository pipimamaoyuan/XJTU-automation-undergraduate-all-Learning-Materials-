clear;
clc;
%��ȡͼ��
test3=imread('test3_corrupt.pgm');
test4=imread('test4 copy.bmp');

% ����Unsharp��������ͼ����з�����ģ�͸������˲��Ĵ���
% ���ش�����ͼ�����ģ
[test3_unsharp,test3_highboost,test3_mask]=Unsharp(test3);
[test4_unsharp,test4_highboost,test4_mask]=Unsharp(test4);

%���ͼ��test3��ԭͼ�����ֲ������ͼ��
figure('NumberTitle','off','Name','test3')


subplot(2,2,1);
imshow(test3);
title('ԭͼ');

subplot(2,2,2);
imshow(test3_mask);
title('������Ĥ');

subplot(2,2,3);
imshow(test3_unsharp);
title('������Ĥ������ͼ��');

subplot(2,2,4);
imshow(test3_highboost);
title('�˲����ͼ��');

%���ͼ��test4��ԭͼ�����ֲ������ͼ��
figure('NumberTitle','off','Name','test4')
subplot(2,2,1);imshow(test4);title('ԭͼ');
subplot(2,2,2);imshow(test4_mask);title('������Ĥ');
subplot(2,2,3);imshow(test4_unsharp);title('������Ĥ������ͼ��');
subplot(2,2,4);imshow(test4_highboost);title('�˲����ͼ��');

%% 
% ������ģ
% ����һ���������������Ϊһ��ͼ��
% �������Ϊ������ģ������ͼ�񣬸������˲����ͼ��ͷ�����ģ
function [Img_unsharp,Img_highboost,mask_unsharp]=Unsharp(Img)

%����GaussianFilter������������ͼ����и�˹�˲���
% �õ��黯ͼ���˲����Ĵ�СΪ7*7����׼��Ϊ3
Imgblur=GaussianFilter(Img,7,3);    

%��ԭͼ���ȥ�黯ͼ�񣬵õ�������ģ
mask_unsharp=Img-Imgblur;   

%��ԭͼ����Ϸ�����ģ���õ�������ģ������ͼ��
Img_unsharp=Img+mask_unsharp;   

%��ԭͼ�����3���ķ�����ģ���õ��������˲����ͼ��k=3��
Img_highboost=Img+3*mask_unsharp;  
end

% ��˹�˲�
%���庯�����������Ϊһ��ͼ���˲����Ĵ�С�ͱ�׼�
% �������Ϊ��˹�˲����ͼ��
function Img_out=GaussianFilter(Img,masksize,sigma)

%�����˲�����ÿ��Ԫ��
for i=1:masksize
    for j=1:masksize

        % ���㵱ǰԪ�صĺ����꣬������˲���������
        x=i-ceil(masksize/2);

        % ���㵱ǰԪ�ص������꣬������˲���������
        y=j-ceil(masksize/2);

        % ���ݸ�˹�����Ĺ�ʽ�����㵱ǰԪ�ص�ֵ
        h(i,j)=exp(-(x^2+y^2)/(2*sigma^2))/(2*pi*sigma^2);
    end
end

 % �ö�ά�������conv2��������ͼ����˲������о����
 % �õ��˲����ͼ�񣬱��ֺ�ԭͼ����ͬ�Ĵ�С
Img_out=uint8(conv2(Img,h,'same'));
end

