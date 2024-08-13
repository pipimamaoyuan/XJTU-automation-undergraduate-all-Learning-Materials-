num = [0 0 0 2.45 2.5];
den = [3.722*conv([0.25 1.25 1 0],[0.264,1])];




sys1=tf(num,den)
margin(num,den)
figure
grid

sys = feedback(sys1,1)

step(sys)
grid