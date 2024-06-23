% 定义一个函数，用于模拟信息传播过程，并返回最终的传播结点数

function s = simulate(P, S, T)
    % P是传播概率矩阵，S是初始结点集合
    % 创建一个n×1的向量，表示n个结点的激活状态
    % 0表示未激活，1表示已激活
    n=100;
    A = zeros(n,1);

    % 激活初始结点
    A(S) = 1;

    % 设置传播次数
    %T = 5; % 可以修改为任意正整数

    % 进行传播过程
    for t = 1:T
        % 找出当前已激活的结点
        active_nodes = find(A == 1);
        % 对每个已激活的结点，尝试激活它的邻居结点
        for u = active_nodes'
            % 找出当前未激活的邻居结点
            inactive_neighbors = find(A == 0);
            % 对每个未激活的邻居结点，以一定概率进行激活
            for v = inactive_neighbors'
                % 生成一个随机数，如果小于传播概率，则激活该结点
                r = rand;
                if r < P(u,v)
                    A(v) = 1;
                end
            end
        end
    end

    % 计算最终的传播结点数
    s = sum(A);
end
