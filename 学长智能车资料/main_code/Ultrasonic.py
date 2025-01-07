import RPi.GPIO as gpio
import time

# 定义引脚
pin1 = 12  # 左正
pin2 = 16  # 左反
pin3 = 18  # 右正
pin4 = 22  # 右反
ENA = 38
ENB = 40
TRIG = 13  # send-pin
ECHO = 15  # receive-pin

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


def setup():
    gpio.setup(TRIG, gpio.OUT, initial=gpio.LOW)
    gpio.setup(ECHO, gpio.IN)
    gpio.setwarnings(False)  # 关闭警告


def distance():
    gpio.output(TRIG, 1)  # 给Trig一个10US以上的高电平
    time.sleep(0.00001)
    gpio.output(TRIG, 0)

    # 等待低电平结束，然后记录时间
    while gpio.input(ECHO) == 0:  # 捕捉 echo 端输出上升沿
        pass
    time1 = time.time()

    # 等待高电平结束，然后记录时间
    while gpio.input(ECHO) == 1:  # 捕捉 echo 端输出下降沿
        pass
    time2 = time.time()

    during = time2 - time1
    # ECHO高电平时刻时间减去低电平时刻时间，所得时间为超声波传播时间
    return during * 340 / 2 * 100


# 超声波传播速度为340m/s,最后单位米换算为厘米，所以乘以100
def loop():
    while True:
        dis = distance()
        print(dis, "cm\n")
        # print dis, 'cm'
        # print ''
        time.sleep(0.3)
        car_forward()
        pwm1.ChangeDutyCycle(30)
        pwm2.ChangeDutyCycle(30)
        if (dis < 30):
            car_back()
            pwm1.ChangeDutyCycle(40)
            pwm2.ChangeDutyCycle(40)
            time.sleep(1)
            car_forward()
            pwm1.ChangeDutyCycle(40)
            pwm2.ChangeDutyCycle(0)
            time.sleep(1)


def destroy():
    gpio.cleanup()


if __name__ == "__main__":
    setup()
    try:
        loop()
    except KeyboardInterrupt:
        destroy()