clc
clear
% 生成一个共有100个结点的有向单连通图，并且要求图的连通性近似符合高斯分布，即图的疏密性存在差异
% 首先，设置结点数和高斯分布的参数
n =100% 结点数
mu = 0.5; % 高斯分布的均值
sigma = 0.1; % 高斯分布的标准差

% 然后，生成一个随机的邻接矩阵A，其中A(i,j)表示从结点i到结点j的边的权重
A = rand(n,n); % 生成一个n*n的随机数矩阵，元素范围为0到1
A = A - diag(diag(A)); % 将对角线元素设为0，表示没有自环

% 接着，根据高斯分布的概率密度函数，计算每个元素被保留为边的概率
p1 = exp(-(A-mu).^2/(2*sigma^2))/(sigma*sqrt(2*pi)); % 计算概率矩阵p

% 然后，根据概率矩阵p，决定哪些元素被保留为边，哪些元素被置为0
%r = rand(n,n); % 生成一个n*n的随机数矩阵，元素范围为0到1
r=1;
A(r >p1) = 0; % 如果r(i,j)大于p(i,j)，则将A(i,j)设为0

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
G = digraph(A); % 使用邻接矩阵A创建一个加权有向图对象G
% 用刚才生成的有向单连通图，作为社会网络图，现在，随机选取5个结点作为初始点，用独立级联模型，进行信息传播，传播概率为0.1，传播最大次数为5次
% 首先，随机选取5个结点作为初始点
k = 5; % 初始点的个数
start = randperm(n,k); % 随机选择k个不重复的结点索引
active = zeros(1,n); % 记录每个结点是否被激活的标志向量
active(start) = 1; % 标记初始点为已激活

% 接着，用独立级联模型进行信息传播
p = 0.1; % 设置传播概率
max_iter = 5; % 设置传播最大次数
iter = 0; % 记录当前传播次数
new_active = start; % 记录新激活的结点

while iter < max_iter && ~isempty(new_active) % 当传播次数小于最大次数并且还有新激活的结点时循环
    iter = iter + 1; % 更新传播次数
    next_active = []; % 记录下一轮新激活的结点
    for u = new_active % 对于每个新激活的结点u
        neighbors = successors(G,u); % 获取u的邻居结点
        for v = neighbors' % 对于每个邻居结点v
            if active(v) == 0 % 如果v没有被激活过
                r = rand; % 生成一个随机数r，范围为0到1
                if r < p % 如果r小于传播概率p
                    active(v) = 1; % 标记v为已激活
                    next_active = [next_active v]; % 将v加入下一轮新激活的结点
                end
            end
        end
    end
    new_active = next_active; % 更新新激活的结点
end

% 最后，显示信息传播的结果
fprintf('初始结点是：%s\n',num2str(start)); % 打印初始结点索引
fprintf('被激活的结点有：%s\n',num2str(find(active))); % 打印被激活的结点索引
plot(G,'layout','force','NodeColor',[active' 1-active' 0*active']); % 绘制网络图，并用颜色区分被激活和未被激活的结点
SUM=sum(active);
fprintf('被激活的点的个数：%d',SUM)
