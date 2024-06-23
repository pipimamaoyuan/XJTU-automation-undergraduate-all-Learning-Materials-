function [En, Mn, Zn] = short_time_time_analysis(frames, win_len, n_frames)
% i = 3;
% [x,fs] = audioread(['1ren' num2str(i) '.wav']);
% flag = 1;
% win_size = 0.02;%窗口长度20ms
% win_shift = 0.01;%窗口移动步长10ms
% [frames, win_len, n_frames] = windows(x,fs,flag,win_size,win_shift);

%%计算短时能量，平均幅度函数和过零率
En = zeros(n_frames, 1);%初始化短时能量矩阵
Mn = zeros(n_frames, 1);%初始化平均幅度函数矩阵
Zn = zeros(n_frames, 1);%初始化过零率矩阵

for i = 1:n_frames
    en = sum(frames(:, i).^2);
    mn = sum(abs(frames(:, i)));
    zn = 0;
    for k = 2:win_len
        zn = zn + abs(sign(frames(k, i)) - sign(frames(k - 1, i))) / 2;
    end
    En(i) = en;
    Mn(i) = mn;
    Zn(i) = zn;
end
subplot(1,3,3)
plot(Zn)
title('过零率')
ylabel('次数')
subplot(1,3,2)
plot(Mn)
title('平均幅度函数')
ylabel('幅度大小')
xlabel('帧数')
subplot(1,3,1)
plot(En)
title('短时能量')
ylabel('能量大小')
end