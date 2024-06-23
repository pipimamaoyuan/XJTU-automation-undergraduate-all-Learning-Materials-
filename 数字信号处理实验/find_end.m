%function [li, ma, ren] = find_end(frames, win_len, n_frames, En, Mn, Zn, En_limit1, En_limit2, Zn_limit1, Zn_limit2)
i = 6;
[x,fs] = audioread(['2ren' num2str(i) '.wav']);
flag = 1;
win_size = 0.02;%窗口长度20ms
win_shift = 0.01;%窗口移动步长10ms
[frames, win_len, n_frames] = windows(x,fs,flag,win_size,win_shift);
[En, Mn, Zn] = short_time_time_analysis(frames, win_len, n_frames);
En_limit1 = 0.2;%能量下限
En_limit2 = 1.5;%能量上限
Zn_limit1 = 10;%过零率下限
Zn_limit2 = 100;%过零率上限
limit1 = zeros(20,1);%下限记录
limit2 = zeros(20,1);%上限记录
number2 = 0;
flag2 = 0;
for i = 1:n_frames
    if En(i) >= En_limit2 && flag2 == 0
        number2 = number2 + 1;
        limit2(number2) = i;
        flag2 = 1;
    end
    if En(i) < En_limit2 && flag2 ==1
        number2 = number2 + 1;
        limit2(number2) = i;
        flag2 = 0;
    end
end

number1 = 0;
flag1 = 0;
start = 1;
for i = 1:2:number2
    if i ~= 1
        start = limit2(i - 1);
    end
    for k = limit2(i):-1:start
        if En(k) <= En_limit1 && flag1 == 0
            number1 = number1 + 1;
            limit1(number1) = k;
            flag1 = 1;
            break;
        end
    end
    if (i + 1) ~= number2
        over_end = limit2(i + 2);
    else 
        over_end = n_frames;
    end
    for k = limit2(i + 1):over_end
        if En(k) <= En_limit1 && flag1 ==1
            number1 = number1 + 1;
            limit1(number1) = k;
            flag1 = 0;
            break;
        end
    end
end


%end