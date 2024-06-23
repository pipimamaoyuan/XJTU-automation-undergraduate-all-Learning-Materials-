#-*- coding: utf-8 -*-
# 柱状图
import matplotlib.pyplot as plt
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号


import numpy as np
import seaborn

CD_LNLP=np.array([15,56,83,59])

size = 4
x = np.arange(size)

# 有a/b/c三种类型的数据，n设置为3
total_width, n = 0.3, 1
# 每种类型的柱状图宽度
width = total_width / n

# 重新设置x轴的坐标
x = x - (total_width - width) / 2
print(x)

plt.figure(figsize=(9,7))
# 画柱状图

plt.bar(x , CD_LNLP, width=width, label="CD_LNLP",color='gold')

k=[0,1,2,3]
x_ticks_label=['否','是，行业结构调整','是，企业裁员','是，人才供给过剩']
plt.xticks(k,x_ticks_label,fontsize=15)
plt.xticks(rotation=30)
plt.yticks([10,20,30,40,50,60,70,80],['10','20','30','40','50','60','70','80'],fontsize=15)
plt.ylabel("人数",fontsize=20)
plt.title("求职者感受到就业市场的不稳定性",fontsize=20)

# 显示柱状图
plt.show()



CD_LNLP=np.array([38,26,28,25,25])

size = 5
x = np.arange(size)

# 有a/b/c三种类型的数据，n设置为3
total_width, n = 0.3, 1
# 每种类型的柱状图宽度
width = total_width / n

# 重新设置x轴的坐标
x = x - (total_width - width) / 2
print(x)

plt.figure(figsize=(9,7))
# 画柱状图

plt.bar(x , CD_LNLP, width=width, label="CD_LNLP",color='pink')

k=[0,1,2,3,4]
x_ticks_label=['刺激企业发展','加大基建投入','增加就业技能培训','扩大社保范围','直接支持就业创业']
plt.xticks(k,x_ticks_label,fontsize=15)
plt.xticks(rotation=30)
plt.yticks([15,20,25,30,35,40],['15','20','25','30','35','40'],fontsize=15)
plt.ylabel("人数",fontsize=20)
plt.title("政府措施",fontsize=20)
plt.ylim(23, 40)  # 这里将Y轴范围设定为0到20
# 显示柱状图
plt.show()


