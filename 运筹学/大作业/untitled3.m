clc;
clear;
% A=xlsread('铅钡详细数据.xlsx')
matrix='铅钡详细数据.xlsx'
A=readmatrix(matrix);
X=A(:,1:14);
Y=A(:,15:15);

% 矩阵乘法实现线性回归  
(m,n) = size(X); % 计算 X 的行数和列数  
A = XX(:, 1:n) / n; % 将 X 的特征向量缩放到对角线上  
b = X(:, 1) - sum(A' * X, 2) / n; % 计算回归结果

% 使用 lasso 回归进行拟合  
f = @(x) log(1 + exp(-x)); % lasso 回归函数  
lambda = 1e3; % 设置 lambda 为超参数  
[~, index] = linalg.QR(A, 'Upper'); % 使用 QR 分解求解可朔性  
y_pred = A' * X @ f(lambda) + b'; % 计算预测结果

% 计算均方误差 (MSE)  
mse = mean((y - y_pred).^2); % 计算 MSE  
disp(['MSE = ' num2str(mse)]);

% 绘制 ROC 曲线  
[y_pred, y_true] = label2cells(y, 'children'); % 将目标变量转换为二进制  
roc = roc(y_true, y_pred); % 计算 ROC 曲线  
plot(roc(:, 1), roc(:, 2), 'o-', 'MarkerSize', 8, 'MarkerFaceColor', 'g'); % 绘制 ROC 曲线  
xlabel('False Positive Rate');  
ylabel('True Positive Rate');  
title('ROC Curve');

% 绘制回归线  
y_pred = A' * X @ f(lambda) + b'; % 计算预测结果  
line(y_true, y_pred, 'LineWidth', 2, 'Color', 'g'); % 绘制回归线

% 打印结果  
disp(['Lambda = ' num2str(lambda)]);  
disp(['MSE = ' num2str(mse)]);  
disp(['ROC Curve = ' num2str(roc)]);  
disp(['Regression Line = ' num2str(y_pred)]);  
