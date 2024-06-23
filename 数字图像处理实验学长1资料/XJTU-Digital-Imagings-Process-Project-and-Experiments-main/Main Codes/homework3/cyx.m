clc
clear
a1=imread('goose.jpg');
imhist(a1)
a2=histeq(a1)
imshow(a2)

