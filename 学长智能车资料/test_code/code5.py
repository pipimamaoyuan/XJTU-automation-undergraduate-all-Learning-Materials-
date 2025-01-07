import time
import cv2
import numpy as np

cap = cv2.VideoCapture(0)
cap.set(3, 640)
cap.set(4, 480)
while (1):
    ret, frame = cap.read()
    cv2.imshow('frame', frame)  # 展示每一帧
    # 转化为灰度图
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    cv2.imshow('gray', gray)  # 展示灰度图
    # 大津法二值化
    retval, dst = cv2.threshold(gray, 100, 255, cv2.THRESH_OTSU)
    # 膨胀，白区域变大
    # dst = cv2.dilate(dst, None, iterations=2)
    # cv2.imshow('dilate_frame', dst)  # 展示每一帧
    # 腐蚀，白区域变小
    dst = cv2.erode(dst, None, iterations=6)
    cv2.imshow('erode_frame', dst)  # 展示每一帧
    # 找到连续白色像素点最宽的那条
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# 释放清理
cap.release()
cv2.destroyAllWindows()