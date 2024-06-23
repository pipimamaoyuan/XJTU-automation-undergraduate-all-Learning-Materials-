clc;
clear;
% 生成一个共有100个结点的有向单连通图，并且要求图的连通性近似符合高斯分布，即图的疏密性存在差异
% 首先，设置结点数和高斯分布的参数
n =100;% 结点数
mu = 0.5; % 高斯分布的均值
sigma = 0.1; % 高斯分布的标准差

% 然后，生成一个随机的邻接矩阵A，其中A(i,j)表示从结点i到结点j的边的权重
A = rand(n,n); % 生成一个n*n的随机数矩阵，元素范围为0到1
A = A - diag(diag(A)); % 将对角线元素设为0，表示没有自环

% 接着，根据高斯分布的概率密度函数，计算每个元素被保留为边的概率
p1 = exp(-(A-mu).^2/(2*sigma^2))/(sigma*sqrt(2*pi)); % 计算概率矩阵p

% 然后，根据概率矩阵p，决定哪些元素被保留为边，哪些元素被置为0
%r = rand(n,n); % 生成一个n*n的随机数矩阵，元素范围为0到1
r=2;
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



% 用贪心算法解决影响力最大化问题
% 假设已知一个有向单连通图G，传播概率p，传播最大次数max_iter，种子结点个数k
% 目标是选择k个种子结点，使得传播的总结点个数最大
k=5;
p=0.1;
max_iter=4;
% 初始化一个空集合S作为种子结点集合
S = [];

% 初始化一个向量MG作为每个候选结点的边际收益
MG = zeros(1,numnodes(G));

% 初始化一个向量LastUpdate作为每个候选结点的上次更新轮数
LastUpdate = zeros(1,numnodes(G));

% 初始化一个变量cur_best作为当前最佳候选结点
cur_best = -1;

% 初始化一个变量cur_mg作为当前最佳候选结点的边际收益
cur_mg = -inf;

% 循环k次，每次选择一个种子结点
for i = 1:k
    
    % 对于每个候选结点u
    for u = 1:numnodes(G)
        
        % 如果u已经在S中，跳过u
        if ismember(u,S)
            continue;
        end
        
        % 如果u不是当前最佳候选结点，且它的边际收益不小于当前最佳候选结点的边际收益，跳过u
        if u ~= cur_best && MG(u) >= cur_mg
            continue;
        end
        
        % 如果u是当前最佳候选结点，或者它的上次更新轮数小于i-1，重新计算它的边际收益
        if u == cur_best || LastUpdate(u) < i-1
            
            % 计算在S中添加u后能够影响到的额外结点个数
            % 这里使用了多次模拟传播过程，并取平均值作为期望值
            % 这里假设模拟次数为1000，可以根据需要调整
            sim_count = 1000;
            sim_result = zeros(1,sim_count);
            for j = 1:sim_count
                
                % 初始化一个向量active作为已激活的结点标志
                active = zeros(1,numnodes(G));
                
                % 将S中的所有结点标记为已激活
                active(S) = 1;
                
                % 将u标记为已激活
                active(u) = 1;
                
                % 初始化一个向量new_active作为新激活的结点
                new_active = [S u];
                
                % 初始化一个变量iter作为当前传播轮数
                iter = 0;
                
                % 当传播轮数小于max_iter并且还有新激活的结点时循环
                while iter < max_iter && ~isempty(new_active)
                    
                    % 更新传播轮数
                    iter = iter + 1;
                    
                    % 初始化一个向量next_active作为下一轮新激活的结点
                    next_active = [];
                    
                    % 对于每个新激活的结点v
                    for v = new_active
                        
                        % 获取v的邻居结点
                        neighbors = successors(G,v);
                        
                        % 对于每个邻居结点w
                        for w = neighbors'
                            
                            % 如果w没有被激活过
                            if active(w) == 0
                                
                                % 生成一个随机数r，范围为0到1


                                r = rand;
                                
                                % 如果r小于传播概率p
                                if r < p
                                    
                                    % 标记w为已激活
                                    active(w) = 1;
                                    
                                    % 将w加入到下一轮新激活的结点
                                    next_active = [next_active w];
                                    
                                end
                            end
                        end
                    end
                    
                    % 更新新激活的结点
                    new_active = next_active;
                    
                end
                
                % 记录本次模拟传播过程中被激活的结点个数
                sim_result(j) = sum(active);
                
            end
            
            % 计算在S中添加u后能够影响到的额外结点个数的期望值，即边际收益
            MG(u) = mean(sim_result) - mean(sim_result(S));
            
            % 更新u的上次更新轮数
            LastUpdate(u) = i;
            
        end
        
        % 如果u的边际收益大于当前最佳候选结点的边际收益，更新当前最佳候选结点和其边际收益
        if MG(u) > cur_mg
            cur_best = u;
            cur_mg = MG(u);
        end
        
    end
    
    % 将当前最佳候选结点加入到S中
    S = [S cur_best];
    
    % 输出当前种子结点集合和其影响力
    fprintf('Round %d: selected node %d, influence: %.2f\n',i,cur_best,cur_mg);
    
end

% 输出最终的种子结点集合和其影响力
fprintf('Final seeds: %s\n',num2str(S));
fprintf('Final influence: %.2f\n',cur_mg);
plot(G)

