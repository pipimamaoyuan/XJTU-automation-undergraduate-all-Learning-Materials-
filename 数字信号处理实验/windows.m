function [frames, win_len, n_frames] = windows(x, fs, flag, win_size, win_shift)
%%读取信号
% i = 0;
% [x,fs] = audioread(['1ren' num2str(i) '.wav']);
% x = x(:,1);
%%设置参数
% win_size = 0.02;%窗口长度20ms
% win_shift = 0.01;%窗口移动步长10ms

%%计算每一帧的采样点数
win_len = round(win_size * fs);%每帧点数
switch(flag)
    case 1
        win = rectwin(win_len);%矩形窗
    case 2
        win = hamming(win_len);%汉明窗
    case 3
        win = hanning(win_len);%海宁窗
end

%%分帧加窗
frame_shift = round(win_shift * fs);%帧移(采样点数)
n_frames = floor((length(x) - win_len) / frame_shift) + 1;%总帧数
frames = zeros(win_len, n_frames);%初始化分帧矩阵

for i = 1:n_frames
    start_idx = (i - 1) * frame_shift + 1;%初始采样点
    end_idx = start_idx + win_len -1;%结束采样点
    frame = x(start_idx:end_idx) .* win;%加窗
    frames(:, i) = frame;
end
end