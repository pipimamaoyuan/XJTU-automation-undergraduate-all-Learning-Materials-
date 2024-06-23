clc
clear
% 问题一
%% 构建机器人
L(1) = Revolute('d', 0, 'a', 0, 'alpha', pi/2);
L(2) = Revolute('d', 0, 'a', 0.43, 'alpha', 0);
L(3) = Revolute('d', 0.15, 'a', 0.02, 'alpha', -pi/2);
L(4) = Revolute('d', 0.43, 'a', 0, 'alpha', pi/2);
L(5) = Revolute('d', 0, 'a', 0, 'alpha', -pi/2);
L(6) = Revolute('d', 0, 'a', 0, 'alpha', 0);
robot = SerialLink(L, 'name', 'Puma 560');

%robot.teach

%关节坐标期望的起始点
q_start=[0,0,0,0,0,0];
q_end=[0.2,-0.1,-0.25,0.3,0.2,0.3];

number=100;
Time=linspace(1,10,number); %仿真时间

T_start=robot.fkine(q_start);
T_end=robot.fkine(q_end);

%在笛卡尔坐标系进行轨迹规划
T_answer=ctraj(T_start,T_end,number);
q_answer=robot.ikine(T_answer);

plot(robot,q_answer)

%所有关节  的角位移、角速度和角加速度曲线
figure;
plot(Time,q_answer,LineWidth=3) %关节的角位移曲线
title("各个关节的角位移")
legend('1','2','3','4','5','6')
xlabel('时间/s')
ylabel('角位移/rad')

p=zeros(3,number);

for i = 1:number
    p(:,i) = T_answer(1,i).t; % 提取出第i个路点的位置
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