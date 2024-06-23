clc
clear
% ͨ��Harris�ǵ����㷨��ʵ������ͼ�����׼��
% 
% 1. ��ʼ��
% 
% 2. ��ȡͼ��ʹ��`imread`������ȡ����ͼ���ļ����ֱ�����Ϊ`ImageA`��`ImageB`��
% 
% 3. �Ҷ�ת��������ȡ�Ĳ�ɫͼ��ת��Ϊ�Ҷ�ͼ���Ա���нǵ��⡣
% 
% 4. ͼ��Ԥ�����ԻҶ�ͼ�������ֵ����ȡ��������������������ǿͼ��ĶԱȶȣ�ʹ�ýǵ�������ԣ����ڼ�⡣
% 
% 5. �ǵ��⣺ʹ��`detectHarrisFeatures`����������ŻҶ�ͼ���ϵĽǵ㡣��������᷵��һ�������ǵ�λ�úͶ�����Ϣ�Ľǵ����
% 
% 6. �ǵ�ѡ��ͨ��`selectStrongest`�����Ӽ�⵽�Ľǵ���ѡ����ǿ��50���ǵ㡣
% 
% 7. ��ʾ�ǵ㣺������ͼ�δ����зֱ���ʾ���ŻҶ�ͼ�񣬲���ͼ���ϱ��ѡ���Ľǵ㡣
% 
% 8. ������ȡ��ʹ��`extractFeatures`����������ͼ������ȡѡ���ǵ������������
% 
% 9. ����ƥ�䣺ʹ��`matchFeatures`����ƥ�����������������ҳ����Ƶ������ԡ�
% 
% 10. ѡ��ƥ��ԣ���ƥ������ѡ��ǰ7����ǿ��ƥ��ԣ���Щƥ��Խ����ڼ���ͼ��֮��ķ���任����
% 
% 11. ��ʾƥ������ʹ��`showMatchedFeatures`������ʾ����ͼ���ƴ�ӣ������߶�����ƥ��Ľǵ㣬�Կ��ӻ���׼�����
% 
% 12. �������任���󣺽�ƥ��Ľǵ�λ��ת��Ϊ˫���ȸ�������Ȼ��ʹ��`cp2tform`����������Щ������`ImageB`��`ImageA`�ķ���任����
% 
% 13. ͼ��任��ʹ��`imtransform`�������ݼ���õ��ķ���任���󣬽�`ImageB`���б任���õ���׼���ͼ��`B_out`��
% 
% 14. ��ʾ�任���ͼ�����µ�ͼ�δ�������ʾ�ο�ͼ��`ImageA`�ͱ任���ͼ��`B_out`��
% 
% 15. ����任׼ȷ�ԣ�����任�����еķ���任����`tform.tdata.T`�����ڼ���任��׼ȷ�ԡ�


% ��ȡ����ͼ��
ImageA=imread('Image A.jpg');
ImageB=imread('Image B.jpg');

% ������ͼ��ת��Ϊ�Ҷ�ͼ��
A_gray=rgb2gray(ImageA);
B_gray=rgb2gray(ImageB);

% �����ŻҶ�ͼ�������ֵȡ�������ڰ׵ߵ���
% ����������ǿͼ��ĶԱȶȣ����ڼ��ǵ�
A_gray=255-A_gray;
B_gray=255-B_gray;

%����Harris�ǵ����㷨���ҵ�����ͼ�ϵĽǵ�
%����һ���ǵ���󣬰����ǵ��λ�úͶ���
A_points=detectHarrisFeatures(A_gray);
B_points=detectHarrisFeatures(B_gray);

% �ӽǵ������ѡ����ǿ��50���ǵ㣬����һ���µĽǵ����
A_points=selectStrongest(A_points,50);
B_points=selectStrongest(B_points,50);

% �ڵ�һ��ͼ�δ�������ʾA_grayͼ��,����ͼ������ʾ50���ǵ�
figure;
imshow(A_gray);
title('ImageA�ϵ�50���ǵ�');
hold on;
plot(A_points);

% �ڵڶ���ͼ�δ�������ʾB_grayͼ�񣬲���ͼ������ʾ50���ǵ�
figure;
imshow(B_gray);
title('ImageB�ϵ�50���ǵ�');
hold on;
plot(B_points);

% ������ͼ�ϵ������ڵ���׼��ֻ��Ҫ7����ǿ�ĵ�
% ������ͼ������ȡ�ǵ����������������һ���������������һ��λ�þ���
[f1,arixA_matrix]=extractFeatures(A_gray,A_points);
[f2,arixB_matrix]=extractFeatures(B_gray,B_points);

% ���������������������ƥ�䣬
% ����һ��ƥ��Ծ���ÿһ�б�ʾһ��ƥ��Ľǵ������
pairs=matchFeatures(f1,f2);

% ��ƥ��Ծ�����ѡ��ǰ7��ƥ��ԣ��ֱ��ȡ������A��Bͼ���е�λ�þ���
matchedPointsA=arixA_matrix(pairs(1:7,1));
matchedPointsB=arixB_matrix(pairs(1:7,2));

% ��ʾA��Bͼ���ƴ�ӣ����ú�ɫ�߶�����ƥ��Ľǵ�
figure;
showMatchedFeatures(ImageA,ImageB,matchedPointsA,matchedPointsB,'montage');
title('Harris�ǵ������׼���');

% ��ƥ��Ľǵ��λ�þ���ת��Ϊ˫���ȸ����������ڼ������任����
arixA=double(matchedPointsA.Location);
arixB=double(matchedPointsB.Location);

% ����ƥ��Ľǵ��λ�ã������Bͼ��Aͼ��ķ���任����
% ����һ���任����
tform=cp2tform(arixB,arixA,'affine');

% ���ݱ任���󣬽�Bͼ����з���任���õ��任���ͼ��B_out
B_out=imtransform(ImageB,tform);

% ��ʾA��B_outͼ��
figure;
imshow(ImageA);
title('�ο�ͼ��')

figure;
imshow(B_out);
title('���ͼ��')

% ��ʾ�任�����еķ���任�������ڼ���任��׼ȷ��
tform.tdata.T



