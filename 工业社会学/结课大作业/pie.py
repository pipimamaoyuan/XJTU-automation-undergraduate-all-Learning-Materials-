#-*- coding: utf-8 -*-

# 饼图
import matplotlib.pyplot as plt
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号



# Example data
labels = ['全球经济不景气', '国内政策调整不当', '金融机构调整不当', '全球贸易紧张局势']
sizes = [11, 3, 3, 9]
colors = ['thistle', 'gold', 'peachpuff', 'powderblue', 'lightsteelblue']

# Create the pie chart without labels
plt.figure(figsize=(7, 7))
plt.pie(sizes, labels=labels, colors=colors, autopct='%1.1f%%', startangle=90,textprops={'fontsize': 15})
plt.title("经济下行的主要原因",fontsize=20)

plt.axis('equal')
plt.show()




# Example data
labels = ['有工作经验，找工作顺利', '有工作经验，找工作困难', '无工作经验，积极找工作','无工作经验，未积极找工作',]
sizes = [15, 28, 70,65]
colors = ['thistle', 'gold', 'peachpuff','powderblue','lightsteelblue']

# Create the pie chart without labels
plt.figure(figsize=(7, 7))
plt.pie(sizes, labels=labels, colors=colors, autopct='%1.1f%%', startangle=0,textprops={'fontsize': 15})
plt.title("问卷调查对象的自身情况",fontsize=20)

plt.axis('equal')
plt.show()

