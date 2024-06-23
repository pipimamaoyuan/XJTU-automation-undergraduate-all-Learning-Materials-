clc
clear
%% 生成一个共有100个结点的有向单连通图，并且要求生成的图较为稀疏
% 首先，设置结点数和边的密度参数
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


G=digraph(A);


%% 首先，选取1个结点作为初始点
number=4;
start_sum=zeros(1,n);
s=[];
for start=1:n
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
start_sum(1,start)=sum(active);
end


[first,first_clo]=max(start_sum)
s=[s first_clo];

%% 选取第二个至第八个点
   
    active = zeros(1,n); % 记录每个结点是否被激活的标志向量
    active(1,first_clo) = 1;% 标记初始点为已激活
    
    for xuandian=2:2
    Active = zeros(1,n); % 记录每个结点是否被激活的标志向量
    Active(1,s) = 1;% 标记初始点为已激活
   
    for num =1:n

        Active = zeros(1,n); % 记录每个结点是否被激活的标志向量
        Active(1,s) = 1;% 标记初始点为已激活
        %start_sum=zeros(1,n);

        if ismember(num,s)
           continue
        end
        
        iter = 0; % 记录当前传播次数
        new_active = [num,s]; % 记录新激活的结点

        while iter < max_iter && ~isempty(new_active) % 当传播次数小于最大次数并且还有新激活的结点时循环
        iter = iter + 1; % 更新传播次数
        next_active = []; % 记录下一轮新激活的结点
        for u = new_active % 对于每个新激活的结点u
            neighbors = successors(G,u); % 获取u的邻居结点
            for v = neighbors' % 对于每个邻居结点v
                if Active(v) == 0 % 如果v没有被激活过
                    r = rand; % 生成一个随机数r，范围为0到1
                    if r < p % 如果r小于传播概率p
                        Active(v) = 1; % 标记v为已激活
                        next_active = [next_active v]; % 将v加入下一轮新激活的结点
                    end
                end
            end
        end
        new_active = next_active; % 更新新激活的结点
        end
        start_sum(1,num)=sum(Active);
        [s_zhi,s_zeng]=max(start_sum);
        s=[s,s_zeng];
    end  
   
    end

s



