% 假设有一个邻接矩阵A表示有向图的边
A = [0 1 0 1; 
    1 0 1 0; 
    0 1 0 1; 
    1 0 1 0];

% 假设有一个向量X表示节点的颜色 
X = [0 0 1 0];
% 创建一个有向图对象
G = digraph(A);
% 设置节点的颜色属性
%G.Nodes.Color = X;
% 定义红色和绿色的RGB值
red = [1 0 0];
green = [0 1 0];
% 根据节点的颜色属性选择相应的RGB值
colors = zeros(numnodes(G),3); 
colors(X==1,:) = repmat(red,sum(X==1),1);
colors(X==0,:) = repmat(green,sum(X==0),1);
% 绘制有向图，使用colors作为节点颜色 
plot(G,'NodeColor',colors,'MarkerSize',10,'LineWidth',2)