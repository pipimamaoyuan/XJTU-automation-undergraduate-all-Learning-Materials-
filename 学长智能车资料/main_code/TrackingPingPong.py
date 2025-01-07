import cv2
import numpy as np
# https://www.cnblogs.com/bjxqmy/p/12333022.html
# https://blog.csdn.net/weixin_44237705/article/details/109021812
import RPi.GPIO as gpio
import time

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


def empty(a):
    pass


def draw_direction(img, lx, ly, nx, ny):
    dx = nx - lx
    dy = ny - ly
    if abs(dx) < 4 and abs(dy) < 4:
        dx = 0
        dy = 0
    else:
        r = (dx ** 2 + dy ** 2) ** 0.5
        dx = int(dx / r * 40)
        dy = int(dy / r * 40)
        # print(dx, dy)
    cv2.arrowedLine(img, (60, 100), (60 + dx, 100 + dy), (0, 255, 0), 2)
    # print(nx-lx, ny-ly)   # 噪声一般为+-1
    # cv2.arrowedLine(img, (150, 150), (150+(nx-lx), 150+(ny-ly)), (0, 0, 255), 2, 0, 0, 0.2)


def Hough_circle(imgGray, canvas):
    # 基于霍夫圆检测找圆，包含了必要的模糊步骤
    # 在imgGray中查找圆，在canvas中绘制结果
    # canvas必须是shape为[x, y, 3]的图片
    global Hough_x, Hough_y
    img = cv2.medianBlur(imgGray, 3)
    img = cv2.GaussianBlur(img, (17, 19), 0)
    # cv2.imshow("Blur", img)
    # cv2.waitKey(30)
    circles = cv2.HoughCircles(img, cv2.HOUGH_GRADIENT, 1, 200,
                               param1=20, param2=50, minRadius=30, maxRadius=70)
    try:
        # try语法保证在找到圆的前提下才进行绘制
        circles = np.uint16(np.around(circles))
        # print("circ:",circles)
        # 经测试，circles为：[[[c0_x, c0_y, c0_r], [c1_x, c1_y, c1_r], ...]]
        # 所以for i in circles[0, :]:中的i为每一个圆的xy坐标和半径
    except:
        pass
    else:
        for i in circles[0, :]:
            # draw the outer circle
            cv2.circle(canvas, (i[0], i[1]), i[2], (255, 100, 0), 2)
            # draw the center of the circle
            cv2.circle(canvas, (i[0], i[1]), 2, (0, 0, 255), 3)
            Hough_x = i[0]
            Hough_y = i[1]


frameWidth = 640
frameHeight = 480
cap = cv2.VideoCapture(0)  # 0对应笔记本自带摄像头
cap.set(3, frameWidth)  # set中，这里的3，下面的4和10是类似于功能号的东西，数字的值没有实际意义
cap.set(4, frameHeight)
cap.set(10, 80)  # 设置亮度
pulse_ms = 30
standard_area = 7000  # 设置乒乓球的标准大小，如果area大于这个值就要退后，如果小于这个值就前进
# 调试用代码，用来产生控制滑条
# cv2.namedWindow("HSV")
# cv2.resizeWindow("HSV", 640, 300)
# cv2.createTrackbar("HUE Min", "HSV", 4, 179, empty)
# cv2.createTrackbar("SAT Min", "HSV", 180, 255, empty)
# cv2.createTrackbar("VALUE Min", "HSV", 156, 255, empty)
# cv2.createTrackbar("HUE Max", "HSV", 32, 179, empty)
# cv2.createTrackbar("SAT Max", "HSV", 255, 255, empty)
# cv2.createTrackbar("VALUE Max", "HSV", 255, 255, empty)

lower = np.array([4, 180, 156])  # 适用于橙色乒乓球4<=h<=32
upper = np.array([32, 255, 255])

targetPos_x = 0  # 颜色检测得到的x坐标
targetPos_y = 0  # 颜色检测得到的y坐标
lastPos_x = 0  # 上一帧图像颜色检测得到的x坐标
lastPos_y = 0  # 上一帧图像颜色检测得到的y坐标
lastarea = 0
Hough_x = 0  # 霍夫圆检测得到的x坐标
Hough_y = 0  # 霍夫圆检测得到的y坐标
# ColorXs = []        # 这些是用来存储x，y坐标的列表，便于后期写入文件
# ColorYs = []
# HoughXs = []
# HoughYs = []

