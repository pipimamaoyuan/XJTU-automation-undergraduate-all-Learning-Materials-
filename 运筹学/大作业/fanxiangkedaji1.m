clc
clear


%我可以尝试帮你用MATLAB编写一个基于反向可达集的算法来解决这个问题。😊

%首先，我需要知道你的有向单连通图的结构，即节点数、边数和边的方向。你可以用一个邻接矩阵来表示这个图，例如：

%%初始化
% A is the adjacency matrix of the graph
% A(i,j) = 1 means there is an edge from node i to node j
% A(i,j) = 0 means there is no edge from node i to node j
A = [0 1 0 0 0;
     0 0 1 1 0;
     1 0 0 0 1;
     0 0 0 0 1;
     0 0 0 0 0];


%然后，我需要定义一些参数，例如传播概率、传播最大次数、种子节点个数等。例如：

%
% p is the propagation probability
p = 0.1;

% T is the maximum number of propagation steps
T = 5;

% k is the number of seed nodes to select
k = 5;


% 接下来，我需要实现一个基于反向可达集的算法来选择种子节点。这个算法的主要思想是：
% 
% - 对于每个节点v，生成一个反向可达集R(v)，即从v开始反向沿着边随机遍历，每条边以概率p被遍历，直到没有新的节点被访问。
% - 对于每个反向可达集R(v)，计算它的覆盖度c(R(v))，即它包含了多少个不同的节点。
% - 对于每个节点v，计算它的边际增益g(v)，即它在当前已选种子节点集合S下能够增加多少覆盖度。
% - 每次选择边际增益最大的节点加入种子节点集合S，直到达到k个。
% 
% 这个算法可以用以下的MATLAB代码来实现：

% n is the number of nodes in the graph
n = size(A,1);

% R is a cell array of reverse reachable sets
R = cell(n,1);

% c is a vector of coverage degrees of reverse reachable sets
c = zeros(n,1);

% S is a vector of seed nodes
S = zeros(k,1);

% sigma is a vector of marginal gains of nodes
sigma = zeros(n,1);
%%
% loop for k times to select k seed nodes
for i = 1:k
    
    % loop for each node to generate reverse reachable set and compute coverage degree
    for v = 1:n
        
        % initialize the reverse reachable set as {v}
        R{v} = [v];
        
        % initialize the active set as {v}
        active = [v];
        
        % loop until no new node is activated
        while ~isempty(active)
            
            % get the last node in the active set
            u = active(end);
            
            % remove it from the active set
            active(end) = [];
            
            % get the in-neighbors of u
            in_nbrs = find(A(:,u) == 1);
            
            % loop for each in-neighbor of u
            for w = in_nbrs'
                
                % generate a random number between 0 and 1
                r = rand();
                
                % if the random number is less than p and w is not in R{v}
                if r < p && ~ismember(w,R{v})
                    
                    % add w to R{v}
                    R{v} = [R{v} w];
                    
                    % add w to the active set
                    active = [active w];
                    
                end
                
            end
            
        end
        
        % compute the coverage degree of R{v} as the number of unique nodes in it
        c(v) = length(unique(R{v}));
        
    end
    
    % loop for each node to compute marginal gain under current seed set S
    for v = 1:n
        
        
        % if v is already in S, skip it
        if ismember(v,S)
            continue;
        end
        
        % initialize the marginal gain of v as 0
        sigma(v) = 0;
        
        % loop for each reverse reachable set R{w} that contains v
        for w = find(cellfun(@(x) ismember(v,x),R))
            
            % if w is not in S, add the coverage degree of R{w} to the marginal gain of v
            if ~ismember(w,S)
                sigma(v) = sigma(v) + c(w) / length(R{w});;
            end
            
        end
        
    end
    
    % find the node with the maximum marginal gain
    [max_gain,max_node] = max(sigma);
    
    % add it to the seed set S
    S(i) = max_node;
    
end

% display the seed set S
disp(S);
