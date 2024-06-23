x=[220 700 222 87 50 29 29 15 9 5 3 2 3 1 1 1];
y=[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 16];
figure;
bar(y,x)
axis([0 17 0 750])
for i = 1:length(x)
    text(y(i),x(i),num2str(x(i)),'HorizontalAlignment','center','VerticalAlignment','bottom');
end


x=[29 29 15 9 5 3 2 3 1 1 1];
y=[5 6 7 8 9 10 11 12 13 14 16];
figure;
bar(y,x)
axis([4 17 0 32])
for i = 1:length(x)
    text(y(i),x(i),num2str(x(i)),'HorizontalAlignment','center','VerticalAlignment','bottom');
end
