% 问题二
%% 构建机器人
clc
clear

L(1) = Revolute('d', 0, 'a', 0, 'alpha', pi/2);
L(2) = Revolute('d', 0, 'a', 0.43, 'alpha', 0);
L(3) = Revolute('d', 0.15, 'a', 0.02, 'alpha', -pi/2);
L(4) = Revolute('d', 0.43, 'a', 0, 'alpha', pi/2);
L(5) = Revolute('d', 0, 'a', 0, 'alpha', -pi/2);
L(6) = Revolute('d', 0, 'a', 0, 'alpha', 0);
robot = SerialLink(L, 'name', 'Puma 560');

%robot.teach
q_start=[0,0,0,0,0,0]; %           起始点关节空间矢量
q_end=[0.2,-0.1,-0.25,0.3,0.2,0.3]; %终止点关节空间矢量

%笛卡尔坐标系中运动起止点的期待值
T_start=robot.fkine(q_start);
T_end=robot.fkine(q_end);

%在关节坐标系进行轨迹规划
q_start=robot.ikine(T_start);
q_end=robot.ikine(T_end);


number=100;
Time=linspace(1,10,number); %仿真时间
[q,qd,qdd]=jtraj(q_start,q_end,Time); %关节空间规划


plot(robot,q)

%所有关节  的角位移、角速度和角加速度曲线
figure;
plot(Time,q,LineWidth=3) %关节的角位移曲线
title("各个关节的角位移")
legend('1','2','3','4','5','6')
xlabel('时间/s')
ylabel('角位移/rad')


figure;
plot(Time,qd,LineWidth=3) %关节的角速度曲线
title("各个关节的角速度")
legend('1','2','3','4','5','6')
xlabel('时间/s')
ylabel('角速度/(rad/s)')

figure;
plot(Time,qdd,LineWidth=3) %关节 角加速度曲线
title("各个关节的角加速度")
xlabel('时间/s')
ylabel('角加速度/(rad/(s*s))')
legend('1','2','3','4','5','6')

%机器人末端轨迹图像
T=fkine(robot,q);
p=zeros(3,number);

for i = 1:number
    p(:,i) = T(1,i).t; % 提取出第i个路点的位置
end

figure;
plot3(p(1,1),p(2,1),p(3,1),'k*',LineWidth=3)
hold on
plot3(p(1,number),p(2,number),p(3,number),'r*',LineWidth=3)

k=1:number;
plot3(p(1,:),p(2,:),p(3,:),'b',LineWidth=3)
title("机器人末端笛卡尔坐标的位移")
xlabel('米/m')
ylabel('米/m')
zlabel('米/m')
legend('起点',"终点")
hold off
