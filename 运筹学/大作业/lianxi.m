n=100000;
TIME=0;
for i=1:n

s=[];
time=0;
b=[];
while length(b)<6
    r=randi([1,6],1,1);
    s=[s r];
    b=unique(s,'stable');
    time=time+1;
end
TIME=TIME+time;
end
TIME=TIME/n