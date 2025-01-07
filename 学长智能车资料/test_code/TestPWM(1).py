'''
test if PWM work normally
'''
import RPi.GPIO as gpio
import time

# 定义输出引脚
IN1 = 12
IN2 = 16
IN3 = 18
IN4 = 22

# 定义使能引脚
ENA = 38
ENB = 40

# 设置编码规范
gpio.setmode(gpio.BOARD)

# 无视警告，开启引脚
gpio.setwarnings(False)

# 设置引脚为输出
gpio.setup([IN1,IN2,IN3,IN4, ENA, ENB], gpio.OUT)

# 对使能引脚开启pwm控制
pwm1 = gpio.PWM(ENA, 50)
pwm2 = gpio.PWM(ENB, 50)

# 启动pwm
pwm1.start(0)
pwm2.start(0)

# 让小车前进
gpio.output([IN1, IN3], gpio.LOW)
gpio.output([IN2, IN4], gpio.HIGH)

print("GO!")

# 让小车每秒钟逐渐增加速度
for i in range(5,11):
    pwm1.ChangeDutyCycle(10 * i)
    pwm2.ChangeDutyCycle(10 * i)
    time.sleep(1)
    print(i,"'s speed up!")

print("Over")

# 让小车停止
gpio.output([IN1, IN2, IN3, IN4], gpio.LOW)

# 释放资源
gpio.cleanup()
pwm1.stop()
pwm2.stop()

