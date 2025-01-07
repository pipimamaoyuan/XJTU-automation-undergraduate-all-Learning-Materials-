# coding:utf-8
#
# 加入摄像头模块，让小车实现自动循迹行驶
# 思路为：摄像头读取图像，进行二值化，将白色的赛道凸显出来
# 选择下方的一行像素，黑色为0，白色为255
# 找到白色值的中点
# 目标中点与标准中点（320）进行比较得出偏移量
# 根据偏移量来控制小车左右轮的转速
# 考虑了偏移过多失控->停止;偏移量在一定范围内->高速直行(这样会速度不稳定，已删)

import RPi.GPIO as gpio
import time
import cv2
import numpy as np

# 定义引脚
pin1 = 12  # 左正
pin2 = 16  # 左反
pin3 = 18  # 右正
pin4 = 22  # 右反
ENA = 38
ENB = 40

# 设置gpio口为BOARD编号规范
gpio.setmode(gpio.BOARD)

# 设置gpio口为输出
gpio.setup(pin1, gpio.OUT)
gpio.setup(pin2, gpio.OUT)
gpio.setup(pin3, gpio.OUT)
gpio.setup(pin4, gpio.OUT)
gpio.setup(ENA, gpio.OUT)
gpio.setup(ENB, gpio.OUT)

# 设置PWM波,频率为50Hz
pwm1 = gpio.PWM(ENA, 50)
pwm2 = gpio.PWM(ENB, 50)

pwm1.start(0)
pwm2.start(0)


def car_forward():  # 定义前进函数
    gpio.output(pin1, gpio.HIGH)  # 将pin1接口设置为高电压
    gpio.output(pin2, gpio.LOW)  # 将pin2接口设置为低电压
    gpio.output(pin3, gpio.HIGH)  # 将pin3接口设置为高电压
    gpio.output(pin4, gpio.LOW)  # 将pin4接口设置为低电压


def car_back():  # 定义后退函数
    gpio.output(pin1, gpio.LOW)
    gpio.output(pin2, gpio.HIGH)
    gpio.output(pin3, gpio.LOW)
    gpio.output(pin4, gpio.HIGH)


def car_left():  # 定义左转函数
    gpio.output(pin1, gpio.LOW)
    gpio.output(pin2, gpio.HIGH)
    gpio.output(pin3, gpio.HIGH)
    gpio.output(pin4, gpio.LOW)


def car_right():  # 定义右转函数
    gpio.output(pin1, gpio.HIGH)
    gpio.output(pin2, gpio.LOW)
    gpio.output(pin3, gpio.LOW)
    gpio.output(pin4, gpio.HIGH)


def car_stop():  # 定义停止函数
    gpio.output(pin1, gpio.LOW)
    gpio.output(pin2, gpio.LOW)
    gpio.output(pin3, gpio.LOW)
    gpio.output(pin4, gpio.LOW)


# center定义
center = 320
# 打开摄像头，图像尺寸640*480（长*高），opencv存储值为480*640（行*列）
cap = cv2.VideoCapture(0)
cap.set(3, 640)
cap.set(4, 480)

while (1):
    ret, frame = cap.read()
    # 转化为灰度图
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    # 大津法二值化
    retval, dst = cv2.threshold(gray, 100, 255, cv2.THRESH_OTSU)
    # 膨胀，白区域变大
    dst = cv2.dilate(dst, None, iterations=2)
    # # 腐蚀，白区域变小
    dst = cv2.erode(dst, None, iterations=6)
    cv2.imshow('color_frame', dst)  # 展示每一帧
    # 单看第400行的像素值
    # print(dst.shape)
    color = dst[400]
    # 找到连续白色像素点最宽的那条
    road_set = []
    road_set_length = []
    road = []
    for i in range(len(color)):
        if (i == 639):
            road_set.append(road)
            road_set_length.append(len(road))
            break
        if color[i] == 255 and color[i + 1] == 255:
            road.append(i)
        elif (len(road) > 20 and color[i + 1] != 255):
            road_set.append(road)
            road_set_length.append(len(road))
            road = []
    if (len(road_set_length) == 0):
        center = 320
    elif (len(road) == 0):
        center = 320
    else:
        index_ = road_set_length.index(max(road_set_length))
        road = road_set[index_]
        center = (min(road) + max(road)) / 2
    # 计算出center与标准中心点的偏移量
    # 如果为正，应该左转
    direction = center - 320

    print(direction)


    threshold = 90                  #右转阈值
    threshold_neg = -40      		#左转阈值
    if abs(direction) >= threshold:
        # 右转
        if direction > threshold:
            car_forward()
            pwm1.ChangeDutyCycle(25 + direction / 18)
            pwm2.ChangeDutyCycle(0)
            if(direction>120 and direction <150):
                time.sleep(0.3)
            elif(direction >= 150):
                time.sleep(0.5)


        # 左转
        elif direction < threshold_neg:
            car_forward()
            pwm1.ChangeDutyCycle(0)
            pwm2.ChangeDutyCycle(25 + abs(direction) / 12)
            if(abs(direction)>120 and abs(direction)<150):
                time.sleep(0.3)
            elif(abs(direction)>=150):
                time.sleep(0.5)

    else:
        car_forward()
        pwm1.ChangeDutyCycle(20)
        pwm2.ChangeDutyCycle(20)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# 释放清理
cap.release()
cv2.destroyAllWindows()
pwm1.stop()
pwm2.stop()

gpio.cleanup()