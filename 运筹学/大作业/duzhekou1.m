% 您好，这是Bing。我可以尝试帮助您解决这个问题。😊
% 
% 根据我的搜索结果，度折扣启发式算法是一种用于选择初始结点的贪心方法，它利用了一种简单而有效的策略，即当一个结点的邻居结点被选为初始结点时，它的度数就会相应地减少，以减少影响力的重叠³。度折扣启发式算法的基本思想是，对于每个结点，根据它的度数和邻居结点的被选概率，计算它的影响力，并按照影响力降序排序。然后，依次选择前k个结点作为初始结点³。
% 
% 在MATLAB中，要实现度折扣启发式算法，您可以参考以下步骤：
% 
% 1. 定义有向单连通图的邻接矩阵A，其中A(i,j)表示从结点i到结点j的边的权重。如果没有边，则A(i,j)为0。
% 2. 定义传播概率p和初始结点个数k。
% 3. 初始化一个空的初始结点集合seeds。
% 4. 初始化每个结点的度数d和邻居被选概率t。对于每个结点v，令d(v)为v的出度和，即A(v,:)的和；令t(v)为0。
% 5. 当seeds的大小小于k时，执行以下操作：
%     - 对于每个结点v，计算它的影响力s(v)，即s(v) = d(v) - 2 * t(v) - (d(v) - t(v)) * t(v) * p。
%     - 选择影响力最大的结点u，并将其加入到seeds中。
%     - 对于u的每个出度邻居w，更新其邻居被选概率t(w)，即t(w) = t(w) + 1。
% 
% 您可以参考以下代码示例来实现度折扣启发式算法：

% Define the adjacency matrix of the directed graph
%%
clc
clear
n = 100; % 结点数
d = 0.1; % 边的密度系数，范围为0到1，越小表示边越稀疏

% 然后，生成一个随机的邻接矩阵A，其中A(i,j)表示从结点i到结点j的边的权重
A = rand(n,n); % 生成一个n*n的随机数矩阵，元素范围为0到1
A = A - diag(diag(A)); % 将对角线元素设为0，表示没有自环

% 接着，根据边的密度系数d，决定哪些元素被保留为边，哪些元素被置为0
r = rand(n,n); % 生成一个n*n的随机数矩阵，元素范围为0到1
A(r > d) = 0; % 如果r(i,j)大于d，则将A(i,j)设为0

% 最后，检查A是否是单连通的，即是否存在从任意结点出发到达任意结点的路径
% 如果不是单连通的，就修改A，使其成为单连通的
% 这里使用了广度优先搜索算法来检查单连通性
visited = zeros(1,n); % 记录每个结点是否被访问过的标志向量
queue = []; % 记录访问顺序的队列
start = 1; % 选择一个起始结点
visited(start) = 1; % 标记起始结点为已访问
queue = [queue start]; % 将起始结点加入队列

while ~isempty(queue) % 当队列不为空时循环
    u = queue(1); % 取出队首元素
    queue(1) = []; % 移除队首元素
    for v = 1:n % 遍历所有其他结点
        if A(u,v) > 0 && visited(v) == 0 % 如果存在一条从u到v的边，并且v没有被访问过
            visited(v) = 1; % 标记v为已访问
            queue = [queue v]; % 将v加入队列
        end
    end
end

if sum(visited) < n % 如果存在没有被访问过的结点，说明A不是单连通的
    for i = find(visited == 0) % 对于每个没有被访问过的结点i
        j = randi(n); % 随机选择一个其他结点j
        while i == j || visited(j) == 0 % 如果i和j相同或者j也没有被访问过，就重新选择j
            j = randi(n);
        end
        w = rand; % 随机生成一个权重w，范围为0到1
       
        A(i,j) = w; % 在A中添加一条从i到j的边，权重为w
    end
end

% Define the propagation probability and number of initial nodes
p = 0.1;
k = 2;

% Initialize an empty initial node set
seeds = [];

% Initialize the degree and neighbor selection probability of each node
n = size(A,1); % number of nodes
d = sum(A,2); % degree of each node
t = zeros(n,1); % neighbor selection probability of each node

% While the size of seeds is less than k
while length(seeds) < k
    % Compute the influence of each node
    s = d - 2 * t - (d - t) .* t * p;
    % Select the node with the maximum influence
    [~,u] = max(s);
    % Add it to the seeds
    seeds = [seeds u];
    % Update the neighbor selection probability of its out-neighbors
    for w = find(A(u,:) > 0)
        t(w) = t(w) + 1;
    end
end

% Display the initial node set
disp(seeds);