function [result,I] = chuanbo(s,A,n,p,max_iter)
    k = 1; % 初始点的个数
    active = zeros(1,n); % 记录每个结点是否被激活的标志向量
    active(s) = 1;% 标记初始点为已激活
    G=digraph(A);
    for start =1:n
        if start==s
           continue
        end
        

% 接着，用独立级联模型进行信息传播
%p = 0.1; % 设置传播概率
%max_iter = 5; % 设置传播最大次数

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
    [result,I]=max(start_sum);
  
end