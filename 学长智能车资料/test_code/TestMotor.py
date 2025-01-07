# ===================================
#  2020.09.11  我开心
# ===================================
# 导入模块并检查它是否成功
try:
    import RPi.GPIO as GPIO
    import time
except RuntimeError:
    print(" import 引入错误 ... ")

GPIO.setmode(GPIO.BOARD)  # board物理编码
GPIO.setwarnings(False)  # 关闭警告

# ===================================
#  电机
# ===================================
INT1 = 12
INT2 = 16
INT3 = 18
INT4 = 22
ENA = 38
ENB = 40
GPIO.setup(INT1, GPIO.OUT)  # 设置端口类型
GPIO.setup(INT2, GPIO.OUT)
GPIO.setup(INT3, GPIO.OUT)
GPIO.setup(INT4, GPIO.OUT)
GPIO.setup(ENA, GPIO.OUT)
GPIO.setup(ENB, GPIO.OUT)

# PWM
pwm1 = GPIO.PWM(ENA, 50)
pwm2 = GPIO.PWM(ENB, 50)

pwm1.start(0)
pwm2.start(0)


def car_forward():  # 定义前进函数
    GPIO.output(INT1, GPIO.HIGH)  # 将INT1接口设置为高电压
    GPIO.output(INT2, GPIO.LOW)  # 将INT2接口设置为低电压
    GPIO.output(INT3, GPIO.HIGH)  # 将INT3接口设置为高电压
    GPIO.output(INT4, GPIO.LOW)  # 将INT4接口设置为低电压


def car_back():  # 定义后退函数
    GPIO.output(INT1, GPIO.LOW)
    GPIO.output(INT2, GPIO.HIGH)
    GPIO.output(INT3, GPIO.LOW)
    GPIO.output(INT4, GPIO.HIGH)


def car_left():  # 定义左转函数
    GPIO.output(INT1, GPIO.LOW)
    GPIO.output(INT2, GPIO.HIGH)
    GPIO.output(INT3, GPIO.HIGH)
    GPIO.output(INT4, GPIO.LOW)


def car_right():  # 定义右转函数
    GPIO.output(INT1, GPIO.HIGH)
    GPIO.output(INT2, GPIO.LOW)
    GPIO.output(INT3, GPIO.LOW)
    GPIO.output(INT4, GPIO.HIGH)


def car_stop():  # 定义停止函数
    GPIO.output(INT1, GPIO.LOW)
    GPIO.output(INT2, GPIO.LOW)
    GPIO.output(INT3, GPIO.LOW)
    GPIO.output(INT4, GPIO.LOW)


# ===================================
# ===================================
# 主程序开始！！！！！
# ===================================
# ===================================
i = 1  # 循环次数

try:
    while i < 3:
        print('第' + str(i) + '次开始')

        print('开始前进')
        car_forward()
        pwm1.ChangeDutyCycle(50)
        pwm2.ChangeDutyCycle(50)
        time.sleep(1)

        print('开始左转')
        car_left()
        time.sleep(1)

        print('开始右转')
        car_right()
        time.sleep(1)

        print('开始后退')
        car_back()
        time.sleep(1)

        print('开始停车')
        car_stop()
        time.sleep(1)

        # 循环的次数+1
        i = i + 1

except KeyboardInterrupt:
    print('KeyboardInterrupt 程序被人为中止....')
finally:
    GPIO.cleanup()
    print('Exit 程序共运行了' + str(i) + '次，程序结束。')