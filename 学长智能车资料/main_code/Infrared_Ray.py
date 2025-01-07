import RPi.GPIO as gpio
import time

# 定义引脚
pin1 = 12  # 左正
pin2 = 16  # 左反
pin3 = 18  # 右正
pin4 = 22  # 右反
ENA = 38
ENB = 40
GPIO_Infrared_left = 29
GPIO_Infrared_right = 31
gpio.setwarnings(False)
# 设置gpio口为BOARD编号规范
gpio.setmode(gpio.BOARD)


# 设置gpio口为输出
gpio.setup(pin1, gpio.OUT)
gpio.setup(pin2, gpio.OUT)
gpio.setup(pin3, gpio.OUT)
gpio.setup(pin4, gpio.OUT)
gpio.setup(ENA, gpio.OUT)
gpio.setup(ENB, gpio.OUT)
gpio.setup(GPIO_Infrared_left, gpio.IN)
gpio.setup(GPIO_Infrared_right, gpio.IN)
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





def InfraredMeasure():
    left_measure = gpio.input(GPIO_Infrared_left)  # if there is an obstacle, GPIO will become 0; else, GPIO_input = 1;
    right_measure = gpio.input(GPIO_Infrared_right)
    return [left_measure, right_measure]

def avoidance(left,right):
    if(left==0 and right !=0 ):
        car_back()
        pwm1.ChangeDutyCycle(25)
        pwm2.ChangeDutyCycle(25)
        time.sleep(1)
        car_right()
        pwm1.ChangeDutyCycle(40)
        pwm2.ChangeDutyCycle(40)
        print("detect obstacles in the left!")
        time.sleep(1)
    elif(left==0 and right ==0):
        car_back()
        pwm1.ChangeDutyCycle(40)
        pwm2.ChangeDutyCycle(40)
        print("detect obstacles in the left and right!")
        time.sleep(1)
    elif(left == 1 and right ==0):
        car_back()
        pwm1.ChangeDutyCycle(25)
        pwm2.ChangeDutyCycle(25)
        time.sleep(2)
        car_left()
        pwm1.ChangeDutyCycle(40)
        pwm2.ChangeDutyCycle(40)
        print("detect obstacles in the right!")
        time.sleep(1)
    else:
        car_forward()
        pwm1.ChangeDutyCycle(30)
        pwm2.ChangeDutyCycle(30)



def loop():
    while True:
        car_forward()
        pwm1.ChangeDutyCycle(30)
        pwm2.ChangeDutyCycle(30)
        [left, right] = InfraredMeasure()
        print(left,right)
        avoidance(left,right)
def destroy():
    gpio.cleanup()



try:
    loop()
except KeyboardInterrupt:
    destroy()