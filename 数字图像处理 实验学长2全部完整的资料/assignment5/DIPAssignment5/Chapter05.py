import cv2
from skimage import io
import numpy as np
from numpy.linalg import norm
from scipy.signal.windows import gaussian
from scipy.fftpack import fft2, ifft2, fftshift, ifftshift
from math import exp, dist
import matplotlib.pyplot as plt


# 计算功率谱比
# 定义函数 calc_spectral_ratio,用于计算滤波后的频谱能量与原始频谱能量的比值。
# 该函数接受两个参数:未滤波的频谱(fft_shifted)和滤波后的频谱(fft_filtered),返回它们的功率谱比。
def calc_spectral_ratio(fft_shifted, fft_filtered):
    return (norm(fft_filtered) ** 2) / (norm(fft_shifted) ** 2)


# unsharp滤波（使用Gaussian高通滤波器）
# 定义函数 unsharp_frequency_filter,用于对图像进行锐化滤波。
# 该函数接受四个参数:输入图像(img)、截止频率(d0)以及两个控制锐化程度的系数(k1和k2)。
# 函数首先创建一个与输入图像大小相同的零矩阵(base_space),并计算图像的中心点坐标(center_point)。
def unsharp_frequency_filter(img, d0, k1, k2):
    base_space = np.zeros(img.shape[:2])
    rows, columns = img.shape[:2]
    center_point = (rows / 2, columns / 2)

    # 这个嵌套循环用于构建锐化滤波器的空间域表示(base_space)。
    # 对于每个像素点,计算其与图像中心点的欧几里得距离,并使用一个高斯函数及系数k1和k2计算该点的滤波器系数。
    for x in range(columns):
        for y in range(rows):
            base_space[y, x] = k1 + k2 * (1 - exp(((-dist((y, x), center_point) ** 2) / (2 * (d0 ** 2)))))

    # 接下来的步骤与高斯滤波函数相似,计算输入图像的二维离散傅里叶变换,
    # 将其与构建的锐化滤波器相乘,得到滤波后的频谱。
    # 然后对滤波后的频谱进行逆傅里叶变换,得到滤波后的图像。
    # 最后,返回滤波后的图像。
    centered = fftshift(fft2(img))
    pass_center = centered * base_space
    passed = ifft2(ifftshift(pass_center)).real
    return passed


# 显示两幅图像的函数
def display_image(image_list, title_list):
    for i in range(2):
        plt.subplot(1, 2, i + 1)
        plt.imshow(image_list[i], 'gray')
        plt.title(title_list[i])
        plt.xticks([]), plt.yticks([])
    plt.show()


# 显示频谱的函数
# 定义函数 magnitude_spectrum,用于计算并显示图像的频谱幅值。
# 该函数接受一个参数:输入图像(img)。函数首先使用 OpenCV 的 dft 函数计算图像的二维离散傅里叶变换,
# 然后对结果进行平移(dft_shift)。接下来,使用 OpenCV 的 magnitude 函数计算频谱的幅值,并进行对数变换以改善可视化效果。
# 最后,返回处理后的频谱数据。
def magnitude_spectrum(img):
    img_dft = cv2.dft(np.float32(img), flags=cv2.DFT_COMPLEX_OUTPUT)
    dft_shift = np.fft.fftshift(img_dft)
    spectrum = 20 * np.log10(cv2.magnitude(dft_shift[:, :, 0], dft_shift[:, :, 1]) + 1)  # +1是为了显示更为清晰
    return spectrum


test3 = io.imread("Resource/test3_corrupt.pgm", as_gray=True)
test4 = io.imread("Resource/test4 copy.bmp", as_gray=True)
# test3 Unsharp Filter
test3Unsharp = unsharp_frequency_filter(test3, d0=1, k1=1, k2=1)
images = [test3, test3Unsharp]
titles = ['test3', 'test3 Unsharp Filter']
display_image(images, titles)

#  plot spectrum of test3 and Unsharp
plt.subplot(121), plt.imshow(magnitude_spectrum(test3)), plt.title('test3 spectrum')
plt.subplot(122), plt.imshow(magnitude_spectrum(test3Unsharp)), plt.title('test3 Unsharp Spectrum')
plt.show()


# test4 Unsharp Filter
test4Unsharp = unsharp_frequency_filter(test4, d0=1, k1=1, k2=1)
images = [test4, test4Unsharp]
titles = ['test4', 'test4 Unsharp Filter']
display_image(images, titles)

#  plot spectrum of test3 and Unsharp
plt.subplot(121), plt.imshow(magnitude_spectrum(test4)), plt.title('test4 spectrum')
plt.subplot(122), plt.imshow(magnitude_spectrum(test4Unsharp)), plt.title('test4 Unsharp Spectrum')
plt.show()

