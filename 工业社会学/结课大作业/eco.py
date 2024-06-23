# -*- coding: utf-8 -*-

# 主要经济体的经济发展
import matplotlib.pyplot as plt
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

import numpy as np
import seaborn

A=np.array([2.3,2.0,3.9,3.5,5.25])+2
C=np.array([4.5,4.4,5.2,0.3,3.45])+2
E=np.array([2.4,2.7,6.5,2.4,4.5])+2
#J=np.array([1.9,1.6,2.6,2.7,0])
J=np.array([1.9,1.6,2.6,2.7,-0.1])+2
G=np.array([1.8,1.9,5.9,2.2,4.5])+2


size = 5
x = np.arange(size)

# 有a/b/c三种类型的数据，n设置为3
total_width, n = 0.5, 5
# 每种类型的柱状图宽度
width = total_width / n

# 重新设置x轴的坐标
x = x - (total_width - width) / 2

plt.figure(figsize=(10,7))

# 画柱状图
plt.bar(x + 3*width, A, width=width, label="美国",color='silver')
plt.bar(x+ 4*width, C, width=width, label="中国",color='pink')
plt.bar(x + 2*width, E, width=width, label="欧洲",color=seaborn.xkcd_rgb['light periwinkle'])
plt.bar(x + width, J, width=width, label="日本",color='gold')
plt.bar(x, G, width=width, label="德国",color=seaborn.xkcd_rgb['pale green'])

k=[0,1,2,3,4]
x_ticks_label=['2024年预测GDP增长','2025年预测GDP增长','失业率','通胀率','中央银行基金利率']
plt.xticks(k,x_ticks_label,fontsize=15)
plt.xticks(rotation=30)
plt.yticks([1,2,3,4,5,6,7,8],['-0.1%','0%','1%','2%','3%','4%','5%','6%'],fontsize=15)
plt.ylabel("比率",fontsize=20)
plt.title("主要经济体的经济指标",fontsize=20)

# 显示图例
plt.legend(loc='best',fontsize=15)

# 显示柱状图
plt.show()
