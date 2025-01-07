import cv2
import numpy as np
import RPi.GPIO as GPIO

# 设定对应引脚
# 设定引脚编号系统
GPIO.setmode(GPIO.BOARD) # 物理引脚BOARD编码
# 引脚12、16、18、22【IN1 - IN4】
IN_List = [12, 16, 18, 22]
ENA = 38
ENB = 40
# 输出引脚
OUTPUT_GPIO = [12, 16 ,18, 22, 38, 40]
for item in OUTPUT_GPIO:
    GPIO.setup(item, GPIO.OUT)
# 设置PWM波,频率为50Hz
PWM1 = GPIO.PWM(ENA, 50) # right
PWM2 = GPIO.PWM(ENB, 50) # left
PWM1.start(0)
PWM2.start(0)

# 前进【IN1、IN4 高电平，IN2、IN3 低电平】
def move_forward():
    pwm_value_right = 35.0 # 值越小，速度越小
    pwm_value_left = 35.0
    GPIO.output(IN_List[0], GPIO.HIGH)
    GPIO.output(IN_List[1], GPIO.LOW)
    GPIO.output(IN_List[2], GPIO.LOW)
    GPIO.output(IN_List[3], GPIO.HIGH)
    PWM1.ChangeDutyCycle(pwm_value_right)
    PWM2.ChangeDutyCycle(pwm_value_left)
# 后退【IN1、IN4 低电平，IN2、IN3 高电平】
def move_backward():
    pwm_value_right = 35.0 # 值越小，速度越小
    pwm_value_left = 35.0
    GPIO.output(IN_List[0], GPIO.LOW)
    GPIO.output(IN_List[1], GPIO.HIGH)
    GPIO.output(IN_List[2], GPIO.HIGH)
    GPIO.output(IN_List[3], GPIO.LOW)
    PWM1.ChangeDutyCycle(pwm_value_right)
    PWM2.ChangeDutyCycle(pwm_value_left)
def turn_right():
    pwm_value_left = 37.0
    pwm_value_right = 37.0
    GPIO.output(IN_List[0], GPIO.HIGH)
    GPIO.output(IN_List[1], GPIO.LOW)
    GPIO.output(IN_List[2], GPIO.HIGH)
    GPIO.output(IN_List[3], GPIO.LOW)
    PWM1.ChangeDutyCycle(pwm_value_right)
    PWM2.ChangeDutyCycle(pwm_value_left)
def turn_left():
    pwm_value_left = 37.0
    pwm_value_right = 37.0
    GPIO.output(IN_List[0], GPIO.LOW)
    GPIO.output(IN_List[1], GPIO.HIGH)
    GPIO.output(IN_List[2], GPIO.LOW)
    GPIO.output(IN_List[3], GPIO.HIGH)
    PWM1.ChangeDutyCycle(pwm_value_right)
    PWM2.ChangeDutyCycle(pwm_value_left)
# 停止
def stop():
    for i in range(len(IN_List)):
        GPIO.output(IN_List[i], GPIO.LOW)

def Hough_circle(imgGray, canvas):
    # 基于霍夫圆检测找圆，包含了必要的模糊步骤
    # 在imgGray中查找圆，在canvas中绘制结果
    # canvas必须是shape为[x, y, 3]的图片
    global Hough_x, Hough_y
    img = cv2.medianBlur(imgGray, 3)
    img = cv2.GaussianBlur(img, (17, 19), 0)

    circles = cv2.HoughCircles(img, cv2.HOUGH_GRADIENT, 1, 200, param1=20, param2=50, minRadius=30, maxRadius=70)
    try:
        # try语法保证在找到圆的前提下才进行绘制
        circles = np.uint16(np.around(circles))
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
cap = cv2.VideoCapture(0)  # 摄像头
cap.set(3, frameWidth)  # set中，这里的3，下面的4和10是类似于功能号的东西，数字的值没有实际意义
cap.set(4, frameHeight)
cap.set(10, 80)  # 设置亮度
pulse_ms = 30
lower = np.array([4, 180, 156])  # 适用于橙色乒乓球4<=h<=32
upper = np.array([32, 255, 255])

targetPos_x = 0  # 颜色检测得到的x坐标
targetPos_y = 0  # 颜色检测得到的y坐标
Hough_x = 0  # 霍夫圆检测得到的x坐标
Hough_y = 0  # 霍夫圆检测得到的y坐标

while True:
    _, img = cap.read()
    # 霍夫圆检测前的处理
    b, g, r = cv2.split(img)  # 分离三个颜色
    r = np.int16(r)  # 将红色与蓝色转换为int16，为了后期做差
    b = np.int16(b)
    
    imgHsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    imgMask = cv2.inRange(imgHsv, lower, upper)  # 获取遮罩
    contours, hierarchy = cv2.findContours(imgMask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)  # 只查找最外侧轮廓，并保留所有最外层轮廓

    # 下面的代码查找包围框，并绘制
    x, y, w, h = 0, 0, 0, 0
    max_area = 0
    targetPos_x_max =0
    targetPos_y_max =0
    for cnt in contours:
        area = cv2.contourArea(cnt)
        if area > 300:
            x, y, w, h = cv2.boundingRect(cnt)
            targetPos_x = int(x + w / 2)
            targetPos_y = int(y + h / 2)
        
            # 矩形框
            cv2.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 2)
            cv2.circle(img, (targetPos_x, targetPos_y), 2, (0, 255, 0), 4)
        if max_area<area:
            max_area=area
            targetPos_x_max=targetPos_x
            targetPos_y_max=targetPos_y

    # 坐标（图像内的）
    cv2.putText(img, "({:0<2d}, {:0<2d}, {:0<2f})".format(targetPos_x_max, targetPos_y_max, max_area), (20, 30), cv2.FONT_HERSHEY_PLAIN, 1, (0, 255, 0), 2)  # 文字

    # 霍夫圆检测
    r_minus_b = r - b  # 红色通道减去蓝色通道，得到r_minus_b
    r_minus_b = (r_minus_b + abs(r_minus_b)) / 2  # r_minus_b中小于0的全部转换为0
    r_minus_b = np.uint8(r_minus_b)  # 将数据类型转换回uint8

    imgHough = img.copy()  # 用于绘制识别结果和输出
    Hough_circle(r_minus_b, imgHough)
    cv2.imshow("R_Minus_B", r_minus_b)
    cv2.putText(imgHough, "({:0<2d}, {:0<2d})".format(Hough_x, Hough_y), (20, 30), cv2.FONT_HERSHEY_PLAIN, 1, (255, 100, 0), 2)

    imgStack = np.hstack([img, imgHough])
    cv2.imshow('Horizontal Stacking', imgStack)  # 显示

    # # 让小车跟踪乒乓球
    if max_area < 100:
        stop()
    else:
        x_delta = targetPos_x - 320
        threshold = 150
        if x_delta <= -threshold:
            turn_left()
        elif x_delta >= threshold:
            turn_right()
        else:
            if max_area < 5000:   
                move_forward()
            elif max_area < 8000:
                stop()
            else:
                move_backward()

    if cv2.waitKey(pulse_ms) & 0xFF == ord('q'):  # 按下“q”退出
        print("Quit\n")
        break

cap.release()
cv2.destroyAllWindows()
