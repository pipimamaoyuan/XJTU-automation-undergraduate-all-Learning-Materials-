# -*- coding: utf-8 -*-

# 中美就业人数分布
import matplotlib.pyplot as plt
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

import numpy as np
import seaborn

CD_LNLP=np.array([0.181,0.017,0.113,0.015,0.206,0.141])  #科学研究 1.3%
DMFCDA=np.array([0.09,0.025,0.15,0.05,0.075,0.35])

size = 6
x = np.arange(size)

# 有a/b/c三种类型的数据，n设置为3
total_width, n = 0.5, 2
# 每种类型的柱状图宽度
width = total_width / n

# 重新设置x轴的坐标
x = x - (total_width - width) / 2
print(x)

plt.figure(figsize=(10,7))
# 画柱状图

plt.bar(x + width, CD_LNLP, width=width, label="中国",color='red')
plt.bar(x, DMFCDA, width=width, label="美国",color='lightblue')

k=[0,1,2,3,4,5]
x_ticks_label=['制造业','信息产业','建筑业','金融业','农林牧渔业','零售和餐饮业']
plt.xticks(k,x_ticks_label,fontsize=15)
plt.xticks(rotation=30)
plt.yticks([0,0.10,0.20,0.30,0.40],['0','10%','20%','30%','40%'],fontsize=15)
plt.ylabel("就业人数占比",fontsize=20)
plt.title("中美两国就业人数分布",fontsize=20)

# 显示图例
plt.legend(loc='best',fontsize=20)

# 显示柱状图
plt.show()
