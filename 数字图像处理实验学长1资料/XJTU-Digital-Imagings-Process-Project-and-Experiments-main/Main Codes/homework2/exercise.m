clear
clc
%使用SURF特征检测算法来实现两张图像的配准。
% 1. 初始化。
% 2. 读取图像：使用`imread`函数读取两张图像文件，分别命名为`A`和`B`。
% 3. 灰度转换：将读取的彩色图像转换为灰度图像，以便进行特征点检测。
% 4. 图像预处理：对灰度图像的像素值进行取反操作，这样做可以增强图像的对比度，使得特征点更加明显，便于检测。
% 5. 特征点检测：使用`detectSURFFeatures`函数检测两张灰度图像上的特征点。这个函数会返回一个包含特征点位置和度量信息的特征点对象。
% 6. 特征点选择：通过`selectStrongest`函数从检测到的特征点中选择最强的50个特征点。
% 7. 显示特征点：在两个图形窗口中分别显示两张灰度图像，并在图像上标出选定的特征点。
% 8. 特征提取：使用`extractFeatures`函数从两张图像中提取选定特征点的特征向量
% 9. 特征匹配：使用`matchFeatures`函数匹配两组特征向量，找出相似的特征对。
% 10. 选择匹配对：从匹配结果中选择前7个最强的匹配对，这些匹配对将用于计算图像之间的仿射变换矩阵。
% 11. 显示匹配结果：使用`showMatchedFeatures`函数显示两张图像的拼接，并用线段连接匹配的特征点，以可视化配准情况。
% 12. 计算仿射变换矩阵：将匹配的特征点位置转换为双精度浮点数，然后使用`estimateGeometricTransform`函数根据这些点计算从`B`到`A`的仿射变换矩阵。
% 13. 图像变换：使用`imwarp`函数根据计算得到的仿射变换矩阵，将`B`进行变换，得到配准后的图像`B_out`。
% 14. 显示变换后的图像：在新的图形窗口中显示参考图像`A`和变换后的图像`B_out`。
% 15. 检验变换准确性**：输出变换对象中的仿射变换矩阵`tform.T`，用于检验变换的准确性。

% 读取两张图像，分别命名为A和B
A = imread('Image A.jpg');
B = imread('Image B.jpg');

% 将两张图像转换为灰度图像，分别命名为A_gray和B_gray
A_gray = rgb2gray(A);
B_gray = rgb2gray(B);

% 将两张灰度图像的像素值取反，即黑白颠倒，
% 这样可以增强图像的对比度，便于检测角点
A_gray=255-A_gray;
B_gray=255-B_gray;

% 运用SURF特征检测算法，找到两张图上的特征点，返回一个特征点对象，包含特征点的位置和度量
pointsA = detectSURFFeatures(A_gray);
pointsB = detectSURFFeatures(B_gray);

% 从特征点对象中选择最强的50个特征点，返回一个新的特征点对象
pointsA=selectStrongest(pointsA,50);
pointsB=selectStrongest(pointsB,50);

% 在第一个图形窗口中显示A_gray图像,并在图像上显示50个特征点
figure;
imshow(A_gray);
title('ImageA上的50个特征点');
hold on;
plot(pointsA);

% 在第二个图形窗口中显示B_gray图像，并在图像上显示50个特征点
figure;
imshow(B_gray);
title('ImageB上的50个特征点');
hold on;
plot(pointsB);

% 从两张图像中提取特征点的特征向量，返回一个特征向量矩阵和一个位置矩阵
[featuresA, validPointsA] = extractFeatures(A_gray, pointsA);
[featuresB, validPointsB] = extractFeatures(B_gray, pointsB);

% 将两个特征向量矩阵进行匹配，返回一个匹配对矩阵，每一行表示一对匹配的特征点的索引
indexPairs = matchFeatures(featuresA, featuresB);

% 从匹配对矩阵中获取匹配的特征点的位置矩阵
matchedPointsA = validPointsA(indexPairs(1:7, 1));
matchedPointsB = validPointsB(indexPairs(1:7, 2));

% 在第一个图形窗口中显示A和B图像的拼接，并用红色线段连接匹配的特征点，用标题显示“Matched points”
figure;
showMatchedFeatures(A, B, matchedPointsA, matchedPointsB,'montage');
title('SURF特征检测的配准情况');

% 将匹配的特征点的位置矩阵转换为双精度浮点数，便于计算仿射变换矩阵
arixA=double(matchedPointsA.Location);
arixB=double(matchedPointsB.Location);

% 根据匹配的特征点的位置，计算从B图像到A图像的仿射变换矩阵，返回一个变换对象
tform = estimateGeometricTransform(arixB, arixA, 'affine');

% 根据变换对象，将B图像进行仿射变换，得到变换后的图像B_out
B_out = imwarp(B, tform);

% 显示A和B_out图像
figure;
imshow(A);
title('参考图像')

figure;
imshow(B_out);
title('输出图像')

% 显示变换对象中的仿射变换矩阵，用于检验变换的准确性
tform.T

