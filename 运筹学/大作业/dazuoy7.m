clc
clear

% 用贪心算法解决有向单连通图的信息传播问题
% 输入：有向单连通图G，传播概率p，传播最大次数t_max，初始结点个数k
% 输出：初始结点集合S，传播的总结点个数num

% 有向单连通图G的邻接矩阵表示
G = [0 1 0 0 0 0;
     0 0 1 0 0 0;
     1 0 0 1 1 0;
     0 0 0 0 1 1;
     0 0 0 0 0 1;
     0 0 0 0 0 0];
[S, num] = greedy(G, 0.1, 5, 2)

function [S, num] = greedy(G, p, t_max, k)
    % 初始化初始结点集合为空
    S = [];
    % 初始化传播的总结点个数为0
    num = 0;
    % 循环k次，每次选择一个初始结点
    for i = 1:k
        % 初始化最大增益为0
        max_gain = 0;
        % 初始化最佳候选结点为-1
        best_node = -1;
        % 遍历所有未被选中的结点
        for j = 1:size(G, 1)
            % 如果结点j已经在S中，跳过
            if ismember(j, S)
                continue;
            end
            % 计算结点j作为初始结点时的信息传播增益
            gain = simulate(G, p, t_max, [S j]);
            % 如果增益大于最大增益，更新最大增益和最佳候选结点
            if gain > max_gain
                max_gain = gain;
                best_node = j;
            end
        end
        % 将最佳候选结点加入S中
        S = [S best_node];
        % 更新传播的总结点个数
        num = num + max_gain;
    end
end

% 模拟信息传播过程，返回被激活的结点个数
% 输入：有向单连通图G，传播概率p，传播最大次数t_max，初始结点集合S
% 输出：被激活的结点个数num

function num = simulate(G, p, t_max, S)
    % 初始化被激活的结点集合为S
    A = S;
    % 初始化当前时刻为0
    t = 0;
    % 循环直到达到最大次数或没有新的结点被激活
    while t < t_max && ~isempty(S)
        % 初始化新激活的结点集合为空
        N = [];
        % 遍历当前时刻的初始结点集合
        for i = 1:length(S)
            % 获取当前结点的出邻居集合
            neighbors = find(G(S(i), :) > 0);
            % 遍历出邻居集合中未被激活的结点
            for j = 1:length(neighbors)
                if ~ismember(neighbors(j), A)
                    % 以概率p尝试激活该邻居结点
                    if rand() < p
                        % 将该邻居结点加入新激活的结点集合中
                        N = [N neighbors(j)];
                    end
                end
            end
        end
        % 将新激活的结点集合加入被激活的结点集合中
        A = [A N];
        % 更新当前时刻的初始结点集合为新激活的结点集合
        S = N;
        % 更新当前时刻
        t = t + 1;
    end
    % 返回被激活的结点个数
    num = length(A);
end

