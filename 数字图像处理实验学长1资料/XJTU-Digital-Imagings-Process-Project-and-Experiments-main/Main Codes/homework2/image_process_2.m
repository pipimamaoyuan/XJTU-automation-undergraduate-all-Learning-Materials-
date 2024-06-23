clc
clear

%% 2.1
% ��ȡ����ͼ��
ImageA=imread('Image A.jpg');
ImageB=imread('Image B.jpg');

% �ڵ�һ��ͼ�δ�������ʾ����ͼ�񣬲����������עx��y
figure;
subplot(121)
imshow(ImageA);
axis on
xlabel x
ylabel y
subplot(122)
imshow(ImageB);
axis on
xlabel x
ylabel y

% �ڵڶ���ͼ�δ�������ʾ����ͼ��ĵ�һ��ͨ����
% ����ɫͨ�����������Լ���ͼ���ά�ȣ����ڼ���
figure;
ImageA=ImageA(:,:,1);
ImageB=ImageB(:,:,1);

subplot(1,2,1)
imshow(ImageA);
axis on
xlabel x
ylabel y
subplot(1,2,2)
imshow(ImageB);
axis on
xlabel x
ylabel y

% ���õ�ģ̬ͼ����Ż����Ͷ��������ڼ���ͼ�����׼
[optimizer, metric] = imregconfig('monomodal');

% ʹ��Ĭ�ϵķ���任����ImageBͼ����׼��ImageAͼ�񣬵õ���׼���ͼ��
ibRegisteredDefault = imregister(ImageB, ImageA, 'affine', optimizer, metric);
figure;
imshow(ibRegisteredDefault)
title('A: Default registration');


% %% 2.2
% 
% ia1=imread('Image A.jpg');
% ib1=imread('Image B.jpg');
% 
% ia_base=rgb2gray(ia1);
% ib_transfer=rgb2gray(ib1);
% 
% ia_base=255-ia_base;
% ib_transfer=255-ib_transfer;
% 
% points_ia=detectHarrisFeatures(ia_base);
% points_ib=detectHarrisFeatures(ib_transfer);
% 
% points_ia=selectStrongest(points_ia,100);
% points_ib=selectStrongest(points_ib,100);
% 
% 
% figure;
% imshow(ia_base);
% title('100���ǵ�');
% hold on;
% plot(points_ia);
% 
% 
% figure;
% imshow(ib_transfer);
% title('ImageB�ϵ�100���ǵ�');
% hold on;
% plot(points_ib);
% 
% [fa,arix_ia_mtx]=extractFeatures(ia_base,points_ia);
% [fb,arix_ib_mtx]=extractFeatures(ib_transfer,points_ib);
% 
% 
% pairs=matchFeatures(fa,fb);
% 
% matchedPoints_ia=arix_ia_mtx(pairs(1:7,1));
% matchedPoints_ib=arix_ib_mtx(pairs(1:7,2));
% 
% figure;
% showMatchedFeatures(ia1,ib1,matchedPoints_ia,matchedPoints_ib,'montage');
% title('��׼');
% 
% 
% arix_ia=double(matchedPointsA.Location);
% arix_ib=double(matchedPoints_ib.Location);
% 
% 
% t_form=cp2tform(arix_ib,arix_ia,'affine');
% b_out=imtransform(ib1,t_form);
% 
% 
% figure;
% subplot(1,2,1)
% imshow(ia1);
% title('�ο�')
% subplot(1,2,2)
% imshow(b_out);
% title('��׼')
% t_form.tdata.T

