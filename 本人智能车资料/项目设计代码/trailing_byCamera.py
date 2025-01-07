# 1.加入摄像头模块，让小车实现自动循迹行驶
import RPi.GPIO as GPIO
import time
import cv2
import numpy as np
LINE0 = 150
LINE1 = 350
LINE2 = 380
BLACK_HIGH = 25
RED_LOW = 40
RED_HIGH = 70
LEFT_COL_PX = 50
RIGHT_COL_PX = 590
RED_FLAG = True
BLACK_FLAG = True
# 设定对应引脚
# 设定引脚编号系统
GPIO.setwarnings(False)
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
    pwm_value_right = 30.0 # 值越小，速度越小
    pwm_value_left = 30.0
    GPIO.output(IN_List[0], GPIO.HIGH)
    GPIO.output(IN_List[1], GPIO.LOW)
    GPIO.output(IN_List[2], GPIO.LOW)
    GPIO.output(IN_List[3], GPIO.HIGH)
    PWM1.ChangeDutyCycle(pwm_value_right)
    PWM2.ChangeDutyCycle(pwm_value_left)
# 后退【IN1、IN4 低电平，IN2、IN3 高电平】
def move_backward():
    pwm_value_right = 30.0 # 值越小，速度越小
    pwm_value_left = 30.0
    GPIO.output(IN_List[0], GPIO.LOW)
    GPIO.output(IN_List[1], GPIO.HIGH)
    GPIO.output(IN_List[2], GPIO.HIGH)
    GPIO.output(IN_List[3], GPIO.LOW)
    PWM1.ChangeDutyCycle(pwm_value_right)
    PWM2.ChangeDutyCycle(pwm_value_left)
def turn_right():
    pwm_value_left = 60.0
    pwm_value_right = 70.0
    GPIO.output(IN_List[0], GPIO.HIGH)
    GPIO.output(IN_List[1], GPIO.LOW)
    GPIO.output(IN_List[2], GPIO.HIGH)
    GPIO.output(IN_List[3], GPIO.LOW)
    PWM1.ChangeDutyCycle(pwm_value_right)
    PWM2.ChangeDutyCycle(pwm_value_left)
def turn_left():
    pwm_value_left = 70.0
    pwm_value_right = 60.0
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
# center定义
center = 320
# 2.摄像头读取图像，打开摄像头,opencv存储值为480*640（行*列）
cap = cv2.VideoCapture(0)
cap.set(3, 640)
cap.set(4, 480)
while (1):
    ret, frame = cap.read()

    # 转化为灰度图
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    dst = gray
    detect = gray[LINE0:LINE1]
    left_col = gray[:, LEFT_COL_PX]
    right_col = gray[:, RIGHT_COL_PX]
    
    black_num = len(np.where(detect <= BLACK_HIGH)[0])
    red_num = len(np.where((detect >= RED_LOW) & (detect <= RED_HIGH))[0])

    if red_num >= 5000 and RED_FLAG:
        stop()
        print("===== RED ===== STOP =====")
        RED_FLAG = False
        BLACK_FLAG = True
        time.sleep(3.0)
    if black_num >= 20000 and BLACK_FLAG:
        left_num = len(np.where(left_col <= BLACK_HIGH + 50)[0])
        right_num = len(np.where(right_col <= BLACK_HIGH + 50)[0])
        print(f"leftnum: {left_num}")
        print(f"rightnum: {right_num}")
        if not (left_num > 20 and right_num > 20):
            stop()
            print("===== BLACK ===== STOP =====")
            RED_FLAG = True
            BLACK_FLAG = False
            time.sleep(1.0)

    # 目标中点与标准中点（320）进行比较得出偏移量
    # 计算出center与标准中心点的偏移量，如果为正，应该右转
    orientation = dst[LINE2]
    blacks = np.where(orientation <= 20)
    if blacks is not None:
        center = np.mean(blacks)
    else:
        center = 320
    direction = center - 320
    cv2.imshow('color_frame', dst)  # 展示每一帧，需要在树莓派操作系统上查看

    # 根据偏移量来控制小车左右轮的转速
    threshold = 100  # 目标中点与标准中点（320）进行比较得出偏移量大于此阈值才会发生转向
    if direction <= -threshold:
        turn_left()
    elif direction >= threshold:
        turn_right()
    else:
        move_forward()

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# 释放清理
cap.release()
cv2.destroyAllWindows()
PWM1.stop()
PWM2.stop()

GPIO.cleanup()