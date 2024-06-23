# 第六次作业题目

1. 在测试图像上产生高斯噪声 lena 图，需能指定均值和方差；并用多种滤波器恢复图像，分析各自优缺点；

2. 在测试图像 lena 图加入椒盐噪声，椒和盐噪声密度均是 0.1，用学过的滤波器恢复图像，再使用反谐波分析 $Q$ 大于 0 和小于 0 的作用；

3. 推导维纳滤波器并实现下边要求：

第一，实现模糊滤波器如以下方程所示：

$$
H\left( u,v \right) =\frac{T}{\pi \left( ua+vb \right)}\sin \left[ \pi \left( ua+vb \right) \right] e^{-j\pi \left( ua+vb \right)}
$$

第二，模糊 lena 图像：45 度方向， $T=1$ ；

第三，在模糊的 lena 图像中增加高斯噪声，均值为 0，方差为 10 个像素，以产生模糊图像；

第四，分别利用如下两个方程恢复图像；并分析算法的优缺点：

$$
\hat{F}\left( u,v \right) =\left[ \frac{1}{H\left( u,v \right)}\cdot \frac{\left| H\left( u,v \right) \right|^2}{\left| H\left( u,v \right) \right|^2+K} \right] \cdot G\left( u,v \right);
$$

$$
\hat{F}\left( u,v \right) =\left[ \frac{H^*\left( u,v \right)}{\left| H\left( u,v \right) \right|^2+\gamma \left| P\left( u,v \right) \right|^2} \right] \cdot G\left( u,v \right)
$$
