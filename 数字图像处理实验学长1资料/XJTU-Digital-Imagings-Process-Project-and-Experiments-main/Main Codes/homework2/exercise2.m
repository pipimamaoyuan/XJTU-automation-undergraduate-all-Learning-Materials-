% 读取两张图像，分别命名为A和B
A = imread('Image A.jpg');
B = imread('Image B.jpg');

% 将两张图像转换为灰度图像，分别命名为A_gray和B_gray
A_gray = rgb2gray(A);
B_gray = rgb2gray(B);

% 定义变换的初始参数，包括平移量(tx, ty)和旋转角度(theta)
tx = 0;
ty = 0;
theta = 0;

% 定义变换的步长，包括平移步长(delta_tx, delta_ty)和旋转步长(delta_theta)
delta_tx = 1;
delta_ty = 1;
delta_theta = 0.01;

% 定义变换的范围，包括平移范围(tx_min, tx_max, ty_min, ty_max)和旋转范围(theta_min, theta_max)
tx_min = -10;
tx_max = 10;
ty_min = -10;
ty_max = 10;
theta_min = -0.1;
theta_max = 0.1;

% 定义变换的终止条件，包括最大迭代次数(max_iter)和最小互信息增量(min_delta_NMI)
max_iter = 100;
min_delta_NMI = 0.001;

% 初始化迭代次数(iter)和互信息(NMI)
iter = 0;
NMI = 0;

% 进行迭代优化，直到满足终止条件
while iter < max_iter
    % 记录上一次的互信息(NMI_old)
    NMI_old = NMI;
    
    % 记录当前的变换参数(tx_old, ty_old, theta_old)
    tx_old = tx;
    ty_old = ty;
    theta_old = theta;
    
    % 计算当前的互信息(NMI)
    NMI = normalized_mutual_information(A_gray, B_gray, tx, ty, theta);
    
    % 如果互信息增量小于最小阈值，终止迭代
    if NMI - NMI_old < min_delta_NMI
        break;
    end
    
    % 初始化最大的互信息增量(max_delta_NMI)和对应的变换参数(tx_best, ty_best, theta_best)
    max_delta_NMI = 0;
    tx_best = tx;
    ty_best = ty;
    theta_best = theta;
    
    % 遍历变换参数的邻域，寻找最大的互信息增量和对应的变换参数
    for tx = tx_old - delta_tx : delta_tx : tx_old + delta_tx
        for ty = ty_old - delta_ty : delta_ty : ty_old + delta_ty
            for theta = theta_old - delta_theta : delta_theta : theta_old + delta_theta
                % 判断变换参数是否在范围内
                if tx >= tx_min && tx <= tx_max && ty >= ty_min && ty <= ty_max && theta >= theta_min && theta <= theta_max
                    % 计算变换后的互信息(NMI_new)
                    NMI_new = normalized_mutual_information(A_gray, B_gray, tx, ty, theta);
                    % 计算互信息增量(delta_NMI)
                    delta_NMI = NMI_new - NMI_old;
                    % 如果互信息增量大于当前最大值，更新最大值和对应的变换参数
                    if delta_NMI > max_delta_NMI
                        max_delta_NMI = delta_NMI;
                        tx_best = tx;
                        ty_best = ty;
                        theta_best = theta;
                    end
                end
            end
        end
    end
    
    % 更新变换参数为最佳值
    tx = tx_best;
    ty = ty_best;
    theta = theta_best;
    
    % 增加迭代次数
    iter = iter + 1;
end

% 输出最终的变换参数和互信息
fprintf('The final transformation parameters are: tx = %d, ty = %d, theta = %.2f\n', tx, ty, theta);
fprintf('The final normalized mutual information is: %.4f\n', NMI);

% 定义计算归一化互信息的函数
function NMI = normalized_mutual_information(A, B, tx, ty, theta)
    % 获取图像的大小，即行数和列数
    [rows, cols] = size(A);
    
    % 定义图像的中心点，即行数和列数的一半
    cx = rows / 2;
    cy = cols / 2;
    
    % 定义旋转矩阵
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    
    % 定义平移向量
    T = [tx; ty];
    
    % 初始化变换后的图像B_out
    B_out = zeros(rows, cols);
    
    % 遍历图像的每个像素
    for x = 1 : rows
        for y = 1 : cols
            % 计算像素相对于中心点的坐标
            p = [x - cx; y - cy];
            
            % 计算像素经过逆变换后的坐标
            q = R \ (p - T);
            
            % 计算像素相对于原点的坐标
            u = q(1) + cx;
            v = q(2) + cy;
            
            % 判断像素是否在图像范围内
            if u >= 1 && u <= rows && v >= 1 && v <= cols
                % 使用双线性插值法计算像素的灰度值
                i = floor(u);
                j = floor(v);
                a = u - i;
                b = v - j;
                B_out(x, y) = (1 - a) * (1 - b) * B(i, j) + a * (1 - b) * B(i + 1, j) + (1 - a) * b * B(i, j + 1) + a * b * B(i + 1, j + 1);
            end
        end
    end
    
    % 将图像转换为整数类型
    A = uint8(A);
    B_out = uint8(B_out);
    
    % 计算图像的直方图
    HA = imhist(A);
    HB = imhist(B_out);
        % 计算图像的联合直方图
    HAB = hist3([A(:), B_out(:)], [256, 256]);
    
    % 计算图像的熵
    EA = -sum(HA .* log2(HA + eps));
    EB = -sum(HB .* log2(HB + eps));
    
    % 计算图像的联合熵
    EAB = -sum(HAB(:) .* log2(HAB(:) + eps));
    
    % 计算图像的归一化互信息
    NMI = (EA + EB) / EAB;
end

