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

# 设置PWM波,频率为500Hz
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
# PID控制参数初始化
Kp = 0.085
Ki = 0
Kd = 0
Target_value = 320   # 设定值初始化
last_Err = 0         # 上一个误差值初始化
total_Err = 0        # 误差累加初始化
output = 0           # PID输出初始化

while (1):
    ret, frame = cap.read()
    # 转化为灰度图
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    # 大津法二值化
    # retval, dst = cv2.threshold(gray, 40, 255, cv2.THRESH_OTSU)
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
    # PID控制
    Error = Target_value - center  # 计算偏差  ：   320 - 路中心
    total_Err = total_Err + Error  # 偏差累加
    output = Kp * Error + Ki * total_Err + Kd * (Error - last_Err)  # PID运算
    last_Err = Error  # 将本次偏差赋给上次一偏差
    u = output  # cx的调整值直接传给速度（调整速度）
    print('center:\t',center)
    print("u:\t",u)
    u_l = 30 + 1.2 * u  # 根据偏差调整左轮的转速
    u_r = 30 - 1.2 * u  # 根据偏差调整右轮的转速
    # 假如左右轮的速度理论值大于等于95，则令其等于95（原因：速度最大为100，以及避免电机长时间满负荷工作）
    if u_l >= 95:
        u_l = 95
    if u_r >= 95:
        u_r = 95
    # 假如左右轮的速度理论值小于等于0，则令其等于0（原因：速度最小为0）
    if u_r <= 0:
        u_r = 0
    if u_l <= 0:
        u_l = 0
    car_forward()
    pwm1.ChangeDutyCycle(u_l)
    pwm2.ChangeDutyCycle(u_r)


    # threshold = 50
    # threshold_neg = -threshold
    # if abs(direction) >= threshold:
    #     # 左转
    #     if direction > threshold:
    #         car_forward()
    #         pwm1.ChangeDutyCycle(25 + direction / 12)
    #         # pwm1.ChangeDutyCycle(40)
    #         pwm2.ChangeDutyCycle(0)
    #         if(direction>120 and direction <150):
    #             time.sleep(0.3)
    #         elif(direction >= 150):
    #             time.sleep(0.5)
    #         # pwm1.ChangeDutyCycle(0)
    #         # # pwm.Chan2geDutyCycle(40)
    #         # pwm2.ChangeDutyCycle(50 + abs(direction) / 120)
    #
    #
    #     # 右转
    #     elif direction < threshold_neg:
    #         car_forward()
    #         pwm1.ChangeDutyCycle(0)
    #         # pwm.Chan2geDutyCycle(40)
    #         pwm2.ChangeDutyCycle(25 + abs(direction) / 12)
    #         if(abs(direction)>120 and abs(direction)<150):
    #             time.sleep(0.3)
    #         elif(abs(direction)>=150):
    #             time.sleep(0.5)
    #         # pwm1.ChangeDutyCycle(50 + direction / 120)
    #         # # pwm1.ChangeDutyCycle(40)
    #         # pwm2.ChangeDutyCycle(0)
    #
    # else:
    #     car_forward()
    #     pwm1.ChangeDutyCycle(20)
    #     pwm2.ChangeDutyCycle(20)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# 释放清理
cap.release()
cv2.destroyAllWindows()
pwm1.stop()
pwm2.stop()

gpio.cleanup()

