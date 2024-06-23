function [zhi,xiabiao,ending]=spead(A,point,n,max_iter,p)
G = digraph(A); % 使用邻接矩阵A创建一个加权有向图对象G
jihuoxiangliang=zeros(1,n);
ending=[];
for num=1:n
active = zeros(1,n); % 记录每个结点是否被激活的标志向量
active(point) = 1; % 标记初始点为已激活
active(num)=1;
iter = 0; % 记录当前传播次数
now_active =[point num]; % 记录新激活的结点

while iter < max_iter % 当传播次数小于最大次数并且还有新激活的结点时循环
    iter = iter + 1; % 更新传播次数
    next_active = []; % 记录下一轮新激活的结点
    for u = now_active % 对于每个新激活的结点u
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
    now_active = [now_active next_active]; % 更新新激活的结点
end
jihuoxiangliang(1,num)=sum(active);
temp=jihuoxiangliang(1,num);
if num==1
ending=active;
SUMM=jihuoxiangliang(1,1);
end
if num>1 && temp>SUMM
    ending=active;
    SUMM=temp;
end

end
[zhi,xiabiao]=max(jihuoxiangliang);

end