# Ball Tracking(HSV)
import time
import numpy as np
import cv2

# set capture window
width, height = 640, 480
camera = cv2.VideoCapture(0)
camera.set(3, width)
camera.set(4, height)






def Trackbar_Init():
    # 1 create windows
    cv2.namedWindow('h_binary')
    cv2.namedWindow('s_binary')
    cv2.namedWindow('v_binary')
    # 2 Create Trackbar
    cv2.createTrackbar('hmin', 'h_binary', 6, 179, nothing)
    cv2.createTrackbar('hmax', 'h_binary', 26, 179, nothing)
    cv2.createTrackbar('smin', 's_binary', 110, 255, nothing)
    cv2.createTrackbar('smax', 's_binary', 255, 255, nothing)
    cv2.createTrackbar('vmin', 'v_binary', 140, 255, nothing)
    cv2.createTrackbar('vmax', 'v_binary', 255, 255, nothing)
    #   创建滑动条     滑动条值名称 窗口名称   滑动条值 滑动条阈值 回调函数


def Init():
    Trackbar_Init()

# 回调函数
def nothing(*arg):
    pass


# 在HSV色彩空间下得到二值图
def Get_HSV(image):
    # 1 get trackbar's value
    hmin = cv2.getTrackbarPos('hmin', 'h_binary')
    hmax = cv2.getTrackbarPos('hmax', 'h_binary')
    smin = cv2.getTrackbarPos('smin', 's_binary')
    smax = cv2.getTrackbarPos('smax', 's_binary')
    vmin = cv2.getTrackbarPos('vmin', 'v_binary')
    vmax = cv2.getTrackbarPos('vmax', 'v_binary')

    # 2 to HSV
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    cv2.imshow('hsv', hsv)
    h, s, v = cv2.split(hsv)

    # 3 set threshold (binary image)
    # if value in (min, max):white; otherwise:black
    h_binary = cv2.inRange(np.array(h), np.array(hmin), np.array(hmax))
    s_binary = cv2.inRange(np.array(s), np.array(smin), np.array(smax))
    v_binary = cv2.inRange(np.array(v), np.array(vmin), np.array(vmax))

    # 4 get binary（对H、S、V三个通道分别与操作）
    binary = cv2.bitwise_and(h_binary, cv2.bitwise_and(s_binary, v_binary))

    # 5 Show
    cv2.imshow('h_binary', h_binary)
    cv2.imshow('s_binary', s_binary)
    cv2.imshow('v_binary', v_binary)
    cv2.imshow('binary', binary)

    return binary


# 图像处理
def Image_Processing():
    global h, s, v
    # 1 Capture the frames
    ret, frame = camera.read()
    image = frame
    cv2.imshow('frame', frame)

    # 2 get HSV
    binary = Get_HSV(frame)

    # 3 Gausi blur
    blur = cv2.GaussianBlur(binary, (9, 9), 0)

    # 4 Open
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (9, 9))
    Open = cv2.morphologyEx(blur, cv2.MORPH_OPEN, kernel)
    cv2.imshow('Open', Open)
    # 5 Close
    Close = cv2.morphologyEx(Open, cv2.MORPH_CLOSE, kernel)
    cv2.imshow('Close', Close)

    # 6 Hough Circle detect
    circles = cv2.HoughCircles(Close, cv2.HOUGH_GRADIENT, 2, 120, param1=120, param2=20, minRadius=20, maxRadius=0)
    #                                                                     param2:决定圆能否被检测到（越少越容易检测到圆，但相应的也更容易出错）
    # judge if circles is exist
    if circles is not None:
        # 1 获取圆的圆心和半径
        x, y, r = int(circles[0][0][0]), int(circles[0][0][1]), int(circles[0][0][2])
        print(x, y, r)
        # 2 画圆
        cv2.circle(image, (x, y), r, (255, 0, 255), 5)
        cv2.imshow('image', image)
    else:
        (x, y), r = (0, 0), 0

    return (x, y), r


if __name__ == '__main__':
    Init()

    while 1:
        # 1 Image Process
        (x, y), r = Image_Processing()


        # must include this codes(otherwise you can't open camera successfully)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break