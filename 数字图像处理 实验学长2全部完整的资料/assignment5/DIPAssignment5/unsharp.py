import cv2
from skimage import io
import numpy as np
from numpy.linalg import norm
from scipy.signal.windows import gaussian
from scipy.fftpack import fft2, ifft2, fftshift, ifftshift
from math import exp, dist
import matplotlib.pyplot as plt

def unsharp_frequency_filter(img, d0, k1, k2):
    # 获取图像的尺寸
    M, N = img.shape

    # 创建高斯高通滤波器
    u = np.arange(M)
    v = np.arange(N)
    idx = np.where(u > M/2)
    u[idx] -= M
    idy = np.where(v > N/2)
    v[idy] -= N
    V, U = np.meshgrid(v, u)
    D = np.sqrt(U**2 + V**2)
    H = 1 - np.exp(-(D**2) / (2*(d0**2)))

    # 应用高通滤波器到图像的频域
    img_dft = np.fft.fft2(img)
    img_dft_shift = np.fft.fftshift(img_dft)
    img_dft_shift *= (k1 + k2 * H)

    # 反变换回空域
    img_filtered = np.fft.ifft2(np.fft.ifftshift(img_dft_shift))
    img_filtered = np.abs(img_filtered)

    # 归一化到0-255
    img_filtered -= img_filtered.min()
    img_filtered = img_filtered * 255 / img_filtered.max()

    return img_filtered.astype(np.uint8)



def display_image(image_list, title_list):
    for i in range(2):
        plt.subplot(1, 2, i + 1)
        plt.imshow(image_list[i], 'gray')
        plt.title(title_list[i])
        plt.xticks([]), plt.yticks([])
    plt.show()


def magnitude_spectrum(img):
    img_dft = cv2.dft(np.float32(img), flags=cv2.DFT_COMPLEX_OUTPUT)
    dft_shift = np.fft.fftshift(img_dft)
    spectrum = 20 * np.log10(cv2.magnitude(dft_shift[:, :, 0], dft_shift[:, :, 1]) + 1)  # +1是为了显示更为清晰
    return spectrum


test3 = io.imread("Resource/test3_corrupt.pgm", as_gray=True)

# test3 Unsharp Filter
test3Unsharp = unsharp_frequency_filter(test3, d0=0.1, k1=1, k2=1000)
images = [test3, test3Unsharp]
titles = ['test3', 'test3 Unsharp Filter']
display_image(images, titles)

#  plot spectrum of test3 and Unsharp
plt.subplot(121), plt.imshow(magnitude_spectrum(test3)), plt.title('test3 spectrum')
plt.subplot(122), plt.imshow(magnitude_spectrum(test3Unsharp)), plt.title('test3 Unsharp Spectrum')
plt.show()



