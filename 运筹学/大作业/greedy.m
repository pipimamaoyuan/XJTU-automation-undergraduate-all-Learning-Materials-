% 定义一个函数，用于贪心地选择初始结点集合，并返回最优解和对应的平均传播结点数
function [S, s] = greedy(P, k)
    n=100;
    % P是传播概率矩阵，k是初始结点集合的大小
    
    % 初始化初始结点集合为空集合
    S = [];
    
    % 初始化平均传播结点数为0
    s = 0;
    
    
    % 迭代k次，每次选择一个未被选中的结点，使得平均传播结点数增加最多
    for i = 1:k
        % 初始化最大增量为0
        max_delta = 0;
        % 初始化最佳候选结点为0
        best_candidate = 0;
        % 遍历所有未被选中的结点，计算它们的增量，并找出最大增量对应的结点
        for j = 1:n
            if ~ismember(j, S)
                % 计算加入j后的平均传播结点数
                new_s = evaluate(P, [S, j]);
                % 计算增量
                delta = new_s - s;
                % 如果增量大于当前最大增量，则更新最大增量和最佳候选结点
                if delta > max_delta
                    max_delta = delta;
                    best_candidate = j;
                end
            end
        end
        % 将最佳候选结点加入初始结点集合，并更新平均传播结点数
        S = [S, best_candidate];
        s = s + max_delta;
    end
    
    % 返回最优解和对应的平均传播结点数
end