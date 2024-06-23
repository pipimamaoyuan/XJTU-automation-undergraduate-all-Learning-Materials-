# -*- coding: utf-8 -*-

# 态度 是 与 非
import matplotlib.pyplot as plt
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

import numpy as np
import seaborn

CD_LNLP=np.array([7/12,8/12,9/12,10/12,3/12,2/12,8/12])
DMFCDA=np.array([5/12,4/12,3/12,2/12,9/12,10/12,4/12])

size = 7
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

plt.bar(x + width, CD_LNLP, width=width, label="是",color='red')
plt.bar(x, DMFCDA, width=width, label="否",color='lightblue')

k=[0,1,2,3,4,5,6]
x_ticks_label=['生活尚可应对','影响小','乐观','对社保制度基本满意','对职业培训教育满意','支持自主创业','期待科技改变现状']
plt.xticks(k,x_ticks_label,fontsize=15)
plt.xticks(rotation=30)
plt.yticks([0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90],['10%','20%','30%','40%','50%','60%','70%','80%','90%'],fontsize=15)
plt.ylabel("人数",fontsize=20)
plt.title("受访者态度 是 / 非",fontsize=20)

# 显示图例
plt.legend(loc='best',fontsize=20)

# 显示柱状图
plt.show()
