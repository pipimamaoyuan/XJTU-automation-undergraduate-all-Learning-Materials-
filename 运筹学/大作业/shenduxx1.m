% Net=alexnet;
% img=imread("C:\Users\pc\Desktop\R.jpg");
% %img=imread('R.jpg');
% figure;
% imshow(img);
% 
% img2=imresize(img,[227 227]);
% label=classify(Net,img2)

net=alexnet;
net.Layers;
img=imread("C:\Users\pc\Desktop\iop.jpg");
img=imresize(img,[227 227]);
[Ypred scores]=classify(net,img)

imshow(img);
title(char(Ypred))
[ssort sidx]=sort(scores,'descend')
numtopclass=3;
topclass=net.Layers(end).ClassNames(sidx(1:numtopclass));
topscore=ssort(1:numtopclass);