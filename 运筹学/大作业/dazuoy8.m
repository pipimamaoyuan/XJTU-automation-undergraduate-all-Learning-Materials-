clc
clear
%% 生成一个共有100个结点的有向单连通图，并且要求图的连通性近似符合高斯分布，即图的疏密性存在差异
% 首先，设置结点数和高斯分布的参数
n = 40; % 结点数
mu = 0.5; % 高斯分布的均值
sigma = 0.1; % 高斯分布的标准差

% 然后，生成一个随机的邻接矩阵A，其中A(i,j)表示从结点i到结点j的边的权重
A = rand(n,n); % 生成一个n*n的随机数矩阵，元素范围为0到1
A = A - diag(diag(A)); % 将对角线元素设为0，表示没有自环

% 接着，根据高斯分布的概率密度函数，计算每个元素被保留为边的概率
p = exp(-(A-mu).^2/(2*sigma^2))/(sigma*sqrt(2*pi)); % 计算概率矩阵p

% 然后，根据概率矩阵p，决定哪些元素被保留为边，哪些元素被置为0
r = rand(n,n); % 生成一个n*n的随机数矩阵，元素范围为0到1
A(r > p) = 0; % 如果r(i,j)大于p(i,j)，则将A(i,j)设为0

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
%%

% 假设有向单连通图G的邻接矩阵为A，节点个数为n
% 假设传播概率为p，传播最大次数为t，初始结点个数为k
p = 0.1;
t = 5;
k = 8;

% 初始化一个空的初始结点集合S和一个空的候选结点集合C
S = [];
C = [];

% 用一个循环来选择k个初始结点
for i = 1:k
    % 初始化一个最大影响力值为0
    max_influence = 0;
    % 初始化一个最佳候选结点为0
    best_candidate = 0;
    % 遍历所有未被选中的结点
    for j = 1:n
        % 如果该结点不在S中，也不在C中，说明它是一个新的候选结点
        if ~ismember(j,S) && ~ismember(j,C)
            % 把该结点加入到C中
            C = [C,j];
            % 计算该结点加入后的影响力值
            influence = simulate_influence(S,C,A,p,t,n);
            % 如果该影响力值大于当前的最大影响力值，更新最大影响力值和最佳候选结点
            if influence > max_influence
                max_influence = influence;
                best_candidate = j;
            end
            % 把该结点从C中移除
            C = C(C~=j);
        end
    end
    % 如果找到了最佳候选结点，把它加入到S中，并从C中移除（如果存在）
    if best_candidate > 0
        S = [S,best_candidate];
        C = C(C~=best_candidate);
    end
end

% 输出初始结点集合S
disp(S);

% 定义一个函数来模拟信息传播的过程，并返回传播的总结点个数
function influence = simulate_influence(S,C,A,p,t,n)
    % 初始化一个激活结点集合为S和C的并集
    active_nodes = union(S,C);
    % 初始化一个新激活结点集合为空
    new_active_nodes = [];
    % 初始化一个传播次数为0
    count = 0;
    % 用一个循环来模拟信息传播，直到没有新的激活结点或达到最大传播次数为止
    while ~isempty(new_active_nodes) || count == 0
        % 如果达到了最大传播次数，跳出循环
        if count == t
            break;
        end
        % 清空新激活结点集合
        new_active_nodes = [];
        % 遍历所有激活结点
        for i = active_nodes
            % 遍历所有与该激活结点相邻的未激活结点
            for j = find(A(i,:)==1 & ~ismember(1:n,active_nodes))
                % 以概率p激活该未激活结点，并把它加入到新激活结点集合中
                if rand < p
                    new_active_nodes = [new_active_nodes,j];
                end
            end
        end
        % 更新激活结点集合为原来的激活结点集合和新激活结点集合的并集
        active_nodes = union(active_nodes,new_active_nodes);
        % 更新传播次数加一
        count = count + 1;
    end
    
    %返回传播的总结点个数，即激活结点集合的长度
    influence = length(active_nodes);
end