while True:
    _, img = cap.read()

    # 霍夫圆检测前的处理Start
    b, g, r = cv2.split(img)  # 分离三个颜色
    r = np.int16(r)  # 将红色与蓝色转换为int16，为了后期做差
    b = np.int16(b)
    r_minus_b = r - b  # 红色通道减去蓝色通道，得到r_minus_b
    r_minus_b = (r_minus_b + abs(r_minus_b)) / 2  # r_minus_b中小于0的全部转换为0
    r_minus_b = np.uint8(r_minus_b)  # 将数据类型转换回uint8
    # 霍夫圆检测前的处理End

    imgHough = img.copy()  # 用于绘制识别结果和输出

    imgHsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

    imgMask = cv2.inRange(imgHsv, lower, upper)  # 获取遮罩
    imgOutput = cv2.bitwise_and(img, img, mask=imgMask)
    contours, hierarchy = cv2.findContours(imgMask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)  # 查找轮廓
    # https://blog.csdn.net/laobai1015/article/details/76400725
    # CV_RETR_EXTERNAL 只检测最外围轮廓 RETE_FREE
    # CV_CHAIN_APPROX_NONE 保存物体边界上所有连续的轮廓点到contours向量内 CHAIN_APPROX_SIMPLE
    # print(np.array(contours).shape)     #查看提取的轮廓数量
    imgMask = cv2.cvtColor(imgMask, cv2.COLOR_GRAY2BGR)  # 转换后，后期才能够与原画面拼接，否则与原图维数不同

    # 下面的代码查找包围框，并绘制
    x, y, w, h = 0, 0, 0, 0
    for cnt in contours:
        area = cv2.contourArea(cnt)
        if area > 300:
            print("area", area)
            x, y, w, h = cv2.boundingRect(cnt)
            lastarea = area
            lastPos_x = targetPos_x
            lastPos_y = targetPos_y
            targetPos_x = int(x + w / 2)
            targetPos_y = int(y + h / 2)
            print("<targetPos_x,targetPos_y", targetPos_x, targetPos_y)
            cv2.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 2)
            cv2.circle(img, (targetPos_x, targetPos_y), 2, (0, 255, 0), 4)

    # 坐标（图像内的）
    cv2.putText(img, "({:0<2d}, {:0<2d})".format(targetPos_x, targetPos_y), (20, 30),
                cv2.FONT_HERSHEY_PLAIN, 1, (0, 255, 0), 2)  # 文字
    draw_direction(img, lastPos_x, lastPos_y, targetPos_x, targetPos_y)

    # 霍夫圆检测Start
    Hough_circle(r_minus_b, imgHough)
    cv2.imshow("R_Minus_B", r_minus_b)
    cv2.putText(imgHough, "({:0<2d}, {:0<2d})".format(Hough_x, Hough_y), (20, 30),
                cv2.FONT_HERSHEY_PLAIN, 1, (255, 100, 0), 2)
    # 霍夫圆检测End

    imgStack = np.hstack([img, imgHough])
    # imgStack = np.hstack([img, imgMask])            # 拼接
    cv2.imshow('Horizontal Stacking', imgStack)  # 显示

    # ColorXs.append(targetPos_x)     # 坐标存入列表
    # ColorYs.append(targetPos_y)
    # HoughXs.append(Hough_x)
    # HoughYs.append(Hough_y)

    # 让小车跟踪乒乓球
    x_delta = targetPos_x - 320
    y_delta = targetPos_y - 240
    # 霍夫
    # x_delta = Hough_x - 320
    # y_delta = Hough_y - 240
    x_threshold = 40
    y_threshold = 30  # 阈值 可修改

    # 先调整左右方向,再前进后退
    if (abs(x_delta) <= x_threshold):
        # 球在中间
        if (abs(y_delta) <= y_threshold):
            # 正中间
            car_stop()
        elif (y_delta < y_threshold * -1):
            # 球在中上，前进
            car_forward()
            pwm1.ChangeDutyCycle(25)
            pwm2.ChangeDutyCycle(25)
        else:
            # 球在中下，后退
            car_back()
            pwm1.ChangeDutyCycle(25)
            pwm2.ChangeDutyCycle(25)

    elif (x_delta < x_threshold * -1):
        # 球在左边
        if (y_delta > y_threshold):
            # 球在左下，向右下方后退
            car_back()
            pwm1.ChangeDutyCycle(20 + abs(x_delta) / 20)
            pwm2.ChangeDutyCycle(0)
        else:
            # 球在左上、左中，向左上方前进
            car_forward()
            pwm1.ChangeDutyCycle(0)
            pwm2.ChangeDutyCycle(20 + abs(x_delta) / 20)
    else:
        # 球在右边
        if (y_delta > y_threshold):
            # 球在右下，向左下方后退
            car_back()
            pwm1.ChangeDutyCycle(0)
            pwm2.ChangeDutyCycle(20 + x_delta / 20)
        else:
            # 球在右上、右中，向右上方前进
            car_forward()
            pwm1.ChangeDutyCycle(20 + x_delta / 20)
            pwm2.ChangeDutyCycle(0)

    if cv2.waitKey(pulse_ms) & 0xFF == ord('q'):  # 按下“q”推出（英文输入法）
        print("Quit\n")
        break

cap.release()
cv2.destroyAllWindows()