clc
clear
%% ��Ŀ1
Image=imread('7.bmp');
figure;

% ��ͼ�δ�������ʾԭʼͼ��
imshow(Image)
title('7 image information');

% ��ȡ BMP �ļ�����Ϣ
info = imfinfo('7.bmp');
% ��ʾ��Ϣ
disp(info);

% �� BMP �ļ�
fid = fopen('7.bmp','r','l'); % 'r' ��ʾֻ��ģʽ��'l' ��ʾС���ֽ�˳��

% ��ȡ�ļ���Ϣͷ
file_header = fread(fid,14,'uint8'); % ��ȡ 14 ���ֽڣ���������Ϊ�޷��� 8 λ����

% ��ȡλͼ��Ϣͷ
bitmap_header = fread(fid,40,'uint8'); % ��ȡ 40 ���ֽڣ���������Ϊ�޷��� 8 λ����
% �ر��ļ�
fclose(fid);


%% ��Ŀ2
% ��ȡ��Ϊ lena.bmp ��ͼ���ļ�
Image=imread('lena.bmp');
figure;

% ��ͼ�δ�������ʾԭʼͼ��
imshow(Image)
title('8 bit');

% ��ȡͼ�� I �Ŀ�Ⱥ͸߶ȣ����ֱ�ֵ������ width �� height
[width,height]=size(Image);

%��ʼ��
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
% ��ͼ�δ�������ʾͼ�� img128������ת��Ϊ 8 λ�޷�����������ָ���Ҷȷ�ΧΪ [0,127]
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

%% ��Ŀ3
% ��ȡ��Ϊ lena.bmp ��ͼ���ļ���
lenaimage=imread('lena.bmp');
figure;

% ��ͼ�δ����л���ͼ���ֱ��ͼ����ʾ��Ҷȷֲ�
imhist(lenaimage)
title('ֱ��ͼ');
average_gray_value=mean2(lenaimage);
Standard_deviation=std2(lenaimage);
Variance_gray_value=Standard_deviation^2;

%������
% disp("ƽ���Ҷ�ֵ��",average_gray_value)
% disp("�Ҷ�ֵ��׼�",Standard_deviation)
% disp("�Ҷ�ֵ���",Variance_gray_value)


%% ��Ŀ4
% ��ȡ��Ϊ lena.bmp ��ͼ���ļ�
lenaimage=imread('lena.bmp');

 % ��ͼ��Ĵ�С����Ϊ 2048 x 2048 ���أ���ʹ������ڲ�ֵ��
nearest=imresize(lenaimage,[2048 2048],'nearest');

%ԭͼ
figure;
imshow(lenaimage);
title('ԭͼ');


figure;
imshow(nearest);
title('����ڲ�ֵͼ��');


bilinearity=imresize(lenaimage,[2048 2048],'bilinear');
figure;
imshow(bilinearity);
title('˫���Է���ֵͼ��');


bicubic=imresize(lenaimage,[2048 2048],'bicubic');
figure;
imshow(bicubic);
title('˫���β�ֵͼ��');

%% ��Ŀ5
%ˮƽƫ��
% ����任����Ϊ����任
t_type='affine';

% ����任����Ϊ
t_matrix=[1 3 0;
          0 1 0;
          0 0 1];

% ���ݱ任���ͺͱ任���󣬴���һ���任���󣬲�����洢�ڱ��� t ��
t=maketform(t_type,t_matrix);

lena=imread('lena.bmp');
elain1=imread('elain1.bmp');

a_t=imtransform(lena,t);
c_t=imtransform(elain1,t);
figure;
imshow(lena);
title('lena ԭͼ');


b1=imresize(a_t,[2048 2048],'nearest');
figure;
imshow(b1);
title('lenaˮƽ�����ڽ���ֵͼ��');


b2=imresize(a_t,[2048 2048],'bilinear');
figure;
imshow(b2);
title('lenaˮƽ��˫����');


b3=imresize(a_t,[2048 2048],'bicubic');
figure;
imshow(b3);
title('lenaˮƽ��˫���β�ֵͼ��');


figure;
imshow(elain1);
title('elain origin');


d1=imresize(c_t,[2048 2048],'nearest');
figure;
imshow(d1);
title('elainˮƽ�����ڽ���ֵͼ��');


d2=imresize(c_t,[2048 2048],'bilinear');
figure;
imshow(d2);
title('elainˮƽ��˫���Բ�ֵͼ��');


d3=imresize(c_t,[2048 2048],'bicubic');
figure;
imshow(d3);
title('elainˮƽ��˫���β�ֵͼ��');

%��ת30��
lenaimage=imread('lena.bmp');
b=imrotate(lenaimage,30,'bilinear','crop');
figure;
imshow(lenaimage);
title('lena ԭͼ');


b1=imresize(b,[2048 2048],'nearest');
figure;
imshow(b1);
title('lena��ת�����ڽ���ֵͼ��');


b2=imresize(b,[2048 2048],'bilinear');
figure;
imshow(b2);
title('lena��ת��˫���Բ�ֵͼ��');


b3=imresize(b,[2048 2048],'bicubic');
figure;
imshow(b3);
title('lena��ת��˫���β�ֵͼ��');


c=imread('elain1.bmp');
d=imrotate(c,30,'bilinear','crop');
figure;
imshow(c);
title('elain ԭͼ');


d1=imresize(d,[2048 2048],'nearest');
figure;
imshow(d1);
title('elain��ת�����ڽ���ֵͼ��');


d2=imresize(d,[2048 2048],'bilinear');
figure;
imshow(d2);
title('elain��ת��˫���Բ�ֵͼ��');


d3=imresize(d,[2048 2048],'bicubic');
figure;
imshow(d3);
title('elain��ת��˫���β�ֵͼ��');





